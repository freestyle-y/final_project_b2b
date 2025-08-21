package com.example.trade.controller;

import java.security.Principal;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
	// 관리자 견적서 작성 페이지
	@GetMapping("/admin/writeQuotation")
	public String writeQuotation(@RequestParam("productRequestNo") int productRequestNo
								,Model model) {
		List<Quotation> quotationOne = quotationService.getQuotationOneByQuotationNo(productRequestNo);

		quotationOne.sort(Comparator
			.comparing(Quotation::getQuotationNo)
			.thenComparing(Quotation::getSubProductRequestNo));

		Map<String, List<Quotation>> groupList = new LinkedHashMap<>();
		for (Quotation q : quotationOne) {
			String key = q.getQuotationNo() + "_" + q.getSubProductRequestNo() + "_" + q.getPrice();
			groupList.computeIfAbsent(key, k -> new ArrayList<>()).add(q);
		}

		model.addAttribute("groupList", groupList);
		model.addAttribute("productRequestNo", productRequestNo);
		return "admin/writeQuotation";
	}

	// 관리자 견적서 작성 팝업 페이지
	@GetMapping("/admin/writeQuotationForm")
	public String writeQuotationForm(@RequestParam("quotationNo") int quotationNo
									 ,@RequestParam("subProductRequestNo") int subProductRequestNo
									 ,Model model) {
		List<Quotation> quotationList = quotationService.getQuotationOne(quotationNo, subProductRequestNo);
		model.addAttribute("quotationList", quotationList);
		return "admin/writeQuotationForm";
	}
	
    // 기업 회원 견적서 목록 페이지
    @GetMapping("/biz/quotationList")
    public String quotationList(@RequestParam String userId, Model model) {
        List<Quotation> quotationList = quotationService.getQuotationList(userId);

        // 2. 견적서 리스트를 정렬
        //    1차 기준: subProductRequestNo (재견적서 번호)
        //    2차 기준: quotationNo (견적서 번호)
        //    → 즉, "재견적서 번호"가 우선적으로 정렬되도록 보장
        quotationList.sort(Comparator
            .comparing(Quotation::getQuotationNo)           // 첫 번째 정렬 기준: 견적서 번호
            .thenComparing(Quotation::getSubProductRequestNo)); // 두 번째 정렬 기준: 재견적서 번호

        // 3. 그룹핑 결과를 담을 Map 준비
        //    Key   : "subProductRequestNo_quotationNo_price" 문자열
        //    Value : 해당 Key에 속하는 Quotation 객체 리스트
        //    LinkedHashMap 사용 → 입력 순서 보장 (정렬된 순서대로 유지)
        Map<String, List<Quotation>> quotationGroupedMap = new LinkedHashMap<>();

        // 4. 견적서 리스트를 순회하면서 그룹핑 처리
        for (Quotation q : quotationList) {
            // Key 생성 규칙:
            //   subProductRequestNo + "_" + quotationNo + "_" + price
            //   예: "1_1_8000000"
            String key = q.getSubProductRequestNo() + "_" + q.getQuotationNo() + "_" + q.getPrice();
            // Key가 없으면 새 리스트 생성, 있으면 기존 리스트에 추가
            quotationGroupedMap.computeIfAbsent(key, k -> new ArrayList<>()).add(q);
        }
        // 5. JSP(View)에서 사용할 데이터 등록
        //    JSP에서는 ${quotationGroupedMap} 으로 접근 가능
        model.addAttribute("quotationGroupedMap", quotationGroupedMap);

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
		int row = quotationService.updateStatusAtApprove(quotationNo, subProductRequestNo);
		
	    return "redirect:/biz/quotationOne?quotationNo=" + quotationNo + "&subProductRequestNo=" + subProductRequestNo;
	}
	
	// 기업회원 견적서 거절
	@PostMapping("/biz/quotationReject")
	public String quotationReject(@RequestParam("quotationNo") int quotationNo
								 ,@RequestParam("subProductRequestNo") int subProductRequestNo
								 ,@RequestParam("rejectionReason") String rejectionReason
								 ,Principal principal) {
		String userId = principal.getName();
		
		int row = quotationService.updateStatusAtReject(quotationNo, subProductRequestNo, rejectionReason, userId);
		
		return "redirect:/biz/quotationOne?quotationNo=" + quotationNo + "&subProductRequestNo=" + subProductRequestNo;
	}
}
