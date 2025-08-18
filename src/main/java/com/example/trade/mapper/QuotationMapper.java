package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Quotation;

@Mapper
public interface QuotationMapper {

	List<Quotation> getQuotationList(String userId);

}
