<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>개인 메인 페이지</title>
<style>
	.wish-count {
	    color: #e74c3c;
	    font-weight: bold;
	}
</style>
</head>
<body class="index-page">

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

	<main class="main">

	<section id="best-sellers" class="best-sellers section">
	
	  <!-- Section Title -->
	  <div class="container section-title" data-aos="fade-up">
	    <h2>Best Sellers</h2>
	  </div><!-- End Section Title -->

	<!-- 검색 input -->
	<div class="header sticky-top mb-4">
		<div class="row justify-content-center">
			<div class="col-md-3 col-lg-3">
				<div class="search-form">
					<div class="input-group">
						<input type="text" class="form-control" id="search-input" placeholder="상품 검색">
						<button class="btn" type="button">
							<i class="bi bi-search"></i>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	  <div class="container" data-aos="fade-up" data-aos-delay="100">
	    <div class="row g-5" id="product-container">
	
	      <!-- Product 반복 출력 -->
	      <c:forEach var="item" items="${productList}">
	        <div class="col-lg-3 col-md-6 product-card" data-name="${item.productName}">
	          <div class="product-item">
	            <div class="product-image">
	              <c:choose>
	                <c:when test="${not empty item.imagePath}">
	                  <img src="${pageContext.request.contextPath}${item.imagePath}"
	                       alt="${item.productName}"
	                       class="img-fluid"
	                       style="max-width: 100%; max-height: 100%; object-fit: contain;"
	                       loading="lazy" />
	                </c:when>
	                <c:otherwise>
	                  <span style="color: #ccc; font-size: 14px;">이미지 없음</span>
	                </c:otherwise>
	              </c:choose>
	              
	              <c:choose>
				    <c:when test="${item.productNo % 3 == 1}">
				      <div class="product-badge limited-badge">Limited</div>
				    </c:when>
				    <c:when test="${item.productNo % 3 == 2}">
				      <div class="product-badge trending-badge">Trending</div>
				    </c:when>
				  </c:choose>
				  
	              <button class="cart-btn">Add to Cart</button>
	            </div>
	
	            <div class="product-info">
	              <h4 class="product-name">
	                <c:choose>
	                  <c:when test="${item.productStatus == 'GS003'}">
	                  	<a href="/personal/productOne?productNo=${item.productNo}">
	                      ${item.productName}
	                    </a>
	                    <span style="color: gray; cursor: default;">
	                    <br>(일시품절)
	                    </span>
	                  </c:when>
	                  <c:otherwise>
	                    <a href="/personal/productOne?productNo=${item.productNo}">
	                      ${item.productName}
	                    </a>
	                  </c:otherwise>
	                </c:choose>
	              </h4>
	
	              <div class="wish-count">❤️ ${item.wishCount}</div>
	            </div>
	          </div>
	        </div>
	      </c:forEach>
	      <!-- End Product 반복 출력 -->
	
	    </div>
	  </div>

	  <!-- 페이징 버튼 -->
	  <div id="pagination" class="category-pagination justify-content-center mt-4"></div>
	</section>
    
    <!-- Scroll Top -->
  	<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>

	</main>
	
	<!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	$(document).ready(function() {
	    const container = $('#product-container');
	    const cards = container.children('.product-card').toArray();
	    const itemsPerPage = 4;
	    let currentPage = 1;
	    let filteredCards = cards;
	
	    function renderPage(page) {
	        container.empty();
	        const start = (page - 1) * itemsPerPage;
	        const end = start + itemsPerPage;
	        filteredCards.slice(start, end).forEach(card => container.append(card));
	        renderPagination();
	    }
	
	    function renderPagination() {
	        const totalPages = Math.ceil(filteredCards.length / itemsPerPage);
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
	
	    // 검색 기능
	    $('#search-input').on('input', function() {
	        const keyword = $(this).val().toLowerCase();
	        filteredCards = cards.filter(card => 
	            $(card).data('name').toLowerCase().includes(keyword)
	        );
	        currentPage = 1;
	        renderPage(currentPage);
	    });
	
	    // 초기 렌더링
	    renderPage(currentPage);
	});
	</script>

</body>
</html>
