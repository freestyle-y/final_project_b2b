package com.example.trade.controller;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommMainController {
	// 공용 메인 페이지
	@GetMapping({"/", "/public/mainPage"})
	public String mainPage(Authentication authentication) {
		// 로그인 안 된 경우 -> public
		if(authentication == null || !authentication.isAuthenticated()) {
			return "public/mainPage";
		}

		// 로그인 된 경우 -> 권한 확인
		for(GrantedAuthority authority : authentication.getAuthorities()) {
			String role = authority.getAuthority();

			if("ROLE_ADMIN".equals(role)) {
				return "redirect:/admin/mainPage";
			} else if("ROLE_BIZ".equals(role)) {
				return "redirect:/biz/mainPage";
			} else if("ROLE_PERSONAL".equals(role)) {
				return "redirect:/personal/mainPage";
			}
		}
		return "public/mainPage";
	}
}
