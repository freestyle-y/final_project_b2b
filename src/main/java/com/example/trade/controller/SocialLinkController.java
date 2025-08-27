package com.example.trade.controller;

import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
							@AuthenticationPrincipal CustomUserDetails principal,
							HttpSession session) {
		log.info("소셜 연동하기 버튼 클릭 한 직후(소셜로그인 전)");
		// 로그인 상태 보장됨 (마이페이지) 
		session.setAttribute("LINK_MODE", Boolean.TRUE); 
		session.setAttribute("LINK_USER_ID", principal.getUsername()); 
		session.setAttribute("LINK_PROVIDER", provider); 
		
		// kakao/naver // OAuth2 인가 페이지로 이동 (기존 spring-security 엔드포인트) 
		return "redirect:/oauth2/authorization/" + provider; 
		}
}
