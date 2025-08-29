<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>기업용 상품 상세</title>

<!-- Font Awesome for star icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
    /* 정렬 드롭다운 */
    #sort-select {
        margin-bottom: 20px;
        padding: 8px;
        font-size: 14px;
    }

    /* 페이징 버튼 */
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
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

	<!-- Page Title -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">Product Details</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="/biz/mainPage">Home</a></li>
            <li class="current">Product Details</li>
          </ol>
        </nav>
      </div>
    </div><!-- End Page Title -->
    
    <!-- Product Details Section -->
    <section id="product-details" class="product-details section">
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
				    (${fn:length(productReview)} reviews)
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
				    <label class="variant-label" for="optionSelect">Options:</label><br/>
				
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

				  </div>
				</div>

              <!-- Benefits List -->
              <div class="benefits-list">
                <div class="benefit-item">
                  <i class="bi bi-truck"></i>
                  <span>Free delivery on orders over $75</span>
                </div>
                <div class="benefit-item">
                  <i class="bi bi-arrow-clockwise"></i>
                  <span>45-day hassle-free returns</span>
                </div>
                <div class="benefit-item">
                  <i class="bi bi-shield-check"></i>
                  <span>3-year manufacturer warranty</span>
                </div>
                <div class="benefit-item">
                  <i class="bi bi-headset"></i>
                  <span>24/7 customer support available</span>
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
                <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#ecommerce-product-details-5-overview" type="button">Overview</button>
                <button class="nav-link" data-bs-toggle="tab" data-bs-target="#ecommerce-product-details-5-customer-reviews" type="button">Reviews (${fn:length(productReview)})</button>
              </nav>

              <div class="tab-content">
                <!-- Overview Tab (상세정보) -->
                <div class="tab-pane fade show active" id="ecommerce-product-details-5-overview">
                  <div class="overview-content">
                    <div class="row g-4">
                      <div class="col-lg-8">
                        <div class="content-section">
                          <h3>Product Overview</h3>
                          <p>Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit.</p>

                          <h4>Key Highlights</h4>
                          <div class="highlights-grid">
                            <div class="highlight-card">
                              <i class="bi bi-volume-up"></i>
                              <h5>Superior Audio</h5>
                              <p>Ut enim ad minima veniam quis nostrum exercitationem</p>
                            </div>
                            <div class="highlight-card">
                              <i class="bi bi-battery-charging"></i>
                              <h5>Long Battery</h5>
                              <p>Excepteur sint occaecat cupidatat non proident</p>
                            </div>
                            <div class="highlight-card">
                              <i class="bi bi-wifi"></i>
                              <h5>Wireless Tech</h5>
                              <p>Duis aute irure dolor in reprehenderit in voluptate</p>
                            </div>
                            <div class="highlight-card">
                              <i class="bi bi-person-check"></i>
                              <h5>Comfort Fit</h5>
                              <p>Lorem ipsum dolor sit amet consectetur adipiscing</p>
                            </div>
                          </div>
                        </div>
                      </div>

                      <div class="col-lg-4">
                        <div class="package-contents">
                          <h4>Package Contents</h4>
                          <ul class="contents-list">
                            <li><i class="bi bi-check-circle"></i>Premium Audio Device</li>
                            <li><i class="bi bi-check-circle"></i>Premium Carrying Case</li>
                            <li><i class="bi bi-check-circle"></i>USB-C Fast Charging Cable</li>
                            <li><i class="bi bi-check-circle"></i>3.5mm Audio Connector</li>
                            <li><i class="bi bi-check-circle"></i>Quick Start Guide</li>
                            <li><i class="bi bi-check-circle"></i>Warranty Documentation</li>
                          </ul>
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
                          <div class="total-reviews">(${fn:length(productReview)}) customer reviews</div>
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
				<div id="review-pagination" class="pagination"></div>
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
 
 	// 옵션 변경 시 가격, 재고, 수량 업데이트
    optionSelect.on('change', function() {
    	const selectedOption = optionSelect.find('option:selected');
    	const stock = Number(selectedOption.data('quantity'));
    	quantityInput.val(1);
    	
    	quantityInput.attr('max', stock); // max 속성 업데이트
        updateInfo();
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
    
    // 정렬
    $('#sort-select').on('change', function () {
        const sortType = $(this).val();
        const reviewList = $('#review-list');
        const reviews = reviewList.children('.review-card').get();

        reviews.sort(function (a, b) {
            const gradeA = parseFloat($(a).data('grade'));
            const gradeB = parseFloat($(b).data('grade'));
            return sortType === 'high' ? gradeB - gradeA : gradeA - gradeB;
        });

        reviewList.empty().append(reviews);
        initReviewPagination(); // 정렬 후 페이징 적용
    });

});
</script>

</body>
</html>