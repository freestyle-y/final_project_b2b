package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.example.trade.dto.Board;
import com.example.trade.dto.Comment;
import com.example.trade.dto.ContractDelivery;
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
	
	// 개인 회원 배송 처리
	@Transactional
	public int updatePersonalDelivery(Order order, DeliveryHistory deliveryHistory) {
		order.setDeliveryStatus("DS002"); // 배송중 처리
    	deliveryHistory.setDeliveryStatus("DS002"); // 배송중 처리
		adminMapper.updatePersonalDelivery(order);
		return adminMapper.insertDeliveryHistory(deliveryHistory);
	}
	
	// 개인 회원 배송 완료 처리
	@Transactional
	public int updateDeliveryComplete(Order order, DeliveryHistory deliveryHistory) {
		
		// 기존 배송 이력 조회
		DeliveryHistory newDeliveryHistory = adminMapper.getDeliveryHistory(deliveryHistory);
		
		order.setDeliveryStatus("DS003"); // 배송완료 처리
		deliveryHistory.setDeliveryCompany(newDeliveryHistory.getDeliveryCompany()); // 택배사
		deliveryHistory.setTrackingNo(newDeliveryHistory.getTrackingNo()); // 운송장 번호
    	deliveryHistory.setDeliveryStatus("DS003"); // 배송완료 처리
		adminMapper.updatePersonalDelivery(order);
		return adminMapper.insertDeliveryHistory(deliveryHistory);
	}

	// 교환 승인 처리
	@Transactional
	public int updateExchangeApprove(Order order, DeliveryHistory deliveryHistory) {
		
		// 기존 주문 건 배송 상태 교환중으로 변경
		order.setDeliveryStatus("DS007");
		adminMapper.updatePersonalDelivery(order);
		
		// 기존 주문 조회
		Order newOrder = adminMapper.getOrderDetail(order);

		// parent_sub_order_no 설정
		newOrder.setParentSubOrderNo(order.getSubOrderNo()); // 기존 subOrderNo를 parent로 설정

		// 새로운 sub_order_no 설정
		String newSubOrderNo = adminMapper.getNextSubOrderNo(order.getOrderNo());
		newOrder.setSubOrderNo(newSubOrderNo);
	    
		// 배송 이력 데이터 설정
		newOrder.setOrderStatus("OS002"); // 주문완료
		newOrder.setDeliveryStatus("DS002"); // 배송중
		newOrder.setCreateUser(order.getUpdateUser()); // 현재 관리자
		newOrder.setUseStatus("Y");
		
		// 새 교환 행 order 테이블에 insert
		adminMapper.insertExchangeOrder(newOrder);
		
		// 배송 이력에도 새로운 sub_order_no 로 입력
		deliveryHistory.setSubOrderNo(newSubOrderNo);
		deliveryHistory.setDeliveryStatus("DS002"); // 배송중
		
		// 새 배송 이력 delivery_history 테이블에 insert
		return adminMapper.insertDeliveryHistory(deliveryHistory);
	}
	
	// 교환 완료 처리
	@Transactional
	public int updateExchangeComplete(Order order) {
		order.setDeliveryStatus("DS008"); // 교환완료
		return adminMapper.updateExchangeComplete(order);
	}

	// 교환 거절 처리
	@Transactional
	public int updateExchangeReject(Order order) {
		order.setDeliveryStatus("DS003"); // 배송완료 복귀
		order.setExchangeQuantity(0); // 수량 0 복귀
		order.setExchangeReason(null); // 사유 null 복귀
		order.setExchangeRequestTime(null); // 신청일 null 복귀
		return adminMapper.updateExchangeReject(order);
	}

	// 반품 승인 처리
	@Transactional
	public int updateReturnApprove(Order order) {
		order.setDeliveryStatus("DS010"); // 반품중
		return adminMapper.updatePersonalDelivery(order);
	}

	// 반품 완료 처리
	@Transactional
	public int updateReturnComplete(Order order) {
		order.setDeliveryStatus("DS005"); // 반품완료
		return adminMapper.updateReturnComplete(order);
	}

	// 반품 거절 처리
	@Transactional
	public int updateReturnReject(Order order) {
		order.setDeliveryStatus("DS003"); // 배송완료 복귀
		order.setReturnQuantity(0); // 수량 0 복귀
		order.setReturnReason(null); // 사유 null 복귀
		order.setReturnRequestTime(null); // 신청일 null 복귀
		return adminMapper.updateReturnReject(order);
	}

	// 기업 회원 배송 처리
	@Transactional
	public int insertBizDelivery(ContractDelivery contractDelivery, DeliveryHistory deliveryHistory) {
		contractDelivery.setContractDeliveryStatus("DS002"); // 배송중 처리
		adminMapper.insertContractDelivery(contractDelivery);
		
		 // 생성된 contract_delivery_no를 deliveryHistory에 세팅
	    deliveryHistory.setContractDeliveryNo(contractDelivery.getContractDeliveryNo());
		deliveryHistory.setDeliveryStatus("DS002"); // 배송중 처리
		return adminMapper.insertBizDeliveryHistory(deliveryHistory);
	}
	
	// 기업 회원 배송 완료 처리
	@Transactional
	public int bizDeliveryComplete(ContractDelivery contractDelivery, DeliveryHistory deliveryHistory) {
		
		// 기존 배송 이력 조회
		DeliveryHistory newDeliveryHistory = adminMapper.getBizDeliveryHistory(deliveryHistory);
		
		contractDelivery.setContractDeliveryStatus("DS003"); // 배송완료 처리
		deliveryHistory.setDeliveryCompany(newDeliveryHistory.getDeliveryCompany()); // 택배사
		deliveryHistory.setTrackingNo(newDeliveryHistory.getTrackingNo()); // 운송장 번호
    	deliveryHistory.setDeliveryStatus("DS003"); // 배송완료 처리
    	
    	adminMapper.updateBizDelivery(contractDelivery);
    	return adminMapper.insertBizDeliveryHistory(deliveryHistory);
	}

	// 로그인 이력 저장
	public int saveLoginHistory(String userId) {
		return adminMapper.insertLoginHistory(userId);
	}
}
