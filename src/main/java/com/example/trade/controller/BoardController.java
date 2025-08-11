package com.example.trade.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class BoardController {
	// 고객센터
	@GetMapping("/public/helpDesk")
	public String helpDesk() {
		return "public/helpDesk";
	}
	
	// 문의 내역
	@GetMapping("/public/QNAList")
	public String QNAList() {
		return "public/QNAList";
	}
	
	// 1:1 문의
	@GetMapping("/public/QNAPage")
	public String QNAPage() {
		return "public/QNAPage";
	}
	
	// 공지사항
	@GetMapping("/public/noticeList")
	public String noticeList() {
		return "public/noticeList";
	}

	// 자주 묻는 질문
	@GetMapping("/public/FAQList")
	public String FAQList() {
		return "public/FAQList";
	}
	
	// 리뷰 목록
	@GetMapping("/public/reviewList")
	public String reviewList() {
		return "public/reviewList";
	}
	
	// 알림 목록
	@GetMapping("/public/notificationList")
	public String notificationList() {
		return "public/notificationList";
	}
}
