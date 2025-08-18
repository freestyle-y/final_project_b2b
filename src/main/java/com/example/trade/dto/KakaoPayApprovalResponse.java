package com.example.trade.dto;

import lombok.Data;

@Data
public class KakaoPayApprovalResponse {
    private String aid; // 요청 고유 번호
    private String tid; // 결제 고유 번호
    private String cid; // 가맹점 코드
    private String partner_order_id;
    private String partner_user_id;
    private String payment_method_type;
    private Amount amount; // 결제 금액 정보

    @Data
    public static class Amount {
        private int total;
        private int tax_free;
        private int vat;
        private int point;
        private int discount;
        private int green_deposit;
    }
}
