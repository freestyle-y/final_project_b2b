package com.example.trade.controller;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Container;
import com.example.trade.dto.RecallGroup;
import com.example.trade.service.RecallProductService;

@Controller
public class RecallProductController {
    private final RecallProductService recallProductService;
    public RecallProductController(RecallProductService recallProductService) {
        this.recallProductService = recallProductService;
    }

    // 회수 상품 목록
    @GetMapping("/admin/recallProductList")
    public String recallProduct(Model model) {
        List<Container> list = recallProductService.getRecallProductList();

        // [수정] 컨테이너(공통정보) 단위로 그룹핑
        Map<String, List<Container>> grouped = list.stream().collect(
            Collectors.groupingBy(
                c -> c.getContainerNo() + "|" +
                     nvl(c.getContainerLocation()) + "|" +
                     nvl(c.getName()) + "|" +
                     nvl(c.getCompanyName()) + "|" +
                     nvl(c.getAddress()) + "|" +
                     nvl(c.getDetailAddress()),
                LinkedHashMap::new, Collectors.toList()
            )
        );

        // [수정] 뷰에서 쓰기 쉬운 구조로 변환
        List<RecallGroup> groups = new ArrayList<>();
        for (List<Container> items : grouped.values()) {
            Container first = items.get(0);
            RecallGroup g = new RecallGroup();
            g.setContainerNo(first.getContainerNo());
            g.setContainerLocation(first.getContainerLocation());
            g.setName(first.getName());
            g.setCompanyName(first.getCompanyName());
            g.setAddress(first.getAddress());
            g.setDetailAddress(first.getDetailAddress());
            g.setRowspan(items.size());
            g.setItems(items);
            groups.add(g);
        }

        // 원래 list가 필요 없으면 빼셔도 됩니다.
        model.addAttribute("groups", groups);   // [수정] JSP는 이걸 사용
        model.addAttribute("list", list);       // (선택) 기존도 유지
        return "admin/recallProductList";
    }

    // 상품 회수 전송
    @PostMapping("/admin/recallProduct")
    public String recallProduct(@RequestParam("containerNo") int containerNo) {
        recallProductService.updateContractDeliveryStatus(containerNo);
        return "redirect:/admin/recallProductList";
    }

    // 상품 회수 취소
    @PostMapping("/admin/recallProductCancel")
    public String recallProductCancel(@RequestParam("containerNo") int containerNo) {
        recallProductService.updateContractDeliveryRollback(containerNo);
        return "redirect:/admin/finalPaymentHistory";
    }

    // [수정] null-safe helper
    private static String nvl(String s) { return s == null ? "" : s; }
}
