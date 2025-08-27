<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>insertContainer</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

	<h1>컨테이너 상품 입력</h1>
	<form action="/admin/insertContainer" method="post">
	<table>
		<tr>
			<td>컨테이너 위치</td>
			<th>
				<input type="text" id="containerLocation" name="containerLocation">
			</th>
		</tr>
		<tr>
			<td>주문 번호</td>
			<th>
				<input type="text" name="contractNo" value="${contractNo}" readOnly>
			</th>
		</tr>
	</table>
	<button type="submit">입력</button>
	</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>