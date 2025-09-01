package com.example.trade.restController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.dto.Address;
import com.example.trade.dto.Category;
import com.example.trade.dto.Inventory;
import com.example.trade.dto.Option;
import com.example.trade.dto.Product;
import com.example.trade.service.ProductService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
public class ProductRestController {
	private final ProductService productService;
	public ProductRestController(ProductService productService) {
		this.productService = productService;
	}
	
	// 찜 삭제
	@PostMapping("/personal/wish/delete")
	public Map<String, Object> deleteWishItems(@RequestBody Map<String, Object> request) {
		List<Integer> productNoList = (List<Integer>) request.get("productNoList");
	    String userId = (String) request.get("userId");
	    
	    log.info(userId);
	    log.info(productNoList.toString());
	    
	    productService.deleteWishItems(userId, productNoList);
	    return Map.of("success", true);
	}
	
	// 장바구니 수량 변경
	@PostMapping("/shoppingCart/updateQuantity")
	public ResponseEntity<Map<String, Object>> updateQuantity(@RequestBody Map<String, Object> payload) {
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		Integer cartId = Integer.parseInt(payload.get("cartId").toString());
	    Integer quantity = Integer.parseInt(payload.get("quantity").toString());

	    //log.info(cartId+ "");
	    //log.info(quantity + "");
	    boolean updated = productService.updateCartItemQuantity(userId, cartId, quantity);

	    Map<String, Object> response = new HashMap<>();
	    if (updated) {
	        response.put("success", true);
	    } else {
	        response.put("success", false);
	        response.put("message", "수량 변경 실패");
	    }
	    return ResponseEntity.ok(response);
    }
	
	// 장바구니 상품 삭제
	@PostMapping("/shoppingCart/deleteItem")
	public ResponseEntity<Map<String, Object>> deleteItem(@RequestBody Map<String, Object> payload) {
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		Integer cartId = Integer.parseInt(payload.get("cartId").toString());
	    
	    boolean deleted = productService.deleteCartItem(userId, cartId);

	    Map<String, Object> response = new HashMap<>();
	    response.put("success", deleted);

	    if (!deleted) {
	        response.put("message", "삭제 실패");
	    }

	    return ResponseEntity.ok(response);
	}	
	
	// 찜 토글
	@PostMapping("/wish/toggle")
	public Map<String, Object> toggleWish(@RequestParam int productNo,
	                                      @RequestParam boolean wish) {
	    String userId = SecurityContextHolder.getContext().getAuthentication().getName();
	    boolean success = productService.toggleWish(userId, productNo, wish);

	    Map<String, Object> res = new HashMap<>();
	    res.put("success", success);
	    return res;
	}

	// 장바구니 상품 담기
	@PostMapping("/shoppingCart/add")
	public ResponseEntity<Map<String, Object>> addCart(
	        @RequestParam int productNo,
	        @RequestParam int optionNo,
	        @RequestParam int quantity) {
		
		//log.info(productNo + "");
		//log.info(optionNo + "");
		//log.info(quantity + "");
		
	    String userId = SecurityContextHolder.getContext().getAuthentication().getName();
	    Map<String, Object> result = productService.addCartItem(userId, productNo, optionNo, quantity);

	    boolean success = (boolean) result.get("success");
	    String message = (String) result.get("message");

	    if (success) {
	        return ResponseEntity.ok(result);  // 200 OK
	    } else if ("이미 장바구니에 담긴 상품입니다.".equals(message)) {
	        return ResponseEntity.status(HttpStatus.CONFLICT).body(result);  // 409 Conflict
	    } else {
	        return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(result); // 기타 실패
	    }
	}

	// 카테고리별 반환(판매중, 일시품절만)
	@GetMapping("/product/byCategory")
	public Map<String, Object> productByCategory(
			@RequestParam(value = "parentId", required = false) String parentId,
		    @RequestParam(value = "middleId", required = false) String middleId) {
		Map<String, Object> result = new HashMap<>();

		//log.info(parentId);
		//log.info(middleId);
		if (parentId != null) {
	        // 대분류 ID가 있으면, 중분류 리스트 조회
	        List<Category> middleCategoryList = productService.selectMiddleCategory(parentId);
	        log.info(middleCategoryList.toString());
	        
	        // 대분류에 속한 상품 리스트 조회
	        List<Map<String, Object>> productList = productService.selectProductListByCategory(parentId, null);
	        //log.info(productList.toString());
	        
	        result.put("middleCategoryList", middleCategoryList);
	        result.put("productList", productList);
	    } else if (middleId != null) {
	        // 중분류 ID가 있으면, 중분류에 속한 상품 리스트만 조회
	        List<Map<String, Object>> productList = productService.selectProductListByCategory(null, middleId);
	        //log.info(productList.toString());
	        result.put("productList", productList);
	    }
       
        return result;
	}
	
	// 카테고리별 반환(전체 -> 관리자용)
	@GetMapping("/admin/product/byCategory")
	public Map<String, Object> bizProductByCategory(
			@RequestParam(value = "parentId", required = false) String parentId,
		    @RequestParam(value = "middleId", required = false) String middleId) {
		Map<String, Object> result = new HashMap<>();

		log.info(parentId);
		log.info(middleId);
		if (parentId != null) {
	        // 대분류 ID가 있으면, 중분류 리스트 조회
	        List<Category> middleCategoryList = productService.selectMiddleCategory(parentId);
	        //log.info(middleCategoryList.toString());
	        
	        // 대분류에 속한 상품 리스트 조회
	        List<Map<String, Object>> productList = productService.selectAllProductListByCategory(parentId, null);
	        //log.info(productList.toString());
	        
	        result.put("middleCategoryList", middleCategoryList);
	        result.put("productList", productList);
	    } else if (middleId != null) {
	        // 중분류 ID가 있으면, 중분류에 속한 상품 리스트만 조회
	        List<Map<String, Object>> productList = productService.selectAllProductListByCategory(null, middleId);
	        //log.info(productList.toString());
	        result.put("productList", productList);
	    }
       
        return result;
	}
	
