package com.example.trade.controller;

import java.math.BigDecimal;
import java.security.Principal;
import java.util.Comparator;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Quotation;
import com.example.trade.dto.QuotationItem;
import com.example.trade.service.QuotationService;

@Controller
public class QuotationController {
	private final QuotationService quotationService;
	
	public QuotationController(QuotationService quotationService) {
		super();
		this.quotationService = quotationService;
	}
	
	// 관리자 전체 견적서 목록
    @GetMapping("/admin/quotationList")
    public String adminQuotationList(
            @RequestParam(value = "productRequestNo", required = false) Integer productRequestNo,
            Model model) {

        // 목록 조회
        List<Quotation> quotationList = (productRequestNo == null)
                ? quotationService.getAllAdminQuotations()
                : quotationService.getAdminQuotationList(productRequestNo);

        model.addAttribute("quotationList", quotationList);
        model.addAttribute("productRequestNo", productRequestNo); // JSP에서 필요 시 사용

        // ✅ NPE/auto-unboxing 방지: null일 때는 호출하지 않음
        if (productRequestNo != null) {
            quotationService.updateProductRequest(productRequestNo);
        }

        return "admin/quotationList";
    }

	
	// 관리자 견적서 상세페이지
	@GetMapping("/admin/quotationOne")
	public String adminQuotationOne(@RequestParam("productRequestNo") int productRequestNo,
	                                Model model) {
	    // 동일 상품의 모든 견적
	    List<Quotation> quotationList = quotationService.getAdminQuotationList(productRequestNo);

	    model.addAttribute("productRequestNo", productRequestNo);
	    model.addAttribute("quotationList", quotationList);
	    return "admin/quotationOne"; // 아래 JSP와 파일명 동일
	}

	// 관리자 견적서 작성 팝업 페이지
	@GetMapping("/admin/writeQuotationForm")
	public String writeQuotationForm(@RequestParam("productRequestNo") int productRequestNo,
	                                 @RequestParam(value="quotationNo", required=false, defaultValue="0") int quotationNo,
	                                 Model model) {

	    if (quotationNo == 0) {
	        // 신규 작성 → product_request에서 상품 가져오기
	        List<QuotationItem> quotationItems = quotationService.getProductRequestForQuotation(productRequestNo);
	        model.addAttribute("quotationItems", quotationItems);
	    } else {
	        // 기존 견적 수정 → 견적서 + 상품들 가져오기
	        Quotation quotation = quotationService.getQuotationOne(quotationNo);
	        model.addAttribute("quotation", quotation);
	    }

	    return "admin/writeQuotationForm";
	}
	
	// 관리자 견적서 수정
	@GetMapping("/admin/modifyQuotationForm")
	public String modifyQuotationForm(@RequestParam("quotationNo") int quotationNo, Model model) {
	    Quotation quotation = quotationService.getQuotationOne(quotationNo);
	    model.addAttribute("quotation", quotation);
	    return "admin/modifyQuotationForm";
	}
	
	// 관리자 견적서 수정 POST
	@PostMapping("/admin/modifyQuotation")
	public String modifyQuotation(@RequestParam("quotationNo") int quotationNo,
	                              @RequestParam("itemId") List<Integer> itemId,
	                              @RequestParam("price") List<BigDecimal> price,
	                              @RequestParam("productRequestNo") int productRequestNo) {

	    for (int i = 0; i < itemId.size(); i++) {
	        QuotationItem item = new QuotationItem();
	        item.setItemId(itemId.get(i));
	        item.setPrice(price.get(i));
	        quotationService.updateQuotationItem(item);
	    }
	    return "redirect:/admin/quotationOne?quotationNo="+quotationNo+"&productRequestNo="+productRequestNo;
	}



	// 관리자 견적서 삭제
	@PostMapping("/admin/deleteQuotation")
	public String deleteQuotation(@RequestParam("quotationNo") int quotationNo
								 ,@RequestParam("productRequestNo") int productRequestNo) {
		int row = quotationService.deleteQuotation(quotationNo, productRequestNo);
		return "redirect:/admin/quotationList?productRequestNo="+productRequestNo;
	}

	
	// 관리자 견적서 작성 POST
	@PostMapping("/admin/submitQuotation")
	public String submitQuotation(
	        @RequestParam("productRequestNos") List<Integer> productRequestNos,
	        @RequestParam("subProductRequestNos") List<Integer> subProductRequestNos,
	        @RequestParam("prices") List<BigDecimal> prices,
	        Principal principal) {

	    String userId = principal.getName();

	    // 1. 마스터 insert
	    Quotation quotation = new Quotation();
	    quotation.setProductRequestNo(productRequestNos.get(0));
	    quotation.setCreateUser(userId);
	    quotationService.insertQuotationMaster(quotation);
	    int quotationNo = quotation.getQuotationNo();

	    // 2. 상품들 insert
	    for (int i = 0; i < subProductRequestNos.size(); i++) {
	        QuotationItem item = new QuotationItem();
	        item.setQuotationNo(quotationNo);
	        item.setProductRequestNo(productRequestNos.get(i));
	        item.setSubProductRequestNo(subProductRequestNos.get(i));
	        item.setPrice(prices.get(i));
	        quotationService.insertQuotationItem(item);
	    }

	    return "redirect:/admin/quotationList?productRequestNo="+productRequestNos.get(0);
	}

	// 기업 회원 견적서 목록 페이지
	@GetMapping("/biz/quotationList")
	public String quotationList(Principal principal, Model model) {
	    String userId = principal.getName();
	    List<Quotation> quotationList = quotationService.getQuotationList(userId);

	    // 정렬만 필요하면 단순히 quotationNo 기준
	    quotationList.sort(Comparator.comparing(Quotation::getQuotationNo));

	    // JSP에서 q.items 직접 출력 가능 → 그룹핑 불필요
	    model.addAttribute("quotationList", quotationList);

	    return "biz/quotationList";
	}


	// 기업회원 견적서 상세 페이지
    @GetMapping("/biz/quotationOne")
    public String quotationOne(Model model,
                               @RequestParam("quotationNo") int quotationNo) {
        Quotation quotationOne = quotationService.getQuotationOne(quotationNo);
        model.addAttribute("quotationOne", quotationOne);
        return "biz/quotationOne";
    }
	
	// 기업회원 견적서 승인
    @PostMapping("/biz/quotationApprove")
    public String quotationApprove(@RequestParam("quotationNo") int quotationNo) {
        quotationService.updateStatusAtApprove(quotationNo);
        return "redirect:/biz/quotationOne?quotationNo=" + quotationNo;
    }
	
	// 기업회원 견적서 거절
    @PostMapping("/biz/quotationReject")
    public String quotationReject(@RequestParam("quotationNo") int quotationNo,
                                 @RequestParam("rejectionReason") String rejectionReason,
                                 Principal principal) {
        String userId = principal.getName();
        quotationService.updateStatusAtReject(quotationNo, rejectionReason, userId);
        return "redirect:/biz/quotationOne?quotationNo=" + quotationNo;
    }
}
