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
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.example.trade.dto.KakaoPayApprovalResponse;
import com.example.trade.dto.KakaoPayReadyResponse;

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

    private KakaoPayReadyResponse kakaoPayReadyResponse;
    private String currentOrderNo;

    /**
     * 결제 준비 요청
     */
    public KakaoPayReadyResponse payReady(String orderNo, String name, int totalPrice) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "SECRET_KEY " + secretKey);
        headers.add("Content-Type", "application/json"); // ✅ JSON 방식 권장

        Map<String, Object> params = new HashMap<>();
        params.put("cid", cid);
        params.put("partner_order_id", orderNo);
        params.put("partner_user_id", "testUser");
        params.put("item_name", name);
        params.put("quantity", 1);
        params.put("total_amount", totalPrice);
        params.put("tax_free_amount", 0);
        params.put("approval_url", approvalUrl);
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
        return kakaoPayReadyResponse;
    }

    /**
     * 결제 승인 요청
     */
    public KakaoPayApprovalResponse payApprove(String pgToken) {
        RestTemplate restTemplate = new RestTemplate();

        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "SECRET_KEY " + secretKey);
        headers.add("Content-type", "application/x-www-form-urlencoded;charset=utf-8");

        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("cid", cid);
        params.add("tid", kakaoPayReadyResponse.getTid());
        params.add("partner_order_id", currentOrderNo);
        params.add("partner_user_id", "testUser"); // Ready와 동일해야 함
        params.add("pg_token", pgToken);

        HttpEntity<MultiValueMap<String, String>> body = new HttpEntity<>(params, headers);

        ResponseEntity<KakaoPayApprovalResponse> response = restTemplate.exchange(
                URI.create(host + "/online/v1/payment/approve"),
                HttpMethod.POST,
                body,
                KakaoPayApprovalResponse.class
        );

        return response.getBody();
    }
}
