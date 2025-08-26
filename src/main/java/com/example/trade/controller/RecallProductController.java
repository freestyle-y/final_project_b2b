package com.example.trade.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Container;
import com.example.trade.service.RecallProductService;

@Controller
public class RecallProductController {
	private final RecallProductService recallProductService;
	public RecallProductController(RecallProductService recallProductService) {
		super();
		this.recallProductService = recallProductService;
	}

	// 회수 상품 목록
	@GetMapping("/admin/recallProductList")
	public String recallProduct(Model model) {
		List<Container> list = recallProductService.getRecallProductList();
		model.addAttribute("list", list);
		return "admin/recallProductList";
	}
	
	// 상품 회수 전송
	@PostMapping("/admin/recallProduct")
	public String recallProduct(@RequestParam("containerNo") int containerNo) {
	    recallProductService.updateContractDeliveryStatus(containerNo);
	    return "redirect:/admin/recallProductList";
	}
	
	// 상품 회수 취소
	@PostMapping("/admin/recallProductCancel")
	public String recallProductCancel(@RequestParam("containerNo") int containerNo) {
		recallProductService.updateContractDeliveryRollback(containerNo);
		return "redirect:/admin/finalPaymentHistory";
	}

}
