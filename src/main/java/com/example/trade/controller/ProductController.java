package com.example.trade.controller;

import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import com.example.trade.dto.Address;
import com.example.trade.dto.Category;
import com.example.trade.dto.Option;
import com.example.trade.dto.Product;
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
	
	// 상품 후기 페이지
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
		log.info(productList.toString());
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
		List<Map<String, Object>> productOne = productService.selectPersonalProductOne(loginUserName, productNo);
		//log.info(productOne.toString());
		
		// 공통 정보 추출 (상품명, 번호, 찜 여부 등)
	    Map<String, Object> commonInfo = new HashMap<>();
	    Map<String, Object> first = productOne.get(0);

	    commonInfo.put("productNo", first.get("productNo"));
	    commonInfo.put("productName", first.get("productName"));
	    
	    String wishUseStatus = (String) first.get("wishUseStatus");
	    commonInfo.put("isWish", "Y".equalsIgnoreCase(wishUseStatus));
	    
	    // 이미지 경로 리스트는 공통 정보로 담기 (옵션마다 중복된 값이므로 첫 번째에서만 추출)
	    List<String> imagePaths = (List<String>) first.get("imagePaths");
	    commonInfo.put("imagePaths", imagePaths);
	    
	    // 옵션 리스트 생성
	    List<Map<String, Object>> optionList = new ArrayList<>();
	    for (Map<String, Object> item : productOne) {
	        Map<String, Object> opt = new HashMap<>();
	        opt.put("optionNameValue", item.get("optionNameValue"));
	        opt.put("price", item.get("price"));
	        opt.put("quantity", item.get("quantity"));
	        opt.put("optionNo", item.get("optionNo"));
	        optionList.add(opt);
	    }

	    List<Map<String, Object>> productReview = productService.selectProductReview(productNo);
	    //log.info(productReview.toString());
	    Double avgProductRate = productService.avgProductRate(productNo);
	    //log.info(avgProductRate + "");
	    
	    //log.info(commonInfo.toString());
	    
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
	
	// 상품 요청 DB insert
	@PostMapping("/biz/productRequest")
	public String productRequest(@ModelAttribute ProductRequestForm form) {
	    List<ProductRequest> productRequestList = form.getProductRequestList();
	    int addressNo = form.getAddressNo();
	    String requests = form.getRequests();

	    for (ProductRequest pr : productRequestList) {
	        // 공통으로 받은 배송지, 요청사항을 각 상품에 세팅해주기 (필요 시)
	        pr.setAddressNo(addressNo);
	        pr.setRequests(requests);
	        //log.info(pr.toString());
	    }
	    
	    productService.insertProductRequest(productRequestList);
	    return "redirect:/biz/productRequestList";
	}
	
	// 상품 요청 리스트 조회 페이지
	@GetMapping("/biz/productRequestList")
	public String productRequestList(Model model) {
		List<ProductRequest> productRequestList = productService.selectProductRequestList();
		//log.info(productRequestList.toString());
		
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	    for (ProductRequest req : productRequestList) {
	        if (req.getCreateDate() != null) {
	            req.setFormattedCreateDate(req.getCreateDate().format(formatter));
	        }
	    }
	    
		Map<Integer, List<ProductRequest>> groupedRequests = 
			    productRequestList.stream()
			        .collect(Collectors.groupingBy(ProductRequest::getProductRequestNo));

		// Map을 내림차순 정렬된 LinkedHashMap으로 변경
		Map<Integer, List<ProductRequest>> sortedGroupedRequests = 
		    groupedRequests.entrySet().stream()
		        .sorted(Map.Entry.<Integer, List<ProductRequest>>comparingByKey(Comparator.reverseOrder()))
		        .collect(Collectors.toMap(
		            Map.Entry::getKey,
		            Map.Entry::getValue,
		            (e1, e2) -> e1,
		            LinkedHashMap::new
		        ));

		model.addAttribute("groupedRequests", sortedGroupedRequests);
		return "biz/productRequestList";
	}
	
	// 상품 요청 상세 조회 페이지
	@GetMapping("/biz/requestDetail")
	public String bizRequestDetail(Model model,
			@RequestParam int requestNo) {
		List<Map<String, Object>> productRequestOne = productService.selectProductRequestOne(requestNo);
		//log.info(productRequestOne.toString());
		model.addAttribute("productRequestOne", productRequestOne);
		return "biz/requestDetail";
	}
	
	// 상품 요청 수정
	@GetMapping("biz/editRequest")
	public String bizEditRequest(Model model,
			@RequestParam int requestNo) {
		String loginUserName = SecurityContextHolder.getContext().getAuthentication().getName();
		//log.info(loginUserName);
		List<Map<String, Object>> productRequestOne = productService.selectProductRequestOne(requestNo);
		log.info(productRequestOne.toString());
		List<Address> bizAddressList = productService.selectBizAddress(loginUserName);
		log.info(bizAddressList.toString());
		model.addAttribute("productRequestOne", productRequestOne);
		model.addAttribute("bizAddressList", bizAddressList);
		return "biz/editRequest";
	}
	
	// 상품 요청 수정 DB update
	@PostMapping("biz/editRequest")
	public String bizEditRequest(@ModelAttribute ProductRequestForm productRequestForm) {
		//log.info(productRequestForm.toString());
		productService.updateProductRequests(productRequestForm);
	    return "redirect:/biz/productRequestList";
	}
	
	// 상품 요청 삭제
	@GetMapping("biz/deleteRequest")
	public String bizDeleteRequest(@RequestParam int requestNo) {
		productService.deleteProductRequest(requestNo);
		return "redirect:/biz/productRequestList";
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
		List<Map<String, Object>> productOne = productService.selectProductOne(productNo);
		//log.info(productOne.toString());
		
		// 공통 정보 추출 (상품명, 번호)
	    Map<String, Object> commonInfo = new HashMap<>();
	    Map<String, Object> first = productOne.get(0);

	    commonInfo.put("productNo", first.get("productNo"));
	    commonInfo.put("productName", first.get("productName"));

	    List<Map<String, Object>> productReview = productService.selectProductReview(productNo);
	    //log.info(productReview.toString());
	    Double avgProductRate = productService.avgProductRate(productNo);
	    //log.info(avgProductRate + "");
	    
	    model.addAttribute("product", commonInfo);
	    model.addAttribute("productReview", productReview);
	    model.addAttribute("avgProductRate", avgProductRate);
		return "biz/productOne";
	}
	
	// 상품 등록 페이지
	@GetMapping("/admin/insertProduct")
	public String insertProduct(Model model) {
		String loginUserName = SecurityContextHolder.getContext().getAuthentication().getName();
		//log.info(loginUserName);
		
		// 카테고리 불러오기
		List<Category> majorCategoryList = productService.selectMajorCategory();
		//log.info(majorCategoryList.toString());
		
		// 옵션 불러오기
		List<Option> optionList = productService.selectOptionList();
		//log.info(optionList.toString());
		
		model.addAttribute("majorCategoryList", majorCategoryList);
		model.addAttribute("optionList", optionList);
		model.addAttribute("loginUserName", loginUserName);
		return "admin/insertProduct";
	}
	
	// 상품 등록 DB insert
	@PostMapping("/admin/insertProduct")
	public String insertProduct(Product product) {
		//log.info(product.toString());
		productService.insertProduct(product);
		return "redirect:/admin/mainPage";
	}
	
	// 관리자 상품 목록 페이지
	@GetMapping("/admin/productList")
	public String adminProductList(Model model) {
		List<Category> majorCategoryList = productService.selectMajorCategory();
		List<Map<String, Object>> productList = productService.selectAllProductListByCategory(null, null);
		//log.info(majorCategoryList.toString());
		log.info(productList.toString());
		model.addAttribute("majorCategoryList", majorCategoryList);
		model.addAttribute("productList", productList);	
		return "admin/productList";
	}
	
	// 관리자 상품 상세 페이지
	@GetMapping("/admin/productOne")
	public String adminProductOne(Model model,
			@RequestParam int productNo) {
		//log.info(productNo + "");
		List<Map<String, Object>> productOne = productService.selectProductOne(productNo);
		//log.info(productOne.toString());
		
		// 공통 정보 추출 (상품명, 번호, 찜 여부 등)
	    Map<String, Object> commonInfo = new HashMap<>();
	    Map<String, Object> first = productOne.get(0);

	    commonInfo.put("productNo", first.get("productNo"));
	    commonInfo.put("productName", first.get("productName"));
	    
	    // 옵션 리스트 생성
	    List<Map<String, Object>> optionList = new ArrayList<>();
	    for (Map<String, Object> item : productOne) {
	        Map<String, Object> opt = new HashMap<>();
	        opt.put("optionNameValue", item.get("optionNameValue"));
	        opt.put("price", item.get("price"));
	        opt.put("quantity", item.get("quantity"));
	        opt.put("optionNo", item.get("optionNo"));
	        optionList.add(opt);
	    }
	    
	    model.addAttribute("product", commonInfo);
	    model.addAttribute("optionList", optionList);
		return "admin/productOne";
	}
	
	// 상품 이미지 등록
	@PostMapping("/admin/uploadProductImage")
	public String uploadProductImage(@RequestParam int productNo, 
			@RequestParam("imageFiles") List<MultipartFile> imageFiles) {
		String loginUserName = SecurityContextHolder.getContext().getAuthentication().getName();
		//log.info(loginUserName);
		
		productService.insertProductImages(productNo, imageFiles, loginUserName);
		return "redirect:/admin/mainPage";
	}
	
	// 재고 목록 페이지
	@GetMapping("/admin/inventoryList")
	public String inventoryList(Model model) {
		List<Map<String, Object>> inventoryList = productService.selectInventoryList();
		//log.info(inventoryList.toString());
		model.addAttribute("inventoryList", inventoryList);
		return "admin/inventoryList";
	}
}
