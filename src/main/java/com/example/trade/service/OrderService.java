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


	public Order getOrder(String orderNo) {
		return orderMapper.getOrder(orderNo);
	}


	public int getOrderItemCount(String orderNo) {

		return orderMapper.getOrderItemCount(orderNo);
	}


	public List<Order> getOrderListByuserId(String userId) {

		return orderMapper.getOrderListByUserId(userId);
	}


	public List<Order> getOrderDetailByOrderNo(int orderNo) {
		
	    return orderMapper.selectOrderDetailByOrderNo(orderNo);
	}
}
