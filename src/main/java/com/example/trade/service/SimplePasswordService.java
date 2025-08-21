package com.example.trade.service;

import org.springframework.stereotype.Service;

import com.example.trade.mapper.SimplePasswordMapper;

@Service
public class SimplePasswordService {
	private final SimplePasswordMapper simPWMapper;
	
	public SimplePasswordService(SimplePasswordMapper simPWMapper) {
		super();
		this.simPWMapper = simPWMapper;
	}


    public boolean checkSimPw(String userId) {
        return simPWMapper.checkSimPw(userId) > 0;
    }


	public boolean validatePassword(String userId, String simplePassword) {
		return simPWMapper.validatePassword(userId, simplePassword) > 0;
	}
	
	public void registerSimplePassword(String userId, String simplePassword) {
		simPWMapper.registerSimplePassword(userId, simplePassword);
	}
}
