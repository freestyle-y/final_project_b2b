package com.example.trade.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.trade.dto.Quotation;
import com.example.trade.service.QuotationService;

@Controller
public class QuotationController {
	private final QuotationService quotationService;
	
	public QuotationController(QuotationService quotationService) {
		super();
		this.quotationService = quotationService;
	}

	// 견적서 작성 페이지
	@GetMapping("/admin/writeQuotation")
	public String writeQuotation() {
		return "admin/writeQuotation";
	}
	
    // 견적서 목록 페이지
	@GetMapping("/biz/quotationList")
	public String quotationList(Model model, Principal principal) {
		String userId = principal.getName();
	    List<Quotation> quotationList = quotationService.getQuotationList(userId);
	    model.addAttribute("quotationList", quotationList);
	    return "biz/quotationList";
	}

	// 견적서 상세 페이지
	@GetMapping("/biz/quotationOne")
	public String quotationOne() {
		return "biz/quotationOne";
	}
}
