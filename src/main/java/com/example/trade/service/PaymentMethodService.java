package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.PaymentMethod;
import com.example.trade.mapper.PaymentMethodMapper;

@Service
public class PaymentMethodService {
	private final PaymentMethodMapper paymentMethodMapper;
	
	public PaymentMethodService(PaymentMethodMapper paymentMethodMapper) {
		super();
		this.paymentMethodMapper = paymentMethodMapper;
	}

	public List<PaymentMethod> getUserCardList(String userId) {
		return paymentMethodMapper.getUserCardList(userId);
	}

	public int insertCard(PaymentMethod paymentMethod) {
		return paymentMethodMapper.insertCard(paymentMethod);
	}

}
