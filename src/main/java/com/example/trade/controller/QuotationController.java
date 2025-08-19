package com.example.trade.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Quotation;
import com.example.trade.service.QuotationService;

@Controller
public class QuotationController {
	private final QuotationService quotationService;
	
	public QuotationController(QuotationService quotationService) {
		super();
		this.quotationService = quotationService;
	}
	// 관리자 견적서 작성 할 목록 페이지
	@GetMapping("/admin/writeQuotation")
	public String writeQuotation(@RequestParam("productRequestNo") int productRequestNo
								,Model model) {
		List<Quotation> quotationOne = quotationService.getQuotationOneByQuotationNo(productRequestNo);
		Map<String, List<Quotation>> grouped = quotationOne.stream()
			    .collect(Collectors.groupingBy(
			        q -> q.getQuotationNo() + "_" + q.getSubProductRequestNo(),
			        LinkedHashMap::new,
			        Collectors.toList()
			    ));

			model.addAttribute("groupList", grouped);
		return "admin/writeQuotation";
	}
	
	// 견적서 작성 popup
	@GetMapping("/admin/writeQuotationForm")
	public String openQuotationPopup(@RequestParam("quotationNo") int quotationNo,
	                                 @RequestParam("subProductRequestNo") int subProductRequestNo,
	                                 Model model) {
	    System.out.println("⛳ popup quotationNo = " + quotationNo);
	    System.out.println("⛳ popup subProductRequestNo = " + subProductRequestNo);

	    List<Quotation> list = quotationService.getQuotationOne(quotationNo, subProductRequestNo);
	    model.addAttribute("quotationList", list);
	    return "admin/writeQuotationForm";
	}
	
	// 견적서 제출 페이지
	@PostMapping("/admin/writeQuotationForm")
	public String writeQuotationForm(Quotation quotation) {
		int row = quotationService.insertQuotation(quotation);
		
		return "admin/writeQuotationForm";
	}
    // 기업 회원 견적서 목록 페이지
    @GetMapping("/biz/quotationList")
    public String quotationList(@RequestParam String userId, Model model) {
        List<Quotation> raw = quotationService.getQuotationList(userId);

        // 최신 createDate가 우선되도록 정렬 (null 안전)
        raw.sort(Comparator.comparing(Quotation::getCreateDate, Comparator.nullsLast(Comparator.reverseOrder())));

        // (quotationNo, subProductRequestNo, productRequestNo) 기준으로 중복제거
        Map<String, Quotation> uniqueMap = new LinkedHashMap<>();
        for (Quotation q : raw) {
            String key = q.getQuotationNo() + "_" + q.getSubProductRequestNo() + "_" + q.getProductRequestNo();
            // 최신이 먼저 오므로 비어있을 때만 넣음
            uniqueMap.putIfAbsent(key, q);
        }
        List<Quotation> quotations = new ArrayList<>(uniqueMap.values());

        // 화면 정렬: quotationNo, subProductRequestNo, productRequestNo 오름차순
        quotations.sort(Comparator
                .comparing(Quotation::getQuotationNo)
                .thenComparing(Quotation::getSubProductRequestNo)
                .thenComparing(Quotation::getProductRequestNo));

        model.addAttribute("quotations", quotations);
        return "biz/quotationList";
    }

	// 기업회원 견적서 상세 페이지
	@GetMapping("/biz/quotationOne")
	public String quotationOne(Model model
							  ,@RequestParam("quotationNo") int quotationNo
							  ,@RequestParam("subProductRequestNo") int subProductRequestNo) {
		List<Quotation> quotationOne = quotationService.getQuotationOne(quotationNo, subProductRequestNo);
		model.addAttribute("quotationOne", quotationOne);
		return "biz/quotationOne";
	}
	
	// 기업회원 견적서 승인
	@PostMapping("/biz/quotationApprove")
	public String quotationApprove(@RequestParam("quotationNo") int quotationNo
								  ,@RequestParam("subProductRequestNo") int subProductRequestNo) {
		quotationService.updateStatusAtApprove(quotationNo, subProductRequestNo);
		return "redirect:/biz/quotationOne?quotationNo=" + quotationNo + "&subProductRequestNo=" + subProductRequestNo;
	}
	
	// 기업회원 견적서 거절
	@PostMapping("/biz/quotationReject")
	public String quotationReject(@RequestParam("quotationNo") int quotationNo
								 ,@RequestParam("subProductRequestNo") int subProductRequestNo
								 ,@RequestParam("rejectionReason") String rejectionReason
								 ,Principal principal) {
		String userId = principal.getName();
		quotationService.updateStatusAtReject(quotationNo, subProductRequestNo, rejectionReason, userId);
		return "redirect:/biz/quotationOne?quotationNo=" + quotationNo + "&subProductRequestNo=" + subProductRequestNo;
	}
}
