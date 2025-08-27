<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>기업회원 계약서 목록</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<h1>contractList</h1>

<!-- ✅ form 추가 -->
<form action="${pageContext.request.contextPath}/biz/writeContract" method="get" id="contractForm">
<table border="1" style="border-collapse: collapse; text-align: center;">
	<tr>
		<th>선택</th>
		<th>계약번호</th>
		<th>계약금</th>
		<th>계약금 입금 상태</th>
		<th>계약금 입금 날짜</th>
		<th>잔금</th>
		<th>잔금 입금 상태</th>
		<th>잔금 납입일</th>
		<th>작성자</th>
		<th>작성일자</th>
	</tr>
	<c:forEach var="con" items="${contractList}">
		<tr>
			<td>
				<input type="radio" name="contractNo" value="${con.contractNo}" required />
			</td>
			<td>
				<a href="/biz/contractOne?contractNo=${con.contractNo}">${con.contractNo}</a>
			</td>
			<td><fmt:formatNumber value="${con.downPayment}" type="number" groupingUsed="true"/></td>
			<td>
				<c:choose>
					<c:when test="${con.downPaymentStatus eq 'PS001'}">입금전</c:when>
					<c:when test="${con.downPaymentStatus eq 'PS002'}">입금완료</c:when>
					<c:otherwise>-</c:otherwise>
				</c:choose>
			</td>
			<td>${con.downPaymentDate}</td>
			<td><fmt:formatNumber value="${con.finalPayment}" type="number" groupingUsed="true"/></td>
			<td>
				<c:choose>
					<c:when test="${con.finalPaymentStatus eq 'PS001'}">입금전</c:when>
					<c:when test="${con.finalPaymentStatus eq 'PS002'}">입금완료</c:when>
					<c:otherwise>-</c:otherwise>
				</c:choose>
			</td>
			<td>${con.finalPaymentDate}</td>
			<td>${con.createUser}</td>
			<td>${con.createDate}</td>
		</tr>
	</c:forEach>
</table>

<!-- ✅ 작성하기 버튼 -->
<div style="margin-top: 20px; text-align: center;">
	<button type="submit">작성하기</button>
</div>
</form>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