	// 카테고리 선택 시 그 다음 카테고리 나오게
	@GetMapping("/categories/{parentId}/children")
    public List<Category> getChildCategories(@PathVariable String parentId) {
		//log.info(parentId);
        List<Category> categoryList = productService.selectMiddleCategory(parentId);
        //log.info(middleCategory.toString());
        
        return categoryList;
    }
	
	// 상품 요청 첨부파일 삭제
	@PostMapping("/biz/deleteAttachment")
	public String deleteAttachment(int attachmentNo) {
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		
	    try {
	        // DB에서 해당 첨부파일 조회 (있으면 업데이트)
	        int updateCount = productService.deleteAttachment(userId, attachmentNo);
	        if (updateCount == 1) {
	            return "success";
	        } else {
	            return "삭제할 파일이 존재하지 않거나 이미 삭제된 상태입니다.";
	        }
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "서버 오류 발생";
	    }
	}

	// 카테고리 추가
	@PostMapping("/addCategories")
	public ResponseEntity<Category> addCategory(@RequestBody Category category) {		
        Category saveCategory = productService.insertCategory(category);      
        return ResponseEntity.ok(saveCategory);
    }
	
	// 옵션 추가
	@PostMapping("/addOption")
	public Option addOption(@RequestBody Option option) {
	    productService.insertOption(option);
	    return option; // JSON으로 반환 (optionNo 포함)
	}
	
	// 상품명, 옵션까지 같으면 등록 안되게 하기
	@PostMapping("/checkProductOptionDuplication")
	public ResponseEntity<Map<String, Boolean>> checkProductOptionDuplication(@RequestParam String productName,
			@RequestParam int optionNo) {
        
        boolean exists = productService.isProductOptionDuplicated(productName, optionNo);
        
        Map<String, Boolean> response = new HashMap<>();
        response.put("exists", exists);
        
        return ResponseEntity.ok(response);
    }
	
	// 재고 수량 수정
	@PostMapping("/updateInventoryQuantity")
    public String updateInventoryQuantity(@RequestBody Inventory inventory) {
		log.info(inventory.toString());
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
        productService.updateInventoryQuantity(userId, inventory.getInventoryId(), inventory.getQuantity(), inventory.getProductNo(), inventory.getOptionNo());
        return "success";
	}
	
	// 사용여부 수정
	@PostMapping("/changeStatus")
	public String changeStatus(@RequestBody Product product) {
		//log.info(product.toString());
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		
		productService.changeProductUseStatus(userId, product.getProductNo(), product.getUseStatus());
		return "success";
	}
	
	// 상품 상태 수정
	@PostMapping("/admin/updateProductStatus")
	public ResponseEntity<String> updateProductStatus(@RequestBody Map<String, Object> data) {
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		int productNo = (Integer)data.get("productNo");
	    String productStatus = data.get("productStatus").toString();

	    productService.updateProductStatus(userId, productNo, productStatus);
	    return ResponseEntity.ok("success");
	}
	
	// 상품 이미지 삭제
	@PostMapping("/admin/deleteProductImage")
	public ResponseEntity<String> deleteProductImage(@RequestBody Map<String, String> data) {
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		int productNo = Integer.parseInt(data.get("productNo"));
	    String imagePath = data.get("imagePath");

	    log.info(data.toString());
	    try {
	        productService.deleteProductImage(userId, productNo, imagePath);
	        return ResponseEntity.ok("success");
	    } catch (Exception e) {
	        return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("fail");
	    }
	}
	
	
	// 상품 옵션 가격 수정
	@PostMapping("/admin/updateProductPrices")
	public ResponseEntity<String> updatePrices(@RequestBody Map<String, Object> data) {
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		int productNo = Integer.parseInt(data.get("productNo").toString());
	    List<Map<String, Object>> priceUpdates = (List<Map<String, Object>>) data.get("priceUpdates");

	    for (Map<String, Object> item : priceUpdates) {
	    	int optionNo = Integer.parseInt(item.get("optionNo").toString());
	        int price = Integer.parseInt(item.get("price").toString());

	        productService.updateProductOptionPrice(userId, productNo, optionNo, price);
	    }

	    return ResponseEntity.ok("success");
	}
	
	// 창고 리스트
	@GetMapping("/admin/warehouses")
	public List<Address> getWarehouses() {
		String userId = SecurityContextHolder.getContext().getAuthentication().getName();
		return productService.selectWarehouse(userId);
	}
	
	// 창고 지정
	@PostMapping("/admin/updateInventoryAddress")
	public ResponseEntity<?> updateInventoryAddress(@RequestBody Map<String, Object> data) {
	    int inventoryId = (Integer) data.get("inventoryId");
	    int addressNo = (Integer) data.get("addressNo");

	    //log.info(inventoryId + "");
	    //log.info(addressNo + "");
	    productService.updateInventoryAddress(inventoryId, addressNo);
	    return ResponseEntity.ok().build();
	}
}
