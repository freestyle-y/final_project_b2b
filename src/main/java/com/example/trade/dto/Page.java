package com.example.trade.dto;

import lombok.Data;

@Data
public class Page {
	private int rowPerPage; // 한 페이지에 보여줄 행 수
	private int currentPage; // 현재 페이지 번호
	private int totalCount; // 전체 데이터 수
	private String searchWord; // 검색어
	private String searchType; // 검색 타입
	private int beginRow; // SQL offset 값

	// 페이지 블럭 관련
	private int pageBlock = 5; // 하단에 보여줄 페이지 번호 개수 (ex: 1~5, 6~10)
	
	// 사용자 아이디 추가
	private String username;

	public Page(int rowPerPage, int currentPage, int totalCount, String searchWord, String searchType) {
		this.rowPerPage = rowPerPage;
		this.currentPage = currentPage;
		this.totalCount = totalCount;
		this.searchWord = searchWord;
		this.searchType = searchType;
		this.beginRow = (currentPage - 1) * rowPerPage;
	}

	// 현재 블럭 시작 페이지
	public int getStartPage() {
		return ((currentPage - 1) / pageBlock) * pageBlock + 1;
	}

	// 현재 블럭 끝 페이지
	public int getEndPage() {
		int totalPage = (int) Math.ceil((double) totalCount / rowPerPage);
		int endPage = getStartPage() + pageBlock - 1;
		return Math.min(endPage, totalPage);
	}

	// 이전 블럭 존재 여부
	public boolean hasPrevBlock() {
		return getStartPage() > 1;
	}

	// 다음 블럭 존재 여부
	public boolean hasNextBlock() {
		int totalPage = (int) Math.ceil((double) totalCount / rowPerPage);
		return getEndPage() < totalPage;
	}
}