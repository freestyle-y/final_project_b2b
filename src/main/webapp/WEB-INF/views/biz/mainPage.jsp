<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>기업 메인 페이지</title>
<style>
	#search-input {
	    padding: 10px;
	    width: 300px;
	    margin-bottom: 20px;
	    border-radius: 6px;
	    border: 1px solid #ccc;
	}
	
	.wish-count {
	    color: #e74c3c;
	    font-weight: bold;
	}
	
	.pagination {
	    margin-top: 20px;
	    text-align: center;
	}
	
	.pagination button {
	    margin: 0 3px;
	    padding: 6px 12px;
	    border: 1px solid #ccc;
	    border-radius: 5px;
	    background-color: #fff;
	    cursor: pointer;
	}
	
	.pagination button.active {
	    background-color: #333;
	    color: #fff;
	    border-color: #333;
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
	    <p>찜 많은순</p>
	  </div><!-- End Section Title -->

	  <!-- 검색 input -->
	  <div class="container" style="margin-bottom: 10px;">
	    <input type="text" id="search-input" placeholder="상품 검색">
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
				  
	            </div>
	
	            <div class="product-info">
	              <h4 class="product-name">
	                <c:choose>
	                  <c:when test="${item.productStatus == 'GS003'}">
	                  	<a href="/biz/productOne?productNo=${item.productNo}">
	                      ${item.productName}
	                    </a>
	                    <span style="color: gray; cursor: default;">
	                    <br>(일시품절)
	                    </span>
	                  </c:when>
	                  <c:otherwise>
	                    <a href="/biz/productOne?productNo=${item.productNo}">
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
	  <div id="pagination" class="pagination"></div>
	</section><!-- /Best Sellers Section -->

    
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
	        for(let i=1; i<=totalPages; i++) {
	            const btn = $('<button>').text(i);
	            if(i === currentPage) btn.addClass('active');
	            btn.on('click', function() {
	                currentPage = i;
	                renderPage(currentPage);
	            });
	            pagination.append(btn);
	        }
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
