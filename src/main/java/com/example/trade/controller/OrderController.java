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

        // 주문번호 기준으로 그룹핑
        Map<String, List<Order>> orderGroupMap = orderList.stream()
                .collect(Collectors.groupingBy(Order::getOrderNo, LinkedHashMap::new, Collectors.toList()));

        model.addAttribute("orderGroupMap", orderGroupMap);

        return "personal/orderList";
    }
    
    // 주문 상세
    @GetMapping("/personal/orderOne")
    public String orderOne(@RequestParam("orderNo") String orderNo, Model model) {
        List<Order> orderDetailList = orderService.getOrderDetailByOrderNo(orderNo);
        model.addAttribute("orderDetailList", orderDetailList);
        return "personal/orderOne";
    }
    
 // ✅ 수정: pg_token을 optional로 받고, 있으면 승인 호출
    @GetMapping("/personal/payment/orderResult")
    public String orderResult(@RequestParam String orderNo,
                              @RequestParam(name = "pg_token", required = false) String pgToken,
                              Model model,
                              HttpSession session) { // ✅ 수정: 세션 주입
        // 주문 리스트 & 일시
        List<Order> orderList = orderService.getOrderList(orderNo);
        Order first = orderList.get(0);
        java.sql.Timestamp orderDate = java.sql.Timestamp.valueOf(first.getOrderTime());
        model.addAttribute("orderList", orderList);
        model.addAttribute("orderDate", orderDate);

        // 주문 요약(구매자 이름/총액/상품명 가공)
        Order summary = orderService.getOrder(orderNo);
        model.addAttribute("name", summary.getName());
        int itemCount = orderService.getOrderItemCount(orderNo);
        String productName = summary.getProductName();
        if (itemCount > 1) productName += " 외 " + (itemCount - 1) + "건";
        model.addAttribute("productName", productName);

        int subtotal = summary.getTotalPrice();
        int usedPoint = 0;
        int usedKakaoPoint = 0;
        Integer realPaidAmount = null;

        if (pgToken != null && !pgToken.isBlank()) {
            // ✅ 수정: 팝업으로 도착한 승인 콜백
            KakaoPayApprovalResponse approval = kakaoPayService.payApprove(pgToken);
            usedPoint       = approval.getUsedPoint();
            usedKakaoPoint  = approval.getUsedKakaoPoint();
            realPaidAmount  = approval.getRealPaidAmount();

            // ✅ 수정: 메인창에서도 바로 보여줄 수 있도록 세션에 저장
            session.setAttribute("or_usedPoint_" + orderNo, usedPoint);
            session.setAttribute("or_usedKakaoPoint_" + orderNo, usedKakaoPoint);
            session.setAttribute("or_realPaidAmount_" + orderNo, realPaidAmount);

            // ✅ 수정: 이 요청은 팝업 → 메인창으로 넘기기 위한 플래그
            model.addAttribute("popRedirect", true);
        } else {
            // ✅ 수정: 메인창에서 새로 열렸을 때 세션에 저장된 값 사용 (없으면 기본 계산)
            Integer sp  = (Integer) session.getAttribute("or_usedPoint_" + orderNo);
            Integer skp = (Integer) session.getAttribute("or_usedKakaoPoint_" + orderNo);
            Integer sra = (Integer) session.getAttribute("or_realPaidAmount_" + orderNo);
            if (sp  != null) usedPoint = sp;
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
