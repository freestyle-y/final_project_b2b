package com.example.trade.controller;

import java.security.Principal;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Address;
import com.example.trade.dto.KakaoPayApprovalResponse;
import com.example.trade.dto.Order;
import com.example.trade.dto.PaymentMethod;
import com.example.trade.dto.User;
import com.example.trade.service.AddressService;
import com.example.trade.service.KakaoPayService;
import com.example.trade.service.OrderService;
import com.example.trade.service.PaymentMethodService;

import jakarta.servlet.http.HttpSession;

@Controller
public class OrderController {

    private final OrderService orderService;
    private final KakaoPayService kakaoPayService;
    private final PaymentMethodService paymentMethodService;
    private final AddressService addressService;
    public OrderController(OrderService orderService, KakaoPayService kakaoPayService,
			PaymentMethodService paymentMethodService, AddressService addressService) {
		super();
		this.orderService = orderService;
		this.kakaoPayService = kakaoPayService;
		this.paymentMethodService = paymentMethodService;
		this.addressService = addressService;
	}
    // 결제 페이지 (주문정보 보여주기)

    @GetMapping("/personal/payment")
    public String payment(@RequestParam("orderNo") String orderNo, Model model, Principal principal) {
    	String userId = principal.getName();
    	System.out.println("🔥 userId = " + userId);

    	List<Order> orderList = orderService.getOrderList(orderNo);
        List<PaymentMethod> cardList = paymentMethodService.getUserCardList(userId);
        
        List<Address> mainAddress = addressService.getMainAddress(userId);
        model.addAttribute("mainAddress", mainAddress);
        
        int reward = orderService.getReward(userId);
        model.addAttribute("reward", reward);
        System.out.println("reward 액 : " + reward);
        
        model.addAttribute("cardList", cardList);
        System.out.println("cardList = " + cardList);
        
        model.addAttribute("orderList", orderList);
        System.out.println("orderList size = " + orderList.size());
        
        return "personal/payment"; 
    }

    // 결제 취소 콜백 (cancel_url)
    @GetMapping("/personal/payment/cancel")
    public String paymentCancel() {
        return "personal/paymentCancel";
    }

    // 결제 실패 콜백 (fail_url)
    @GetMapping("/personal/payment/fail")
    public String paymentFail() {
        return "personal/paymentFail";
    }
    
    // 주문조회
    @GetMapping("/personal/orderList")
    public String orderList(Model model, Principal principal) {
        String userId = principal.getName();

        List<Order> orderList = orderService.getOrderListByuserId(userId);
        List<User> userInformation = orderService.getUserInformation(userId);
        // 주문번호 기준으로 그룹핑
        Map<String, List<Order>> orderGroupMap = orderList.stream()
                .collect(Collectors.groupingBy(Order::getOrderNo, LinkedHashMap::new, Collectors.toList()));

        model.addAttribute("userInformation", userInformation);
        model.addAttribute("orderGroupMap", orderGroupMap);

        return "personal/orderList";
    }
    
    // 주문 상세
    @GetMapping("/personal/orderOne")
    public String orderOne(@RequestParam("orderNo") String orderNo, Model model) {
        List<Order> orderDetailList = orderService.getOrderDetailByOrderNo(orderNo);
        int usedPoint = orderService.getUsedPointByOrderNo(orderNo);
        model.addAttribute("usedPoint", usedPoint);
        model.addAttribute("orderDetailList", orderDetailList);
        return "personal/orderOne";
    }
    
 // ✅ 수정: pg_token을 optional로 받고, 있으면 승인 호출
    @GetMapping("/personal/payment/orderResult")
    public String orderResult(@RequestParam String orderNo,
                              @RequestParam(name = "pg_token", required = false) String pgToken,
                              Model model,
                              HttpSession session) {

        List<Order> orderList = orderService.getOrderList(orderNo);
        Order first = orderList.get(0);
        java.sql.Timestamp orderDate = java.sql.Timestamp.valueOf(first.getOrderTime());
        model.addAttribute("orderList", orderList);
        model.addAttribute("orderDate", orderDate);

        Order summary = orderService.getOrder(orderNo);
        int subtotal = summary.getTotalPrice();

        // ✅ reward_history에서 사용한 적립금 조회
        int usedPoint = orderService.getUsedPointByOrderNo(orderNo);

        int usedKakaoPoint = 0;
        Integer realPaidAmount = null;

        if (pgToken != null && !pgToken.isBlank()) {
            KakaoPayApprovalResponse approval = kakaoPayService.payApprove(pgToken);
            usedKakaoPoint  = approval.getUsedKakaoPoint();
            realPaidAmount  = approval.getRealPaidAmount();

            session.setAttribute("or_usedKakaoPoint_" + orderNo, usedKakaoPoint);
            session.setAttribute("or_realPaidAmount_" + orderNo, realPaidAmount);

            model.addAttribute("popRedirect", true);
        } else {
            Integer skp = (Integer) session.getAttribute("or_usedKakaoPoint_" + orderNo);
            Integer sra = (Integer) session.getAttribute("or_realPaidAmount_" + orderNo);
            if (skp != null) usedKakaoPoint = skp;
            if (sra != null) realPaidAmount = sra;

            model.addAttribute("popRedirect", false);
        }

        int effectiveRealPaid = (realPaidAmount != null ? realPaidAmount : (subtotal - usedPoint));
        int chargedCashOrCard = effectiveRealPaid - usedKakaoPoint;

        model.addAttribute("subtotal", subtotal);
        model.addAttribute("usedPoint", usedPoint);
        model.addAttribute("usedKakaoPoint", usedKakaoPoint);
        model.addAttribute("realPaidAmount", effectiveRealPaid);
        model.addAttribute("chargedCashOrCard", chargedCashOrCard);

        return "personal/orderResult";
    }



}
