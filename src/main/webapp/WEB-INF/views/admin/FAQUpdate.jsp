<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>자주 묻는 질문 수정</title>
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
        margin: 10px auto;
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
	
    <h1>자주 묻는 질문 수정</h1>
    
   	<a href="/admin/FAQList">자주 묻는 질문</a> /
	<a href="/admin/QNAList">문의 내역</a> /
	<a href="/admin/noticeList">공지사항</a>

    <!-- FAQ 수정 폼 -->
    <form action="/admin/FAQUpdate" method="post">
    	<!-- boardNo hidden -->
    	<input type="hidden" name="boardNo" value="${FAQOne.boardNo}">
    	
        <label for="boardTitle">제목</label>
        <input type="text" id="boardTitle" name="boardTitle" value="${FAQOne.boardTitle}" required>

        <label for="boardContent">내용</label>
        <textarea id="boardContent" name="boardContent" rows="6" required>${FAQOne.boardContent}</textarea>

		<label for="useStatus">사용 여부</label>
		<select id="useStatus" name="useStatus" required>
			<option value="Y" ${FAQOne.useStatus == 'Y' ? 'selected' : ''}>사용</option>
			<option value="N" ${FAQOne.useStatus == 'N' ? 'selected' : ''}>미사용</option>
		</select>
		
		<button type="submit">수정</button>
    </form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
   
</body>
</html>