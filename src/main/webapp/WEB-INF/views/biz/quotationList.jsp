<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>견적서 목록</title>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
        text-align: center;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
    }
</style>
</head>
<body>

<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<h1>견적서 목록</h1>

<table>
    <thead>
        <tr>
            <th>quotationNo</th>
            <th>subProductRequestNo</th>
            <th>price</th>
            <th>status</th>
            <th>createUser</th>
            <th>createDate</th>
            <th>productName</th>
            <th>productQuantity</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="q" items="${quotationList}">
            <tr>
                <td>${q.quotationNo}</td>
                <td>${q.subProductRequestNo}</td>
                <td>${q.price}</td>
                <td>${q.status}</td>
                <td>${q.createUser}</td>
                <td>${q.createDate}</td>
                <td>${q.productName}</td>
                <td>${q.productQuantity}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
