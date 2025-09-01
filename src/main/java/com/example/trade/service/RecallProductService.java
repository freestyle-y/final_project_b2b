package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Container;
import com.example.trade.mapper.RecallProductMapper;

@Service
public class RecallProductService {

    private final RecallProductMapper recallProductMapper;

    public RecallProductService(RecallProductMapper recallProductMapper) {
        this.recallProductMapper = recallProductMapper;
    }

    /** 회수 요청: contract_delivery에 RC_REQ 한 줄 append */
    @Transactional
    public void updateContractDeliveryStatus(int containerNo) {
        recallProductMapper.updateContractDeliveryStatus(containerNo); // INSERT RC_REQ
    }

    /** 리스트 */
    @Transactional(readOnly = true)
    public List<Container> getRecallProductList() {
        return recallProductMapper.getRecallProductList();
    }

    /** 회수 취소: contract_delivery에 RC_CANCEL 한 줄 append */
    @Transactional
    public void updateContractDeliveryRollback(int containerNo) {
        recallProductMapper.updateContractDeliveryRollback(containerNo); // INSERT RC_CANCEL
    }
}
