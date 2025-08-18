package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Order {
	private String orderNo; // 확인 필요
	private String subOrderNo; // 확인 필요
	private String parentSubOrderNo; // 확인 필요
	private String userId;
	private int addressNo;
	private String deliveryRequest;
	private int productNo;
	private String productName;
	private int optionNo;
	private String optionName;
	private String optionNameValue;
	private int orderQuantity;
	private int price;
	private String paymentType;
	private LocalDateTime paymentTime;
	private int returnQuantity;
	private String returnReason;
	private LocalDateTime returnRequestTime;
	private LocalDateTime returnEndTime;
	private int exchangeQuantity;
	private String exchangeReason;
	private LocalDateTime exchangeRequestTime;
	private LocalDateTime exchangeEndTime;
	private String returnDeliveryMethod;
	private String orderStatus;
	private String deliveryStatus;
	private LocalDateTime orderTime;
	private int orderReward;
	private String orderRewardStatus;
	private String review;
	private double grade;
	private int reviewReward;
	private String reviewRewardStatus;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	
	// 결제 금액 총액 확인용
	private int totalPrice;
	// address 테이블 조인
	private String address;
	private String detailAddress;
	// user 테이블 조인
	private String name;
}
