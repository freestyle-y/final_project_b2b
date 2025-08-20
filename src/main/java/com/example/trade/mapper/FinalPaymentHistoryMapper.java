package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Contract;

@Mapper
public interface FinalPaymentHistoryMapper {

	List<Contract> getFinalList();

}
