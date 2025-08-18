package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {
	// 관리자 메인 페이지
	@GetMapping({"/admin/mainPage"})
	public String adminMainPage() {
		return "admin/mainPage";
	}
}
