package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.PaymentMethod;

@Mapper
public interface PaymentMethodMapper {

	List<PaymentMethod> getUserCardList(String userId);

	int insertCard(PaymentMethod paymentMethod);

}
