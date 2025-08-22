package com.example.trade.dto;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ProductRequestForm {
    private List<ProductRequest> productRequestList;
    private int addressNo;      // 배송지 번호
    private String requests;     // 요청사항
}
