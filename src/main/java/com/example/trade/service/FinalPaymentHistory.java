package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Contract;
import com.example.trade.mapper.FinalPaymentHistoryMapper;

@Service
public class FinalPaymentHistory {
	private final FinalPaymentHistoryMapper finalPaymentHistoryMapper;

	public FinalPaymentHistory(FinalPaymentHistoryMapper finalPaymentHistoryMapper) {
		super();
		this.finalPaymentHistoryMapper = finalPaymentHistoryMapper;
	}

	public List<Contract> getFinalList() {
		return finalPaymentHistoryMapper.getFinalList();
	}
	
}
