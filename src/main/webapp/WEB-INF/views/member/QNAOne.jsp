<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 내역 상세</title>
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
	
	<h1>문의 내역 상세</h1>
	<table>
		<c:forEach var="qna" items="${QNAOne}">
		<tr>
			<th>제목</th>
			<td>${qna.boardTitle}</td>
		</tr>
		<tr>
			<th>내용</th>
			<td>${qna.boardContent}</td>
		</tr>
		<tr>
			<th>작성자</th>
			<td>${qna.createUser}</td>
		</tr>
		<tr>
			<th>작성일시</th>
			<td>${qna.createDate}</td>
		</tr>
		</c:forEach>
	</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>