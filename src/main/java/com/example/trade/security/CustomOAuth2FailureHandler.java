package com.example.trade.security;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.AuthenticationFailureHandler;
import org.springframework.stereotype.Component;

@Slf4j
@Component
public class CustomOAuth2FailureHandler implements AuthenticationFailureHandler {

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception)
            throws IOException, ServletException {
    	log.info("소셜로그인 연동 실패 핸들러");
        var session = request.getSession(false);
        boolean linkMode = session != null && Boolean.TRUE.equals(session.getAttribute("LINK_MODE"));

        if (linkMode) {
            // 연동 모드 실패 → 마이페이지로
            session.removeAttribute("LINK_MODE");
            session.removeAttribute("LINK_USER_ID");
            session.removeAttribute("LINK_PROVIDER");
            String msg = URLEncoder.encode("소셜 연동에 실패했습니다. 다시 시도해주세요.", StandardCharsets.UTF_8);
            response.sendRedirect("/member/myPage?errorMsg=" + msg);
            return;
        }

        // 일반 로그인 실패 처리 (기존 로직)
        if ("NO_LINKED_ACCOUNT".equals(exception.getMessage())) {
            String msg = URLEncoder.encode("등록되지 않은 소셜 계정입니다. 먼저 회원가입을 진행해주세요.", StandardCharsets.UTF_8);
            response.sendRedirect("/public/join?errorMsg=" + msg);
        } else {
            String msg = URLEncoder.encode("소셜 로그인에 실패했습니다. 연동하지 않은 소셜 계정일 경우 회원가입 후 마이페이지에서 연동해주세요.", StandardCharsets.UTF_8);
            response.sendRedirect("/public/login?errorMsg=" + msg);
        }
    }
}
