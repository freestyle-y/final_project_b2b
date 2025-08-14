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
	private String notificationTitle;
	private LocalDateTime startDate;
	private LocalDateTime endDate;
}
