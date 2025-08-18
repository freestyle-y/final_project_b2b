package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Category;

@Mapper
public interface ProductMapper {
	
	// 상품 목록(찜 많은순)
	List<Map<String, Object>> productListByWish();
	// 개인 찜 목록 보기
	List<Map<String, Object>> wishList(String id);
	// 개인 장바구니 목록 보기
	List<Map<String, Object>> shoppingCart(String id);
	// 카테고리(대분류) 목록
	List<Category> majorCategory();
	// 카테고리(중분류) 목록
	List<Category> middleCategory(String id);
	// 카테고리별 상품 목록 보기
	List<Map<String, Object>> productListByCategory(String parentId, String middleId);
}
