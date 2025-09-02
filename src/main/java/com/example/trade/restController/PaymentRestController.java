package com.example.trade.restController;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    public ResponseEntity<?> saveMethodAndPoints(@RequestBody Map<String, Object> request) {
        try {
            String orderNo = request.get("orderNo") != null ? request.get("orderNo").toString() : null;
            String paymentMethod = request.get("paymentMethod") != null ? request.get("paymentMethod").toString() : null;
            if (orderNo == null || paymentMethod == null) {
                return ResponseEntity.badRequest().body(Map.of("message", "필수 파라미터 누락(orderNo/paymentMethod)"));
            }

            int usePoint = toIntOrDefault(request.get("usePoint"), 0);            // ✅ 수정
            Integer addressNo = toIntegerOrNull(request.get("addressNo"));        // ✅ 수정

            Integer paymentMethodNo = null;
            if ("card".equals(paymentMethod)) {
                paymentMethodNo = toIntegerOrNull(request.get("cardMethodNo"));   // ✅ 수정
                if (paymentMethodNo == null) {
                    return ResponseEntity.badRequest().body(Map.of("message", "카드를 선택하세요."));
                }
            }

            String methodKor = switch (paymentMethod) {
                case "kakaopay" -> "카카오페이";
                case "bank"     -> "계좌이체";
                case "card"     -> "카드결제";
                default         -> "기타";
            };

            // ✅ 수정: 서비스에 null 허용(wrapper)로 전달
            orderService.saveMethodAndPoints(orderNo, methodKor, usePoint, addressNo, paymentMethodNo);

            String redirectUrl = "/personal/payment/orderResult?orderNo=" + URLEncoder.encode(orderNo, StandardCharsets.UTF_8);
            return ResponseEntity.ok(Map.of("redirectUrl", redirectUrl));

        } catch (NumberFormatException | NullPointerException e) {                 // ✅ 수정
            return ResponseEntity.badRequest().body(Map.of("message", "요청 파라미터 형식 오류: " + e.getMessage()));
        } catch (IllegalArgumentException e) {
            return ResponseEntity.badRequest().body(Map.of("message", e.getMessage()));
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(Map.of("message", "서버 오류가 발생했습니다."));
        }
    }

    private static int toIntOrDefault(Object o, int def) {
        if (o == null) return def;
        String s = o.toString().trim();
        if (s.isEmpty()) return def;
        return Integer.parseInt(s);
    }

    private static Integer toIntegerOrNull(Object o) {
        if (o == null) return null;
        String s = o.toString().trim();
        if (s.isEmpty()) return null;
        return Integer.valueOf(s);
    }


}
