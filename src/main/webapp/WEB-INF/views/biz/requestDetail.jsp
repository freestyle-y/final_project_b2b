<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>요청 상세</title>
    <style>
        .detail-container {
            max-width: 800px;
            margin: 30px auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }
        .detail-table th, .detail-table td {
            border-bottom: 1px solid #ddd;
            padding: 10px;
        }
        .detail-table th {
            background-color: #f0f0f0;
        }
        .button-area {
            text-align: right;
            margin-top: 20px;
        }
        .btn {
            padding: 8px 16px;
            margin-left: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-edit { background: #4CAF50; color: white; }
        .btn-delete { background: #f44336; color: white; }
    </style>
</head>
<jsp:include page="/WEB-INF/common/header/bizHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/bizSidebar.jsp" />

<div class="detail-container">
    <h2>요청 상세 정보</h2>

    <table class="detail-table">
        <tr>
            <th>상품명</th>
            <th>옵션</th>
            <th>수량</th>
            <th>주소</th>
        </tr>
        <c:forEach var="item" items="${productRequestOne}">
            <tr>
                <td>${item.productName}</td>
                <td>${item.productOption}</td>
                <td>${item.productQuantity}</td>
                <td>
                    ${item.address} ${item.detail_address} (${item.postal})
                </td>
            </tr>
        </c:forEach>
    </table>

    <c:set var="status" value="${productRequestOne[0].status}" />
    
    <div class="button-area">
        <c:if test="${status eq '확인전'}">
            <button class="btn btn-edit" onclick="location.href='/biz/editRequest?requestNo=${param.requestNo}'">수정</button>
            <button class="btn btn-delete" onclick="confirmDelete(${param.requestNo})">삭제</button>
        </c:if>
    </div>
</div>

<script>
    function confirmDelete(requestNo) {
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = '/biz/deleteRequest?requestNo=' + requestNo;
        }
    }
</script>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
