<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잔금 확인 페이지</title>
</head>
<body>
	<h1>final Payment History</h1>
	<table border="1">
		<c:forEach var="list" items="${list}">
		<tr>
			<td>계약 번호</td>
			<th>${list.contractNo}</th>		
			<td>계약금</td>
			<th>${list.downPayment}</th>		
			<td>잔금</td>
			<th>${list.finalPayment}</th>		
		</tr>
		</c:forEach>
	</table>
</body>
</html>