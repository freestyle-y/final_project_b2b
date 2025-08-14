package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class NotiController {
	// 알림 목록
	@GetMapping("/public/notificationList")
	public String notificationList() {
		return "public/notificationList";
	}
	
	// 알림 작성 페이지
	@GetMapping("/admin/writeNotification")
	public String writeNotification() {
		return "admin/writeNotification";
	}
}
