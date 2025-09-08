package com.example.trade.service;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Attachment;
import com.example.trade.dto.Order;
import com.example.trade.dto.User;
import com.example.trade.mapper.OrderMapper;
import com.example.trade.mapper.ProductMapper;

@Service
public class OrderService {
	private final OrderMapper orderMapper;
	private final ProductMapper productMapper;
	public OrderService(OrderMapper orderMapper, ProductMapper productMapper) {
		this.orderMapper = orderMapper;
		this.productMapper = productMapper;
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


	public List<Order> getOrderDetailByOrderNo(String orderNo) {
		
	    return orderMapper.selectOrderDetailByOrderNo(orderNo);
	}


	public int getReward(String userId) {

		return orderMapper.getReward(userId);
	}


    @Transactional
    public void updateDeliveryRequest(String orderNo, String deliveryRequest) {
        int rows = orderMapper.updateDeliveryRequest(orderNo, deliveryRequest);
    }

    @Transactional
    public void saveMethodAndPoints(String orderNo, String methodKor, int usePoint, Integer addressNo, Integer paymentMethodNo) {
        orderMapper.updateDeliveryAddress(orderNo, addressNo);
        orderMapper.savePaymentMethod(orderNo, methodKor, paymentMethodNo);
        List<Order> orderList = orderMapper.getOrderList(orderNo);
        for (Order order : orderList) {
            int updatedRows = orderMapper.decreaseStock(order.getProductNo(), order.getOptionNo(), order.getOrderQuantity());
            int quantity = productMapper.findInventoryQuantity(order.getProductNo(), order.getOptionNo());
            if (quantity == 0) {
            	productMapper.updateProductAndOptionStatus("system", order.getProductNo(), order.getOptionNo(), "GS003");
            }
            if (updatedRows == 0) { // 재고 부족으로 구매 실패
                throw new IllegalArgumentException(
                    String.format("상품 [%s %s] 재고 부족 (요청: %d, 남은 수량: %d)", 
                    order.getProductName(), order.getOptionNameValue(), order.getOrderQuantity(), quantity));
            }
        }
        
        if (usePoint > 0) orderMapper.insertUsedPoint(orderNo, usePoint);
    }

	public int updateOrderStatus(String orderNo, String subOrderNo) {
		return orderMapper.updateOrderStatus(orderNo, subOrderNo);
	}


	public List<User> getUserInformation(String userId) {
		return orderMapper.getUserInformation(userId);
	}

	// 결제 시 사용한 적립금 확인
	public int getUsedPointByOrderNo(String orderNo) {
		return orderMapper.getUsedPointByOrderNo(orderNo);
	}


	public int getCardCount(String userId) {
		return orderMapper.getCardCount(userId);
	}



}
