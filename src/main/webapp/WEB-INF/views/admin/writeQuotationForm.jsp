<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>견적 작성 팝업</title>
</head>
<body>
<h2>견적 작성하기</h2>
<form action="${pageContext.request.contextPath}/admin/submitQuotation" method="post">
    <table border="1">
        <thead>
            <tr>
                <th>상품명</th>
                <th>수량</th>
                <th>옵션</th>
                <th>가격 입력</th>
            </tr>
        </thead>
        <tbody>
            <!-- 신규 작성 (product_request에서 불러온 상품 목록) -->
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

            <!-- 기존 견적 수정 (quotation + items) -->
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
    
    <button type="submit">제출</button>
</form>
</body>
</html>