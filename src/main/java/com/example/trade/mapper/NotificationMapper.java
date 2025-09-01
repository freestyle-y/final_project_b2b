package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface NotificationMapper {

	List<Map<String, Object>> getNotifications(String userId);

	int getUnreadCount(String userId);

	void markAsRead(int notificationNo);

}
