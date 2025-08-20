package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Address;
import com.example.trade.dto.Category;
import com.example.trade.dto.Product;
import com.example.trade.dto.ProductRequest;

@Mapper
public interface ProductMapper {
	// 상품 후기 목록 보기
	List<Map<String, Object>> reviewList();
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
	// 상품 상세 페이지 보기
	List<Map<String, Object>> productOne(@Param("id") String id, @Param("productNo") int productNo);
	// 상품별 리뷰 보기
	List<Map<String, Object>> productReview(int productNo);
	// 상품별 평균 평점
	Double avgProductRate(int productNo);
	// 기업회원 배송지
	List<Address> bizAddress(String id);
	// 상품 요청 입력
	int insertProductRequest(ProductRequest pr);
	// 대분류 최대 ID 조회 
	String selectMaxMajorCategoryId();
	// 중분류, 소분류 최대 ID 조회
	String selectMaxSubCategoryId(String parentId);
	// 카테고리 추가
	int insertCategory(Category category);
	
	// 상품 번호 찾기
	Integer findProductNoByName(String productName);
	// 상품 최대 번호 찾기
	Integer findMaxProductNo();
	// 상품 등록
	int insertProduct(Product product);
}
