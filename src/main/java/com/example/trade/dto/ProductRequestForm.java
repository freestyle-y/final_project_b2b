package com.example.trade.dto;

import java.util.List;

public class ProductRequestForm {
    private List<ProductRequest> productRequestList;
    private int addressNo;      // 배송지 번호
    private String requests;     // 요청사항

    public ProductRequestForm() {}

    public List<ProductRequest> getProductRequestList() {
        return productRequestList;
    }

    public void setProductRequestList(List<ProductRequest> productRequestList) {
        this.productRequestList = productRequestList;
    }

    public int getAddressNo() {
        return addressNo;
    }

    public void setAddressNo(int addressNo) {
        this.addressNo = addressNo;
    }

    public String getRequests() {
        return requests;
    }

    public void setRequests(String requests) {
        this.requests = requests;
    }
}
