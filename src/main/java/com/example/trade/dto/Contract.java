package com.example.trade.dto;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Contract {
	private int contractNo;
	private int quotationNo;
	private int downPayment;
	private String downPaymentStatus;
	private LocalDateTime downPaymentDate;
	private int finalPayment;
	private String finalPaymentStatus;
	private LocalDateTime finalPaymentDate;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	
	public String getFormattedCreateDate() {
		if (createDate == null) return "";
		return createDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss"));
	}
	// comm_tbl 조인
	private String codeName;
	
	// product_request 조인
	private String productName;
	private String productOption;
	private String productQuantity;
	
	// user 조인
	private String name;
	private String companyName;
	private String address;
	private String detailAddress;
	private String phone;
}
