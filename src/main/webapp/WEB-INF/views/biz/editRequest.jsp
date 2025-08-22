<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 요청 수정</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .product-group {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
            width: 700px;
            max-width: 90%;
            background: #f9f9f9;
        }
    </style>
</head>

<jsp:include page="/WEB-INF/common/header/bizHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/bizSidebar.jsp" />

<h1>수정</h1>

<form method="post" action="/biz/editRequest">
    <div id="product-container">
        <c:forEach var="item" items="${productRequestOne}" varStatus="status">
            <div class="product-group">
                <div>상품명: 
                    <input type="text" name="productRequestList[${status.index}].productName" value="${item.productName}" required>
                </div>
                <div>옵션: 
                    <input type="text" name="productRequestList[${status.index}].productOption" value="${item.productOption}" required>
                </div>
                <div>수량: 
                    <input type="number" name="productRequestList[${status.index}].productQuantity" value="${item.productQuantity}" min="1" required>
                </div>
                
                <!-- 숨겨야 하는 필드 -->
                <input type="hidden" name="productRequestList[${status.index}].subProductRequestNo" value="${item.subProductRequestNo}" />
                <input type="hidden" name="productRequestList[${status.index}].productRequestNo" value="${item.productRequestNo}" />
                <input type="hidden" name="productRequestList[${status.index}].updateUser" value="${item.createUser}" />
            </div>
        </c:forEach>
    </div>

    <br/>

    <div>
        <label for="requests">요청사항:</label><br/>
        <textarea id="requests" name="requests" rows="3" cols="40">${productRequestOne[0].requests}</textarea>
    </div>

    <br/>

    <div>
        <label><strong>배송지 선택:</strong></label><br/>
        <c:set var="selectedAddressNo" value="${productRequestOne[0].addressNo}" />
        <c:forEach var="addr" items="${bizAddressList}">
            <label>
                <input type="radio" name="addressNo"
                       value="${addr.addressNo}"
                       <c:if test="${addr.addressNo == selectedAddressNo}">checked</c:if> />
                [${addr.postal}] ${addr.address} ${addr.detailAddress}
            </label><br/>
        </c:forEach>
    </div>

    <br/>
    <button type="submit">수정 완료</button>
</form>

<script>
    $(function () {
        // 배송지 선택 안 했을 경우 경고
        $('form').on('submit', function (e) {
            const isAddressSelected = $('input[name="addressNo"]:checked').length > 0;
            if (!isAddressSelected) {
                alert("배송지를 선택해주세요.");
                e.preventDefault();
            }
        });
    });
</script>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
