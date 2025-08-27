package com.example.trade.dto;

import java.util.List;

import lombok.Data;

@Data
public class RecallGroup {
    private int containerNo;
    private String containerLocation;
    private String name;
    private String companyName;
    private String address;
    private String detailAddress;
    private int rowspan;
    private List<Container> items;
}
