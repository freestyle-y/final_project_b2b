package com.example.trade.mapper;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.example.trade.dto.Board;
import com.example.trade.dto.Comment;
import com.example.trade.dto.DeliveryHistory;
import com.example.trade.dto.Order;
import com.example.trade.dto.Page;

@Mapper
public interface AdminMapper {
	
	// 자주 묻는 질문(FAQ) 목록
	List<Map<String, Object>> selectFAQList(Page page);
	
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
	List<Map<String, Object>> selectQNAListById(Page page);

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
	List<Map<String, Object>> selectNoticeList(Page page);

	// 공지사항 전체 행 수 조회
	int selectNoticeTotalCount(Page page);
	
	// 공지사항 상세 조회
	Board selectNoticeOne(Board board);
	
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

	int updatePersonalDelivery(@Param("orderNo") String orderNo,
					            @Param("subOrderNo") String subOrderNo,
					            @Param("deliveryStatus") String deliveryStatus,
					            @Param("updateUser") String updateUser);

	// 개인 회원 배송 상태 변경
	int updatePersonalDelivery(Order order);

	// 배송 이력 저장
	int insertDeliveryHistory(DeliveryHistory deliveryHistory);
}
