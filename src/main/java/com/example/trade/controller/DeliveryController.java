package com.example.trade.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
	
	// 배송 상세 페이지(기업)
	@GetMapping("/biz/deliveryOne")
	public String bizDeliveryOne() {
		return "biz/deliveryOne";
	}
	
	// 배송 목록 페이지(개인)
	@GetMapping("/personal/deliveryList")
	public String personalDeliveryList() {
		return "personal/deliveryList";
	}
	
	// 배송 상세 페이지(개인)
	@GetMapping("/personal/deliveryOne")
	public String personalDeliveryOne(@RequestParam int subOrderNo, Model model) {
		List<Map<String, Object>> personalDeliveryOne = deliveryService.getPersonalDeliveryOne(subOrderNo);
		model.addAttribute("personalDeliveryOne", personalDeliveryOne);
		return "personal/deliveryOne";
	}
}
