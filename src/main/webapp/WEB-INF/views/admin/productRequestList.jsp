<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 견적서 목록</title>
</head>
<body>
	<h1>상품 요청 목록 페이지</h1>
	${userId}님 반갑습니다.
	<table border="1">
	<c:forEach var="l" items="${list}">
		<tr>
			<th>번호</th>
			<td>
				<a href="/admin/writeQuotation?productRequestNo=${l.productRequestNo}">${l.productRequestNo}</a>
			</td>
			<th>상품명</th>
			<td>${l.productName}</td>
			<th>옵션</th>
			<td>${l.productOption}</td>
			<th>수량</th>
			<td>${l.productQuantity}</td>
			<th>작성자</th>
			<td>${l.createUser}</td>
		</tr>
	</c:forEach>
	</table>
</body>
</html>