package com.example.trade.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Board;
import com.example.trade.dto.Page;
import com.example.trade.service.AdminService;

@Controller
public class AdminController {
	private AdminService adminService;
	public AdminController(AdminService adminService) {
		this.adminService = adminService;
	}
	
	// 관리자 메인 페이지
	@GetMapping({"/admin/mainPage"})
	public String adminMainPage() {
		return "admin/mainPage";
	}
	
	// 고객센터 관리 페이지
	@GetMapping("/admin/helpDesk")
	public String helpDesk() {
		return "admin/helpDesk";
	}
	
	// 자주 묻는 질문(FAQ) 관리 페이지
	@GetMapping("/admin/FAQList")
	public String FAQList(Model model
						,@RequestParam(defaultValue = "10") int rowPerPage
						,@RequestParam(defaultValue = "1") int currentPage
						,@RequestParam(defaultValue = "") String searchWord
						,@RequestParam(defaultValue = "all") String searchType) {
		
	    // Page 객체 생성 (DB 조회 전 totalCount = 0으로 초기화)
	    Page page = new Page(rowPerPage, currentPage, 0, searchWord, searchType);
	    
	    // 전체 행 수 조회
	    int totalCount = adminService.getFAQTotalCount(page);
	    page.setTotalCount(totalCount);
		
	    // FAQ 리스트 조회
		List<Map<String, Object>> FAQList = adminService.getFAQList(page);
		
		// 모델에 값 전달
		model.addAttribute("FAQList", FAQList);
		model.addAttribute("page", page);
		
		return "admin/FAQList";
	}
	
	// 자주 묻는 질문(FAQ) 상세 페이지
	@GetMapping("/admin/FAQOne")
	public String FAQList(Board board, Model model) {
		
	    // 자주 묻는 질문(FAQ) 상세 조회
		Board FAQOne = adminService.getFAQOne(board);
		
		// 모델에 값 전달
		model.addAttribute("FAQOne", FAQOne);
		
		return "admin/FAQOne";
	}
	
	// 로그인 이력 조회 페이지
	@GetMapping("/admin/loginHistory")
	public String loginHistory(Model model) {
		List<Map<String, Object>> loginHistory = adminService.getLoginHistory();
		model.addAttribute("loginHistory", loginHistory);
		return "admin/loginHistory";
	}
	
	// 알림 목록 조회 페이지
	@GetMapping("/admin/alarmList")
	public String alarmList(Model model) {
		List<Map<String, Object>> alarmList = adminService.getAlarmHistory();
		model.addAttribute("alarmList", alarmList);
		return "admin/alarmList";
	}
	
	// 알림 등록 페이지
	@GetMapping("/admin/alarmWrite")
	public String alarmWrite() {
		return "admin/alarmWrite";
	}
	
	// 기업 회원의 배송 현황 페이지
	@GetMapping("/admin/bizDeliveryList")
	public String bizDeliveryList(Model model) {
		List<Map<String, Object>> bizDeliveryList = adminService.getBizDeliveryList();
		model.addAttribute("bizDeliveryList", bizDeliveryList);
		return "admin/bizDeliveryList";
	}
}
