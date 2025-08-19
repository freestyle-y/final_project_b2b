package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Notification {
	private int notificationNo;
	private String targetType;
	private String targetValue;
	private String notificationType;
	private String notificationTitle;
	private String notificationContent;
	private String targetUrl;
	private String imageUrl;
	private String readStatus;
	private LocalDateTime readDate;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
}
