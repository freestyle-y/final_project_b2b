<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
	
	<h1>공지사항 상세</h1>
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
	
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>