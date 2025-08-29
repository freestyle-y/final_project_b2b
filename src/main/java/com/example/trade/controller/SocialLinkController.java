package com.example.trade.controller;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.oauth2.core.user.DefaultOAuth2User;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;

import com.example.trade.security.CustomUserDetails;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/api/social")
public class SocialLinkController {
	
	@GetMapping("/link/{provider}")
	public String startLink(@PathVariable String provider,
							HttpSession session) {
		log.info("소셜 연동하기 버튼 클릭 한 직후(소셜로그인 전)");
		
		// SecurityContext에서 현재 로그인 사용자 가져오기
        var auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || auth.getPrincipal() == null) {
            throw new IllegalStateException("로그인된 사용자가 없습니다. 연동을 시작할 수 없습니다.");
        }

        String userId;
        Object principal = auth.getPrincipal();
        if (principal instanceof CustomUserDetails) {
            userId = ((CustomUserDetails) principal).getUsername();
        } else if (principal instanceof DefaultOAuth2User) {
            userId = (String) ((DefaultOAuth2User) principal).getAttribute("id");
        } else {
            throw new IllegalStateException("알 수 없는 로그인 사용자 타입입니다.");
        }
		// 로그인 상태 보장됨 (마이페이지) 
		session.setAttribute("LINK_MODE", Boolean.TRUE); 
		session.setAttribute("LINK_USER_ID", userId); 
		session.setAttribute("LINK_PROVIDER", provider); 
		
		// kakao/naver // OAuth2 인가 페이지로 이동 (기존 spring-security 엔드포인트) 
		return "redirect:/oauth2/authorization/" + provider; 
		}
}
