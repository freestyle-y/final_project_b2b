package com.example.trade.service;

import java.net.URI;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import com.example.trade.dto.KakaoPayApprovalResponse;
import com.example.trade.dto.KakaoPayReadyResponse;
import com.example.trade.mapper.OrderMapper;

@Service
public class KakaoPayService {

    @Value("${kakaopay.host}")
    private String host;

    @Value("${kakaopay.cid}")
    private String cid;   // 테스트: TC0ONETIME

    @Value("${kakaopay.secret-key}")   
    private String secretKey;   // ✅ Secret Key

    @Value("${kakaopay.approval-url}")
    private String approvalUrl;

    @Value("${kakaopay.cancel-url}")
    private String cancelUrl;

    @Value("${kakaopay.fail-url}")
    private String failUrl;

    private final OrderMapper orderMapper;  // ✅ 주문 정보 조회용 Mapper

    private KakaoPayReadyResponse kakaoPayReadyResponse;
    private String currentOrderNo;
    private String currentUserId;

    public KakaoPayService(OrderMapper orderMapper) {
        this.orderMapper = orderMapper;
    }

    /**
     * 결제 준비 요청
     * @param totalPrice 
     * @param name 
     */
    public KakaoPayReadyResponse payReady(String orderNo, String name, int clientFinalPrice) {
        // 1) 주문/사용자/상품명 DB 조회 (그대로 유지)
        int dbTotalPrice = orderMapper.getTotalPrice(orderNo);
        String userId = orderMapper.getUserIdByOrderNo(orderNo);
        String firstProductName = orderMapper.getFirstProductName(orderNo);
        int productCount = orderMapper.getOrderItemCount(orderNo);

        String itemName = firstProductName;
        if (productCount > 1) {
            itemName = firstProductName + " 외 " + (productCount - 1) + "건";
        }

        // 2) 최종 금액 검증 & 보정
        int finalPrice = clientFinalPrice;
        if (finalPrice > dbTotalPrice) finalPrice = dbTotalPrice;
        if (finalPrice < 0) finalPrice = 0;

        int usedPoint = dbTotalPrice - finalPrice;
        System.out.println("[KAKAO READY] dbTotal=" + dbTotalPrice
                + ", clientFinal=" + clientFinalPrice
                + ", usedPoint(derived)=" + usedPoint);

        // 3) 카카오 파라미터 구성
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "SECRET_KEY " + secretKey);
        headers.add("Content-Type", "application/json");

        Map<String, Object> params = new HashMap<>();
        params.put("cid", cid);
        params.put("partner_order_id", orderNo);
        params.put("partner_user_id", userId);
        params.put("item_name", itemName);
        params.put("quantity", 1);
        params.put("total_amount", finalPrice);
        params.put("tax_free_amount", 0);

        // ✅ 수정: 승인 성공 리다이렉트 URL을 /orderResult 로 변경
        //   - 기존 approvalUrl 이 /personal/payment/success 라고 가정
        //   - pg_token 은 카카오가 자동으로 붙여줍니다.
        String orderResultUrl =
                (approvalUrl != null && approvalUrl.contains("/success"))
                        ? approvalUrl.replace("/success", "/orderResult")
                        : (approvalUrl + "/personal/payment/orderResult"); // fallback
        orderResultUrl += "?orderNo=" + URLEncoder.encode(orderNo, StandardCharsets.UTF_8); // ✅ 수정
        params.put("approval_url", orderResultUrl); // ✅ 수정

        params.put("cancel_url", cancelUrl);
        params.put("fail_url", failUrl);

        System.out.println("[KAKAO READY PARAMS] " + params);

        HttpEntity<Map<String, Object>> body = new HttpEntity<>(params, headers);

        ResponseEntity<KakaoPayReadyResponse> response = restTemplate.exchange(
                URI.create(host + "/online/v1/payment/ready"),
                HttpMethod.POST,
                body,
                KakaoPayReadyResponse.class
        );

        kakaoPayReadyResponse = response.getBody();

        kakaoPayReadyResponse.setUsedPoint(usedPoint);
        kakaoPayReadyResponse.setRealPaidAmount(finalPrice);

        this.currentOrderNo = orderNo;
        this.currentUserId = userId;

        return kakaoPayReadyResponse;
    }

    /**
     * 결제 승인 요청
     */
    public KakaoPayApprovalResponse payApprove(String pgToken) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "SECRET_KEY " + secretKey);
        headers.add("Content-Type", "application/json");

        Map<String, Object> params = new HashMap<>();
        params.put("cid", cid);
        params.put("tid", kakaoPayReadyResponse.getTid());
        params.put("partner_order_id", currentOrderNo);
        params.put("partner_user_id", currentUserId);
        params.put("pg_token", pgToken);

        HttpEntity<Map<String, Object>> body = new HttpEntity<>(params, headers);

        ResponseEntity<KakaoPayApprovalResponse> response = restTemplate.exchange(
                URI.create(host + "/online/v1/payment/approve"),
                HttpMethod.POST,
                body,
                KakaoPayApprovalResponse.class
        );

        KakaoPayApprovalResponse result = response.getBody();

        // ✅ 사용한 포인트 계산
        int dbTotalPrice = orderMapper.getTotalPrice(currentOrderNo);
        int actualPaid = result.getAmount().getTotal(); // 카카오에서 결제한 실제 금액
        int usedPoint = dbTotalPrice - actualPaid;
        // ✅ 추가: 카카오페이 포인트
        int usedKakaoPoint = result.getAmount().getPoint(); // 이거 중요!!
        
        // ✅ 값 세팅
        result.setUsedPoint(usedPoint);
        result.setRealPaidAmount(actualPaid);
        result.setUsedKakaoPoint(usedKakaoPoint);
    
        return result;
    }
}
