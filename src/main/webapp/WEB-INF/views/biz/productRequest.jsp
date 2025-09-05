<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%@ include file="/WEB-INF/common/head.jsp"%>
    <title>상품 요청</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        /* Google Fonts - Noto Sans KR */
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');

        main.main {
            font-family: 'Noto Sans KR', sans-serif; /* 폰트 적용 */
            background-color: #f0f2f5; /* 메인 배경색 */
            color: #333; /* 기본 텍스트 색상 */
            line-height: 1.6;
            max-width: 800px;
            margin: 40px auto; /* 중앙 정렬 */
            padding: 20px;
            background-color: #fff; /* 내부 배경 흰색 */
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        /* Form and Input Styling */
        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .product-group {
            border: 1px solid #e0e0e0;
            padding: 20px;
            border-radius: 8px;
            background: #fdfdfd;
            transition: box-shadow 0.3s ease-in-out;
            position: relative; /* 삭제 버튼 위치 기준점 */
        }

        .product-group:hover {
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        .product-group > div {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 10px;
        }

        /* 마지막 div의 하단 여백 제거 */
        .product-group > div:last-of-type {
            margin-bottom: 0;
        }

        /* Input 필드와 라벨 너비 조정 */
        .product-group label {
            width: 70px; /* 라벨 너비 고정 */
        }

        .product-group input[type="text"],
        .product-group input[type="number"],
        .product-group textarea {
            width: 300px; /* Input 필드 너비 조정 */
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease-in-out;
        }

        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus {
            border-color: #3498db;
            outline: none;
        }

        label strong {
            color: #555;
            font-weight: 500;
        }

        textarea {
            width: 100%;
            resize: vertical;
        }

        /* File Input & Radio Buttons */
        input[type="file"] {
            display: block;
            margin-top: 5px;
        }

        input[type="radio"] {
            margin-right: 8px;
        }
    </style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<h1>상품 요청</h1>

<form method="post" action="/biz/productRequest" enctype="multipart/form-data">
    <div id="product-container">
        <!-- 초기 상품 입력 항목 -->
        <div class="product-group">
            <div>상품명: <input type="text" name="productRequestList[0].productName" required></div>
            <div>옵션: <input type="text" name="productRequestList[0].productOption" required></div>
            <div>수량: <input type="number" name="productRequestList[0].productQuantity" min="1" required></div>
            <input type="hidden" name="productRequestList[0].createUser" value="${loginUserName}" />
        </div>
    </div>

	<section class="register py-1">
	   <div class="text-center">
	      <button type="button" id="addProductBtn" class="btn btn-register"
	      	style="font-size: 14px; padding: 10px 20px; height: 45px; line-height: 1.1;">
	      + 상품 추가</button>
	   </div>
	</section>

    <br/><br/>
    
    <div>
	    <label for="requestFiles"><strong>첨부 파일:</strong></label><br/>
	    <input type="file" id="requestFiles" name="requestFiles" multiple />
	</div>
    
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
    <section class="register py-1">
	   <div class="text-end">
	      <button type="submit" class="btn btn-register btn-sm"
	      	style="font-size: 14px; padding: 10px 20px; height: 45px; line-height: 1.1;">
	      요청 제출</button>
	   </div>
	</section>
</form>

</main>

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
	                <section class="register py-1">
	             	   <div class="text-front">
	             	      <button type="button" class="remove-btn btn btn-danger">삭제</button>
	             	   </div>
	             	</section>
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