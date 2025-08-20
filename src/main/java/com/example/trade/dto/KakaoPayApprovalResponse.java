package com.example.trade.dto;

import lombok.Data;

@Data
public class KakaoPayApprovalResponse {
    private String aid;
    private String tid;
    private String cid;
    private String partner_order_id;
    private String partner_user_id;
    private String payment_method_type;
    private Amount amount;
    private int usedPoint;
    private int realPaidAmount;
    private int usedKakaoPoint; // ✅ 추가

    @Data
    public static class Amount {
        private int total;
        private int tax_free;
        private int vat;
        private int point; // ✅ 카카오페이 포인트 (중요!)
        private int discount;
        private int green_deposit;
    }
}
