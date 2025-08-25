package com.example.trade.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Quotation {
    private int quotationNo;
    private int productRequestNo;
    private String status;
    private String refusalReason;
    private String createUser;
    private String createDate;
    private String updateUser;
    private String updateDate;
    private String useStatus;

    // 견적서 안에 포함된 상품들
    private List<QuotationItem> items;
	
	// product_request 조인
	private String productName;
	private int productQuantity;
	private String productOption;
	private String requestCompanyUser;
	private String requestCompanyName;
}
