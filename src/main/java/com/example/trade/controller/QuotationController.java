package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class QuotationController {
	// 견적서 작성 페이지
	@GetMapping("/admin/writeQuotation")
	public String writeQuotation() {
		return "admin/writeQuotation";
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
}
