package com.example.trade.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.example.trade.dto.Board;
import com.example.trade.mapper.BoardMapper;

@Service
public class BoardService {
	private BoardMapper boardMapper;
	public BoardService(BoardMapper boardMapper) {
		this.boardMapper = boardMapper;
	}

	// 자주 묻는 질문(FAQ) 목록
	public List<Map<String, Object>> getFAQList() {
		return boardMapper.selectFAQList();
	}

	// 접속한 사용자의 문의 내역
	public List<Map<String, Object>> getQNAList(String username) {
		return boardMapper.selectQNAListById(username);
	}

	// 문의 내역 상세 조회
	public List<Map<String, Object>> getQNAOne(Board board) {
		return boardMapper.selectQNAOne(board);
	}

	// 공지사항 목록 조회
	public List<Map<String, Object>> getNoticeList() {
		return boardMapper.selectNoticeList();
	}

	// 공지사항 상세 조회
	public List<Map<String, Object>> getNoticeOne(int boardNo) {
		return boardMapper.selectNoticeOne(boardNo);
	}

}
