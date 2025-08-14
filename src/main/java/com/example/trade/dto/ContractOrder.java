package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ContractOrder {
	private int contractOrderNo;
	private int contractNo;
	private LocalDateTime orderTime;
	private LocalDateTime arrivalTime;
}
