package com.example.trade.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.trade.dto.ProductRequest;
import com.example.trade.service.ProductRequestService;

@Controller
public class ProductRequestController {
	private final ProductRequestService productRequestService;
	
	public ProductRequestController(ProductRequestService productRequestService) {
		super();
		this.productRequestService = productRequestService;
	}

	@GetMapping("/admin/productRequestList")
	public String productRequestList(Model model, Principal principal) {
		String userId = principal.getName();
		List<ProductRequest> list = productRequestService.getProductRequestList();
		model.addAttribute("userId", userId);
		model.addAttribute("list", list);
		return "admin/productRequestList";
	}
}
