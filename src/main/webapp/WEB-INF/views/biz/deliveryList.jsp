<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>배송 현황</title>
<style>
    table {
        width: 90%;
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
	
	<h1>배송 현황</h1>
	<table>
		<tr>
			<th>계약 번호</th>
			<th>계약금</th>
			<th>상태</th>
			<th>입금일시</th>
			<th>잔금</th>
			<th>상태</th>
			<th>입금일시</th>
			<th>배송지 주소</th>
			<th>배송 일시</th>
			<th>배송 상태</th>
			<th>배송 조회</th>
		</tr>
		<c:forEach var="bizDeliveryList" items="${bizDeliveryList}">
			<tr>
				<td><a href="/biz/contractOne?contractNo=${bizDeliveryList.contractNo}">${bizDeliveryList.contractNo}</a></td>
				<td>${bizDeliveryList.downPayment}</td>
				<td>${bizDeliveryList.downPaymentStatus}</td>
				<td>${bizDeliveryList.downPaymentDate}</td>
				<td>${bizDeliveryList.finalPayment}</td>
				<td>${bizDeliveryList.finalPaymentStatus}</td>
				<td>${bizDeliveryList.finalPaymentDate}</td>
				<td>${bizDeliveryList.address}</td>
				<td>${bizDeliveryList.contractDeliveryTime}</td>
				<td>${bizDeliveryList.contractDeliveryStatus}</td>
				<td>
					<c:choose>
						<c:when test="${empty bizDeliveryList.contractDeliveryNo}">
							<button disabled>배송조회</button>
						</c:when>
						<c:otherwise>
							<button onclick="location.href='/biz/deliveryOne?contractDeliveryNo=${bizDeliveryList.contractDeliveryNo}'">배송조회</button>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</table>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>