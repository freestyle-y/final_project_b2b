<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertContainer</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

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
				<input type="text" value="${contractNo}" readOnly>
			</th>
		</tr>
	</table>
	</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>