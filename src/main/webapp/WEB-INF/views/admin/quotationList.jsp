<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>견적서 목록</title>
<style>
table {
	width: 100%;
	border-collapse: collapse;
	text-align: center;
}
th, td {
	border: 1px solid #ccc;
	padding: 8px;
}
a {
	color: #4c59ff;
	text-decoration: none;
}
button {
	margin: 20px auto;
	display: block;
	padding: 8px 20px;
	font-size: 14px;
	cursor: pointer;
}
</style>
</head>
<body>
<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<h1>견적서</h1>
<table>
	<thead>
		<tr>
			<th>상품요청번호</th>
			<th>견적번호</th>
			<th>price</th>
			<th>요청한 회원</th>
			<th>status</th>
			<th>createUser</th>
			<th>createDate</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="q" items="${quotationList}">
			<tr>
				<td>
					<a href="/admin/quotationOne?quotationNo=${q.quotationNo}">
						${q.productRequestNo}
					</a>
				</td>
				<td>${q.quotationNo }</td>
				<td>
					<c:forEach var="item" items="${q.items}">
						${item.productName} (${item.productQuantity}) - 
						₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/><br/>
					</c:forEach>
				</td>
				<td>${q.requestCompanyName} (${q.requestCompanyUser})</td>
				<td>${q.status}</td>
				<td>${q.createUser}</td>
				<td>${fn:replace(q.createDate, 'T', ' ')}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>
<c:choose>
	<c:when test="${empty quotationList}">
		<button type="button" onclick="openWriteQuotationPopup()">견적서 작성</button>
	</c:when>
	<c:when test="${not empty param.productRequestNo}">
		<c:set var="hasReject" value="false" />
		<c:forEach var="q" items="${quotationList}">
			<c:if test="${q.status eq '승인거절'}">
				<c:set var="hasReject" value="true" />
			</c:if>
		</c:forEach>
		<c:if test="${hasReject}">
			<button type="button" onclick="openWriteQuotationPopup()">견적서 작성</button>
		</c:if>
	</c:when>
</c:choose>

<script>
	const productRequestNo = "${param.productRequestNo != null ? param.productRequestNo : 0}";
	const quotationNo = "${param.quotationNo != null ? param.quotationNo : 0}";
	const subProductRequestNo = "${param.subProductRequestNo != null ? param.subProductRequestNo : 0}";

	function openWriteQuotationPopup() {
		const url = "${pageContext.request.contextPath}/admin/writeQuotationForm"
		          + "?productRequestNo=" + productRequestNo
		          + "&quotationNo=" + quotationNo
		          + "&subProductRequestNo=" + subProductRequestNo;
		window.open(url, "writeQuotationPopup", "width=800,height=600,scrollbars=yes");
	}
</script>
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
</body>
</html>