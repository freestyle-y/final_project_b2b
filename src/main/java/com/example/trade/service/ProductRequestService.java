package com.example.trade.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.example.trade.dto.ProductRequest;
import com.example.trade.mapper.ProductRequestMapper;

@Service
public class ProductRequestService {
	private final ProductRequestMapper productRequestMapper;

	public ProductRequestService(ProductRequestMapper productRequestMapper) {
		super();
		this.productRequestMapper = productRequestMapper;
	}

	public List<ProductRequest> getProductRequestList() {
		return productRequestMapper.getProductRequestList();
	}

}
