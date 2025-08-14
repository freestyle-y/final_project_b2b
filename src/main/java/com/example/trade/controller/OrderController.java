package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class OrderController {
	// 결제 페이지
	@GetMapping("/personal/payment")
	public String payment() {
		return "personal/payment";
	}
	// 주문 조회 페이지
	@GetMapping("/personal/orderList")
	public String orderList() {
		return "personal/orderList";
	}
	
	// 주문 상세 페이지
	@GetMapping("/personal/orderOne")
	public String orderOne() {
		return "personal/orderOne";
	}
}
