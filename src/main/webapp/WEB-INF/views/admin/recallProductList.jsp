<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>회수 상품 목록</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<h1>회수 상품 목록</h1>
<table border="1">
	<thead>
	<tr>
		<th>컨테이너 번호</th>
		<th>컨테이너 위치</th>
		<th>구매자 이름</th>
		<th>회사명</th>
		<th>배송지</th>
		<th>상품명</th>
		<th>옵션</th>
		<th>수량</th>
	</tr>
	</thead>
	<tbody>
	<c:forEach var="g" items="${groups}">
	  <c:forEach var="it" items="${g.items}" varStatus="st">
	    <tr>
	      <c:if test="${st.first}">
	        <td rowspan="${g.rowspan}">${g.containerNo}</td>
	        <td rowspan="${g.rowspan}">${g.containerLocation}</td>
	        <td rowspan="${g.rowspan}">${g.name}</td>
	        <td rowspan="${g.rowspan}">${g.companyName}</td>
	        <td rowspan="${g.rowspan}">${g.address} ${g.detailAddress}</td>
	      </c:if>
	      <td>${it.productName}</td>
	      <td>${it.productOption}</td>
	      <td>${it.productQuantity}</td>
	    </tr>
	  </c:forEach>
	</c:forEach>
	</tbody>

</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>