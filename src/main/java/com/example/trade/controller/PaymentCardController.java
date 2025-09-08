package com.example.trade.controller;

import java.security.Principal;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.PaymentMethod;
import com.example.trade.service.PaymentCardService;

@Controller
public class PaymentCardController {

    private final PaymentCardService paymentCardService;

    public PaymentCardController(PaymentCardService paymentCardService) {
        this.paymentCardService = paymentCardService;
    }

    /** 결제수단 목록 페이지 */
    @GetMapping("/personal/paymentCard")
    public String paymentMethodList(Principal principal, Model model) {
        String userId = principal.getName(); // 로그인 가정

        int orderList = paymentCardService.getCountOrderList(userId);
        model.addAttribute("order", orderList);
        List<PaymentMethod> list = paymentCardService.getCardList(userId);
        model.addAttribute("paymentMethodList", list);
        
        return "personal/paymentCard";
    }
    
    @PostMapping("/personal/paymentCardDelete")
    public String paymentCardDelete(@RequestParam("paymentMethodNo") int paymentMethodNo
    							   ,Principal principal) {
    	String userId = principal.getName();
    	paymentCardService.updateUseStatus(paymentMethodNo, userId);
    	return "personal/paymentCard";
    }
    
    @PostMapping("/personal/setDefault")
    public String setDefault(@RequestParam("paymentMethodNo") int paymentMethodNo
    						,Principal principal)	{
    	String userId = principal.getName();
    	paymentCardService.setDefault(paymentMethodNo, userId);
    	
    	return "redirect:/personal/paymentCard?userId="+userId;
    }
    
    @GetMapping("/personal/cardOne")
    public String cardOne(@RequestParam("paymentMethodNo") int paymentMethodNo
    					 ,Principal principal
    					 ,Model model) {
    	String userId = principal.getName();
    	PaymentMethod paymentMethod = paymentCardService.getCardOne(paymentMethodNo, userId);
    	
    	model.addAttribute("paymentMethod", paymentMethod);
    	return "personal/cardOne";
    }
    
    @PostMapping("/personal/cardUpdate")
    public String cardUpdate(@ModelAttribute PaymentMethod paymentMethod
    						,Principal principal) {
    	paymentMethod.setUserId(principal.getName());
    	paymentCardService.updateCardInfo(paymentMethod);
    	return "redirect:/personal/paymentCard";
    }
}
