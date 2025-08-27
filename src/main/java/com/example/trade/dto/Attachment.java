package com.example.trade.dto;

import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class Attachment {
	private int attachmentNo;
	private String attachmentCode;
	private int categoryCode;
	private int priority;
	private String filepath;
	private String filename;
	private String createUser;
	private LocalDateTime createDate;
	private String updateUser;
	private LocalDateTime updateDate;
	private String useStatus;
	@Override
	public String toString() {
		return "Attachment [attachmentNo=" + attachmentNo + ", attachmentCode=" + attachmentCode + ", categoryCode="
				+ categoryCode + ", priority=" + priority + ", filepath=" + filepath + ", filename=" + filename
				+ ", createUser=" + createUser + ", createDate=" + createDate + ", updateUser=" + updateUser
				+ ", updateDate=" + updateDate + ", useStatus=" + useStatus + "]";
	}

}
