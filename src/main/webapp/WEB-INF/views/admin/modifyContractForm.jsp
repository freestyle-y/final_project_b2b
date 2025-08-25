<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>계약서 수정</title>
</head>
<body>
<%@ include file="/WEB-INF/common/header/header.jsp" %>
<%@ include file="/WEB-INF/common/sidebar/sidebar.jsp" %>

<h1>계약서 수정</h1>

<form action="${pageContext.request.contextPath}/admin/modifyContract" method="post">
  <input type="hidden" name="contractNo" value="${contract.contractNo}" />
  <input type="hidden" name="quotationNo" value="${quotationNo}" />

  <table border="1" style="border-collapse: collapse; text-align: left;">
    <tr>
      <th>계약금</th>
      <td><input type="text" name="downPayment" value="${contract.downPayment}" /></td>
    </tr>
    <tr>
      <th>잔금</th>
      <td><input type="text" name="finalPayment" value="${contract.finalPayment}" /></td>
    </tr>
  </table>

  <br>
  <button type="submit">수정 완료</button>
  <a href="${pageContext.request.contextPath}/admin/contractList">목록으로</a>
</form>

<%@ include file="/WEB-INF/common/footer/footer.jsp" %>
</body>
</html>
