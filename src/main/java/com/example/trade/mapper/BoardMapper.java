package com.example.trade.mapper;


import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.example.trade.dto.Board;
import com.example.trade.dto.Comment;
import com.example.trade.dto.Page;

@Mapper
public interface BoardMapper {

	// 자주 묻는 질문(FAQ) 목록
	List<Map<String, Object>> selectFAQList(Page page);
	
	// FAQ 전체 행 수 조회
	int selectFAQTotalCount(Page page);

	// 접속한 사용자의 문의 내역
	List<Map<String, Object>> selectQNAListById(Page page);

	// 문의 내역 전체 행 수 조회
	int selectQNATotalCount(Page page);
	
	// 문의 내역 상세 조회
	List<Map<String, Object>> selectQNAOne(Board board);
	
	// 1:1 문의 등록
	int insertBoard(Board board);
	
	// 1:1 문의 수정
	int updateQNA(Board board);
	
	// 1:1 문의 삭제(비활성화)
	int deleteQNA(Board board);
	
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
	List<Map<String, Object>> selectNoticeOne(int boardNo);
}
