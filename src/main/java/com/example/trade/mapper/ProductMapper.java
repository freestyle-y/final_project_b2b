package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Address;
import com.example.trade.dto.Attachment;
import com.example.trade.dto.Category;
import com.example.trade.dto.Option;
import com.example.trade.dto.Product;
import com.example.trade.dto.ProductRequest;

@Mapper
public interface ProductMapper {
	// 상품 후기 목록 보기
	List<Map<String, Object>> reviewList();
	// 상품 목록(찜 많은순)
	List<Map<String, Object>> productListByWish();
	// 상품 대표 이미지 보기
	List<Map<String, Object>> productMainImage();
	
	// 개인 찜 목록 보기
	List<Map<String, Object>> wishList(String id);
	// 개인 찜 삭제(하나 ~ 여러개)
	int deleteByUserNameAndProductNos(@Param("userName") String userName,
            @Param("productNoList") List<Integer> productNoList);
	// 개인 장바구니 목록 보기
	List<Map<String, Object>> shoppingCart(String id);
	
	// 장바구니 아이디로 상품id, 옵션id 찾기
	Map<String, Integer> findProductAndOptionByCartId(int cartId);
	// 재고 조회
	Integer findInventoryQuantity(int productNo, int optionNo);
	// 개인 장바구니 수량 변경
	int updateCartQuantity(String userId, int shoppingCartNo, int quantity);
	// 개인 장바구니 상품 삭제
	int deleteCartItemById(String userId, int cartId);

	// 찜 테이블에 데이터 있는지 확인
	Integer checkWishExists(Map<String, Object> param);
	// 찜 테이블에 찜 삽입
	int insertWish(Map<String, Object> param);
	// 찜 삭제/등록(하나만)
	int updateWishStatus(Map<String, Object> param);
	
	// 장바구니에 이미 담겨있는지 확인
    int checkCart(@Param("userId") String userId, @Param("productNo") int productNo, @Param("optionNo") int optionNo);
    // 장바구니에 담기
    int insertCart(@Param("userId") String userId, @Param("productNo") int productNo, @Param("optionNo") int optionNo, @Param("quantity") int quantity);
    
	// 카테고리(대분류) 목록
	List<Category> majorCategory();
	// 카테고리(중분류) 목록
	List<Category> middleCategory(String id);
	// 카테고리별 상품 목록 보기(판매중, 일시품절만)
	List<Map<String, Object>> productListByCategory(String parentId, String middleId);
	// 카테고리별 상품 목록 보기(전체)
	List<Map<String, Object>> allProductListByCategory(String parentId, String middleId);
		
	// 상품 상세 페이지 보기(개인용)
	List<Map<String, Object>> personalProductOne(@Param("id") String id, @Param("productNo") int productNo);
	// 상품 상세 이미지 모두 보기
	List<Map<String, Object>> productImage(int productNo);
	
	// 상품 상세 페이지 보기(기업, 관리자용)
	List<Map<String, Object>> productOne(int productNo);
	// 상품별 리뷰 보기
	List<Map<String, Object>> productReview(int productNo);
	// 상품별 평균 평점
	Double avgProductRate(int productNo);
	
	// 기업회원 배송지
	List<Address> bizAddress(String id);
	// 상품 요청 입력
	int insertProductRequest(ProductRequest pr);
	
	// 상품 요청 리스트 조회
	List<ProductRequest> productRequestList();
	// 상품 요청 상세 조회
	List<Map<String, Object>> productRequestOne(int requestNo);
	// 상품 요청 첨부파일 조회
	List<Map<String, Object>> attachmentByRequestNo(int requestNo);
	// 상품 요청 수정
	int updateProductRequest(ProductRequest productRequest);
	// 상품 요청 첨부파일 삭제
	int deleteAttachment(int attachmentNo);
	// 상품 요청 삭제
	int deleteProductRequest(int requestNo); 
	// 상품에 대한 첨부파일 모두 삭제
	int deleteProductAttachment(int requestNo);
	
	// 대분류 최대 ID 조회 
	String selectMaxMajorCategoryId();
	// 중분류, 소분류 최대 ID 조회
	String selectMaxSubCategoryId(String parentId);
	// 카테고리 추가
	int insertCategory(Category category);
	
	// 옵션 목록 보기
	List<Option> optionList();
	// 옵션 추가
	int insertOption(Option option);
	
	// 상품 번호 찾기
	Integer findProductNoByName(String productName);
	// 상품 최대 번호 찾기
	Integer findMaxProductNo();
	// 상품 등록
	int insertProduct(Product product);
	// 초기 재고 등록(개수 : 0)
	void insertInventory(int productNo, int optionNo);
	
	// 최대 priority 찾기(이미지)
	Integer findMaxPriorityByCategoryCode(int categoryCode);
	// 최대 priority 찾기(첨부파일)
	Integer findMaxPriorityByRequestNo(int requestNo);
	// 파일 저장
	void insertAttachment(Attachment attachment);
	
	// 재고 목록 조회
	List<Map<String, Object>> inventoryList();
	// 재고 수정
	int updateInventoryQuantity(@Param("inventoryId") int inventoryId, @Param("quantity") int quantity);
	
	// 상품 사용여부 변경
	int updateProductStatus(@Param("userId") String userId, @Param("productNo") int productNo, @Param("useStatus") String useStatus);
	
	// 창고 주소 불러오기
	List<Address> warehouse(String id);
	// 재고 창고 수정
	void updateInventoryAddress(int inventoryId, int addressNo);
}
