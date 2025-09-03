package com.example.trade.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.trade.service.ProductService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class CommMainController {
	private ProductService productService;
	public CommMainController(ProductService productService) {
		this.productService = productService;
	}
	
	// 공용 메인 페이지
	@GetMapping({"/", "/public/mainPage"})
	public String mainPage(Authentication authentication, Model model) {
		// 로그인 안 된 경우 -> public
		if(authentication == null || !authentication.isAuthenticated()) {
			List<Map<String, Object>> productList = productService.selectProductByWish();
			model.addAttribute("productList", productList);
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
