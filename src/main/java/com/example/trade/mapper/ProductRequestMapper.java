package com.example.trade.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.ProductRequest;

@Mapper
public interface ProductRequestMapper {

	List<ProductRequest> getProductRequestList();
}
