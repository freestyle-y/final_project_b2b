package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class DeliveryHistory {
	private int deliveryHistoryNo;
	private int orderNo;
	private int subOrderNo;
	private LocalDateTime time;
	private String status;
}
