package com.example.trade.controller;

import java.security.Principal;
import java.util.List;
import java.util.Map;

import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.example.trade.dto.Board;
import com.example.trade.dto.Comment;
import com.example.trade.dto.Page;
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
	public String FAQList(Model model
						,@RequestParam(defaultValue = "10") int rowPerPage
						,@RequestParam(defaultValue = "1") int currentPage
						,@RequestParam(defaultValue = "") String searchWord
						,@RequestParam(defaultValue = "all") String searchType) {
		
	    // Page 객체 생성 (DB 조회 전 totalCount = 0으로 초기화)
	    Page page = new Page(rowPerPage, currentPage, 0, searchWord, searchType);
	    
	    // 전체 행 수 조회
	    int totalCount = boardService.getFAQTotalCount(page);
	    page.setTotalCount(totalCount);
		
	    // FAQ 리스트 조회
		List<Map<String, Object>> FAQList = boardService.getFAQList(page);
		
		// 모델에 값 전달
		model.addAttribute("FAQList", FAQList);
		model.addAttribute("page", page);
		
		return "public/FAQList";
	}

	// 접속된 사용자의 문의 내역 조회
	@GetMapping("/member/QNAList")
	public String QNAList(Model model
						,@RequestParam(defaultValue = "10") int rowPerPage
						,@RequestParam(defaultValue = "1") int currentPage
						,@RequestParam(defaultValue = "") String searchWord
						,@RequestParam(defaultValue = "all") String searchType) {
		
	    // Page 객체 생성 (DB 조회 전 totalCount = 0으로 초기화)
	    Page page = new Page(rowPerPage, currentPage, 0, searchWord, searchType);
	    
		// 접속한 사용자 ID 조회
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		page.setUsername(username);
		
		// 전체 행 수 조회
		int totalCount = boardService.getQNATotalCount(page);
		page.setTotalCount(totalCount);
		
		// 문의 내역 조회
		List<Map<String, Object>> QNAList = boardService.getQNAList(page);
		
		// 모델에 값 전달
		model.addAttribute("QNAList", QNAList);
		model.addAttribute("page", page);
		
		return "member/QNAList";
	}
	
	// 문의 내역 상세 조회
	@GetMapping("/member/QNAOne")
	public String QNAOne(Board board, Model model) {
		
		// 접속한 사용자 ID 조회
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		board.setCreateUser(username);
		
		// 문의 내역 상세 조회
		List<Map<String, Object>> QNAOne = boardService.getQNAOne(board);
		
		// 댓글 조회
		List<Map<String, Object>> commentList = boardService.getCommentByBoardNo(board.getBoardNo());
		
	    // 댓글 간격(depth) 계산
		for(Map<String, Object> comment : commentList) {
			// 기본 depth = 0 (최상위 댓글)
			int depth = 0;
			
			// 현재 댓글의 부모 댓글 번호 가져오기
			Integer parent = (Integer)comment.get("parentCommentNo");
			
			// 부모가 존재하면 계속 위로 따라가면서 depth 계산
			while(parent != null) {
				for(Map<String, Object> c : commentList) {
					// 현재 댓글의 parent와 일치하는 commentNo 발견 시
					if(c.get("commentNo").equals(parent)) {
						depth++;
						parent = (Integer)c.get("parentCommentNo"); // 부모의 부모로 이동
						break; // 부모 찾은 후 내부 for문 종료
					}
				}
			}
			comment.put("depth", depth);
		}
		
		// 모델에 값 전달
		model.addAttribute("QNAOne", QNAOne);
		model.addAttribute("commentList", commentList);
		model.addAttribute("username", username);
		
		return "member/QNAOne";
	}
	
	// 댓글 등록
	@PostMapping("/member/commentWrite")
	public String commentWrite(Comment comment, Principal principal) {
		
		// 로그인 사용자 ID
		comment.setCreateUser(principal.getName());
		
		// 댓글 DB에 저장
		int row = boardService.insertComment(comment);
		
		if(row != 0) {
			System.out.println("댓글 등록 성공");
			// 등록 후 다시 상세 페이지로 redirect
			return "redirect:/member/QNAOne?boardNo=" + comment.getBoardNo();
		} else {
			System.out.println("댓글 등록 실패");
			return "redirect:/member/QNAOne?boardNo=" + comment.getBoardNo();
		}
	}
	
	// 댓글 수정
	@PostMapping("/member/commentUpdate")
	public String updateComment(Comment comment, Principal principal) {
		
		// 로그인 사용자
		String username = principal.getName();

		// 업데이트 정보 세팅
		comment.setUpdateUser(username);

		int row = boardService.updateComment(comment);
		
		if(row != 0) {
			System.out.println("댓글 수정 성공");
			// 수정 후 다시 상세 페이지로 redirect
			return "redirect:/member/QNAOne?boardNo=" + comment.getBoardNo();
		} else {
			System.out.println("댓글 수정 실패");
			return "redirect:/member/QNAOne?boardNo=" + comment.getBoardNo();
		}
	}
	
	// 댓글 삭제(비활성화)
	@PostMapping("/member/deleteComment")
	public String deleteComment(Comment comment, Principal principal) {
		// 로그인 사용자 ID
		String username = principal.getName();
		comment.setUpdateUser(username);

		// 해당 댓글의 use_status 값 'N'으로 변경
		int row = boardService.deleteComment(comment);
		
		if(row != 0) {
			System.out.println("댓글 삭제 성공");
			// 변경 후 해당 게시글 상세로 리다이렉트
			return "redirect:/member/QNAOne?boardNo=" + comment.getBoardNo();
		} else {
			System.out.println("댓글 삭제 실패");
			return "redirect:/member/QNAOne?boardNo=" + comment.getBoardNo();
		}
	}

	// 1:1 문의 작성 페이지
	@GetMapping("/member/QNAWrite")
	public String QNAWrite() {
		return "member/QNAWrite";
	}
	
	// 1:1 문의 내역 등록
	@PostMapping("/member/QNAWrite")
	public String QNAWrite(Board board, Principal principal) {
		// 접속한 사용자 ID 조회
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		board.setCreateUser(username);
		
		// 사용자가 작성한 문의 글 DB에 저장
		int row = boardService.insertBoard(board);
		
		if(row != 0) {
			int newBoardNo = board.getBoardNo(); // useGeneratedKeys 로 세팅된 boardNo
			System.out.println("QNA 등록 성공");
			return "redirect:/member/QNAOne?boardNo=" + newBoardNo;
		} else {
			System.out.println("QNA 등록 실패");
			return "redirect:/member/QNAWrite";
		}
	}

	// 공지사항
	@GetMapping("/public/noticeList")
	public String noticeList(Model model
							,@RequestParam(defaultValue = "10") int rowPerPage
							,@RequestParam(defaultValue = "1") int currentPage
							,@RequestParam(defaultValue = "") String searchWord
							,@RequestParam(defaultValue = "all") String searchType) {
		
	    // Page 객체 생성 (DB 조회 전 totalCount = 0으로 초기화)
	    Page page = new Page(rowPerPage, currentPage, 0, searchWord, searchType);
	    
		// 전체 행 수 조회
		int totalCount = boardService.getNoticeTotalCount(page);
		page.setTotalCount(totalCount);
		
		// 공지사항 조회
		List<Map<String, Object>> noticeList = boardService.getNoticeList(page);
		
		// 모델에 값 전달
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("page", page);
		
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
