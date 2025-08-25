<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 등록</title>
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
	
    <h1>1:1 문의 등록</h1>
    
   	<a href="/public/FAQList">자주 묻는 질문</a> /
	<a href="/member/QNAList">문의 내역</a> /
	<a href="/member/QNAWrite">1:1 문의</a> /
	<a href="/public/noticeList">공지사항</a>

    <!-- 문의 등록 폼 -->
    <form action="/member/QNAWrite" method="post">
        <label for="boardTitle">제목</label>
        <input type="text" id="boardTitle" name="boardTitle" required>

        <label for="boardContent">내용</label>
        <textarea id="boardContent" name="boardContent" rows="6" required></textarea>

        <!-- hidden 값 : 구분 코드(BC002) -->
        <input type="hidden" name="boardCode" value="BC002">
        <button type="submit">등록하기</button>
    </form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
   
</body>
</html>