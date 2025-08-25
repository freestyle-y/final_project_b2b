<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 견적서 상세</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h1>견적서 상세</h1>
<form method="GET" action="/admin/writeContract">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>

    <!-- 공통 값 hidden 처리 -->
    <input type="hidden" name="quotationNo" value="${adminQuotationOne.quotationNo}"/>
    <input type="hidden" name="productRequestNo" value="${adminQuotationOne.productRequestNo}"/>

    <table border="1">
        <tr>
            <th>견적서 번호</th>
            <th>상태</th>
            <th>작성자</th>
            <th>작성일자</th>
            <th>상품명</th>
            <th>옵션</th>
            <th>수량</th>
            <th>가격</th>
        </tr>

        <c:set var="rowCount" value="${fn:length(adminQuotationOne.items)}"/>
        <c:forEach var="item" items="${adminQuotationOne.items}" varStatus="status">
            <tr>
                <c:if test="${status.first}">
                    <!-- 공통 정보는 첫 행에서만 rowspan -->
                    <td rowspan="${rowCount}">${adminQuotationOne.quotationNo}</td>
                    <td rowspan="${rowCount}">${adminQuotationOne.status}</td>
                    <td rowspan="${rowCount}">${adminQuotationOne.createUser}</td>
                    <td rowspan="${rowCount}">${fn:replace(adminQuotationOne.createDate, 'T', ' ')}</td>
                </c:if>
                <!-- 상품별 정보 -->
                <td>${item.productName}</td>
                <td>${item.productOption}</td>
                <td>${item.productQuantity}</td>
                <td>₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/></td>
            </tr>
        </c:forEach>
    </table>
    <button type="submit">계약서 작성</button>
</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
