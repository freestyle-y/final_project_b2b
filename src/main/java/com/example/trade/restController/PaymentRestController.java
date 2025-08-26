package com.example.trade.restController;

import java.util.Map;

import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.example.trade.dto.KakaoPayReadyResponse;
import com.example.trade.dto.PaymentMethod;
import com.example.trade.service.KakaoPayService;
import com.example.trade.service.OrderService;
import com.example.trade.service.PaymentMethodService;

@RestController
@RequestMapping("/personal/payment")
public class PaymentRestController {

    private final PaymentMethodService paymentMethodService;
    private final KakaoPayService kakaoPayService;
    private final OrderService orderService;

    // ✅ 생성자 주입
    public PaymentRestController(PaymentMethodService paymentMethodService,
                                 KakaoPayService kakaoPayService,
                                 OrderService orderService) {
        this.paymentMethodService = paymentMethodService;
        this.kakaoPayService = kakaoPayService;
        this.orderService = orderService;
    }

    // ✅ 카드 등록
    @PostMapping("/addCard")
    public String addCard(@RequestBody PaymentMethod card) {
        card.setCreateUser(card.getUserId());
        card.setUseStatus("Y");
        card.setPaymentCode("CARD");
        if (card.getIsDefault() == null) {
            card.setIsDefault("N"); // 기본값 세팅
        }
        int row = paymentMethodService.insertCard(card);
        System.out.println("insert 결과: " + row);
        return row > 0 ? "success" : "fail";
    }

    // ✅ 카카오페이 결제 준비
    @PostMapping("/ready")
    public KakaoPayReadyResponse kakaoPayReady(@RequestBody Map<String, Object> request) {
        String orderNo = (String) request.get("orderNo");
        String name = (String) request.get("name");
        int totalPrice = Integer.parseInt(request.get("totalPrice").toString());

        System.out.println("카카오페이 요청 들어옴: " + request);

        return kakaoPayService.payReady(orderNo, name, totalPrice);
    }

    // ✅ 결제 수단 및 포인트 저장
    @PostMapping("/saveMethodAndPoints")
    public void saveMethodAndPoints(@RequestBody Map<String, Object> request) {
        String orderNo = (String) request.get("orderNo");
        String paymentMethod = (String) request.get("paymentMethod");
        int usePoint = request.get("usePoint") == null ? 0 : Integer.parseInt(request.get("usePoint").toString());
        Integer addressNo = request.get("addressNo") != null ? Integer.parseInt(request.get("addressNo").toString()) : null;
        String methodKor = switch (paymentMethod) {
            case "kakaopay" -> "카카오페이";
            case "bank"     -> "계좌이체";
            case "card"     -> "카드결제";
            default         -> "기타";
        };
        orderService.saveMethodAndPoints(orderNo, methodKor, usePoint, addressNo);
    }
}
