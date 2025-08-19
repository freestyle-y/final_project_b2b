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
	public List<Quotation> getQuotationOne(int quotationNo, int subProductRequestNo) {

		return quotationMapper.getQuotationOne(quotationNo, subProductRequestNo);
	}
	public int updateStatusAtApprove(int quotationNo, int subProductRequestNo) {

		return quotationMapper.updateStatusAtApprove(quotationNo, subProductRequestNo);
	}
	public int updateStatusAtReject(int quotationNo, int subProductRequestNo, String rejectionReason, String userId) {

		return quotationMapper.updateStatusAtReject(quotationNo, subProductRequestNo, rejectionReason, userId);
	}
	public List<Quotation> getQuotationOneByQuotationNo(int productRequestNo) {

		return quotationMapper.getQuotaionOneByQuotationNo(productRequestNo);
	}
	public int insertQuotation(Quotation quotation) {

		return quotationMapper.insertQuotation(quotation);
	}
}
