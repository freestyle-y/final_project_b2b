package com.example.trade.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.service.NotificationService;

@RestController
public class NotificationRestController {
	private NotificationService notificationService;
	public NotificationRestController(NotificationService notificationService) {
		this.notificationService = notificationService;
	}

	// 알림 목록 조회
	@GetMapping("/member/notificationList")
	public List<Map<String, Object>> getNotifications(Principal principal) {
		return notificationService.getNotifications(principal.getName());
	}

	// 안 읽은 알림 개수
	@GetMapping("/member/notificationCount")
	public int getUnreadCount(Principal principal) {
		return notificationService.getUnreadCount(principal.getName());
	}

	// 특정 알림 읽음 처리
	@PostMapping("/member/notificationRead")
	public void markAsRead(@RequestParam int notificationNo) {
		notificationService.markAsRead(notificationNo);
	}
}
