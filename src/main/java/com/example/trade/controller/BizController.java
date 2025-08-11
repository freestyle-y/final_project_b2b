package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BizController {
	// 상품 요청 페이지
	@GetMapping("/biz/productRequest")
	public String productRequest() {
		return "biz/productRequest";
	}
	
	// 견적서 목록 페이지
	@GetMapping("/biz/quotationList")
	public String quotationList() {
		return "biz/quotationList";
	}
	
	// 견적서 상세 페이지
	@GetMapping("/biz/quotationOne")
	public String quotationOne() {
		return "biz/quotationOne";
	}
	
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
	
	// 배송 목록 페이지
	@GetMapping("/biz/deliveryList")
	public String deliveryList() {
		return "biz/deliveryList";
	}
	
	// 배송 상세 페이지
	@GetMapping("/biz/deliveryOne")
	public String deliveryOne() {
		return "biz/deliveryOne";
	}
	
}
