package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Container;
import com.example.trade.mapper.RecallProductMapper;

@Service
public class RecallProductService {
	private final RecallProductMapper recallProductMapper;
	public RecallProductService(RecallProductMapper recallProductMapper) {
		super();
		this.recallProductMapper = recallProductMapper;
	}

	public void updateContractDeliveryStatus(int containerNo) {
		recallProductMapper.updateContractDeliveryStatus(containerNo);
	}

	public List<Container> getRecallProductList() {
		return recallProductMapper.getRecallProductList();
	}

	public void updateContractDeliveryRollback(int containerNo) {
		recallProductMapper.updateContractDeliveryRollback(containerNo);
	}

}
