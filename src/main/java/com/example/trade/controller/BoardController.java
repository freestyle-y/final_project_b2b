package com.example.trade.controller;

import java.util.List;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Board;
import com.example.trade.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {
	private BoardService boardService;
	public BoardController(BoardService boardService) {
		this.boardService = boardService;
	}
	
	// 고객센터
	@GetMapping("/public/helpDesk")
	public String helpDesk() {
		return "public/helpDesk";
	}
	
	// 자주 묻는 질문(FAQ)
	@GetMapping("/public/FAQList")
	public String FAQList(Model model) {
		List<Map<String, Object>> FAQList = boardService.getFAQList();
		model.addAttribute("FAQList", FAQList);
		return "public/FAQList";
	}

	// 문의 내역
	@GetMapping("/member/QNAList")
	public String QNAList(Model model) {
		// 접속한 사용자 ID 조회
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		model.addAttribute("username", username);
		
		List<Map<String, Object>> QNAList = boardService.getQNAList(username);
		model.addAttribute("QNAList", QNAList);
		return "member/QNAList";
	}
	
	// 문의 내역 상세 조회
	@GetMapping("/member/QNAOne")
	public String QNAOne(Board board, Model model) {
		// 접속한 사용자 ID 조회
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		board.setCreateUser(username);
		
		List<Map<String, Object>> QNAOne = boardService.getQNAOne(board);
		model.addAttribute("QNAOne", QNAOne);
		return "member/QNAOne";
	}

	// 1:1 문의 작성 페이지
	@GetMapping("/member/QNAWrite")
	public String QNAWrite() {
		return "member/QNAWrite";
	}

	// 공지사항
	@GetMapping("/public/noticeList")
	public String noticeList(Model model) {
		List<Map<String, Object>> noticeList = boardService.getNoticeList();
		model.addAttribute("noticeList", noticeList);
		return "public/noticeList";
	}
	
	// 공지사항 상세 조회
	@GetMapping("/public/noticeOne")
	public String noticeOne(@RequestParam int boardNo, Model model) {
		List<Map<String, Object>> noticeOne = boardService.getNoticeOne(boardNo);
		model.addAttribute("noticeOne", noticeOne);
		return "public/noticeOne";
	}
}
