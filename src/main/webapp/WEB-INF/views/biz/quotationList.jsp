<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>견적서 목록</title>
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

<h1>견적서 목록</h1>
<table>
  <thead>
    <tr>
      <th>quotation_no</th>
      <th>price</th>
      <th>status</th>
      <th>createUser</th>
      <th>createDate</th>
    </tr>
  </thead>
  <tbody>
    <c:if test="${not empty quotationGroupedMap}">
      <c:forEach var="entry" items="${quotationGroupedMap}">
        <c:set var="list" value="${entry.value}" />
        <c:set var="first" value="${list[0]}" />
        <tr>
          <td>
            <a href="/biz/quotationOne?quotationNo=${first.quotationNo}&subProductRequestNo=${first.subProductRequestNo}">${first.quotationNo}-${first.subProductRequestNo}</a>
          </td>
          <td>₩<fmt:formatNumber value="${first.price}" type="number" groupingUsed="true"/></td>
          <td>${first.status}</td>
          <td>${first.createUser}</td>
          <td>${fn:replace(first.createDate, 'T', ' ')}</td>
        </tr>
      </c:forEach>
    </c:if>
  </tbody>
</table>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
