<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>상품 상세</title>

<!-- Font Awesome for star icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
    #wishHeart.red i {
	  color: red;
	}

    /* 정렬 드롭다운 */
    #sort-select {
        margin-bottom: 20px;
        padding: 8px;
        font-size: 14px;
    }
    
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

    <!-- Page Title -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">상품 상세</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="/personal/mainPage">Home</a></li>
            <li class="current">상품 상세</li>
          </ol>
        </nav>
      </div>
    </div><!-- End Page Title -->
    
    <!-- Product Details Section -->
    <section id="product-details" class="product-details section">
    
	<c:if test="${not empty errorMessage}">
	    <div style="color: red; text-align: center;">
	        ${errorMessage}
	    </div>
	</c:if>

      <div class="container" data-aos="fade-up" data-aos-delay="100">

        <div class="row g-4">
          <!-- Product Gallery -->
          <div class="col-lg-7" data-aos="zoom-in" data-aos-delay="150">
            <div class="product-gallery">
              <div class="main-showcase">
                <div class="image-zoom-container">
                  <c:if test="${not empty product.imagePaths}">
				    <img 
				        src="${pageContext.request.contextPath}${product.imagePaths[0]}" 
				        alt="Product Main" 
				        class="img-fluid main-product-image drift-zoom" 
				        id="main-product-image" 
				        data-zoom="${pageContext.request.contextPath}${product.imagePaths[0]}" />
				  </c:if>
                  <div class="image-navigation">
                    <button class="nav-arrow prev-image image-nav-btn prev-image" type="button">
                      <i class="bi bi-chevron-left"></i>
                    </button>
                    <button class="nav-arrow next-image image-nav-btn next-image" type="button">
                      <i class="bi bi-chevron-right"></i>
                    </button>
                  </div>
                </div>
              </div>

              <div class="thumbnail-grid">
                <c:forEach var="imgPath" items="${product.imagePaths}" varStatus="status">
				    <div class="thumbnail-wrapper thumbnail-item ${status.index == 0 ? 'active' : ''}" 
				         data-image="${pageContext.request.contextPath}${imgPath}">
				      <img src="${pageContext.request.contextPath}${imgPath}" 
				           alt="${product.productName} View ${status.index + 1}" 
				           class="img-fluid">
				    </div>
				  </c:forEach>
              </div>
            </div>
          </div>

          <!-- Product Details -->
          <div class="col-lg-5" data-aos="fade-left" data-aos-delay="200">
            <div class="product-details">
              <div class="product-badge-container">
                			
				<div class="rating-group">
				  <div class="stars">
					  <c:set var="fullStars" value="${fn:substringBefore(avgProductRate, '.')}" />
	                  <c:set var="decimal" value="${avgProductRate - fullStars}" />
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
				
				  <!-- 리뷰 개수 표시 -->
				  <span class="review-text">
				    (${fn:length(productReview)}개의 리뷰)
				  </span>
				</div>
              </div>

              <h1 class="product-name">${product.productName}</h1>

              <div class="pricing-section">
                <div class="price-display">
                  <span class="sale-price" id="sale-price">${optionList[0].price}원</span>
                </div>
              </div>

              <div class="product-description">
              </div>

              <div class="availability-status">
                <div class="stock-indicator">
                  <i class="bi" id="stock-icon"></i>
                  <span class="stock-text" id="stock-text">
                  	${optionList[0].quantity > 0 ? 'Available' : 'Out of Stock'}
                  </span>
                </div>
                <div class="quantity-left" id="quantity-left">Only ${optionList[0].quantity} items remaining</div>
              </div>

				<!-- Product Variants -->
				<div class="variant-section">
				  <div class="color-selection">
				    <label class="variant-label" for="optionSelect">옵션:</label><br/>
				
				    <!-- 드롭다운 셀렉트 박스 -->
				    <select id="optionSelect" name="option" class="form-select" style="max-width: 300px;">
				      <c:forEach var="opt" items="${optionList}">
				        <option value="${opt.optionNo}"
				                data-price="${opt.price}"
				                data-quantity="${opt.quantity}"
				                data-option-name="${opt.optionName}">
				          ${opt.optionNameValue}
				          <c:if test="${opt.quantity == 0}">(품절)</c:if>
				        </option>
				      </c:forEach>
				    </select>
				
				    <!-- 선택된 옵션 정보 -->
				    <div class="mt-2" id="price-container">
				      <span class="regular-price" id="price">${optionList[0].price} 원</span>
				      <span id="reward" style="margin-left: 20px; font-weight: normal; color: #555;">
				        적립금: ${Math.floor(optionList[0].price * 0.01)} 원
				      </span>
				    </div>
				
				    <div id="stock">수량: ${optionList[0].quantity} 개</div>
				  </div>
				</div>

              <!-- Purchase Options -->
              <div class="purchase-section">
                <div class="quantity-control">
                  <label class="control-label">수량:</label>
                  <div class="quantity-input-group">
                    <div class="quantity-selector">
                      <button class="quantity-btn decrease" type="button">
                        <i class="bi bi-dash"></i>
                      </button>
                      <input type="number" class="quantity-input" value="1" min="1" max="${optionList[0].quantity}">
                      <button class="quantity-btn increase" type="button">
                        <i class="bi bi-plus"></i>
                      </button>
                    </div>
                  </div>
                </div>

                <div class="action-buttons">
                  <button id="addCartBtn" class="btn primary-action">
                    <i class="bi bi-bag-plus"></i>
                    장바구니 담기
                  </button>
                  <button id="buyNowBtn" class="btn secondary-action">
                    <i class="bi bi-lightning"></i>
                    구매하기
                  </button>
                  
                  <button id="wishHeart" class="btn icon-action ${product.isWish ? 'red' : ''}" 
				        data-product-no="${product.productNo}" 
				        data-is-wish="${product.isWish}"
				        title="찜하기/취소하기">
					  <i class="bi ${product.isWish ? 'bi-heart-fill' : 'bi-heart'}"></i>
				  </button>
                  
                </div>
              </div>

              <!-- Benefits List -->
              <div class="benefits-list">
                <div class="benefit-item">
                  <i class="bi bi-truck"></i>
                  <span>전 품목 무료배송</span>
                </div>
                <div class="benefit-item">
                  <i class="bi bi-arrow-clockwise"></i>
                  <span>7일 이내 반품 가능</span>
                </div>
                <div class="benefit-item">
                  <i class="bi bi-shield-check"></i>
                  <span>1년 보증기간</span>
                </div>
                <div class="benefit-item">
                  <i class="bi bi-headset"></i>
                  <span>24/7 연중무휴</span>
                </div>
              </div>
            </div>
          </div>
        </div>

        <!-- Information Tabs -->
        <div class="row mt-5" data-aos="fade-up" data-aos-delay="300">
          <div class="col-12">
            <div class="info-tabs-container">
              <nav class="tabs-navigation nav">
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#ecommerce-product-details-5-overview" type="button">상품 상세정보</button>
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#ecommerce-product-details-5-customer-reviews" type="button">리뷰 ${fn:length(productReview)}개</button>
              </nav>

              <div class="tab-content">
                <!-- Overview Tab (상세정보) -->
                <div class="tab-pane fade show active" id="ecommerce-product-details-5-overview">
                  <div class="overview-content">
                    <div class="row g-4">
                      <div class="col-lg-8">
                        <div class="content-section">
                          	<c:forEach var="detailImg" items="${product.detailImagePaths}">
							    <img src="${pageContext.request.contextPath}${detailImg}" alt="상세 이미지"
							    	style="max-width: 1170px; height: auto; display: block; margin: 20px auto;" />
							</c:forEach>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

                <!-- Reviews Tab -->
                <div class="tab-pane fade" id="ecommerce-product-details-5-customer-reviews">
                  <div class="reviews-content">
                    <div class="reviews-header">
                      <div class="rating-overview">
                        <div class="average-score">
                          <div class="score-display">${avgProductRate}</div>
                          
                          <div class="score-stars">
							  <c:set var="fullStars" value="${fn:substringBefore(avgProductRate, '.')}" />
			                  <c:set var="decimal" value="${avgProductRate - fullStars}" />
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
                          <div class="total-reviews">${fn:length(productReview)}개의 리뷰</div>
                        </div>
                      </div>
                    </div>

                    <div class="customer-reviews-list">     
                    
                    <!-- 정렬 드롭다운 추가 -->
				    <div class="review-sort">
				        <label for="sort-select">리뷰 정렬: </label>
				        <select id="sort-select">
				            <option value="high">별점 높은순</option>
				            <option value="low">별점 낮은순</option>
				        </select>
				    </div>      
				    
                      <div id="review-list">
					    <c:forEach var="item" items="${productReview}">
					        <div class="review-card" data-grade="${item.grade}">
					            <div class="reviewer-profile">
					                <div class="profile-details">
					                    <div class="customer-name">
					                        <!-- 이름 마스킹 -->
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
					                    <div class="review-meta">
					                        <div class="review-stars">
					                            <c:set var="fullStars" value="${fn:substringBefore(item.grade, '.')}" />
					                            <c:set var="decimal" value="${item.grade - fullStars}" />
					                            <c:set var="hasHalf" value="${decimal >= 0.5}" />
					                            <c:set var="emptyStars" value="${5 - fullStars - (hasHalf ? 1 : 0)}" />
					
					                            <c:forEach begin="1" end="${fullStars}" var="i">
					                                <i class="bi bi-star-fill"></i>
					                            </c:forEach>
					
					                            <c:if test="${hasHalf}">
					                                <i class="bi bi-star-half"></i>
					                            </c:if>
					
					                            <c:forEach begin="1" end="${emptyStars}" var="i">
					                                <i class="bi bi-star"></i>
					                            </c:forEach>
					                        </div>
					                    </div>
					                </div>
					            </div>
					            <h5 class="review-headline">${item.productName} - 옵션: ${item.optionNameValue}</h5>
					            <div class="review-text">
					                <p>${item.review}</p>
					            </div>
					        </div>
					    </c:forEach>
					
					    <c:if test="${empty productReview}">
					        <p>등록된 리뷰가 없습니다.</p>
					    </c:if>
					</div>
                  </div>
                </div>
                <!-- ✅ 페이지네이션 버튼 영역 -->
				<div id="pagination" class="category-pagination justify-content-center mt-4"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

     </div>
    </section><!-- /Product Details Section -->

	<!-- Scroll Top -->
  	<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
	
	</main>
	
	<!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>
	
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
    $(function() {
    	const itemsPerPage = 4;
    	let currentPage = 1;

        const wishHeart = $('#wishHeart');
        const optionSelect = $('#optionSelect');
        const priceDisplay = $('#price');
        const stockDisplay = $('#stock');
        const quantityInput = $('.quantity-input');
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
            
         	// ✅ 하단 정보도 같이 갱신
            $('#sale-price').text(price.toLocaleString() + '원');
            $('#stock-text').text(stock > 0 ? 'Available' : 'Out of Stock');
            $('#quantity-left').text('Only ' + stock + ' items remaining');
            
            if (stock > 0) {
                $('#stock-text').text('Available');
                $('#quantity-left').text('Only ' + stock + ' items remaining');

                $('#stock-icon')
                  .removeClass('bi-x-circle-fill text-danger')
                  .addClass('bi-check-circle-fill text-success');
                $('#stock-text').removeClass('text-danger').addClass('text-success');
            } else {
                $('#stock-text').text('Out of Stock');
                $('#quantity-left').text('Only 0 items remaining');

                $('#stock-icon')
                  .removeClass('bi-check-circle-fill text-success')
                  .addClass('bi-x-circle-fill text-danger');
                $('#stock-text').removeClass('text-success').addClass('text-danger');
            }
        }

     	// 찜 하트 클릭 토글
        wishHeart.on('click', function () {
            const heart = $(this);
            const icon = heart.find('i');
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
                    	heart.toggleClass('red'); // 빨간색 토글
                        icon.toggleClass('bi-heart bi-heart-fill'); // 아이콘 토글
                        updateWishCount();
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
        	const selectedOption = optionSelect.find('option:selected');
        	const stock = Number(selectedOption.data('quantity'));
        	quantityInput.val(1);
        	
        	quantityInput.attr('max', stock); // max 속성 업데이트
            updateInfo();
        });
         
        
        // + 버튼 클릭
        $('.quantity-btn.increase').on('click', function() {
            const $input = $(this).siblings('.quantity-input');
            const max = Number($input.attr('max')) || 1000;
            let currentVal = Number($input.val());
            if (currentVal <= max) {
                $input.val(currentVal);
                updateInfo();
            }
        });

        // - 버튼 클릭
        $('.quantity-btn.decrease').on('click', function() {
            const $input = $(this).siblings('.quantity-input');
            let currentVal = Number($input.val());
            if (currentVal >= 1) {
                $input.val(currentVal);
                updateInfo();
            }
        });

        // 수량 직접 입력 변경 시
        $('.quantity-input').on('input', function() {
            const max = Number($(this).attr('max')) || 1000;
            let val = Number($(this).val());

            if (isNaN(val) || val < 1) val = 1;
            if (val > max) val = max;

            $(this).val(val);
            updateInfo();
        });

        // 장바구니 담기
        addCartBtn.on('click', function() {
            const productNo = wishHeart.data('product-no');
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
						updateCartCount();
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
    	    const pagination = $('#pagination');
    	    pagination.empty();

    	 // <ul> 생성
	        const ul = $('<ul>').addClass('justify-content-center');

	        const maxVisible = 3;
	        let start = Math.max(1, currentPage - Math.floor(maxVisible / 2));
	        let end = start + maxVisible - 1;

	        if (end > totalPages) {
	            end = totalPages;
	            start = Math.max(1, end - maxVisible + 1);
	        }

	        // ◀ 이전 버튼
	        if (currentPage > 1) {
	            const li = $('<li>').append(
	                $('<a href="#">').html('<i class="bi bi-chevron-left"></i>').on('click', function (e) {
	                    e.preventDefault();
	                    currentPage--;
	                    renderPage(currentPage);
	                })
	            );
	            ul.append(li);
	        }

	        // 1페이지 버튼
	        if (start > 1) {
	            const li = $('<li>').append(
	                $('<a href="#">').text(1).on('click', function (e) {
	                    e.preventDefault();
	                    currentPage = 1;
	                    renderPage(currentPage);
	                })
	            );
	            ul.append(li);
	            if (start > 2) {
	                ul.append($('<li>').html('<span>...</span>'));
	            }
	        }

	        // 중간 페이지 버튼들
	        for (let i = start; i <= end; i++) {
	            const a = $('<a href="#">').text(i).on('click', function (e) {
	                e.preventDefault();
	                currentPage = i;
	                renderPage(currentPage);
	            });
	            if (i === currentPage) a.addClass('active');
	            ul.append($('<li>').append(a));
	        }

	        // 마지막 페이지 버튼
	        if (end < totalPages) {
	            if (end < totalPages - 1) {
	                ul.append($('<li>').html('<span>...</span>'));
	            }
	            const li = $('<li>').append(
	                $('<a href="#">').text(totalPages).on('click', function (e) {
	                    e.preventDefault();
	                    currentPage = totalPages;
	                    renderPage(currentPage);
	                })
	            );
	            ul.append(li);
	        }

	        // ▶ 다음 버튼
	        if (currentPage < totalPages) {
	            const li = $('<li>').append(
	                $('<a href="#">').html('<i class="bi bi-chevron-right"></i>').on('click', function (e) {
	                    e.preventDefault();
	                    currentPage++;
	                    renderPage(currentPage);
	                })
	            );
	            ul.append(li);
	        }

	        pagination.append($('<nav>').append(ul));
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
            const quantity = Number(quantityInput.val());

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