package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductRequest {
	private int productRequestNo;
	private int subProductRequestNo;
	private int addressNo;
	private String productName;
	private String productOption;
	private int productQuantity;
	private String requests;
	private String status;
	private String createUser;
	private LocalDateTime createDate;
	private String formattedCreateDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	
	// quotatio 조인
	private String quotationStatus;
	
	// ProductRequest.java
	private Integer revisionNo;                 // 0=미작성, 1=첫 견적, 2=재작성...
	private Long    quotationNo;                // 견적 번호
	private LocalDateTime quotationCreatedAt;   // 견적 생성일(정렬용)
	
	// user 조인
	private String name;
}
