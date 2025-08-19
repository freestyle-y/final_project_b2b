<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 요청</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .product-group {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
            position: relative;
        }
        .remove-btn {
            position: absolute;
            right: 10px;
            top: 10px;
            background: red;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }
    </style>
</head>
<jsp:include page="/WEB-INF/common/header/bizHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/bizSidebar.jsp" />

<h1>상품 요청</h1>

<!-- 로그인 사용자명 -->
<div>${loginUserName}</div>

<!-- 요청 form 시작 -->
<form method="post" action="/biz/productRequest">
    <div id="product-container">
        <!-- 초기 상품 입력 항목 -->
        <div class="product-group">
            <button type="button" class="remove-btn" style="display:none;">삭제</button>
            <div>상품명: <input type="text" name="productRequestList[0].productName" required></div>
            <div>옵션: <input type="text" name="productRequestList[0].productOption" required></div>
            <div>수량: <input type="number" name="productRequestList[0].productQuantity" min="1" required></div>
            <!-- createUser hidden -->
            <input type="hidden" name="productRequestList[0].createUser" value="${loginUserName}" />
        </div>
    </div>

    <button type="button" id="addProductBtn">+ 상품 추가</button>

    <br/><br/>

    <!-- 요청사항 (공통) -->
    <div>
        <label for="requests">요청사항:</label><br/>
        <textarea id="requests" name="productRequestList[0].requests" rows="3" cols="40"></textarea>
    </div>

    <br/>

    <!-- 배송지 선택 -->
    <div>
        <label><strong>배송지 선택:</strong></label><br/>
        <c:forEach var="addr" items="${bizAddressList}">
            <label>
                <input type="radio" name="productRequestList[0].addressNo"
                       value="${addr.addressNo}"
                       ${addr.mainAddress == 'Y' ? 'checked' : ''} />
                [${addr.postal}] ${addr.address} ${addr.detailAddress}
            </label><br/>
        </c:forEach>
    </div>

    <br/>
    <button type="submit">요청 제출</button>
</form>

<!-- 스크립트 -->
<script>
    $(function () {
        let index = 1;

        $('#addProductBtn').on('click', function () {
            const lastGroup = $('#product-container .product-group').last();
            const productName = lastGroup.find('input[name$=".productName"]').val().trim();
            const option = lastGroup.find('input[name$=".productOption"]').val().trim();
            const quantity = lastGroup.find('input[name$=".productQuantity"]').val().trim();

            if (!productName || !option || !quantity) {
                alert("상품명, 옵션, 수량을 모두 입력해주세요.");
                return;
            }

            const selectedAddress = $('input[name="productRequestList[0].addressNo"]:checked').val();
            const requests = $('#requests').val();
            const createUser = lastGroup.find('input[name$=".createUser"]').val();

            const newGroup = $(`
                <div class="product-group">
                    <button type="button" class="remove-btn">삭제</button>
                    <div>상품명: <input type="text" name="productRequestList[${index}].productName" required></div>
                    <div>옵션: <input type="text" name="productRequestList[${index}].productOption" required></div>
                    <div>수량: <input type="number" name="productRequestList[${index}].productQuantity" min="1" required></div>
                    <input type="hidden" name="productRequestList[${index}].addressNo" value="${selectedAddress}" />
                    <input type="hidden" name="productRequestList[${index}].requests" value="${requests}" />
                    <input type="hidden" name="productRequestList[${index}].createUser" value="${createUser}" />
                </div>
            `);

            $('#product-container').append(newGroup);
            index++;
        });

        // 삭제 버튼
        $('#product-container').on('click', '.remove-btn', function () {
            $(this).closest('.product-group').remove();

            // 이름 재정렬
            $('#product-container .product-group').each(function (i) {
                $(this).find('input[name$=".productName"]').attr('name', `productRequestList[${i}].productName`);
                $(this).find('input[name$=".productOption"]').attr('name', `productRequestList[${i}].productOption`);
                $(this).find('input[name$=".productQuantity"]').attr('name', `productRequestList[${i}].productQuantity`);
                $(this).find('input[name$=".addressNo"]').attr('name', `productRequestList[${i}].addressNo`);
                $(this).find('input[name$=".requests"]').attr('name', `productRequestList[${i}].requests`);
                $(this).find('input[name$=".createUser"]').attr('name', `productRequestList[${i}].createUser`);
            });

            index = $('#product-container .product-group').length;
        });

        // 배송지 선택 안 했을 때 제출 방지
        $('form').on('submit', function (e) {
            const isAddressSelected = $('input[name="productRequestList[0].addressNo"]:checked').length > 0;
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
