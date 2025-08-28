package com.example.trade.security;

import java.util.Map;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.example.trade.domain.UserDomain;
import com.example.trade.service.MemberService;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final MemberService memberService;
    private final HttpSession session;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        // 1. OAuth2 provider로부터 유저 정보 조회
        OAuth2User oAuth2User = super.loadUser(userRequest);
        Map<String, Object> attributes = oAuth2User.getAttributes();

        // 2. provider 식별
        String provider = userRequest.getClientRegistration().getRegistrationId(); // ex: naver, kakao

        // 3. 소셜 ID 추출
        String socialId = extractSocialId(provider, attributes);
        if (socialId == null) {
            throw new OAuth2AuthenticationException("INVALID_SOCIAL_RESPONSE");
        }

        // 4. DB에서 socialId로 매핑된 userId 조회
        String userId = memberService.findUserIdBySocial(provider, socialId);

        // 5. 세션에서 연동 모드 확인
        boolean linkMode = Boolean.TRUE.equals(session.getAttribute("LINK_MODE"));
        String linkUserId = (String) session.getAttribute("LINK_USER_ID");

        if (userId == null) {
            if (linkMode && linkUserId != null) {
                // 🔹 연동 모드: SuccessHandler에서 DB insert 처리
                return oAuth2User; 
            } else {
                // 🔹 일반 로그인 모드에서 연결된 계정 없음 → 실패
                throw new OAuth2AuthenticationException("NO_LINKED_ACCOUNT");
            }
        }

        // 6. userId로 UserDomain 가져오기
        UserDomain userDomain = memberService.getSessionByUserId(userId);
        if (userDomain == null) {
            throw new OAuth2AuthenticationException("USER_NOT_FOUND");
        }

        // 7. 정상 로그인 처리: CustomUserDetails + id 매핑
        return new DefaultOAuth2User(
                new CustomUserDetails(userDomain).getAuthorities(),
                Map.of("id", userDomain.getId()),
                "id"
        );
    }

    private String extractSocialId(String provider, Map<String, Object> attributes) {
        if ("naver".equals(provider)) {
            Map<String, Object> response = (Map<String, Object>) attributes.get("response");
            return (String) response.get("id");
        } else if ("kakao".equals(provider)) {
            return String.valueOf(attributes.get("id"));
        }
        return null;
    }
}
