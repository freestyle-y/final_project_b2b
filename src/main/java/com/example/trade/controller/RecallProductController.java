package com.example.trade.controller;

import java.security.Principal;
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
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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

        model.addAttribute("list", list);
        return "admin/recallProductList";
    }
    
    @PostMapping("/admin/recallProduct")
    public String recallProduct(@RequestParam int containerNo) {
        recallProductService.updateContractDeliveryStatus(containerNo);
        return "redirect:/admin/recallProductList";
    }

    @PostMapping("/admin/recallProductCancel")
    public String recallProductCancel(@RequestParam int containerNo) {
        // 취소도 “취소 상태”를 한 줄 추가하는 것을 권장
        recallProductService.updateContractDeliveryRollback(containerNo);
        return "redirect:/admin/finalPaymentHistory";
    }
}
