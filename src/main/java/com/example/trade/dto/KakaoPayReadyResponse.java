package com.example.trade.dto;

import lombok.Data;

@Data
public class KakaoPayReadyResponse {
    private String tid;                     // 결제 고유 번호
    private String next_redirect_pc_url;    // 결제 페이지 URL (PC)
    private String created_at;
}
