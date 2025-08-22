package com.example.trade.dto;

import lombok.Data;

@Data
public class ContractSignForm {
    private String contractNo;
    private String supplierSignature;
    private String buyerSignature;
}
