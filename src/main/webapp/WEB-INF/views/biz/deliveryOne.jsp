<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>배송 상세 조회</title>
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

<main class="main">
	
	<h1>배송 상세 조회</h1>
	<table border="1" style="border-collapse:collapse; text-align:center; width:100%;">
		<tr>
			<th>택배사</th>
			<th>운송장 번호</th>
			<th>처리 일시</th>
			<th>배송 상태</th>
		</tr>
		<c:forEach var="deliveryOne" items="${deliveryOne}">
			<tr>
				<td>${deliveryOne.deliveryCompany}</td>
				<td>${deliveryOne.trackingNo}</td>
				<td>${deliveryOne.updateDate}</td>
				<td>${deliveryOne.deliveryStatus}</td>
			</tr>
		</c:forEach>
	</table>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>