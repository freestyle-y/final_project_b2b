package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Board;
import com.example.trade.dto.Comment;
import com.example.trade.dto.ContractDelivery;
import com.example.trade.dto.DeliveryHistory;
import com.example.trade.dto.Order;
import com.example.trade.dto.Page;

@Mapper
public interface AdminMapper {
	
	// 자주 묻는 질문(FAQ) 목록
	List<Map<String, Object>> selectFAQList();
	
	// 자주 묻는 질문(FAQ) 전체 행 수 조회
	int selectFAQTotalCount(Page page);
	
	// 자주 묻는 질문(FAQ) 상세 조회
	Board selectFAQOne(Board board);
	
	// 자주 묻는 질문(FAQ) 등록
	int insertBoard(Board board);
	
	// FAQ 수정
	int updateBoard(Board board);
	
	// FAQ 삭제
	int deleteBoard(Board board);

	// QNA 목록 조회
	List<Map<String, Object>> selectQNAListById();

	// QNA 목록 전체 행 수 조회
	int selectQNATotalCount(Page page);
	
	// 문의 내역 상세 조회
	List<Map<String, Object>> selectQNAOne(Board board);
	
	// 댓글 조회
	List<Map<String, Object>> selectCommentByBoardNo(int boardNo);
	
	// 댓글 등록
	int insertComment(Comment comment);
	
	// 댓글 수정
	int updateComment(Comment comment);
	
	// 댓글 삭제
	int deleteComment(Comment comment);
	
	// 공지사항 목록 조회
	List<Map<String, Object>> selectNoticeList();

	// 공지사항 전체 행 수 조회
	int selectNoticeTotalCount(Page page);
	
	// 공지사항 상세 조회
	Board selectNoticeOne(Board board);
	
	// 공지사항 등록
	int insertNotice(Board board);
	
	// 공지사항 수정
	int updateNotice(Board board);
	
	// 공지사항 삭제
	int deleteNotice(Board board);
	
	// 로그인 이력 조회
	List<Map<String, Object>> selectLoginHistory();

	// 알림 목록 조회
	List<Map<String, Object>> selectAlarmList();

	// 기업 회원의 배송 현황 조회
	List<Map<String, Object>> selectBizDeliveryList();

	// 개인 회원 배송 현황 조회
	List<Map<String, Object>> selectPersonalDeliveryList(Page page);

	// 개인 회원 배송 전체 행 수 조회
	int selectPersonalDeliveryTotalCount(Page page);

	// 개인 회원 배송 상태 변경
	int updatePersonalDelivery(Order order);
	
	// 기존 배송 이력 조회
	DeliveryHistory getDeliveryHistory(DeliveryHistory deliveryHistory);
	
	// 배송 이력 저장
	int insertDeliveryHistory(DeliveryHistory deliveryHistory);

	// 기존 주문 데이터 조회
	Order getOrderDetail(Order order);

	// 해당 주문의 다음 sub_order_no 계산
	String getNextSubOrderNo(String orderNo);
	
	// 교환 주문 행 생성
	int insertExchangeOrder(Order order);

	// 교환 완료 처리
	int updateExchangeComplete(Order order);

	// 교환 거절 처리
	int updateExchangeReject(Order order);

	// 반품 완료 처리
	int updateReturnComplete(Order order);

	// 반품 거절 처리
	int updateReturnReject(Order order);

	// 기업 회원 배송 처리
	int insertContractDelivery(ContractDelivery contractDelivery);

	// 기업 회원 배송 이력 등록
	int insertBizDeliveryHistory(DeliveryHistory deliveryHistory);

	// 기존 배송 이력 조회(기업)
	DeliveryHistory getBizDeliveryHistory(DeliveryHistory deliveryHistory);

	// 기업 회원 배송 상태 변경
	int updateBizDelivery(ContractDelivery contractDelivery);
	
	// 로그인 이력 저장
	int insertLoginHistory(String userId);
}