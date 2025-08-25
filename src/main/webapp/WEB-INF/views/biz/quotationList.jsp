<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업회원 견적서 목록</title>
<style>
    table { width: 100%; border-collapse: collapse; text-align: center; }
    th, td { border: 1px solid #ccc; padding: 8px; }
    a { color: #4c59ff; text-decoration: none; }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h1>기업회원 견적서 목록</h1>
<table>
  <thead>
    <tr>
      <th>견적서 번호</th>
      <th>상품정보</th>
      <th>상태</th>
      <th>작성자</th>
      <th>작성일</th>
    </tr>
  </thead>
  <tbody>
    <c:forEach var="q" items="${quotationList}">
      <tr>
        <td>
          <!-- 견적서 번호 클릭 시 상세 페이지 이동 -->
          <a href="${pageContext.request.contextPath}/biz/quotationOne?quotationNo=${q.quotationNo}">
            ${q.quotationNo}
          </a>
        </td>
        <td>
          <!-- 견적서에 속한 상품들 출력 -->
          <c:forEach var="item" items="${q.items}">
            ${item.productName} (${item.productQuantity}) 
            - ₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/><br/>
          </c:forEach>
        </td>
        <td>${q.status}</td>
        <td>${q.createUser}</td>
        <td>${fn:replace(q.createDate, 'T', ' ')}</td>
      </tr>
    </c:forEach>
  </tbody>
</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>