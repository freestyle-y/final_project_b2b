<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 견적서 목록</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>상품 요청 목록 페이지</h1>
	${userId}님 반갑습니다.
	<table border="1">
	    <thead>
	        <tr>
	            <th>요청번호</th>
	            <th>상품명</th>
	            <th>옵션</th>
	            <th>수량</th>
	            <th>작성자</th>
	        </tr>
	    </thead>
	    <tbody>
	        <c:forEach var="entry" items="${groupedList}">
	            <c:set var="productList" value="${entry.value}" />
	            <c:set var="firstProduct" value="${productList[0]}" />
	            <c:forEach var="p" items="${productList}" varStatus="status">
	                <tr>
	                    <c:if test="${status.first}">
	                        <!-- 링크는 병합 셀로 출력 -->
	                        <td rowspan="${fn:length(productList)}">
	                            <a href="/admin/writeQuotation?productRequestNo=${firstProduct.productRequestNo}">
	                                ${firstProduct.productRequestNo}
	                            </a>
	                        </td>
	                    </c:if>
	                    <td>${p.productName}</td>
	                    <td>${p.productOption}</td>
	                    <td>${p.productQuantity}</td>
	                    <td>${p.createUser}</td>
	                </tr>
	            </c:forEach>
	        </c:forEach>
	    </tbody>
	</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>