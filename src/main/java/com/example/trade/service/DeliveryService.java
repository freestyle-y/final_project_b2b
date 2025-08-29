package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.trade.dto.DeliveryHistory;
import com.example.trade.dto.Order;
import com.example.trade.mapper.DeliveryMapper;

@Service
public class DeliveryService {
	private DeliveryMapper deliveryMapper;
	public DeliveryService(DeliveryMapper deliveryMapper) {
		this.deliveryMapper = deliveryMapper;
	}

	// 배송 목록 조회(기업)
	public List<Map<String, Object>> getBizDeliveryList(String username) {
		return deliveryMapper.selectBizDeliveryList(username);
	}
	
	// 배송 상세 조회(기업)
	public List<DeliveryHistory> getBizDeliveryOne(DeliveryHistory deliveryHistory) {
		return deliveryMapper.selectBizDeliveryOne(deliveryHistory);
	}

	// 배송 상세 조회(개인)
	public List<Map<String, Object>> getPersonalDeliveryOne(DeliveryHistory deliveryHistory) {
		return deliveryMapper.selectPersonalDeliveryBySubOrderNo(deliveryHistory);
	}

	// 교환/반품 신청 처리
	public int requestExchangeReturn(Order order) {
		return deliveryMapper.updateExchangeReturn(order);
	}
}
