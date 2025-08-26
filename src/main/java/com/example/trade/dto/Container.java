package com.example.trade.dto;

import java.math.BigDecimal;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Container {
	private int containerNo;
	private String containerLocation;
	private int contractOrderNo;
	
	// 상품 회수 조인용
	private String address;
	private String detailAddress;
	private String name;
	private String contractDeliveryStatus;
	private BigDecimal downPayment;
	private BigDecimal finalPayment;
	private String productName;
	private String productOption;
	private int productQuantity;
	private String companyName;
}
