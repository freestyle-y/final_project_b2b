package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Address;

@Mapper
public interface AddressMapper {

	List<Address> getAddressList(String userId);

	int addAddress(Address address);

}
