package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.PaymentMethod;

@Mapper
public interface PaymentCardMapper {

	List<PaymentMethod> getCardList(String userId);

	void updateUseStatus(int paymentMethodNo, String userId);

	void setDefault(int paymentMethodNo, String userId);

	PaymentMethod getCardOne(int paymentMethodNo, String userId);

	void updateCardInfo(PaymentMethod paymentMethod);

	int getCountOrderList(String userId);

}
