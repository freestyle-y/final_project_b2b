package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Attachment;
import com.example.trade.dto.Order;
import com.example.trade.dto.User;

@Mapper
public interface OrderMapper {

	List<Order> getOrderList(String orderNo);
	Order getOrder(@Param("orderNo") String orderNo);
	int getTotalPrice(String orderNo);
	int getOrderItemCount(String orderNo);
	String getUserIdByOrderNo(String orderNo);
	String getFirstProductName(String orderNo);
	List<Order> getOrderListByUserId(String userId);
	List<Order> selectOrderDetailByOrderNo(String orderNo);
	int getReward(String userId);
	int updateDeliveryRequest(@Param("orderNo") String orderNo
							 ,@Param("deliveryRequest") String deliveryRequest);
	void insertUsedPoint(@Param("orderNo") String orderNo
						,@Param("rewardUse") int rewardUse);
	int savePaymentMethod(@Param("orderNo") String orderNo
						 ,@Param("methodKor") String methodKor
						 ,@Param("paymentMethodNo") Integer paymentMethodNo);
	int updateOrderStatus(@Param("orderNo") String orderNo, @Param("subOrderNo") String subOrderNo);
	void updateDeliveryAddress(@Param("orderNo") String orderNo, @Param("addressNo") Integer addressNo);
	int decreaseStock(@Param("productNo") int productNo, @Param("optionNo") int optionNo, @Param("quantity") int quantity);
	List<User> getUserInformation(String userId);
	Integer getUsedPointByOrderNo(String orderNo);	
}
