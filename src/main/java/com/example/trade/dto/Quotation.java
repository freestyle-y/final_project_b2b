package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Quotation {
	private int quotationNo;
	private int subProductRequestNo;
	private int productRequestNo;
	private int price;
	private String status;
	private String refusalReason;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	
	// product_request 조인
	private String productName;
	private int productQuantity;
}
