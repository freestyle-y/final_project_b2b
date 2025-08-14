package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class User {
	private String id;
	private String password;
	private String customerCategory;
	private String name;
	private String phone;
	private String sn;
	private String email;
	private String postal;
	private String address;
	private String detailAddress;
	private String simplePassword;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String companyName;
	private String bussinessNo;
	private int totalReward;
	private int failedLoginCount;
	private String customerStatus;
}
