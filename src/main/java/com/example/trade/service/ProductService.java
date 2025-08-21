package com.example.trade.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Address;
import com.example.trade.dto.Category;
import com.example.trade.dto.Option;
import com.example.trade.dto.Product;
import com.example.trade.dto.ProductRequest;
import com.example.trade.mapper.ProductMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
@Transactional
public class ProductService {
	private final ProductMapper productMapper;

	public ProductService(ProductMapper productMapper) {
		this.productMapper = productMapper;
	}
	
	// 상품 후기 목록 보기
	public List<Map<String, Object>> selectReviewList() {
		return productMapper.reviewList();
	}
	
	// 상품 목록(찜 많은순)
	public List<Map<String, Object>> selectProductByWish() {
		return productMapper.productListByWish();
	}
	
	// 개인 찜 목록 보기
	public List<Map<String, Object>> selectWishList(String id) {
		return productMapper.wishList(id);
	}
	
	// 개인 찜 삭제
	public void deleteWishItems(String loginUserName, List<Integer> productNoList) {
	    productMapper.deleteByUserNameAndProductNos(loginUserName, productNoList);
	}
	
	// 개인 장바구니 목록 보기
	public List<Map<String, Object>> selectShoppingCart(String id) {
		return productMapper.shoppingCart(id);
	}
	
	// 개인 장바구니 수량 변경
	public boolean updateCartItemQuantity(String userId, int shoppingCartNo, int quantity) {
	    // 1. cartId로 productNo와 optionNo 모두 조회
	    Map<String, Integer> itemInfo = productMapper.findProductAndOptionByCartId(shoppingCartNo);
	    if (itemInfo == null) return false;

	    Integer productNo = itemInfo.get("productNo");
	    Integer optionNo = itemInfo.get("optionNo");
	    
	    // 2. 재고 수량 조회
	    Integer inventoryQuantity = productMapper.findInventoryQuantity(productNo, optionNo);
	    //log.info(inventoryQuantity+ "");
	    if (inventoryQuantity == null || quantity > inventoryQuantity) {
	        return false; // ❌ 재고 부족 또는 잘못된 요청
	    }
	    
		int updatedRows = productMapper.updateCartQuantity(userId, shoppingCartNo, quantity);
        return updatedRows > 0;
	}
	
	// 개인 장바구니 상품 삭제
	public boolean deleteCartItem(String userId, int cartId) {
	    int result = productMapper.deleteCartItemById(userId, cartId);
	    return result > 0;
	}

	// 찜 토글
	public boolean toggleWish(String userId, int productNo, boolean wish) {
	    Map<String, Object> param = new HashMap<>();
	    param.put("userId", userId);
	    param.put("productNo", productNo);

	    Integer exists = productMapper.checkWishExists(param); // 0 or 1

	    if (exists == null || exists == 0) {
	        // 찜이 아예 없으면 insert
	        param.put("useStatus", wish ? "Y" : "N"); // 대부분 처음엔 Y
	        return productMapper.insertWish(param) > 0;
	    } else {
	        // 찜이 이미 있으면 update
	        param.put("useStatus", wish ? "Y" : "N");
	        return productMapper.updateWishStatus(param) > 0;
	    }
	}
	
	// 장바구니 추가
	public Map<String, Object> addCartItem(String userId, int productNo, int optionNo, int quantity) {
	    Map<String, Object> result = new HashMap<>();

	    int existing = productMapper.checkCart(userId, productNo, optionNo);

	    if (existing > 0) {
	        result.put("success", false);
	        result.put("message", "이미 장바구니에 담긴 상품입니다.");
	    } else {
	        boolean inserted = productMapper.insertCart(userId, productNo, optionNo, quantity) > 0;
	        result.put("success", inserted);
	        result.put("message", inserted ? "장바구니에 담겼습니다!" : "장바구니 추가에 실패했습니다.");
	    }

	    return result;
	}

	
	// 카테고리(대분류) 목록
	public List<Category> selectMajorCategory() {
		return productMapper.majorCategory();
	}
	
	// 카테고리(중분류) 목록
	public List<Category> selectMiddleCategory(String id) {
		return productMapper.middleCategory(id);
	}
	
	// 카테고리별 상품 목록 보기(판매중, 일시품절만)
	public List<Map<String, Object>> selectProductListByCategory(String parentId, String middleId) {
		return productMapper.productListByCategory(parentId, middleId);
	}
	
	// 카테고리별 상품 목록 보기(전체)
	public List<Map<String, Object>> selectAllProductListByCategory(String parentId, String middleId) {
		return productMapper.allProductListByCategory(parentId, middleId);
	}

