<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>견적 작성</title>

<!-- 폰트/부트스트랩 -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">
<style>
   a {
      text-decoration: none;
      color: inherit;
   }
  body {
    font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo",
                 "Noto Sans KR","Malgun Gothic",Arial,sans-serif;
    background:#f9fafb;
  }

  .quotation-container {
    max-width: 1200px;
    margin: 30px auto;
    background:#fff;
    border-radius: 12px;
    padding: 30px;
    box-shadow:0 4px 20px rgba(0,0,0,0.08);
  }

  h2 {
    font-size:1.4rem;
    font-weight:700;
    margin-bottom:20px;
    color:#111827;
    text-align:center;
  }

  table {
    width:100%;
    border-collapse:collapse;
    margin-bottom:20px;
  }

  table thead th {
    background:#f3f4f6;
    padding:12px;
    border:1px solid #e5e7eb;
    text-align:center;
    font-weight:600;
    color:#374151;
  }

  table tbody td {
    border:1px solid #e5e7eb;
    padding:10px;
    text-align:center;
    vertical-align:middle;
  }

  table tbody tr:nth-child(even){ background:#fafafa; }

  input[type="number"] {
    width:120px;
    padding:6px 8px;
    border:1px solid #d1d5db;
    border-radius:6px;
    font-size:0.9rem;
  }


</style>
</head>
<body>
<%@include file="/WEB-INF/common/header/header.jsp"%>
<div class="quotation-container">
  <h2>견적 작성하기</h2>

  <form action="${pageContext.request.contextPath}/admin/submitQuotation" method="post">
    <table>
      <thead>
        <tr>
          <th>상품명</th>
          <th>수량</th>
          <th>옵션</th>
          <th>가격 입력</th>
        </tr>
      </thead>
      <tbody>
        <!-- 신규 작성 -->
        <c:if test="${not empty quotationItems}">
          <c:forEach var="item" items="${quotationItems}">
            <tr>
              <td>${item.productName}</td>
              <td>${item.productQuantity}</td>
              <td>${item.productOption}</td>
              <td>
                <input type="number" name="prices" required placeholder="₩ 가격">
                <input type="hidden" name="productRequestNos" value="${item.productRequestNo}">
                <input type="hidden" name="subProductRequestNos" value="${item.subProductRequestNo}">
              </td>
            </tr>
          </c:forEach>
        </c:if>

        <!-- 기존 견적 수정 -->
        <c:if test="${not empty quotation}">
          <c:forEach var="item" items="${quotation.items}">
            <tr>
              <td>${item.productName}</td>
              <td>${item.productQuantity}</td>
              <td>${item.productOption}</td>
              <td>
                <input type="number" name="prices" value="${item.price}" required>
                <input type="hidden" name="productRequestNos" value="${item.productRequestNo}">
                <input type="hidden" name="subProductRequestNos" value="${item.subProductRequestNo}">
              </td>
            </tr>
          </c:forEach>
        </c:if>
      </tbody>
    </table>

	<section class="register py-1">
		<div class="text-center">
			<button type="submit" class="btn btn-register">제출</button>
		</div>
	</section>
  </form>
</div>
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
</body>
</html>