<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
<c:forEach var="entry" items="${quotationGroupedMap}">
    <c:set var="keyParts" value="${fn:split(entry.key, '_')}" />
    <c:set var="quotationList" value="${entry.value}" />
    <c:set var="first" value="true" />

    <c:forEach var="q" items="${quotationList}">
        <tr>
            <td><c:if test="${first}">${keyParts[0]}</c:if></td>
            <td><c:if test="${first}">${keyParts[1]}</c:if></td>
            <td><c:if test="${first}">${keyParts[2]}</c:if></td>
            <td><c:if test="${first}">${q.status}</c:if></td>
            <td><c:if test="${first}">${q.createUser}</c:if></td>
            <td><c:if test="${first}">${q.createDate}</c:if></td>
            <td>${q.productName}</td>
            <td>${q.productQuantity}</td>
        </tr>
        <c:set var="first" value="false" />
    </c:forEach>
</c:forEach>
    </tbody>
</table>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
