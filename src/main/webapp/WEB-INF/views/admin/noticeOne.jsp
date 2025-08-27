<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>공지사항 상세</title>
<style>
    table {
        width: 50%;
        border-collapse: collapse;
        text-align: center;
        margin: auto;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
    }
    .delete-btn {
        border: none;
        background: none;
        padding: 0;
        margin: 0;
        color: blue;
        text-decoration: underline;
        cursor: pointer;
        font-size: 1em;
    }
    .delete-btn:hover {
        color: darkred;
    }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
	
	<h1>공지사항 상세</h1>
	
   	<a href="/admin/FAQList">자주 묻는 질문</a> /
	<a href="/admin/QNAList">문의 내역</a> /
	<a href="/admin/noticeList">공지사항</a>
	
	<table>
		<tr>
			<th>번호</th>
			<td>${noticeOne.boardNo}</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${noticeOne.boardTitle}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${noticeOne.boardContent}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${noticeOne.createUser}</td>
		</tr>
		<tr>
			<th>작성일시</th>
			<td>${noticeOne.createDate}</td>
		</tr>
		<tr>
			<th>수정자</th>
			<td>${noticeOne.updateUser}</td>
		</tr>
		<tr>
			<th>수정일시</th>
			<td>${noticeOne.updateDate}</td>
		</tr>
		<tr>
			<th>사용 여부</th>
			<td>${noticeOne.useStatus}</td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>${noticeOne.viewCount}</td>
		</tr>
	</table>
	
	<a href="/admin/noticeList">목록</a> /
	<a href="/admin/noticeUpdate?boardNo=${noticeOne.boardNo}">수정</a> /
	<form action="/admin/noticeDelete" method="post" style="display: inline;">
		<input type="hidden" name="boardNo" value="${noticeOne.boardNo}">
		<button type="submit" class="delete-btn" onclick="return confirm('정말 댓글을 삭제하시겠습니까?');">삭제</button>
	</form>
	
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>