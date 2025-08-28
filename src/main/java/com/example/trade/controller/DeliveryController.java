package com.example.trade.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.example.trade.dto.DeliveryHistory;
import com.example.trade.dto.Order;
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
	public String bizDeliveryList(Model model, Principal principal) {
		
		String username = principal.getName();
		model.addAttribute("username", username);

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
	public String personalDeliveryOne(DeliveryHistory deliveryHistory, Model model) {
		List<Map<String, Object>> personalDeliveryOne = deliveryService.getPersonalDeliveryOne(deliveryHistory);
		model.addAttribute("personalDeliveryOne", personalDeliveryOne);
		return "personal/deliveryOne";
	}
	
	// 교환/반품 신청 페이지(개인)
	@GetMapping("/personal/exchangeReturn")
	public String exchangeReturn(Order order, Model model) {
		model.addAttribute("orderNo", order.getOrderNo());
		model.addAttribute("subOrderNo", order.getSubOrderNo());
		model.addAttribute("orderQuantity", order.getOrderQuantity());
		return "personal/exchangeReturn";
	}
	
	// 교환/반품 신청 처리
	@PostMapping("/personal/exchangeReturn")
	public String submitExchangeReturn(Order order, Principal principal) {
		// 로그인 사용자
		order.setUpdateUser(principal.getName());

		// 서비스 호출
		deliveryService.requestExchangeReturn(order);

		// 신청 후 주문 목록으로 리다이렉트
		return "redirect:/personal/orderList";
	}
}
