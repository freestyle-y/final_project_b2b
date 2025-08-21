<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 목록</title>
</head>
<jsp:include page="/WEB-INF/common/header/personalHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<h1>주문 목록</h1>

<table border="1" style="border-collapse:collapse; text-align:center; width:100%;">
    <thead>
        <tr>
            <th>주문번호</th>
            <th>회원ID</th>
            <th>상품명</th>
        </tr>
    </thead>
    <tbody>
		<c:forEach var="entry" items="${orderGroupMap}">
		    <c:set var="orderNo" value="${entry.key}" />
		    <c:set var="orderList" value="${entry.value}" />
		    <c:set var="first" value="${orderList[0]}" />
		
		    <tr>
		        <td><a href="orderOne?orderNo=${orderNo}">${orderNo}</a></td>
		        <td>${first.userId}</td>
		        <td>
		            ${first.productName}
		            <c:if test="${fn:length(orderList) > 1}">
		                외 ${fn:length(orderList) - 1}건
		            </c:if>
		        </td>
		    </tr>
		</c:forEach>
    </tbody>
</table>

</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>
