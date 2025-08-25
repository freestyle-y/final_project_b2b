<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자주 묻는 질문 상세</title>
<style>
    table {
        width: 50%;
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
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
	
	<h1>자주 묻는 질문 상세</h1>
	
	<a href="/public/FAQList">자주 묻는 질문</a> /
	<a href="/member/QNAList">문의 내역</a> /
	<a href="/member/QNAWrite">1:1 문의</a> /
	<a href="/public/noticeList">공지사항</a>
	
	<table>
			<c:forEach var="faq" items="${FAQOne}">
			<tr>
				<th>제목</th>
				<td>${faq.boardTitle}</td>
			</tr>
			<tr>
				<th>내용</th>
				<td>${faq.boardContent}</td>
			</tr>
			</c:forEach>
	</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>