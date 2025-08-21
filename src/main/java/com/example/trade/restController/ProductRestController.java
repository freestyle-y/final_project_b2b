package com.example.trade.restController;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

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
	
	// 카테고리별 반환
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
	        //log.info(middleCategoryList.toString());
	        
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
		
	// 카테고리 선택 시 그 다음 카테고리 나오게
	@GetMapping("/categories/{parentId}/children")
    public List<Category> getChildCategories(@PathVariable String parentId) {
		//log.info(parentId);
        List<Category> categoryList = productService.selectMiddleCategory(parentId);
        //log.info(middleCategory.toString());
        
        return categoryList;
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
	
	// 재고 수량 수정
	@PostMapping("/updateInventoryQuantity")
    public String updateInventoryQuantity(@RequestBody Inventory inventory) {
        productService.updateInventoryQuantity(inventory.getInventoryId(), inventory.getQuantity());
        return "success";
	}
	
	// 사용여부 수정
	@PostMapping("/changeStatus")
	public String changeStatus(@RequestBody Product product) {
		//log.info(product.toString());
		productService.changeProductStatus(product.getProductNo(), product.getUseStatus());
		return "success";
	}
}
