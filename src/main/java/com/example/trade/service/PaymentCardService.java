package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.PaymentMethod;
import com.example.trade.mapper.PaymentCardMapper;

@Service
public class PaymentCardService {
	private final PaymentCardMapper paymentCardMapper;
	
	public PaymentCardService(PaymentCardMapper paymentCardMapper) {
		super();
		this.paymentCardMapper = paymentCardMapper;
	}

	public List<PaymentMethod> getCardList(String userId) {

		return paymentCardMapper.getCardList(userId);
	}

	public void updateUseStatus(int paymentMethodNo, String userId) {
		paymentCardMapper.updateUseStatus(paymentMethodNo, userId);
	}

}
