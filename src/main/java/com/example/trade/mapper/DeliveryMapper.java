package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface DeliveryMapper {

	// 배송 목록 조회(기업)
	List<Map<String, Object>> selectBizDeliveryList();
}
