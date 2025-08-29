<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>기업 회원 배송 현황</title>
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
	
	<h1>기업 회원 배송 현황</h1>
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
			<th>배송 처리</th>
		</tr>
		
		<c:forEach var="bizDeliveryList" items="${bizDeliveryList}">
			<tr>
				<td><a href="/admin/contractOne?contractNo=${bizDeliveryList.contractNo}">${bizDeliveryList.contractNo}</a></td>
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
						<%-- 배송 처리 : null일 때만 가능 --%>
						<c:when test="${bizDeliveryList.contractDeliveryStatus eq null}">
							<form action="/admin/bizDeliveryUpdate" method="get">
								<input type="hidden" name="containerNo" value="${bizDeliveryList.containerNo}">
								<button type="submit">배송</button>
							</form>
						</c:when>
						<%-- 배송 완료 처리 : 배송중일 때만 가능 --%>
						<c:when test="${bizDeliveryList.contractDeliveryStatus eq '배송중'}">
							<form action="/admin/bizDeliveryComplete" method="post" onsubmit="return confirm('배송 완료 처리하시겠습니까?');">
								<input type="hidden" name="contractDeliveryNo" value="${bizDeliveryList.contractDeliveryNo}">
								<button type="submit">완료</button>
							</form>
						</c:when>
						<c:otherwise>
							<button type="button" disabled>배송</button>
							<button type="button" disabled>완료</button>
						</c:otherwise>
					</c:choose>
				</td>
			</tr>
		</c:forEach>
	</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>