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

<form action="/admin/submitQuotation" method="post">
    <input type="hidden" name="quotationNo" value="${quotationList[0].quotationNo}" />
    <input type="hidden" name="subProductRequestNo" value="${quotationList[0].subProductRequestNo}" />
    
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
            <c:forEach var="q" items="${quotationList}" varStatus="s">
                <tr>
                    <td>${q.productName}</td>
                    <td>${q.productQuantity}</td>
                    <td>${q.productOption}</td>
                    <td>
                        <input type="number" name="prices" required placeholder="₩ 가격">
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    
    <button type="submit">제출</button>
</form>
</body>
</html>
