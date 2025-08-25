package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Comment {
	private int commentNo;
	private Integer parentCommentNo; // null 허용을 위해 Integer로 변경
	private String commentContent;
	private int boardNo;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
}
