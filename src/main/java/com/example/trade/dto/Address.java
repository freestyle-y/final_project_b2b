package com.example.trade.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Address {
	public int addressNo;
	public String ownerType;
	public String ownerNo;
	public String postal;
	public String address;
	public String detailAddress;
	public String nickname;
	public String createUser;
	public String createDate;
	public String updateUser;
	public String updateDate;
	public String useStatus;
	public String managerName;
}
