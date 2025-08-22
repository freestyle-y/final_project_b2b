<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
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
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
	
	<h1>배송 상세 조회</h1>
	<table border="1" style="border-collapse:collapse; text-align:center; width:100%;">
		<tr>
			<th>상품</th>
			<th>옵션</th>
			<th>수량</th>
			<th>가격</th>
			<th>주문 상태</th>
			<th>주문 시간</th>
			<th>배송 상태</th>
		</tr>
		
		<c:forEach var="personalDeliveryOne" items="${personalDeliveryOne}">
			<tr>
				<td>${personalDeliveryOne.productName}</td>
				<td>${personalDeliveryOne.option}</td>
				<td>${personalDeliveryOne.orderQuantity}</td>
				<td>${personalDeliveryOne.price}</td>
				<td>${personalDeliveryOne.orderStatus}</td>
				<td>${personalDeliveryOne.orderTime}</td>
				<td>${personalDeliveryOne.deliveryStatus}</td>
			</tr>
		</c:forEach>
	</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>