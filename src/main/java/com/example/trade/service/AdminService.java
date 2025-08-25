package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Board;
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
}
