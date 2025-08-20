package com.example.trade.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.trade.service.DeliveryService;

@Controller
public class DeliveryController {
	private DeliveryService deliveryService;
	public DeliveryController(DeliveryService deliveryService) {
		this.deliveryService = deliveryService;
	}
	
	// 배송 입력 페이지
	@GetMapping("/admin/insertDelivery")
	public String insertDelivery() {
		return "admin/insertDelivery";
	}
	
	// 배송 목록 페이지(기업)
	@GetMapping("/biz/deliveryList")
	public String bizDeliveryList(Model model) {
		List<Map<String, Object>> bizDeliveryList = deliveryService.getBizDeliveryList();
		model.addAttribute("bizDeliveryList", bizDeliveryList);
		return "biz/deliveryList";
	}
	
	// 배송 상세 페이지
	@GetMapping("/biz/deliveryOne")
	public String bizDeliveryOne() {
		return "biz/deliveryOne";
	}
	
	// 배송 조회 페이지
	@GetMapping("/personal/deliveryList")
	public String personalDeliveryList() {
		return "personal/deliveryList";
	}
	
	// 배송 페이지
	@GetMapping("/personal/deliveryOne")
	public String personalDeliveryOne() {
		return "personal/deliveryOne";
	}
}
