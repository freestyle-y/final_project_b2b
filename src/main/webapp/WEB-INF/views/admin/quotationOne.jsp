<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>quotationOne</h1>
	<form action="${pageContext.request.contextPath}/admin/writeQuotation" method="get">
    <!-- ✅ 수정: Spring Security 사용 시 CSRF 토큰 전송 -->
    <c:if test="${not empty _csrf}">
    	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
	<table border="1">
	    <tr>
	        <th>견적서 번호</th>
	        <th>재견적서 번호</th>
	        <th>가격</th>
	        <th>승인상태</th>
	        <th>작성자</th>
	        <th>작성일자</th>
	        <th>상품명</th>
	        <th>수량</th>
	    </tr>
    <!-- quotationOne 리스트의 크기(상품 개수)를 rowCount 변수에 저장 -->
    <!-- 예: quotationOne 리스트에 4개의 상품이 있으면 rowCount = 4 -->
    <c:set var="rowCount" value="${fn:length(adminQuotationOne)}" />
    <!-- quotationOne 리스트를 순회 시작 -->
    <!-- var="q" : 현재 반복에서 꺼낸 Quotation 객체 (상품 1개 정보) -->
    <!-- varStatus="status" : 반복 상태 정보를 담음 (예: status.first → 첫 번째인지 여부) -->
    <c:forEach var="q" items="${adminQuotationOne}" varStatus="status">
        <tr>
            <!-- 첫 번째 상품일 때만 공통 정보 출력 -->
            <!-- status.first = true 일 때만 실행됨 -->
            <!-- rowspan="${rowCount}" → 공통 정보 셀을 rowCount 만큼 세로로 병합 -->
            <c:if test="${status.first}">
                <input type="hidden" name="quotationNo" value="${q.quotationNo}"/>
            	<input type="hidden" name="subProductRequestNo" value="${q.subProductRequestNo}"/>
                <input type="hidden" name="productRequestNo" value="${q.productRequestNo}"/>
                <!-- 견적서 번호 : 모든 상품에 동일한 값 → 1번만 찍고 세로 병합 -->
                <td rowspan="${rowCount}">${q.quotationNo}</td>
                <td rowspan="${rowCount}">${q.subProductRequestNo}</td>
                <td rowspan="${rowCount}">${q.price}</td>
                <td rowspan="${rowCount}">${q.status}</td>
                <td rowspan="${rowCount}">${q.createUser}</td>
                <td rowspan="${rowCount}">${q.createDate}</td>
            </c:if>
            <!-- 상품별 정보 (모든 행에서 출력됨) -->
            <!-- 상품명 : 각 상품마다 다르므로 무조건 출력 -->
            <td>${q.productName}</td>
            <!-- 수량 : 각 상품마다 다르므로 무조건 출력 -->
            <td>${q.productQuantity}</td>
        </tr>
    </c:forEach>
	</table>
	<button type="submit">견적내기</button>
	</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>