package com.example.trade.security;

import java.io.IOException;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.web.authentication.AuthenticationSuccessHandler;

import com.example.trade.service.MemberService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RequiredArgsConstructor
public class CustomOAuth2SuccessHandler implements AuthenticationSuccessHandler {

    private final MemberService memberService;
    private final UserDetailsService userDetailsService;    // 원래 사용자로 복구할 때 사용
    private final AuthenticationSuccessHandler defaultLoginSuccessHandler; // 일반 로그인 성공 로직으로 위임

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response,
                                        Authentication authentication) throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        
        
        log.info("customOAuth2SuccessHandler 호출");
        boolean linkMode = session != null && Boolean.TRUE.equals(session.getAttribute("LINK_MODE"));

        if (!linkMode) {
            // 일반 소셜 로그인 성공 → 기존(successHandler)에 위임
            defaultLoginSuccessHandler.onAuthenticationSuccess(request, response, authentication);
            return;
        }

        try {
            // ---- 연동 모드 처리 ----
            String originalUserId = (String) session.getAttribute("LINK_USER_ID");
            String provider = (String) session.getAttribute("LINK_PROVIDER"); // kakao/naver

            // OAuth2User의 attribute에서 소셜ID 추출
            // (CustomOAuth2UserService와 동일 규칙을 사용)
            Map<String, Object> attributes = (Map<String, Object>) authentication.getPrincipal()
                                                                                 .getClass()
                                                                                 .getMethod("getAttributes")
                                                                                 .invoke(authentication.getPrincipal());

            String socialId = null;
            if ("naver".equals(provider)) {
                Map<String, Object> resp = (Map<String, Object>) attributes.get("response");
                socialId = (String) resp.get("id");
            } else if ("kakao".equals(provider)) {
                socialId = String.valueOf(attributes.get("id"));
            }

            if (socialId == null) {
                throw new IllegalStateException("소셜 ID 파싱 실패");
            }

            // DB에 연동 등록 (중복 체크는 서비스에서)
            memberService.linkSocialAccount(originalUserId, provider, socialId);

            // 세션 플래그 제거
            session.removeAttribute("LINK_MODE");
            session.removeAttribute("LINK_USER_ID");
            session.removeAttribute("LINK_PROVIDER");

            // ✅ 원래 로그인 사용자로 복구
            var userDetails = userDetailsService.loadUserByUsername(originalUserId);
            var restoredAuth = new UsernamePasswordAuthenticationToken(
                    userDetails, userDetails.getPassword(), userDetails.getAuthorities());
            SecurityContextHolder.getContext().setAuthentication(restoredAuth);

            // 마이페이지로 리다이렉트 (완료 메시지)
            response.sendRedirect("/member/myPage?linkResult=success");

        } catch (Exception e) {
            // 실패 시 원래 사용자로 복구는 시도하고 에러 페이지로
            if (session != null) {
                Object originalUserId = session.getAttribute("LINK_USER_ID");
                if (originalUserId != null) {
                    try {
                        var ud = userDetailsService.loadUserByUsername(originalUserId.toString());
                        var restored = new UsernamePasswordAuthenticationToken(
                                ud, ud.getPassword(), ud.getAuthorities());
                        SecurityContextHolder.getContext().setAuthentication(restored);
                    } catch (Exception ignore) {}
                }
                session.removeAttribute("LINK_MODE");
                session.removeAttribute("LINK_USER_ID");
                session.removeAttribute("LINK_PROVIDER");
            }
            response.sendRedirect("/member/myPage?linkResult=fail");
        }
    }
}
