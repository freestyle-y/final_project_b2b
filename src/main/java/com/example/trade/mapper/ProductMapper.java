package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ProductMapper {
	
	// 상품 목록(찜 많은순)
	List<Map<String, Object>> productListByWish();
	// 개인 찜 목록 보기
	List<Map<String, Object>> wishList(String id);
	// 개인 장바구니 목록 보기
	List<Map<String, Object>> shoppingCart(String id);
}
