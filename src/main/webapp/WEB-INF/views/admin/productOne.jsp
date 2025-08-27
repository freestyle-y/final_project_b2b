<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>상품 상세</title>
<style>
    .product-section {
        border: 1px solid #ccc;
        padding: 20px;
        margin: 20px;
    }
    .product-section h3 {
        margin-top: 0;
    }
    .option-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }
    .option-table th, .option-table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }
    
    .image-slider {
	    position: relative;
	    width: 250px;
	    margin: 20px 0;
	    overflow: hidden;
	}
	
	.slide {
	    min-width: 100%;
	    max-width: 150px;  /* 이미지 최대 너비 */
	    max-height: 200px; /* 이미지 최대 높이 */
	    object-fit: contain;
	    user-select: none;
	}


	.slides-container {
	    display: flex;
	    transition: transform 0.3s ease-in-out;
	}
	
	.prev-btn, .next-btn {
	    position: absolute;
	    top: 50%;
	    transform: translateY(-50%);
	    background: rgba(0,0,0,0.5);
	    border: none;
	    color: white;
	    font-size: 24px;
	    padding: 6px 12px;
	    cursor: pointer;
	    z-index: 10;
	    border-radius: 3px;
	}

	.prev-btn { left: 10px; }
	.next-btn { right: 10px; }
	
	.dots-container {
	    text-align: center;
	    margin-top: 10px;
	}
	
	.dot {
	    display: inline-block;
	    width: 10px;
	    height: 10px;
	    margin: 0 4px;
	    background-color: #bbb;
	    border-radius: 50%;
	    cursor: pointer;
	}
	
	.dot.active {
	    background-color: #333;
	}
	
	.slide-wrapper {
    position: relative;
    min-width: 100%; /* 이거 꼭 필요함!! */
    display: flex;
    justify-content: center;
    align-items: center;
}
    
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<!-- ✅ 상품 기본 정보 표시 -->
<div class="product-section">
    <h3>상품 정보</h3>
    <p><strong>상품명:</strong> ${product.productName}</p>
    <div class="form-group">
	    <label><strong>상품 상태 변경:</strong></label>
	    <select id="productStatusSelect" data-product-no="${product.productNo}">
		    <c:forEach var="status" items="${productStatus}">
		        <c:if test="${status.codeNumber == 'GS001' || status.codeNumber == 'GS004'}">
		            <option value="${status.codeNumber}" 
		                <c:if test="${status.codeNumber == product.productStatus}">selected</c:if>>
		                ${status.codeName}
		            </option>
		        </c:if>
		    </c:forEach>
		</select>
	</div>
	
    <div class="image-slider">
	    <button class="prev-btn">&lt;</button>
	    
	    <div class="slides-container">
	        <c:forEach var="imgPath" items="${product.imagePaths}">
	            <div class="slide-wrapper" style="position: relative;">
		            <img src="${pageContext.request.contextPath}${imgPath}" alt="${product.productName}" class="slide" />
		            <button class="delete-image-btn" data-img-path="${imgPath}" style="
		                position: absolute;
		                top: 5px;
		                right: 5px;
		                background: red;
		                color: white;
		                border: none;
		                border-radius: 50%;
		                cursor: pointer;
		                font-weight: bold;
		            ">×</button>
		        </div>
	        </c:forEach>
	    </div>
	    
	    <button class="next-btn">&gt;</button>
	    
	    <div class="dots-container">
	        <c:forEach var="imgPath" items="${product.imagePaths}" varStatus="status">
	            <span class="dot" data-index="${status.index}"></span>
	        </c:forEach>
	    </div>
	</div>
</div>

<!-- ✅ 옵션 가격만 수정 -->
<div class="product-section">
    <h3>옵션 가격 수정</h3>
    <table class="option-table">
        <thead>
            <tr>
                <th>옵션명</th>
                <th>가격</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="option" items="${optionList}">
                <tr>
                    <td>
                        ${option.optionNameValue}
                        <input type="hidden" class="optionNo" value="${option.optionNo}" />
                    </td>
                    <td>
                        <input type="number" class="priceInput" value="${option.price}" required />
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
    <button type="button" id="updatePricesBtn">가격 수정</button>
