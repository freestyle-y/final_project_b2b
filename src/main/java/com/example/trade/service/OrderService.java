package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Order;
import com.example.trade.mapper.OrderMapper;

@Service
public class OrderService {
	private final OrderMapper orderMapper;	
	public OrderService(OrderMapper orderMapper) {
		this.orderMapper = orderMapper;
	}


	public List<Order> getOrderList(String orderNo) {

		return orderMapper.getOrderList(orderNo);
	}

}
