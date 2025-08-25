package com.example.trade.dto;

import lombok.Data;

@Data
public class ContractSignForm {
    private String quotationNo;        // ✅ 견적서 번호 (계약 생성 시 필요)
    private String contractNo;         // ✅ 계약서 번호 (insert 후 자동 생성되는 PK)
    private String supplierSignature;
    private String buyerSignature;
    private String downPayment;
    private String finalPayment;
}
