package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class OrderAndDeliveryController {
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
	
	// 배송 조회 페이지
	@GetMapping("/personal/deliveryList")
	public String deliveryList() {
		return "personal/deliveryList";
	}
	
	// 배송 페이지
	@GetMapping("/personal/deliveryOne")
	public String deliveryOne() {
		return "personal/deliveryOne";
	}
	
	// 적립금 페이지
	@GetMapping("/personal/rewardList")
	public String rewardList() {
		return "personal/rewardList";
	}
}
