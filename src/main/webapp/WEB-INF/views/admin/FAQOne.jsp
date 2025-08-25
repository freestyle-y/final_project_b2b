<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자주 묻는 질문 상세</title>
<style>
    table {
        width: 30%;
        border-collapse: collapse;
        text-align: left;
        margin: auto;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
    }
    .pagination {
        margin: 20px auto;
        text-align: center;
    }
    .pagination a {
        display: inline-block;
        margin: 0 5px;
        padding: 5px 10px;
        border: 1px solid #ccc;
        text-decoration: none;
        color: #333;
    }
    .pagination a.active {
        background: #333;
        color: #fff;
        font-weight: bold;
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
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
	
	<h1>자주 묻는 질문 상세</h1>
	
   	<a href="/admin/FAQList">자주 묻는 질문</a> /
	<a href="/admin/QNAList">문의 내역</a> /
	<a href="/admin/noticeList">공지사항</a>
	
	<table>
		<tr>
			<th>번호</th>
			<td>${FAQOne.boardNo}</td>
		</tr>
		<tr>
			<th>제목</th>
			<td>${FAQOne.boardTitle}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${FAQOne.boardContent}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${FAQOne.createUser}</td>
		</tr>
		<tr>
			<th>작성일시</th>
			<td>${FAQOne.createDate}</td>
		</tr>
		<tr>
			<th>수정자</th>
			<td>${FAQOne.updateUser}</td>
		</tr>
		<tr>
			<th>수정일시</th>
			<td>${FAQOne.updateDate}</td>
		</tr>
		<tr>
			<th>사용 여부</th>
			<td>${FAQOne.useStatus}</td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>${FAQOne.viewCount}</td>
		</tr>
	</table>
	
	<a href="/admin/FAQList">목록</a> /
	<a href="/admin/FAQUpdate?boardNo=${FAQOne.boardNo}">수정</a> /
	<form action="/admin/FAQDelete" method="post" style="display: inline;">
		<input type="hidden" name="boardNo" value="${FAQOne.boardNo}">
		<button type="submit" class="delete-btn" onclick="return confirm('정말 댓글을 삭제하시겠습니까?');">삭제</button>
	</form>
	
	<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>