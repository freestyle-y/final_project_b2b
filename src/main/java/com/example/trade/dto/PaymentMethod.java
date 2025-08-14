package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PaymentMethod {
	private int paymentMethodNo;
	private String userId;
	private String paymentCode;
	private String financialInstitution;
	private String accountNumber;
	private String cardPassword;
	private String cardCvc;
	private String cardExpiration;
	private String isDefault;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
}
