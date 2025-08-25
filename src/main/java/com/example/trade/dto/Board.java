package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Board {
	private int boardNo;
	private String boardTitle;
	private String boardContent;
	private String boardCode;
	private String subCode;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	private int viewCount;
}
