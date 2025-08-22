package com.example.trade.security;

import java.util.Map;

import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;

import com.example.trade.service.MemberService;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final MemberService memberService;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId(); // naver, kakao
        Map<String, Object> attributes = oAuth2User.getAttributes();

        String socialId = null;
        if ("naver".equals(registrationId)) {
            Map<String, Object> response = (Map<String, Object>) attributes.get("response");
            socialId = (String) response.get("id");
        } else if ("kakao".equals(registrationId)) {
            socialId = String.valueOf(attributes.get("id")); // 카카오는 id가 최상위
        }

        if (socialId == null) {
            throw new OAuth2AuthenticationException("INVALID_SOCIAL_RESPONSE");
        }

        // DB에서 소셜 계정으로 userId 조회
        String userId = memberService.findUserIdBySocial(registrationId, socialId);

        if (userId == null) {
            // 연동된 계정 없음 → 예외 발생 (FailureHandler에서 잡음)
            throw new OAuth2AuthenticationException("NO_LINKED_ACCOUNT");
        }

        return oAuth2User;
    }
}
