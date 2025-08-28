package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Board;
import com.example.trade.dto.Comment;
import com.example.trade.dto.DeliveryHistory;
import com.example.trade.dto.Order;
import com.example.trade.dto.Page;
import com.example.trade.mapper.AdminMapper;

@Service
public class AdminService {
	private AdminMapper adminMapper;
	public AdminService(AdminMapper adminMapper) {
		this.adminMapper = adminMapper;
	}
	
	// 자주 묻는 질문(FAQ) 목록
	public List<Map<String, Object>> getFAQList(Page page) {
		return adminMapper.selectFAQList(page);
	}
	
	// 자주 묻는 질문(FAQ) 전체 행 수 조회
	public int getFAQTotalCount(Page page) {
		return adminMapper.selectFAQTotalCount(page);
	}
	
	// 자주 묻는 질문(FAQ) 상세 조회
	public Board getFAQOne(Board board) {
		return adminMapper.selectFAQOne(board);
	}
	
	// 자주 묻는 질문(FAQ) 등록
	public int insertBoard(Board board) {
		return adminMapper.insertBoard(board);
	}
	
	// FAQ 수정
	public int updateFAQ(Board board) {
		return adminMapper.updateBoard(board);
	}

	// FAQ 삭제
	public int deleteFAQ(Board board) {
		return adminMapper.deleteBoard(board);
	}
	
	// QNA 목록 조회
	public List<Map<String, Object>> getQNAList(Page page) {
		return adminMapper.selectQNAListById(page);
	}
	
	// QNA 목록 전체 행 수 조회
	public int getQNATotalCount(Page page) {
		return adminMapper.selectQNATotalCount(page);
	}
	
	// QNA 상세 조회
	public List<Map<String, Object>> getQNAOne(Board board) {
		return adminMapper.selectQNAOne(board);
	}
	
	// 댓글 조회
	public List<Map<String, Object>> getCommentByBoardNo(int boardNo) {
		return adminMapper.selectCommentByBoardNo(boardNo);
	}
	
	// 댓글 등록
	public int insertComment(Comment comment) {
		return adminMapper.insertComment(comment);
	}
	
	// 댓글 수정
	public int updateComment(Comment comment) {
		return adminMapper.updateComment(comment);
	}
	
	// 댓글 삭제
	public int deleteComment(Comment comment) {
		return adminMapper.deleteComment(comment);
	}

	// 공지사항 목록 조회
	public List<Map<String, Object>> getNoticeList(Page page) {
		return adminMapper.selectNoticeList(page);
	}
	
	// 공지사항 전체 행 수 조회
	public int getNoticeTotalCount(Page page) {
		return adminMapper.selectNoticeTotalCount(page);
	}
	
	// 공지사항 상세 조회
	public Board getNoticeOne(Board board) {
		return adminMapper.selectNoticeOne(board);
	}
	
	// 공지사항 수정
	public int updateNotice(Board board) {
		return adminMapper.updateNotice(board);
	}
	
	// 공지사항 삭제
	public int deleteNotice(Board board) {
		return adminMapper.deleteNotice(board);
	}
	
	// 로그인 이력 조회
	public List<Map<String, Object>> getLoginHistory() {
		return adminMapper.selectLoginHistory();
	}

	// 알림 목록 조회
	public List<Map<String, Object>> getAlarmHistory() {
		return adminMapper.selectAlarmList();
	}

	// 기업 회원의 배송 현황 조회
	public List<Map<String, Object>> getBizDeliveryList() {
		return adminMapper.selectBizDeliveryList();
	}

	// 개인 회원 배송 현황 조회
	public List<Map<String, Object>> getPersonalDeliveryList(Page page) {
		return adminMapper.selectPersonalDeliveryList(page);
	}

	// 개인 회원 배송 전체 행 수 조회
	public int getPersonalDeliveryTotalCount(Page page) {
		return adminMapper.selectPersonalDeliveryTotalCount(page);
	}
	
	// 개인 회원 배송 상태 변경
	@Transactional
	public int updatePersonalDelivery(Order order, DeliveryHistory deliveryHistory) {
		adminMapper.updatePersonalDelivery(order);
		return adminMapper.insertDeliveryHistory(deliveryHistory);
	}
}
