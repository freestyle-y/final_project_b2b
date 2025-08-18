package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ContractController {
	// 계약서 목록 페이지
	@GetMapping("/biz/contractList")
	public String contractList() {
		return "biz/contractList";
	}
	
	// 계약서 상세 페이지
	@GetMapping("/biz/contractOne")
	public String contractOne() {
		return "biz/contractOne";
	}
	
}
