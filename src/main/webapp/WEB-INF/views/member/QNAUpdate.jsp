<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 수정</title>
<style>
    body {
        font-family: Arial, sans-serif;
        text-align: left;
    }
    form {
        width: 400px;
        margin: 30px auto;
        text-align: left;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 6px;
        background-color: #f9f9f9;
    }
    label {
        font-weight: bold;
    }
    input[type="text"], textarea {
        width: 100%;
        padding: 6px;
        margin: 8px 0 15px 0;
        box-sizing: border-box;
    }
    button {
        width: 100%;
        padding: 10px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    button:hover {
        background-color: #45a049;
    }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
	
    <h1>1:1 문의 수정</h1>
    
   	<a href="/public/FAQList">자주 묻는 질문</a> /
	<a href="/member/QNAList">문의 내역</a> /
	<a href="/member/QNAWrite">1:1 문의</a> /
	<a href="/public/noticeList">공지사항</a>

	<!-- 문의 수정 폼 -->
	<c:forEach var="qna" items="${QNAOne}">
		<form action="/member/QNAUpdate" method="post">
			<input type="hidden" name="boardNo" value="${qna.boardNo}">
			<label for="boardTitle">제목</label>
			<input type="text" id="boardTitle" name="boardTitle" value="${qna.boardTitle}" required>

			<label for="boardContent">내용</label>
			<textarea id="boardContent" name="boardContent" rows="6" required>${qna.boardContent}</textarea>

			<button type="submit">수정</button>
		</form>
	</c:forEach>

	<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
   
</body>
</html>