</div>

<!-- ✅ 이미지 업로드 -->
<div class="product-section">
    <h3>상품 이미지 등록</h3>
    <form action="/admin/uploadProductImage" method="post" enctype="multipart/form-data">
        <input type="hidden" name="productNo" value="${product.productNo}" />
        <input type="file" name="imageFiles" accept="image/*" multiple required />
        <button type="submit">이미지 업로드</button>
    </form>
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function() {
    const $slidesContainer = $('.slides-container');
    const $slides = $('.slide');
    const $dots = $('.dot');
    const totalSlides = $slides.length;
    let currentIndex = 0;

    function updateSlider(index) {
        // 이미지 이동
        $slidesContainer.css('transform', 'translateX(' + (-index * 100) + '%)');
        // 점 활성화 변경
        $dots.removeClass('active').eq(index).addClass('active');
    }

    $('.next-btn').click(function() {
        currentIndex = (currentIndex + 1) % totalSlides;
        updateSlider(currentIndex);
    });

    $('.prev-btn').click(function() {
        currentIndex = (currentIndex - 1 + totalSlides) % totalSlides;
        updateSlider(currentIndex);
    });

    $dots.click(function() {
        const index = $(this).data('index');
        currentIndex = index;
        updateSlider(currentIndex);
    });

    // 초기 상태 세팅
    updateSlider(currentIndex);
    
 	// 상품 상태 변경 이벤트
    $('#productStatusSelect').on('change', function() {
        const newStatus = $(this).val();
        const productNo = $(this).data('product-no');

        $.ajax({
            url: '/admin/updateProductStatus',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                productNo: productNo,
                productStatus: newStatus
            }),
            success: function(response) {
                alert('상품 상태가 변경되었습니다.');
            },
            error: function() {
                alert('상품 상태 변경에 실패했습니다.');
            }
        });
    });
 	
 	// 이미지 삭제
    $(document).on('click', '.delete-image-btn', function () {
        if (!confirm('이 이미지를 삭제하시겠습니까?')) return;

        const imgPath = $(this).data('img-path');
        const productNo = ${product.productNo};

        $.ajax({
            url: '/admin/deleteProductImage',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                productNo: productNo,
                imagePath: imgPath
            }),
            success: function () {
                alert('이미지가 삭제되었습니다.');
                location.reload(); // 새로고침으로 갱신
            },
            error: function () {
                alert('이미지 삭제에 실패했습니다.');
            }
        });
    });

 	
 	// ✅ 옵션 가격 수정 AJAX
    $('#updatePricesBtn').click(function() {
        const productNo = ${product.productNo}; // EL 코드 그대로 JS에 사용
        const priceUpdates = [];

        let isValid = true;
        
        $('.optionNo').each(function(index) {
        	const optionNo = $(this).val();
            const $priceInput = $('.priceInput').eq(index);
            const priceStr = $priceInput.val().trim();

            // 빈 값 확인
            if (priceStr === "") {
                alert(`옵션 ${index + 1}의 가격을 입력해주세요.`);
                $priceInput.focus();
                isValid = false;
                return false; // each 종료
            }

            // 숫자인지 확인
            if (isNaN(priceStr)) {
                alert(`옵션 ${index + 1}의 가격이 숫자가 아닙니다.`);
                $priceInput.focus();
                isValid = false;
                return false;
            }

            const price = parseInt(priceStr);

            // 음수 확인
            if (price < 0) {
                alert(`옵션 ${index + 1}의 가격은 0 이상이어야 합니다.`);
                $priceInput.focus();
                isValid = false;
                return false;
            }

            priceUpdates.push({
                optionNo: optionNo,
                price: price
            });
        });

        $.ajax({
            url: '/admin/updateProductPrices',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                productNo: productNo,
                priceUpdates: priceUpdates
            }),
            success: function() {
                alert('가격이 성공적으로 수정되었습니다.');
            },
            error: function(xhr) {
                alert('가격 수정 실패: ' + xhr.responseText);
            }
        });
    });
});
</script>    
</body>
</html>