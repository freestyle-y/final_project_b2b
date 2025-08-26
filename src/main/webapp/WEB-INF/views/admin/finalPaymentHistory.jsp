<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잔금 확인 페이지</title>
</head>
<body>
<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>final Payment History</h1>
	<table border="1">
		<c:forEach var="list" items="${list}">
			<tr>
				<th>계약 번호</th>
				<td>${list.contractNo}</td>		
				<th>계약금</th>
				<td>${list.downPayment}</td>		
				<th>잔금</th>
				<td>${list.finalPayment}</td>
			</tr>
		</c:forEach>
	</table>
	<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
	
</body>
</html>