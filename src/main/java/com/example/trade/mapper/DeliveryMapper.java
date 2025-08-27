package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Order;

@Mapper
public interface DeliveryMapper {

	// 배송 목록 조회(기업)
	List<Map<String, Object>> selectBizDeliveryList();

	// 배송 상세 조회(개인)
	List<Map<String, Object>> selectPersonalDeliveryBySubOrderNo(int orderNo, int subOrderNo);

	// 교환/반품 신청 처리
	int updateExchangeReturn(Order order);
}
