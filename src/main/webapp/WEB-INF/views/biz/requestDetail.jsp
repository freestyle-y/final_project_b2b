<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<%@ include file="/WEB-INF/common/head.jsp"%>
    <title>요청 상세</title>
    <style>
        body {
            font-family: 'SUIT', sans-serif;
            background-color: #f6f8fa;
        }

        .detail-container {
            max-width: 900px;
            margin: 40px auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .detail-container h2 {
            margin-bottom: 25px;
            font-size: 1.5rem;
            font-weight: 700;
            color: #333;
        }

        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }

        .detail-table th, .detail-table td {
            padding: 14px 12px;
            border-bottom: 1px solid #e0e0e0;
            text-align: left;
        }

        .detail-table th {
            background-color: #f5f6f8;
            font-weight: 600;
            color: #333;
        }

        .detail-table tr:hover {
            background-color: #f9f9f9;
        }

        .file-list {
            list-style: none;
            padding-left: 0;
            margin: 8px 0 0 0;
        }

        .file-list li {
            margin-bottom: 5px;
        }

        .file-list a {
            color: #3366cc;
            text-decoration: none;
        }

        .file-list a:hover {
            text-decoration: underline;
        }

        .file-section {
            margin-top: 25px;
            font-size: 0.95rem;
            color: #333;
        }
    </style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<div class="detail-container">
    <h2>요청 상세 정보</h2>

    <table class="detail-table">
        <thead>
            <tr>
                <th>상품명</th>
                <th>옵션</th>
                <th>수량</th>
                <th>주소</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${productRequestOne}">
                <tr>
                    <td>${item.productName}</td>
                    <td>${item.productOption}</td>
                    <td>
                        <fmt:formatNumber value="${item.productQuantity}" type="number" />
                    </td>
                    <td>${item.address} ${item.detail_address} (${item.postal})</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>

    <c:set var="firstItem" value="${productRequestOne[0]}" />
    <div class="file-section">
        <strong>첨부파일:</strong>
        <c:choose>
            <c:when test="${not empty firstItem.attachments}">
                <ul class="file-list">
                    <c:forEach var="file" items="${firstItem.attachments}">
                        <li>
                            <a href="${file.filepath}" download>${file.filename}</a>
                        </li>
                    </c:forEach>
                </ul>
            </c:when>
            <c:otherwise>
                <span>첨부파일 없음</span>
            </c:otherwise>
        </c:choose>
    </div>

    <c:set var="status" value="${productRequestOne[0].status}" />
    <div class="button-area">
        <c:if test="${status eq '확인전'}">
	        <section class="register py-1">
			   <div class="d-flex justify-content-end align-items-center gap-2">
			      <button class="btn btn-primary" onclick="location.href='/biz/editRequest?requestNo=${param.requestNo}'">수정</button>
			      <button class="btn btn-danger" onclick="confirmDelete(${param.requestNo})">삭제</button>
			   </div>
			</section>
        </c:if>
    </div>
</div>

</main>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
    function confirmDelete(requestNo) {
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = '/biz/deleteRequest?requestNo=' + requestNo;
        }
    }
</script>

</body>
</html>