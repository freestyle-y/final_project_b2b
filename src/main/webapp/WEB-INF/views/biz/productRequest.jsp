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
            width: 700px;
            max-width: 90%;
            background: #f9f9f9;
        }

        .remove-btn {
            margin-top: 5px;
            background-color: #e74c3c;
            color: white;
            border: none;
            padding: 5px 10px;
            cursor: pointer;
        }

        .remove-btn:hover {
            background-color: #c0392b;
        }
    </style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h1>상품 요청</h1>

<form method="post" action="/biz/productRequest">
    <div id="product-container">
        <!-- 초기 상품 입력 항목 -->
        <div class="product-group">
            <div>상품명: <input type="text" name="productRequestList[0].productName" required></div>
            <div>옵션: <input type="text" name="productRequestList[0].productOption" required></div>
            <div>수량: <input type="number" name="productRequestList[0].productQuantity" min="1" required></div>
            <input type="hidden" name="productRequestList[0].createUser" value="${loginUserName}" />
        </div>
    </div>

    <button type="button" id="addProductBtn">+ 상품 추가</button>

    <br/><br/>

    <div>
        <label for="requests">요청사항:</label><br/>
        <textarea id="requests" name="requests" rows="3" cols="40"></textarea>
    </div>

    <br/>

    <div>
        <label><strong>배송지 선택:</strong></label><br/>
        <c:forEach var="addr" items="${bizAddressList}">
            <label>
                <input type="radio" name="addressNo"
                       value="${addr.addressNo}"
                       ${addr.mainAddress == 'Y' ? 'checked' : ''} />
                [${addr.postal}] ${addr.address} ${addr.detailAddress}
            </label><br/>
        </c:forEach>
    </div>

    <br/>
    <button type="submit">요청 제출</button>
</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- 스크립트 -->
<script>
	$(function () {
	    const loginUserName = $('#loginUserDiv').data('user');
	
	    // 상품 추가 버튼 클릭 시
	    $('#addProductBtn').on('click', function () {
	        const lastGroup = $('#product-container .product-group').last();
	        const productName = lastGroup.find('input[name$=".productName"]').val().trim();
	        const option = lastGroup.find('input[name$=".productOption"]').val().trim();
	        const quantity = lastGroup.find('input[name$=".productQuantity"]').val().trim();
	
	        if (!productName || !option || !quantity) {
	            alert("상품명, 옵션, 수량을 모두 입력해주세요.");
	            return;
	        }
	
	        const index = $('#product-container .product-group').length;
	
	        const newGroupHtml = `
	            <div class="product-group">
	                <div>상품명: <input type="text" name="productRequestList[\${index}].productName" required></div>
	                <div>옵션: <input type="text" name="productRequestList[\${index}].productOption" required></div>
	                <div>수량: <input type="number" name="productRequestList[\${index}].productQuantity" min="1" required></div>
	                <input type="hidden" name="productRequestList[\${index}].createUser" value="${loginUserName}" />
	                <button type="button" class="remove-btn">삭제</button>
	            </div>
	        `.replace(/\$\{index\}/g, index);
	
	        $('#product-container').append(newGroupHtml);
	    });
	
	    // 삭제 버튼 클릭 시 해당 상품 그룹 삭제
	    $(document).on('click', '.remove-btn', function () {
	        $(this).closest('.product-group').remove();
	        reindexInputs();
	    });
	
	    // 삭제 후 인덱스 재정렬 함수
	    function reindexInputs() {
		    $('#product-container .product-group').each(function (idx) {
		        $(this).find('input[type="text"]').eq(0).attr('name', 'productRequestList[' + idx + '].productName');
		        $(this).find('input[type="text"]').eq(1).attr('name', 'productRequestList[' + idx + '].productOption');
		        $(this).find('input[type="number"]').attr('name', 'productRequestList[' + idx + '].productQuantity');
		        $(this).find('input[type="hidden"]').attr('name', 'productRequestList[' + idx + '].createUser');
		    });
		}

	
	    // 배송지 선택 안 했을 때 제출 방지
	    $('form').on('submit', function (e) {
	        const isAddressSelected = $('input[name="addressNo"]:checked').length > 0;
	        if (!isAddressSelected) {
	            alert("배송지를 선택해주세요.");
	            e.preventDefault();
	        }
	    });
	});
</script>

</body>
</html>