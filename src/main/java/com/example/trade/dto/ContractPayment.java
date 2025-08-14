package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ContractPayment {
	private int contractPaymentNo;
	private int contractDeliveryNo;
	private String contractPaymentStatus;
	private LocalDateTime contractPaymentDate;
}
