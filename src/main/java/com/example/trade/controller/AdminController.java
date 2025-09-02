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
import com.example.trade.dto.ContractDelivery;
import com.example.trade.dto.DeliveryHistory;
import com.example.trade.dto.Order;
import com.example.trade.service.AdminService;

@Controller
public class AdminController {
	private AdminService adminService;
	public AdminController(AdminService adminService) {
		this.adminService = adminService;
	}
	
	// 관리자 메인 페이지
	@GetMapping({"/admin/mainPage"})
	public String adminMainPage(Model model) {
		// 미응답 QNA 수
		int noCommentQnaCount = adminService.getNoCommentQnaCount();
		if(noCommentQnaCount != 0) {
			model.addAttribute("noCommentQnaCount",noCommentQnaCount);
		}
		return "admin/mainPage";
	}
	
	// 고객센터 관리 페이지
	@GetMapping("/admin/helpDesk")
	public String helpDesk() {
		return "admin/helpDesk";
	}
	
	// 자주 묻는 질문(FAQ) 관리 페이지
	@GetMapping("/admin/FAQList")
	public String FAQList(Model model) {
	    
	    // FAQ 리스트 조회
		List<Map<String, Object>> FAQList = adminService.getFAQList();
		
		// 모델에 값 전달
		model.addAttribute("FAQList", FAQList);
		
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
	
	// 자주 묻는 질문(FAQ) 등록 페이지
	@GetMapping("/admin/FAQWrite")
	public String FAQWriteForm() {
	    return "admin/FAQWrite";
	}

	// 자주 묻는 질문(FAQ) 등록 처리
	@PostMapping("/admin/FAQWrite")
	public String FAQWrite(Board board, Principal principal) {
		
		// 로그인 사용자 ID 세팅
		String username = principal.getName();
		board.setCreateUser(username);

		int row = adminService.insertBoard(board);
		
		if(row != 0) {
			System.out.println("FAQ 등록 성공");
			return "redirect:/admin/FAQOne?boardNo=" + board.getBoardNo();
		} else {
			System.out.println("FAQ 등록 실패");
			return "redirect:/admin/FAQWrite";
		}
	}
	
	// FAQ 수정 페이지
	@GetMapping("/admin/FAQUpdate")
	public String FAQUpdateForm(Board board, Model model) {
		// 상세 조회
		Board FAQOne = adminService.getFAQOne(board);
		model.addAttribute("FAQOne", FAQOne);
		return "admin/FAQUpdate";
	}

	// FAQ 수정 처리
	@PostMapping("/admin/FAQUpdate")
	public String FAQUpdate(Board board, Principal principal) {
		// 접속한 사용자 ID
		String username = principal.getName();
		board.setUpdateUser(username);

		int row = adminService.updateFAQ(board);
		
		if(row != 0) {
			System.out.println("FAQ 수정 성공");
			return "redirect:/admin/FAQOne?boardNo=" + board.getBoardNo();
		} else {
			System.out.println("FAQ 수정 실패");
			return "redirect:/admin/FAQUpdate?boardNo=" + + board.getBoardNo();
		}
	}
	
	// FAQ 삭제 처리
	@PostMapping("/admin/FAQDelete")
	public String FAQDelete(Board board, Principal principal) {
		// 접속한 사용자 ID
		String username = principal.getName();
		board.setUpdateUser(username);

		int row = adminService.deleteFAQ(board);
		
		if(row != 0) {
			System.out.println("FAQ 삭제 성공");
			return "redirect:/admin/FAQList";
		} else {
			System.out.println("FAQ 삭제 실패");
			return "redirect:/admin/FAQOne?boardNo=" + + board.getBoardNo();
		}
	}
	
	// QNA 목록 조회
	@GetMapping("/admin/QNAList")
	public String QNAList(Model model) {
		
		// 문의 내역 조회
		List<Map<String, Object>> QNAList = adminService.getQNAList();
		
		// 모델에 값 전달
		model.addAttribute("QNAList", QNAList);
		
		return "admin/QNAList";
	}
	
	// QNA 상세 조회
	@GetMapping("/admin/QNAOne")
	public String QNAOne(Board board, Model model) {
		
		// 접속한 사용자 ID 조회
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		board.setCreateUser(username);
		
		// QNA 상세 조회
		List<Map<String, Object>> QNAOne = adminService.getQNAOne(board);
		
		// 댓글 조회
		List<Map<String, Object>> commentList = adminService.getCommentByBoardNo(board.getBoardNo());
		
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
		
		return "admin/QNAOne";
	}
	
	// 댓글 등록
	@PostMapping("/admin/commentWrite")
	public String commentWrite(Comment comment, Principal principal) {
		
		// 로그인 사용자 ID
		comment.setCreateUser(principal.getName());
		
		// 댓글 DB에 저장
		int row = adminService.insertComment(comment);
		
		if(row != 0) {
			System.out.println("댓글 등록 성공");
			// 등록 후 다시 상세 페이지로 redirect
			return "redirect:/admin/QNAOne?boardNo=" + comment.getBoardNo();
		} else {
			System.out.println("댓글 등록 실패");
			return "redirect:/admin/QNAOne?boardNo=" + comment.getBoardNo();
		}
	}
	
	// 댓글 수정
	@PostMapping("/admin/commentUpdate")
	public String updateComment(Comment comment, Principal principal) {
		
		// 로그인 사용자
		String username = principal.getName();

		// 업데이트 정보 세팅
		comment.setUpdateUser(username);

		int row = adminService.updateComment(comment);
		
		if(row != 0) {
			System.out.println("댓글 수정 성공");
			// 수정 후 다시 상세 페이지로 redirect
			return "redirect:/admin/QNAOne?boardNo=" + comment.getBoardNo();
		} else {
			System.out.println("댓글 수정 실패");
			return "redirect:/admin/QNAOne?boardNo=" + comment.getBoardNo();
		}
	}
	
	// 댓글 삭제(비활성화)
	@PostMapping("/admin/deleteComment")
	public String deleteComment(Comment comment, Principal principal) {
		// 로그인 사용자 ID
		String username = principal.getName();
		comment.setUpdateUser(username);

		// 해당 댓글의 use_status 값 'N'으로 변경
		int row = adminService.deleteComment(comment);
		
		if(row != 0) {
			System.out.println("댓글 삭제 성공");
			// 변경 후 해당 게시글 상세로 리다이렉트
			return "redirect:/admin/QNAOne?boardNo=" + comment.getBoardNo();
		} else {
			System.out.println("댓글 삭제 실패");
			return "redirect:/admin/QNAOne?boardNo=" + comment.getBoardNo();
		}
	}
	
	// 공지사항 목록 조회
	@GetMapping("/admin/noticeList")
	public String noticeList(Model model) {
		
		// 공지사항 조회
		List<Map<String, Object>> noticeList = adminService.getNoticeList();
		
		// 모델에 값 전달
		model.addAttribute("noticeList", noticeList);
		
		return "admin/noticeList";
	}
	
	// 공지사항 상세 조회
	@GetMapping("/admin/noticeOne")
	public String noticeOne(Board board, Model model) {
		Board noticeOne = adminService.getNoticeOne(board);
		model.addAttribute("noticeOne", noticeOne);
		return "admin/noticeOne";
	}
	
	// 공지사항 등록 페이지
	@GetMapping("/admin/noticeWrite")
	public String noticeWrite() {
		return "admin/noticeWrite";
	}
	
	// 공지사항 등록 처리
	@PostMapping("/admin/noticeWrite")
	public String noticeWrite(Board board, Principal principal) {
		adminService.insertNotice(board, principal);
		return "redirect:/admin/noticeOne?boardNo=" + board.getBoardNo();
	}
	
	// 공지사항 수정 페이지
	@GetMapping("/admin/noticeUpdate")
	public String noticeUpdate(Board board, Model model) {
		Board noticeOne = adminService.getNoticeOne(board);
		model.addAttribute("noticeOne", noticeOne);
		return "admin/noticeUpdate";
	}

	// 공지사항 수정 처리
	@PostMapping("/admin/noticeUpdate")
	public String noticeUpdate(Board board, Principal principal) {
		String username = principal.getName(); // 로그인한 관리자
		board.setUpdateUser(username);
		adminService.updateNotice(board);
		return "redirect:/admin/noticeOne?boardNo=" + board.getBoardNo();
	}
	
	// 공지사항 삭제
	@PostMapping("/admin/noticeDelete")
	public String noticeDelete(Board board, Principal principal) {
		String username = principal.getName(); // 로그인한 관리자
		board.setUpdateUser(username);
		adminService.deleteNotice(board);
		return "redirect:/admin/noticeList";
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
	
	// 개인 회원 배송 현황 페이지
	@GetMapping("/admin/personalDeliveryList")
	public String personalDeliveryList(Model model) {
		
		// 개인 회원 배송 현황 조회
		List<Map<String, Object>> personalDeliveryList = adminService.getPersonalDeliveryList();
		
		// 모델에 값 전달
		model.addAttribute("personalDeliveryList", personalDeliveryList);
		
		return "admin/personalDeliveryList";
	}
	
	// 개인 회원 배송 처리 페이지
    @GetMapping("/admin/personalDeliveryUpdate")
    public String personalDeliveryUpdate(@RequestParam String orderNo,
	                                     @RequestParam String subOrderNo,
	                                     Model model) {
        model.addAttribute("orderNo", orderNo);
        model.addAttribute("subOrderNo", subOrderNo);
        return "admin/personalDeliveryUpdate";
    }

    // 개인 회원 배송 처리
    @PostMapping("/admin/personalDeliveryUpdate")
    public String personalDeliveryUpdate(Order order, DeliveryHistory deliveryHistory, Principal principal) {
    	
    	String updateUser = principal.getName();
    	order.setUpdateUser(updateUser);
    	
    	adminService.updatePersonalDelivery(order, deliveryHistory);
    	
        return "redirect:/admin/personalDeliveryList";
    }
    
    // 개인 회원 배송 완료 처리
	@PostMapping("/admin/personalDeliveryComplete")
	public String personalDeliveryComplete(Order order, DeliveryHistory deliveryHistory, Principal principal) {
		
		String updateUser = principal.getName();
		order.setUpdateUser(updateUser);
		
		adminService.updateDeliveryComplete(order, deliveryHistory);
		
		return "redirect:/admin/personalDeliveryList";
	}
    
    // 교환 배송 처리 페이지
    @GetMapping("/admin/personalExchangeUpdate")
    public String personalExchangeUpdate(Order order, Model model) {
    	model.addAttribute("order", order);
    	return "admin/personalExchangeUpdate";
    }
    
    // 교환 승인 처리
	@PostMapping("/admin/exchangeApprove")
	public String exchangeApprove(Order order, DeliveryHistory deliveryHistory, Principal principal) {
		
		String updateUser = principal.getName();
		order.setUpdateUser(updateUser);
		
		adminService.updateExchangeApprove(order, deliveryHistory);
		return "redirect:/admin/personalDeliveryList";
	}
	
	// 교환 완료 처리
	@PostMapping("/admin/exchangeComplete")
	public String exchangeComplete(Order order, Principal principal) {
		
		String updateUser = principal.getName();
		order.setUpdateUser(updateUser);
		
		adminService.updateExchangeComplete(order);
		return "redirect:/admin/personalDeliveryList";
	}

	// 교환 거절 처리
	@PostMapping("/admin/exchangeReject")
	public String exchangeReject(Order order, Principal principal) {
		
		String updateUser = principal.getName();
		order.setUpdateUser(updateUser);
		
		adminService.updateExchangeReject(order);
		return "redirect:/admin/personalDeliveryList";
	}

	// 반품 승인 처리
	@PostMapping("/admin/returnApprove")
	public String returnApprove(Order order, Principal principal) {
		
		String updateUser = principal.getName();
		order.setUpdateUser(updateUser);
		
		adminService.updateReturnApprove(order);
		return "redirect:/admin/personalDeliveryList";
	}
	
	// 반품 완료 처리
	@PostMapping("/admin/returnComplete")
	public String returnComplete(Order order, Principal principal) {
		
		String updateUser = principal.getName();
		order.setUpdateUser(updateUser);
		
		adminService.updateReturnComplete(order);
		return "redirect:/admin/personalDeliveryList";
	}

	// 반품 거절 처리
	@PostMapping("/admin/returnReject")
	public String returnReject(Order order, Principal principal) {
		
		String updateUser = principal.getName();
		order.setUpdateUser(updateUser);
		
		adminService.updateReturnReject(order);
		return "redirect:/admin/personalDeliveryList";
	}
	
	// 기업 회원 배송 처리 페이지
    @GetMapping("/admin/bizDeliveryUpdate")
    public String bizDeliveryUpdate(@RequestParam int containerNo, Model model) {
        model.addAttribute("containerNo", containerNo);
        return "admin/bizDeliveryUpdate";
    }

    // 기업 회원 배송 처리
    @PostMapping("/admin/bizDeliveryUpdate")
    public String bizDeliveryUpdate(ContractDelivery contractDelivery, DeliveryHistory deliveryHistory) {
    	
    	adminService.insertBizDelivery(contractDelivery, deliveryHistory);
    	
        return "redirect:/admin/bizDeliveryList";
    }
    
    // 기업 회원 배송 완료 처리
	@PostMapping("/admin/bizDeliveryComplete")
	public String bizDeliveryComplete(ContractDelivery contractDelivery, DeliveryHistory deliveryHistory) {
		
		adminService.bizDeliveryComplete(contractDelivery, deliveryHistory);
		
		return "redirect:/admin/bizDeliveryList";
	}
}
