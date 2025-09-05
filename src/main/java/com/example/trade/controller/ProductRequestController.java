package com.example.trade.controller;

import java.security.Principal;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.example.trade.dto.ProductRequest;
import com.example.trade.service.ProductRequestService;

@Controller
public class ProductRequestController {
	private final ProductRequestService productRequestService;
	
	public ProductRequestController(ProductRequestService productRequestService) {
		super();
		this.productRequestService = productRequestService;
	}

	@GetMapping("/admin/productRequestList")
	public String productRequestList(Model model, Principal principal) {
	    String userId = principal.getName();
	    List<ProductRequest> list = productRequestService.getProductRequestList();

	    // 요청번호-회차로 그룹핑 (표시는 요청번호만, 병합 기준만 회차 포함)
	    Map<String, List<ProductRequest>> grouped = list.stream()
	        .collect(Collectors.groupingBy(
	            pr -> pr.getProductRequestNo() + "-" + (pr.getRevisionNo()==null?0:pr.getRevisionNo()),
	            LinkedHashMap::new,
	            Collectors.toList()
	        ));

	    model.addAttribute("userId", userId);
	    model.addAttribute("groupedList", grouped);
	    return "admin/productRequestList";
	}

}
