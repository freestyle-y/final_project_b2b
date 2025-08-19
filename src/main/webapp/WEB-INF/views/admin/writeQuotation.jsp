<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	<h1>writeQuotation</h1>
	<table border="1">
		<c:forEach var="qu" items="${quotationOne}">
			<tr>
				<th>계약번호</th>
				<td>${qu.quotationNo}</td>
			</tr>
		</c:forEach>
	</table>
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>