package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ContainerController {
	// 컨테이너 입력 페이지
	@GetMapping("/admin/insertContainer")
	public String insertContainer() {
		return "admin/insertContainer";
	}
}
