<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터 관리</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>고객센터 관리</h1>
	
   	<a href="/admin/FAQList">자주 묻는 질문</a> /
	<a href="/admin/QNAList">문의 내역</a> /
	<a href="/admin/noticeList">공지사항</a>
	
	<h3>고객센터 관리 페이지입니다.</h3>
	
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>