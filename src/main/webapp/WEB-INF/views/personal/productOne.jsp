<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 상세</title>

<!-- Font Awesome for star icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
    /* 하트 토글 스타일 */
    .heart {
        font-size: 24px;
        cursor: pointer;
        user-select: none;
        color: gray;
        transition: color 0.3s ease;
    }
    .heart.red {
        color: red;
    }

    /* 옵션 및 수량 영역 */
    #optionSelect {
        padding: 8px;
        font-size: 16px;
        margin-bottom: 10px;
    }
    #quantity-container {
        display: flex;
        align-items: center;
        gap: 10px;
        margin-bottom: 10px;
    }
    #quantity-container button {
        width: 30px;
        height: 30px;
        font-size: 20px;
        cursor: pointer;
    }
    #quantity {
        width: 50px;
        text-align: center;
        font-size: 16px;
    }

    #price, #stock {
        font-weight: bold;
        margin-bottom: 10px;
    }

    /* 버튼 공통 스타일 */
    .action-btn {
        padding: 8px 16px;
        font-size: 14px;
        cursor: pointer;
        border: none;
        border-radius: 5px;
        background-color: #4CAF50; /* 초록색 */
        color: white;
        margin-right: 10px;
        transition: background-color 0.3s ease;
    }

    .action-btn:hover {
        background-color: #45a049;
    }

    /* 리뷰 스타일 */
    #review-summary {
        margin-top: 50px;
        border-top: 2px solid #ccc;
        padding-top: 20px;
    }

    .review-card {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 16px;
        margin-bottom: 20px;
        max-width: 800px;
    }

    .review-card .name {
        font-weight: bold;
        margin-bottom: 4px;
    }

    .review-card .product {
        color: #333;
        font-size: 1.1em;
        margin-bottom: 4px;
    }

    .review-card .option {
        font-size: 0.9em;
        color: #666;
        margin-bottom: 6px;
    }

    .review-card .content {
        margin-bottom: 10px;
    }

    .review-card .grade i {
        color: #f39c12;
        font-size: 18px;
        margin-right: 2px;
    }
    
    /* 정렬 드롭다운 */
    #sort-select {
        margin-bottom: 20px;
        padding: 8px;
        font-size: 14px;
    }
    
    /* ✅ 리뷰 페이징 버튼 스타일 */
	.pagination {
	    text-align: center;
	    margin-top: 20px;
	}
	.pagination button {
	    margin: 0 4px;
	    padding: 6px 12px;
	    border-radius: 5px;
	    border: 1px solid #ccc;
	    background: #fff;
	    cursor: pointer;
	    font-size: 1em;
	}
	.pagination button.active {
	    background-color: #333;
	    color: white;
	    border-color: #333;
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
    
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h2>${product.productName}</h2>

	<c:if test="${not empty errorMessage}">
	    <div style="color: red;">${errorMessage}</div>
	</c:if>
	
	<div class="image-slider">
	    <button class="prev-btn">&lt;</button>
	    
	    <div class="slides-container">
		     <c:forEach var="imgPath" items="${product.imagePaths}">
	            <img src="${pageContext.request.contextPath}${imgPath}" alt="${product.productName}" class="slide" />
	        </c:forEach>
		</div>

	    
	    <button class="next-btn">&gt;</button>
	    
	    <div class="dots-container">
	        <c:forEach var="imgPath" items="${product.imagePaths}" varStatus="status">
	            <span class="dot" data-index="${status.index}"></span>
	        </c:forEach>
	    </div>
	</div>


    <!-- 찜 하트 -->
    <span id="wishHeart" class="heart ${product.isWish ? 'red' : ''}" 
	      data-product-no="${product.productNo}" 
	      data-is-wish="${product.isWish}"
	      title="찜하기/취소하기">
	    ♥
	</span>

    <!-- 옵션 선택 -->
    <div>
        <label for="optionSelect">옵션 선택:</label><br/>
        <select id="optionSelect" name="option">
		    <c:forEach var="opt" items="${optionList}">
		        <option value="${opt.optionNo}" 
		                data-price="${opt.price}" 
		                data-quantity="${opt.quantity}"
		                data-option-name="${opt.optionName}"
		                <c:if test="${opt.quantity == 0}">disabled</c:if>>
		            ${opt.optionNameValue} 
		            <c:if test="${opt.quantity == 0}">(품절)</c:if>
		        </option>
		    </c:forEach>
		</select>
    </div>

    <!-- 가격 및 적립금 표시 -->
    <div id="price-container">
        <span id="price">가격: ${optionList[0].price} 원</span>
        <span id="reward" style="margin-left: 20px; font-weight: normal; color: #555;">
            적립금: ${Math.floor(optionList[0].price * 0.01)} 원
        </span>
    </div>

    <!-- 재고 표시 -->
    <div id="stock">수량: ${optionList[0].quantity} 개</div>

    <!-- 수량 조절 -->
    <div id="quantity-container">
        <button id="btnDecrease" type="button">-</button>
        <input type="text" id="quantity" value="1" readonly />
        <button id="btnIncrease" type="button">+</button>
    </div>

    <!-- 버튼들 -->
    <button id="addCartBtn" type="button" class="action-btn">장바구니 담기</button>
    <button id="buyNowBtn" type="button" class="action-btn">바로구매</button>

    <!-- 평균 평점 및 리뷰 -->
	<div id="review-summary">
	    <h3>상품 리뷰</h3>
	    <p><strong>평균 평점:</strong> ${avgProductRate} / 5</p>
	
		<!-- 정렬 드롭다운 -->
	    <select id="sort-select">
	        <option value="high">별점 높은순</option>
	        <option value="low">별점 낮은순</option>
	    </select>
    
	    <div id="review-list">
	        <c:forEach var="item" items="${productReview}">
	            <div class="review-card" data-grade="${item.grade}">
	                <!-- 이름 마스킹 -->
	                <div class="name">
	                    <c:set var="name" value="${item.name}" />
	                    <c:choose>
	                        <c:when test="${fn:length(name) == 2}">
	                            ${fn:substring(name, 0, 1)}*
	                        </c:when>
	                        <c:when test="${fn:length(name) >= 3}">
	                            ${fn:substring(name, 0, 1)}*${fn:substring(name, 2, fn:length(name))}
	                        </c:when>
	                        <c:otherwise>
	                            ${name}
	                        </c:otherwise>
	                    </c:choose>
	                </div>
	
	                <div class="product">${item.productName}</div>
	                <div class="option">옵션: ${item.optionNameValue}</div>
	                <div class="content">${item.review}</div>
	
	                <!-- 별점 -->
	                <div class="grade">
	                    <c:set var="grade" value="${item.grade}" />
	                    <c:set var="fullStars" value="${fn:substringBefore(grade, '.')}" />
	                    <c:set var="decimal" value="${grade - fullStars}" />
	                    <c:set var="hasHalf" value="${decimal >= 0.5}" />
	                    <c:set var="emptyStars" value="${5 - fullStars - (hasHalf ? 1 : 0)}" />
	
	                    <c:forEach begin="1" end="${fullStars}" var="i">
	                        <i class="fas fa-star"></i>
	                    </c:forEach>
	
	                    <c:if test="${hasHalf}">
	                        <i class="fas fa-star-half-alt"></i>
	                    </c:if>
	
	                    <c:forEach begin="1" end="${emptyStars}" var="i">
	                        <i class="far fa-star"></i>
	                    </c:forEach>
	                </div>
	            </div>
	        </c:forEach>
	
	        <c:if test="${empty productReview}">
	            <p>등록된 리뷰가 없습니다.</p>
	        </c:if>
	    </div>
	    
	    <!-- ✅ 페이지네이션 버튼 영역 -->
		<div id="review-pagination" class="pagination"></div>
	</div>
	
	<!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>
	
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(function() {
    	const itemsPerPage = 5;
    	let currentPage = 1;

        const wishHeart = $('#wishHeart');
        const optionSelect = $('#optionSelect');
        const priceDisplay = $('#price');
        const stockDisplay = $('#stock');
        const quantityInput = $('#quantity');
        const btnIncrease = $('#btnIncrease');
        const btnDecrease = $('#btnDecrease');
        const addCartBtn = $('#addCartBtn');

        // 초기 선택된 옵션 정보 가져오기
        function updateInfo() {
            const selectedOption = optionSelect.find('option:selected');
            const price = Number(selectedOption.data('price'));
            const stock = Number(selectedOption.data('quantity'));
            const quantity = Number(quantityInput.val());

            const totalPrice = price * quantity;
            const reward = Math.floor(totalPrice * 0.01); // 적립금 1%

            priceDisplay.text('가격: ' + totalPrice.toLocaleString() + ' 원');
            $('#reward').text('적립금: ' + reward.toLocaleString() + ' 원');
            stockDisplay.text('재고: ' + stock + ' 개');

            if(quantity > stock) {
                quantityInput.val(stock);
            }
        }

     	// 찜 하트 클릭 토글
        wishHeart.on('click', function () {
            const heart = $(this);
            const productNo = heart.data('product-no');
            const isCurrentlyWish = heart.hasClass('red'); // 현재 찜 상태 확인

            $.ajax({
                url: '/wish/toggle',
                type: 'POST',
                data: {
                    productNo: productNo,
                    wish: !isCurrentlyWish // 반대 상태 전송
                },
                success: function (res) {
                    if (res.success) {
                        heart.toggleClass('red'); // UI 반영
                    } else {
                        alert('찜 처리에 실패했습니다.');
                    }
                },
                error: function () {
                    alert('서버 오류가 발생했습니다.');
                }
            });
        });

        // 옵션 변경 시 가격, 재고, 수량 업데이트
        optionSelect.on('change', function() {
            quantityInput.val(1); // 수량 초기화
            updateInfo();
        });

        // 수량 증가 버튼
        btnIncrease.on('click', function() {
            const selectedOption = optionSelect.find('option:selected');
            const stock = Number(selectedOption.data('quantity'));
            let quantity = Number(quantityInput.val());

            if(quantity < stock) {
                quantity++;
                quantityInput.val(quantity);
                updateInfo();
            } else {
            	alert('수량은 최대 ' + stock + '개까지 가능합니다.');
            }
        });

        // 수량 감소 버튼
        btnDecrease.on('click', function() {
            let quantity = Number(quantityInput.val());
            if(quantity > 1) {
                quantity--;
                quantityInput.val(quantity);
                updateInfo();
            }
        });

        // 장바구니 담기
        addCartBtn.on('click', function() {
            const productNo = wishHeart.data('product-no');
            const selectedOption = optionSelect.find('option:selected').val();
            const selectedOptionNo = optionSelect.find('option:selected').val(); // ← optionNo
            const quantity = Number(quantityInput.val());

            // AJAX로 구현
            $.ajax({
                url: '/shoppingCart/add',
                type: 'POST',
                data: {
                    productNo: productNo,
                    optionNo: selectedOptionNo,
                    quantity: quantity
                },
                success: function(res) {
                    // 정상 담겼으면 장바구니로 이동할지 물어보기
                    if (res.success) {
                        if (confirm('장바구니에 담겼습니다. 장바구니로 이동하시겠습니까?')) {
                            window.location.href = '/personal/shoppingCart'; // 장바구니 페이지 URL에 맞게 조정
                        }
                    }
                },
                error: function(xhr) {
                    if (xhr.status === 409) {  // 이미 장바구니에 담긴 상품인 경우
                        let res = xhr.responseJSON;
                        alert(res.message);
                        if (confirm('장바구니로 이동하시겠습니까?')) {
                            window.location.href = '/personal/shoppingCart';
                        }
                    } else {
                        alert('서버 오류가 발생했습니다.');
                    }
                }
            });

        });

    	function renderReviewPage(page, list) {
    	    const start = (page - 1) * itemsPerPage;
    	    const end = start + itemsPerPage;

    	    list.hide().slice(start, end).show();
    	}

    	function renderPagination(totalItems, list) {
    	    const totalPages = Math.ceil(totalItems / itemsPerPage);
    	    const $pagination = $('#review-pagination');
    	    $pagination.empty();

    	    for (let i = 1; i <= totalPages; i++) {
    	        const $btn = $('<button>').text(i);
    	        if (i === currentPage) $btn.addClass('active');
    	        $btn.on('click', function () {
    	            currentPage = i;
    	            renderReviewPage(currentPage, list);
    	            renderPagination(totalItems, list);
    	        });
    	        $pagination.append($btn);
    	    }
    	}

    	function initReviewPagination() {
    	    const $reviewList = $('#review-list');
    	    const $cards = $reviewList.children('.review-card');
    	    currentPage = 1;
    	    renderReviewPage(currentPage, $cards);
    	    renderPagination($cards.length, $cards);
    	}
    	
        // 페이지 로딩 시 초기값 세팅
        updateInfo();
        initReviewPagination(); // ✅ 리뷰 페이징 초기화
        
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
        });

        
     	// ⭐ 리뷰 정렬
        $('#sort-select').on('change', function () {
            const sortType = $(this).val(); // "high" or "low"
            const reviewList = $('#review-list');
            const reviews = reviewList.children('.review-card').get();

            reviews.sort(function (a, b) {
                const gradeA = parseFloat($(a).data('grade'));
                const gradeB = parseFloat($(b).data('grade'));
                return sortType === 'high' ? gradeB - gradeA : gradeA - gradeB;
            });

            reviewList.empty().append(reviews);
            initReviewPagination(); // ✅ 정렬 후 페이징 다시 적용
        });
     	
        $('#buyNowBtn').on('click', function() {
            const userId = '${loginUserName}';
            const productNo = $('#wishHeart').data('product-no');
            const selectedOption = $('#optionSelect option:selected');
            const optionNo = selectedOption.val();
            const productName = '${product.productName}';
            const optionName = selectedOption.data('option-name') || '';
            const optionNameValue = selectedOption.text().trim();
            const price = selectedOption.data('price');
            const quantity = Number($('#quantity').val());

            function createHiddenInput(name, value) {
                const input = document.createElement("input");
                input.type = "hidden";
                input.name = name;
                input.value = value;
                return input;
            }

            const form = document.createElement("form");
            form.method = "POST";
            form.action = "/personal/purchase";
            form.style.display = "none";

            form.appendChild(createHiddenInput("purchaseList[0].userId", userId));
            form.appendChild(createHiddenInput("purchaseList[0].productNo", productNo));
            form.appendChild(createHiddenInput("purchaseList[0].optionNo", optionNo));
            form.appendChild(createHiddenInput("purchaseList[0].productName", productName));
            form.appendChild(createHiddenInput("purchaseList[0].optionName", optionName));
            form.appendChild(createHiddenInput("purchaseList[0].optionNameValue", optionNameValue));
            form.appendChild(createHiddenInput("purchaseList[0].orderQuantity", quantity));
            form.appendChild(createHiddenInput("purchaseList[0].price", price));
            form.appendChild(createHiddenInput("purchaseList[0].source", "direct"));

            document.body.appendChild(form);
            form.submit();
        });

    });
    </script>

</body>
</html>