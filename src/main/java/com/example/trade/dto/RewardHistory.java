package com.example.trade.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RewardHistory {
	private int rewardHistoryNo;
	private String orderNo;
	private int rewardUse;
	private int kakaoPayRewardUse;
}
