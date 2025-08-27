<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">
	
	<h1>공지사항 상세</h1>
	
	<a href="/public/FAQList">자주 묻는 질문</a> /
	<a href="/member/QNAList">문의 내역</a> /
	<a href="/member/QNAWrite">1:1 문의</a> /
	<a href="/public/noticeList">공지사항</a>
	
	<table>
		<c:forEach var="notice" items="${noticeOne}">
		<tr>
			<th>제목</th>
			<td>${notice.boardTitle}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${notice.boardContent}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${notice.createUser}</td>
		</tr>
		<tr>
			<th>작성일시</th>
			<td>${notice.createDate}</td>
		</tr>
		<tr>
			<th>조회수</th>
			<td>${notice.viewCount}</td>
		</tr>
		</c:forEach>
	</table>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>