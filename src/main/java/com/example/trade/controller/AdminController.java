package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class AdminController {
	// 견적서 작성 페이지
	@GetMapping("/admin/writeQuotation")
	public String writeQuotation() {
		return "admin/writeQuotation";
	}
	
	// 계약서 작성 페이지
	@GetMapping("/admin/writeContract")
	public String writeContract() {
		return "admin/writeContract";
	}
	
	// 컨테이너 입력 페이지
	@GetMapping("/admin/insertContainer")
	public String insertContainer() {
		return "admin/insertContainer";
	}
	
	// 배송 입력 페이지
	@GetMapping("/admin/insertDelivery")
	public String insertDelivery() {
		return "admin/insertDelivery";
	}
	
	// 상품 입력 페이지
	@GetMapping("/admin/insertProduct")
	public String insertProduct() {
		return "admin/insertProduct";
	}
	
	// 재고 목록 페이지
	@GetMapping("/admin/inventoryList")
	public String inventoryList() {
		return "admin/inventoryList";
	}
	
	// 로그인 이력 페이지
	@GetMapping("/admin/loginHistory")
	public String loginHistory() {
		return "admin/loginHistory";
	}
	
	// 알림 작성 페이지
	@GetMapping("/admin/writeNotification")
	public String writeNotification() {
		return "admin/writeNotification";
	}
}
