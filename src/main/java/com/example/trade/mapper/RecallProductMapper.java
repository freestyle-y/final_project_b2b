package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Container;

@Mapper
public interface RecallProductMapper {

    /** RC_REQ append */
    void updateContractDeliveryStatus(int containerNo);

    /** 리스트(최신 배송상태/존재여부 포함해서 뽑아도 Container에 매핑되는 것만 바인딩됨) */
    List<Container> getRecallProductList();

    /** RC_CANCEL append */
    void updateContractDeliveryRollback(int containerNo);
}
