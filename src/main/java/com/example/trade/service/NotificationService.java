package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.trade.mapper.NotificationMapper;

@Service
public class NotificationService {
	private NotificationMapper notificationMapper;
	public NotificationService(NotificationMapper notificationMapper) {
		this.notificationMapper = notificationMapper;
	}
	
	// 알림 목록 조회
	public List<Map<String, Object>> getNotifications(String userId) {
		return notificationMapper.getNotifications(userId);
	}
	
	// 안 읽은 알림 개수
	public int getUnreadCount(String userId) {
		return notificationMapper.getUnreadCount(userId);
	}
	
	// 특정 알림 읽음 처리
	public void markAsRead(int notificationNo) {
		notificationMapper.markAsRead(notificationNo);
	}
}
