<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	<h1>contractList</h1>
	<table border="1">
		<tr>
			<th>계약서 번호</th>
			<th>계약금</th>
			<th>입금 상태</th>
			<th>잔금</th>
			<th>생성 일자</th>
		</tr>
		<c:forEach var="con" items="${contractList}">
			<tr>
				<td>
					<a href="/biz/contractOne?contractNo=${con.contractNo}">${con.contractNo}</a>
				</td>
				<td>${con.downPayment}</td>
				<td>${con.codeName}</td>
				<td>${con.finalPayment}</td>
				<td>${con.formattedCreateDate}</td>
			</tr>
		</c:forEach>
	</table>
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>