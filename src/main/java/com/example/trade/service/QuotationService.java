package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Quotation;
import com.example.trade.mapper.QuotationMapper;

@Service
public class QuotationService {
	private final QuotationMapper quotationMapper;
	public QuotationService(QuotationMapper quotationMapper) {
		super();
		this.quotationMapper = quotationMapper;
	}
	public List<Quotation> getQuotationList(String userId) {

		return quotationMapper.getQuotationList(userId);
	}
	
}
