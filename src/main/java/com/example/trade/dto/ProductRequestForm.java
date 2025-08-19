package com.example.trade.dto;

import java.util.List;

public class ProductRequestForm {
    private List<ProductRequest> productRequestList;

    // 기본 생성자
    public ProductRequestForm() {}

    // getter & setter
    public List<ProductRequest> getProductRequestList() {
        return productRequestList;
    }

    public void setProductRequestList(List<ProductRequest> productRequestList) {
        this.productRequestList = productRequestList;
    }
}