	// 상품 상세 페이지 보기
	public List<Map<String, Object>> selectProductOne(String id, int productNo) {
		return productMapper.productOne(id, productNo);
	}
	
	// 상품별 리뷰 보기
	public List<Map<String, Object>> selectProductReview(int productNo) {
		return productMapper.productReview(productNo);
	}
	
	// 상품별 평균 평점
	public Double avgProductRate(int productNo) {
		return productMapper.avgProductRate(productNo);
	}
	
	// 기업회원 배송지
	public List<Address> selectBizAddress(String id) {
		return productMapper.bizAddress(id);
	}
	
	// 상품 요청 입력
	public void insertProductRequest(List<ProductRequest> list) {
		
        // 첫 번째 상품 insert (subProductRequestNo = 1)
        ProductRequest first = list.get(0);
        first.setSubProductRequestNo(1);
        first.setUseStatus("Y");
        productMapper.insertProductRequest(first);
        
        // 자동 생성된 productRequestNo 가져오기
        int productRequestNo = first.getProductRequestNo();
        
        // 두 번째 상품부터는 같은 productRequestNo, subProductRequestNo 증가하면서 insert
        int subNo = 2;
        for (int i = 1; i < list.size(); i++) {
            ProductRequest pr = list.get(i);
            pr.setProductRequestNo(productRequestNo);
            pr.setSubProductRequestNo(subNo++);
            pr.setUseStatus("Y");
            productMapper.insertProductRequest(pr);
        }
	}
	
	// 카테고리 추가
	public Category insertCategory(Category category) {
		String parentId = category.getParentCategory();
		
		if ("0".equals(parentId)) {
		    // 대분류 처리
		    String maxIdStr = productMapper.selectMaxMajorCategoryId();
		    int newId = (maxIdStr != null) ? Integer.parseInt(maxIdStr) + 1 : 1;
		    category.setCategoryId(String.valueOf(newId));

		} else if (parentId.length() == 1) {
		    // 중분류 처리 (예: parentId = "1", newId는 "1001", "1002", ...)
		    String maxSubIdStr = productMapper.selectMaxSubCategoryId(parentId);
		    int nextSubNum = 1;

		    if (maxSubIdStr != null && maxSubIdStr.startsWith(parentId)) {
		        String suffix = maxSubIdStr.substring(parentId.length()); // "002"
		        nextSubNum = Integer.parseInt(suffix) + 1;
		    }

		    String newId = parentId + String.format("%03d", nextSubNum);
		    category.setCategoryId(newId);

		} else if (parentId.length() == 4) {
		    // 소분류 처리 (예: parentId = "1002", newId는 "1002001", "1002002", ...)
		    String maxSubIdStr = productMapper.selectMaxSubCategoryId(parentId);
		    int nextSubNum = 1;

		    if (maxSubIdStr != null && maxSubIdStr.startsWith(parentId)) {
		        String suffix = maxSubIdStr.substring(parentId.length()); // "001"
		        nextSubNum = Integer.parseInt(suffix) + 1;
		    }

		    String newId = parentId + String.format("%03d", nextSubNum);
		    category.setCategoryId(newId);

		}

		productMapper.insertCategory(category);
		return category;
	}
	
	// 옵션 목록 보기
	public List<Option> selectOptionList() {
		return productMapper.optionList();
	}
	
	// 옵션 추가
	public void insertOption(Option option) {
		productMapper.insertOption(option);
	}
	
	// 상품 등록
	public void insertProduct(Product product) {
        // 1. product_no 설정
        Integer existingProductNo = productMapper.findProductNoByName(product.getProductName());

        int resolvedProductNo;
        if (existingProductNo != null) {
            resolvedProductNo = existingProductNo; // 기존 product 사용
        } else {
            Integer maxProductNo = productMapper.findMaxProductNo();
            resolvedProductNo = (maxProductNo != null) ? maxProductNo + 1 : 1;
        }

        product.setProductNo(resolvedProductNo);
		productMapper.insertProduct(product);
	}
	
	// 재고 조회
	public List<Map<String, Object>> selectInventoryList() {
		return productMapper.inventoryList();
	}
	
	// 재고 수정
	public void updateInventoryQuantity(int inventoryId, int quantity) {
		productMapper.updateInventoryQuantity(inventoryId, quantity);
	}
	
	// 상품 사용여부 변경
	public void changeProductStatus(String userId, int productNo, String useStatus) {
		productMapper.updateProductStatus(userId, productNo, useStatus);
	}
}
