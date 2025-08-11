package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class ProductController {
	// 상품 목록
	@GetMapping("/public/productList")
	public String productList() {
		return "public/productList";
	}
	
	// 상품 상세 페이지
	@GetMapping("/public/productOne")
	public String productOne() {
		return "public/productOne";
	}
	
	// 찜
	@GetMapping("/personal/wishList")
	public String wishList() {
		return "personal/wishList";
	}
	
	// 장바구니
	@GetMapping("/personal/shoppingCart")
	public String shoppingCart() {
		return "personal/shoppingCart";
	}
	
}
