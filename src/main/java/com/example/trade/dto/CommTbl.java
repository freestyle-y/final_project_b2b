package com.example.trade.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommTbl {
	private String codeNumber;
	private String codeName;
	private int parameter1;
	private int parameter2;
	private String useStatus;
}
