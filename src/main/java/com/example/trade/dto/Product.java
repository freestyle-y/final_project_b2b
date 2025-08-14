package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Product {
	private int productNo;
	private int optionNo;
	private String productName;
	private String productStatus;
	private String category; // 확인 필요
	private int price;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
}
