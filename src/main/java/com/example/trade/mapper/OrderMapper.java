package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Order;

@Mapper
public interface OrderMapper {

	List<Order> getOrderList(String orderNo);

}
