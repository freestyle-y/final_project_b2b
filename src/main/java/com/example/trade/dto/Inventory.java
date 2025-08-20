package com.example.trade.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Inventory {
	private int inventoryId;
	private int productNo;
	private int optionNo;
	private int quantity;
	private int addressNo;
}
