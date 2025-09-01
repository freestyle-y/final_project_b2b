package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Container;

@Mapper
public interface RecallProductMapper {

	List<Container> getRecallProductList();

	void updateContractDeliveryStatus(int containerNo);
    
	void updateContractDeliveryRollback(int containerNo);


}
