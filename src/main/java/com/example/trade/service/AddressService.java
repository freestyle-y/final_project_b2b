package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Address;
import com.example.trade.mapper.AddressMapper;

@Service
public class AddressService {
	private final AddressMapper addressMapper;
	
	public AddressService(AddressMapper addressMapper) {
		this.addressMapper = addressMapper;
	}

	public List<Address> getAddressList(String userId) {

		return addressMapper.getAddressList(userId);
	}

	public int addAddress(Address address) {

		return addressMapper.addAddress(address);
	}

}
