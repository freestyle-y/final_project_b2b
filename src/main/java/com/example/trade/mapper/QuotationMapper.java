package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Quotation;

@Mapper
public interface QuotationMapper {

	List<Quotation> getQuotationList(String userId);

	List<Quotation> getQuotationOne(int quotationNo, int subProductRequestNo);

	int updateStatusAtApprove(int quotationNo, int subProductRequestNo);

	int updateStatusAtReject(int quotationNo, int subProductRequestNo, String rejectionReason, String userId);

	List<Quotation> getQuotaionOneByQuotationNo(int productRequestNo);

	int insertQuotation(String quotationNo, String subProductRequestNo, int price);

	List<Quotation> getAdminQuotationList();

	List<Quotation> adminQuotationOne(int quotationNo, int subProductRequestNo);

}
