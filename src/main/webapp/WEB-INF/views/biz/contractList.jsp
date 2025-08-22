<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>contractList</h1>
	<table border="1">
		<tr>
			<th>계약서 번호</th>
			<th>계약금</th>
			<th>입금 상태</th>
			<th>잔금</th>
			<th>생성 일자</th>
		</tr>
		<c:forEach var="con" items="${contractList}">
			<tr>
				<td>
					<a href="/biz/contractOne?contractNo=${con.contractNo}">${con.contractNo}</a>
				</td>
				<td>${con.downPayment}</td>
				<td>${con.codeName}</td>
				<td>${con.finalPayment}</td>
				<td>${con.formattedCreateDate}</td>
			</tr>
		</c:forEach>
	</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>