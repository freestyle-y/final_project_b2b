package com.example.trade.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Address;
import com.example.trade.dto.Category;
import com.example.trade.dto.ProductRequest;
import com.example.trade.dto.ProductRequestForm;
import com.example.trade.service.ProductService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class ProductController {
	private final ProductService productService;
	public ProductController(ProductService productService) {
		this.productService = productService;
	}

	// 상품 후기 페이지(개인)
	@GetMapping("/personal/reviewList")
	public String personalReviewList(Model model) {
		List<Map<String, Object>> reviewList = productService.selectReviewList();
		//log.info(reviewList.toString());
		model.addAttribute("reviewList", reviewList);
		return "personal/reviewList";
	}
	
	// 상품 후기 페이지(전체)
	@GetMapping("/public/reviewList")
	public String publicReviewList(Model model) {
		List<Map<String, Object>> reviewList = productService.selectReviewList();
		//log.info(reviewList.toString());
		model.addAttribute("reviewList", reviewList);
		return "public/reviewList";
	}
	
	// 개인 메인 페이지
	@GetMapping("/personal/mainPage")
	public String personalMainPage(Model model) {
		List<Map<String, Object>> productList = productService.selectProductByWish();
		//log.info(productList.toString());
		model.addAttribute("productList", productList);
		return "personal/mainPage";
	}
	
	// 찜
	@GetMapping("/personal/wishList")
	public String wishList(Model model) {
		String loginUserName = SecurityContextHolder.getContext().getAuthentication().getName();
		//log.info(loginUserName);
		List<Map<String, Object>> wishList = productService.selectWishList(loginUserName);
		//log.info(wishList.toString());
		model.addAttribute("loginUserName", loginUserName);
		model.addAttribute("wishList", wishList);
		return "personal/wishList";
	}
	
	// 장바구니
	@GetMapping("/personal/shoppingCart")
	public String shoppingCart(Model model) {
		String loginUserName = SecurityContextHolder.getContext().getAuthentication().getName();
		//log.info(loginUserName);
		List<Map<String, Object>> shoppingCartList = productService.selectShoppingCart(loginUserName);
		//log.info(shoppingCartList.toString());
		model.addAttribute("loginUserName", loginUserName);
		model.addAttribute("shoppingCartList", shoppingCartList);
		return "personal/shoppingCart";
	}
	
	// 상품 목록
	@GetMapping("/personal/productList")
	public String personalProductList(Model model) {
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
	public String personalProductOne(Model model,
			@RequestParam int productNo) {
		//log.info("" + productNo);
		String loginUserName = SecurityContextHolder.getContext().getAuthentication().getName();
		//log.info(loginUserName);
		List<Map<String, Object>> productOne = productService.selectProductOne(loginUserName, productNo);
		//log.info(productOne.toString());
		
		// 공통 정보 추출 (상품명, 번호, 찜 여부 등)
	    Map<String, Object> commonInfo = new HashMap<>();
	    Map<String, Object> first = productOne.get(0);

	    commonInfo.put("productNo", first.get("productNo"));
	    commonInfo.put("productName", first.get("productName"));
	    commonInfo.put("isWish", first.get("isWish"));

	    // 옵션 리스트 생성
	    List<Map<String, Object>> optionList = new ArrayList<>();
	    for (Map<String, Object> item : productOne) {
	        Map<String, Object> opt = new HashMap<>();
	        opt.put("optionNameValue", item.get("optionNameValue"));
	        opt.put("price", item.get("price"));
	        opt.put("quantity", item.get("quantity"));
	        optionList.add(opt);
	    }

	    List<Map<String, Object>> productReview = productService.selectProductReview(productNo);
	    //log.info(productReview.toString());
	    Double avgProductRate = productService.avgProductRate(productNo);
	    //log.info(avgProductRate + "");
	    
	    model.addAttribute("product", commonInfo);
	    model.addAttribute("optionList", optionList);
	    model.addAttribute("productReview", productReview);
	    model.addAttribute("avgProductRate", avgProductRate);
	    model.addAttribute("loginUserName", loginUserName);
		return "personal/productOne";
	}
	
	// 기업회원 상품 요청
	@GetMapping("/biz/productRequest")
	public String productRequest(Model model) {
		String loginUserName = SecurityContextHolder.getContext().getAuthentication().getName();
		//log.info(loginUserName);
		List<Address> bizAddressList = productService.selectBizAddress(loginUserName);
		//log.info(bizAddressList.toString());
		model.addAttribute("bizAddressList", bizAddressList);
		model.addAttribute("loginUserName", loginUserName);
		return "biz/productRequest";
	}
	
	//
	@PostMapping("/biz/productRequest")
	public String productRequest(@ModelAttribute ProductRequestForm form) {
	    return "redirect:/biz/mainPage";
	}
	
	// 기업 메인 페이지
	@GetMapping("/biz/mainPage")
	public String bizMainPage(Model model) {
		List<Map<String, Object>> productList = productService.selectProductByWish();
		//log.info(productList.toString());
		model.addAttribute("productList", productList);
		return "biz/mainPage";
	}
	
	// 기업용 상품 목록 페이지
	@GetMapping("/biz/productList")
	public String bizProductList(Model model) {
		List<Category> majorCategoryList = productService.selectMajorCategory();
		List<Map<String, Object>> productList = productService.selectProductListByCategory(null, null);
		//log.info(majorCategoryList.toString());
		//log.info(productList.toString());
		model.addAttribute("majorCategoryList", majorCategoryList);
		model.addAttribute("productList", productList);
		return "biz/productList";
	}
	
	// 기업용 상품 상세 페이지
	@GetMapping("/biz/productOne")
	public String bizProductOne(Model model,
			@RequestParam int productNo) {
		//log.info("" + productNo);
		List<Map<String, Object>> productOne = productService.selectProductOne("user01", productNo);
		//log.info(productOne.toString());
		
		// 공통 정보 추출 (상품명, 번호, 찜 여부 등)
	    Map<String, Object> commonInfo = new HashMap<>();
	    Map<String, Object> first = productOne.get(0);

	    commonInfo.put("productNo", first.get("productNo"));
	    commonInfo.put("productName", first.get("productName"));
	    commonInfo.put("isWish", first.get("isWish"));

	    // 옵션 리스트 생성
	    List<Map<String, Object>> optionList = new ArrayList<>();
	    for (Map<String, Object> item : productOne) {
	        Map<String, Object> opt = new HashMap<>();
	        opt.put("optionNameValue", item.get("optionNameValue"));
	        opt.put("price", item.get("price"));
	        opt.put("quantity", item.get("quantity"));
	        optionList.add(opt);
	    }

	    List<Map<String, Object>> productReview = productService.selectProductReview(productNo);
	    //log.info(productReview.toString());
	    Double avgProductRate = productService.avgProductRate(productNo);
	    //log.info(avgProductRate + "");
	    
	    // JSP로 전달
	    model.addAttribute("product", commonInfo);
	    model.addAttribute("optionList", optionList);
	    model.addAttribute("productReview", productReview);
	    model.addAttribute("avgProductRate", avgProductRate);
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
