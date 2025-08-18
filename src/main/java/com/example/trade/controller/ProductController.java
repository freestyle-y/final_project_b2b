package com.example.trade.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.trade.dto.Category;
import com.example.trade.dto.Order;
import com.example.trade.dto.User;
import com.example.trade.service.ProductService;

import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ProductController {
	private final ProductService productService;
	public ProductController(ProductService productService) {
		this.productService = productService;
	}

	// 상품 후기 페이지
	@GetMapping("/public/reviewList")
	public String reviewList(Model model) {
		List<Map<String, Object>> reviewList = productService.selectReviewList();
		log.info(reviewList.toString());
		model.addAttribute("reviewList", reviewList);
		return "public/reviewList";
	}
	
	// 개인 메인 페이지
	@GetMapping("/personal/mainPage")
	public String perMainPage(Model model) {
		List<Map<String, Object>> productList = productService.selectProductByWish();
		//log.info(productList.toString());
		model.addAttribute("productList", productList);
		return "personal/mainPage";
	}
	
	// 찜
	@GetMapping("/personal/wishList")
	public String wishList(HttpSession session, Model model) {
		//User loginUser = (User) session.getAttribute("loginUser");
		List<Map<String, Object>> wishList = productService.selectWishList("user01");
		//log.info(wishList.toString());
		model.addAttribute("wishList", wishList);
		return "personal/wishList";
	}
	
	// 장바구니
	@GetMapping("/personal/shoppingCart")
	public String shoppingCart(HttpSession session, Model model) {
		//User loginUser = (User) session.getAttribute("loginUser");
		List<Map<String, Object>> shoppingCartList = productService.selectShoppingCart("3");
		//log.info(shoppingCartList.toString());
		model.addAttribute("shoppingCartList", shoppingCartList);
		return "personal/shoppingCart";
	}
	
	// 상품 목록
	@GetMapping("/personal/productList")
	public String productList(Model model) {
		List<Category> majorCategoryList = productService.selectMajorCategory();
		List<Map<String, Object>> productList = productService.selectProductListByCategory(null, null);
		//log.info(majorCategoryList.toString());
		//log.info(productList.toString());
		model.addAttribute("majorCategoryList", majorCategoryList);
		model.addAttribute("productList", productList);
		return "personal/productList";
	}
	
	// 개인용 상품 상세 페이지
	@GetMapping("/personal/productOne")
	public String perProductOne() {
		return "indiviual/productOne";
	}
	
	// 기업회원 상품 요청
	@GetMapping("/biz/productRequest")
	public String productRequest() {
		return "biz/productRequest";
	}
	
	// 기업 메인 페이지
	@GetMapping("/biz/mainPage")
	public String bizMainPage() {
		return "biz/mainPage";
	}
	
	// 기업용 상품 상세 페이지
	@GetMapping("/biz/productOne")
	public String bizProductOne() {
		return "biz/productOne";
	}
	
	// 상품 등록 페이지
	@GetMapping("/admin/insertProduct")
	public String insertProduct() {
		return "admin/insertProduct";
	}
	
	// 재고 목록 페이지
	@GetMapping("/admin/inventoryList")
	public String inventoryList() {
		return "admin/inventoryList";
	}
}
