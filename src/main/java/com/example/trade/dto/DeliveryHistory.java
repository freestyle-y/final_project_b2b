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
	private String orderNo;
	private String subOrderNo;
	private String deliveryCompany;
	private String trackingNo;
	private LocalDateTime updateDate;
	private String deliveryStatus;
}
