<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
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

<!-- 헤더 : 권한별 분기 -->
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <jsp:include page="/WEB-INF/common/header/adminHeader.jsp"/>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_BIZ')">
    <jsp:include page="/WEB-INF/common/header/bizHeader.jsp"/>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_PERSONAL')">
    <jsp:include page="/WEB-INF/common/header/personalHeader.jsp"/>
</sec:authorize>
<sec:authorize access="isAnonymous()">
    <jsp:include page="/WEB-INF/common/header/publicHeader.jsp"/>
</sec:authorize>

<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	
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
</body>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>