package com.example.trade.controller;

import java.lang.annotation.Target;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.example.trade.dto.KakaoPayApprovalResponse;
import com.example.trade.dto.KakaoPayReadyResponse;
import com.example.trade.dto.Order;
import com.example.trade.service.KakaoPayService;
import com.example.trade.service.OrderService;

@Controller
public class OrderController {

    private final OrderService orderService;
    private final KakaoPayService kakaoPayService;

    public OrderController(OrderService orderService, KakaoPayService kakaoPayService) {
        this.orderService = orderService;
        this.kakaoPayService = kakaoPayService;
    }

    // 결제 페이지 (주문정보 보여주기)

    @GetMapping("/personal/payment")
    public String payment(@RequestParam("orderNo") String orderNo, Model model) {
        List<Order> orderList = orderService.getOrderList(orderNo);
        model.addAttribute("orderList", orderList);
        return "personal/payment"; 
    }

    //카카오페이 결제 준비 요청 - orderNo, name, totalPrice JSON 받음, - KakaoPayService 호출 → ReadyResponse 그대로 반환
    @PostMapping("/personal/payment/ready")
    @ResponseBody
    public KakaoPayReadyResponse kakaoPayReady(@RequestBody Map<String, Object> request) {
        String orderNo = (String) request.get("orderNo");
        String name = (String) request.get("name");
        int totalPrice = (int) request.get("totalPrice");

        System.out.println("🔥 카카오페이 요청 들어옴: " + request);
        
        return kakaoPayService.payReady(orderNo, name, totalPrice);
    }

    @GetMapping("/personal/payment/success")
    public String paymentSuccess(@RequestParam("pg_token") String pgToken,
                                 @RequestParam("orderNo") String orderNo,
                                 Model model) {
        // 1. 카카오 결제 승인
        KakaoPayApprovalResponse response = kakaoPayService.payApprove(pgToken);

        // 2. 주문 정보
        Order order = orderService.getOrder(orderNo);

        // 3. 아이템 개수 조회
        int itemCount = orderService.getOrderItemCount(orderNo);

        // 4. 상품명 가공
        String productName = order.getProductName();
        if (itemCount > 1) {
            productName += " 외 " + (itemCount - 1) + "건";
        }

        // 5. JSP에 전달
        model.addAttribute("name", order.getName());  // 구매자
        model.addAttribute("productName", productName); // 상품명 (외 n건 포함)
        model.addAttribute("totalPrice", order.getTotalPrice()); // 총액

        return "personal/paymentSuccess";
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
    public String orderList() {
    	return "personal/orderList";
    }
}
