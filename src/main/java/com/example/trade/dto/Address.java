package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Address {
	private int addressNo;
	private String ownerType;
	private String userId;
	private String postal;
	private String address;
	private String detailAddress;
	private String nickname;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	private String managerName;
	private String mainAddress;
}
