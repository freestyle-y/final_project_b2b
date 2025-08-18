package com.example.trade.service;

import java.net.URI;
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
    public KakaoPayReadyResponse payReady(String orderNo, String name, int totalPrice) {
        // ✅ DB에서 orderNo 기준 총합 다시 조회 (프론트 조작 방지)
        int dbTotalPrice = orderMapper.getTotalPrice(orderNo);
        String userId = orderMapper.getUserIdByOrderNo(orderNo);   // ✅ DB에서 user_id 가져오기
        String firstProductName = orderMapper.getFirstProductName(orderNo); // ✅ 대표 상품명
        int productCount = orderMapper.getOrderItemCount(orderNo); // ✅ 상품 개수

        // ✅ 상품명이 여러 개면 "외 n건" 추가
        String itemName = firstProductName;
        if (productCount > 1) {
            itemName = firstProductName + " 외 " + (productCount - 1) + "건";
        }

        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "SECRET_KEY " + secretKey);
        headers.add("Content-Type", "application/json");

        Map<String, Object> params = new HashMap<>();
        params.put("cid", cid);
        params.put("partner_order_id", orderNo);   // ✅ 주문번호
        params.put("partner_user_id", userId);     // ✅ DB user_id
        params.put("item_name", itemName);
        params.put("quantity", 1);                 // ✅ 묶음 처리 → 무조건 1건
        params.put("total_amount", dbTotalPrice);  // ✅ 반드시 총합 전달
        params.put("tax_free_amount", 0);
        params.put("approval_url", approvalUrl + "?orderNo=" + orderNo);
        params.put("cancel_url", cancelUrl);
        params.put("fail_url", failUrl);

        HttpEntity<Map<String, Object>> body = new HttpEntity<>(params, headers);

        ResponseEntity<KakaoPayReadyResponse> response = restTemplate.exchange(
                URI.create(host + "/online/v1/payment/ready"),
                HttpMethod.POST,
                body,
                KakaoPayReadyResponse.class
        );

        kakaoPayReadyResponse = response.getBody();
        this.currentOrderNo = orderNo; // ✅ approve에서 다시 사용
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
        params.put("partner_order_id", currentOrderNo);   // ✅ Ready와 동일
        params.put("partner_user_id", currentUserId);     // ✅ Ready와 동일 (DB user_id)
        params.put("pg_token", pgToken);

        System.out.println("approve request >>> " + params); // 👀 디버깅용 로그

        HttpEntity<Map<String, Object>> body = new HttpEntity<>(params, headers);

        ResponseEntity<KakaoPayApprovalResponse> response = restTemplate.exchange(
                URI.create(host + "/online/v1/payment/approve"),
                HttpMethod.POST,
                body,
                KakaoPayApprovalResponse.class
        );

        return response.getBody();
    }
}
