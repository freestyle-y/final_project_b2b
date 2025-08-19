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
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
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
    <c:forEach var="q" items="${quotations}">
      <tr>
        <td>
          <a href="/biz/quotationOne?quotationNo=${q.quotationNo}&subProductRequestNo=${q.subProductRequestNo}">${q.quotationNo}-${q.subProductRequestNo}</a>
        </td>
        <td>₩<fmt:formatNumber value="${q.price}" type="number" groupingUsed="true"/></td>
        <td>${q.status}</td>
        <td>${q.createUser}</td>
        <td>${fn:replace(q.createDate, 'T', ' ')}</td>
      </tr>
    </c:forEach>
  </tbody>
</table>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
