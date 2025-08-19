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
	private String customerCategory; // CC001 : 관리자 CC002 : 기업회원 CC003 : 개인회원
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
	private String companyName; // 기업회원만
	private String businessNo; // 기업회원만
	private Integer totalReward;
	private Integer failedLoginCount;
	private String customerStatus;
}
