package com.example.trade.dto;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Contract {
	private Integer contractNo;
	private int quotationNo;
	private BigDecimal downPayment;
	private String downPaymentStatus;
	private LocalDateTime downPaymentDate;
	private BigDecimal finalPayment;
	private String finalPaymentStatus;
	private LocalDateTime finalPaymentDate;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	
	public String getFormattedCreateDate() {
		if (createDate == null) return "";
		return createDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	}
	public String getFormattedDownPaymentDate() {
		if (downPaymentDate == null) return "";
		return downPaymentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	}

	public String getFormattedFinalPaymentDate() {
		if (finalPaymentDate == null) return "";
		return finalPaymentDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	}
	
	// comm_tbl 조인
	private String codeName;
	
	// product_request 조인
	private String productName;
	private String productOption;
	private int productQuantity;
	private BigDecimal price;
	// user 조인
	private String name;
	private String companyName;
	private String address;
	private String detailAddress;
	private String phone;
	
	// container 조인
	private int containerNo;
	
	// quotation 조인
	private LocalDateTime quotationCreateDate;
	public String getFormattedQuotationCreateDate() {
		if (quotationCreateDate == null) return "";
		return quotationCreateDate.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
	}
	
	// container_delivery 조인
	private String contractDeliveryStatus;
	
	// 배송상태 확인용
	private int deliveryExist;
	private String latestDeliveryStatus;
	private String recalled;
	
	// 관리자 기업회원 사인 유무 확인용
    private boolean supplierSigned;
    private boolean buyerSigned;
}
