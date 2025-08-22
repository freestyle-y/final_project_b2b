package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.trade.mapper.DeliveryMapper;

@Service
public class DeliveryService {
	private DeliveryMapper deliveryMapper;
	public DeliveryService(DeliveryMapper deliveryMapper) {
		this.deliveryMapper = deliveryMapper;
	}

	// 배송 목록 조회(기업)
	public List<Map<String, Object>> getBizDeliveryList() {
		return deliveryMapper.selectBizDeliveryList();
	}

	// 배송 상세 조회(개인)
	public List<Map<String, Object>> getPersonalDeliveryOne(int orderNo, int subOrderNo) {
		return deliveryMapper.selectPersonalDeliveryBySubOrderNo(orderNo, subOrderNo);
	}
}
