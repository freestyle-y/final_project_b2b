<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>결제수단 상세</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="/WEB-INF/common/header/header.jsp" %>

<main class="main container mt-4">
  <h2>결제수단 상세 / 수정</h2>
  <form method="post" action="<c:url value='/personal/cardUpdate'/>" class="mt-3">

    <input type="hidden" name="paymentMethodNo" value="${paymentMethod.paymentMethodNo}"/>

    <div class="mb-3">
      <label class="form-label">금융기관</label>
      <input type="text" class="form-control" name="financialInstitution" 
             value="${paymentMethod.financialInstitution}" required>
    </div>

    <div class="mb-3">
      <label class="form-label">결제 코드</label>
      <input type="text" class="form-control" name="paymentCode" 
             value="${paymentMethod.paymentCode}" readonly>
    </div>

    <div class="mb-3">
      <label class="form-label">계좌/카드번호</label>
      <input type="text" class="form-control" name="accountNumber" 
             value="${paymentMethod.accountNumber}" required>
    </div>

    <div class="mb-3">
      <label class="form-label">카드 비밀번호(앞 2자리)</label>
      <input type="password" class="form-control" name="cardPassword" 
             value="${paymentMethod.cardPassword}">
    </div>

    <div class="mb-3">
      <label class="form-label">CVC</label>
      <input type="text" class="form-control" name="cardCvc" 
             value="${paymentMethod.cardCvc}">
    </div>

    <div class="mb-3">
      <label class="form-label">유효기간(YYYY-MM)</label>
      <input type="month" class="form-control" name="cardExpiration" 
             value="${paymentMethod.cardExpiration}">
    </div>

    <div class="mb-3">
      <label class="form-label">사용 여부</label>
      <select name="useStatus" class="form-select">
        <option value="Y" ${paymentMethod.useStatus eq 'Y' ? 'selected' : ''}>Y</option>
        <option value="N" ${paymentMethod.useStatus eq 'N' ? 'selected' : ''}>N</option>
      </select>
    </div>

    <div class="d-flex justify-content-between">
      <a href="<c:url value='/personal/paymentCard'/>" class="btn btn-secondary">목록</a>
      <button type="submit" class="btn btn-primary">저장</button>
    </div>
  </form>
</main>

<%@ include file="/WEB-INF/common/footer/footer.jsp"%>
<script src="<c:url value='/assets/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>
</body>
</html>