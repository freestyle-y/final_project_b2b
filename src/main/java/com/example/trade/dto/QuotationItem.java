package com.example.trade.dto;

import lombok.Data;

@Data
//QuotationItem.java
public class QuotationItem {
 private int itemId;
 private int quotationNo;
 private int productRequestNo;
 private int subProductRequestNo;
 private int price;

 // JOIN 결과용
 private String productName;
 private String productOption;
 private int productQuantity;
}

