<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>컨테이너 수정</title>
</head>
<body>
<%@include file="/WEB-INF/common/header/header.jsp"%>

<h1>컨테이너 수정</h1>
<form action="${pageContext.request.contextPath}/admin/modifyContainer" method="post">
	<input type="hidden" name="containerNo" value="${container.containerNo}" />
	<table border="1">
		<tr>
			<th>위치</th>
			<td><input type="text" name="containerLocation" value="${container.containerLocation}" /></td>
		</tr>
		<tr>
			<th>계약서 주문번호</th>
			<td><input type="number" name="contractOrderNo" value="${container.contractOrderNo}" /></td>
		</tr>
	</table>
	<button type="submit">수정 완료</button>
</form>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>
</body>
</html>
