<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>insertContainer</title>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
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
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>