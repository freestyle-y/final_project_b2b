package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.mapper.ProductMapper;

@Service
@Transactional
public class ProductService {
	private final ProductMapper productMapper;

	public ProductService(ProductMapper productMapper) {
		this.productMapper = productMapper;
	}
	
	// 상품 목록(찜 많은순)
	public List<Map<String, Object>> selectProductByWish() {
		return productMapper.productListByWish();
	}
	
	// 개인 찜 목록 보기
	public List<Map<String, Object>> selectWishList(String id) {
		return productMapper.wishList(id);
	}
	
	// 개인 장바구니 목록 보기
	public List<Map<String, Object>> selectShoppingCart(String id) {
		return productMapper.shoppingCart(id);
	}
}
