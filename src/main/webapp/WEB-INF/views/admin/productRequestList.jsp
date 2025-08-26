<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 상품 요청 목록</title>
</head>
<body>
<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h1>상품 요청 목록 페이지</h1>
	<table border="1">
		<thead>
			<tr>
				<th>요청번호</th>
				<th>상품명</th>
				<th>옵션</th>
				<th>수량</th>
				<th>작성자</th>
				<th>견적서 상태</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="productList" items="${groupedList.values()}">
			    <c:set var="firstProduct" value="${productList[0]}" />
			    <c:forEach var="p" items="${productList}" varStatus="status">
			        <tr>
			            <c:if test="${status.first}">
						    <td rowspan="${fn:length(productList)}">
						        <c:choose>
						            <c:when test="${empty firstProduct.quotationStatus}">
						                <a href="${pageContext.request.contextPath}/admin/quotationList?productRequestNo=${firstProduct.productRequestNo}">
						                    ${firstProduct.productRequestNo}
						                </a>
						            </c:when>
						            <c:otherwise>
						                ${firstProduct.productRequestNo}
						            </c:otherwise>
						        </c:choose>
						    </td>
			            </c:if>
			            <td>${p.productName}</td>
			            <td>${p.productOption}</td>
			            <td>${p.productQuantity}</td>
			            <td>${p.createUser}</td>
			            <td>${empty p.quotationStatus ? '미작성' : p.quotationStatus}</td>
			        </tr>
			    </c:forEach>
			</c:forEach>
		</tbody>
	</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
</body>
</html>