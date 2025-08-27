package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Order;

@Mapper
public interface OrderMapper {

	List<Order> getOrderList(String orderNo);
	Order getOrder(@Param("orderNo") String orderNo);
	int getTotalPrice(String orderNo);
	int getOrderItemCount(String orderNo);
	String getUserIdByOrderNo(String orderNo);
	String getFirstProductName(String orderNo);
	List<Order> getOrderListByUserId(String userId);
	List<Order> selectOrderDetailByOrderNo(int orderNo);
	int getReward(String userId);
	int updateDeliveryRequest(@Param("orderNo") String orderNo
							 ,@Param("deliveryRequest") String deliveryRequest);
	void insertUsedPoint(@Param("orderNo") String orderNo
						,@Param("rewardUse") int rewardUse);
	int savePaymentMethod(@Param("orderNo") String orderNo
						 ,@Param("methodKor") String methodKor);
	int updateOrderStatus(String orderNo, String subOrderNo);
	void updateDeliveryAddress(String orderNo, Integer addressNo);
	int decreaseStock(@Param("productNo") int productNo, @Param("optionNo") int optionNo, @Param("quantity") int quantity);
}
