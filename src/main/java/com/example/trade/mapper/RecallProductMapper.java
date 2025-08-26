package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Container;

@Mapper
public interface RecallProductMapper {

	void updateContractDeliveryStatus(int containerNo);

	List<Container> getRecallProductList();

	void updateContractDeliveryRollback(int containerNo);

}
