<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<form action="/admin/modifyQuotation" method="post">
	<input type="hidden" name="quotationNo" value="${quotation.quotationNo}">
	<!-- 예: 가격 수정 -->
	<c:forEach var="item" items="${quotation.items}">
		<p>
			${item.productName} / ${item.productOption}
			<input type="number" name="price" value="${item.price}">
			<input type="hidden" name="itemId" value="${item.itemId}">
			<input type="hidden" name="productRequestNo" value="${item.productRequestNo}">
			<input type="hidden" name="subProductRequestNo" value="${item.subProductRequestNo}">
		</p>
	</c:forEach>
	<button type="submit">수정 완료</button>
</form>
</body>
</html>