package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Address;
import com.example.trade.mapper.AddressMapper;

@Service
public class AddressService {
	private final AddressMapper addressMapper;
	
	public AddressService(AddressMapper addressMapper) {
		this.addressMapper = addressMapper;
	}

	// 주소 목록 받기
	public List<Address> getAddressList(String userId) {
		return addressMapper.getAddressList(userId);
	}
	
	// 주소 추가
	public int addAddress(Address address) {
		return addressMapper.addAddress(address);
	}

	// 기본 배송지 받기
	public List<Address> getMainAddress(String userId) {
		return addressMapper.getMainAddress(userId);
	}

	// 기본 배송지 수정(N 으로 전체 변경 후 Y 변경)
	@Transactional
	public int changeMainAddress(String userId, int addressNo) {
	    addressMapper.resetMainAddress(userId);
	    return addressMapper.changeMainAddress(userId, addressNo);
	}

	// 배송지 삭제
	public int deleteAddress(String userId, int addressNo) {
	    return addressMapper.deleteAddress(userId, addressNo);
	}

}
