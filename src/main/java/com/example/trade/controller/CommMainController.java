package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class CommMainController {
	// 메인페이지
	@GetMapping("/public/mainPage")
	public String mainPage() {
		return "public/mainPage";
	}
}
