<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계약서 목록</title>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

	<h1>관리자 계약서 목록</h1>

	<table border="1" style="border-collapse:collapse; text-align:center;">
		<thead>
			<tr>
				<th>계약번호</th>
				<th>견적번호</th>
				<th>계약금</th>
				<th>입금 상태</th>
				<th>잔금</th>
				<th>잔금 납입일</th>
				<th>작성자</th>
				<th>작성일자</th>
				<th>계약서 작성하기</th>
				<th>컨테이너 상품 입력</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="con" items="${contractList}">
				<tr>
					<td>
						<a href="${pageContext.request.contextPath}/admin/contractOne?contractNo=${con.contractNo}">
							${con.contractNo}
						</a>
					</td>
					<td>${con.quotationNo}</td>
					<td>${con.downPayment} 원</td>
					<td>
						<c:choose>
							<c:when test="${con.downPaymentStatus == 'PS001'}">입금전</c:when>
							<c:when test="${con.downPaymentStatus == 'PS002'}">입금완료</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose>
					</td>
					<td>${con.finalPayment} 원</td>
					<td>${con.finalPaymentDate}</td>
					<td>${con.createUser}</td>
					<td>${con.createDate}</td>
					<form method="get" action="/admin/writeContract">
						<input type="hidden" name="contractNo" value="${con.contractNo}" />
						<td><button type="submit">작성하기</button></td>
					</form>
					<form method="get" action="/admin/insertContainer">
						<input type="hidden" name="contractNo" value="${con.contractNo}" />
						<td><button type="submit">컨테이너 입력</button></td>
					</form>
				</tr>
			</c:forEach>
		</tbody>
	</table>

</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>
