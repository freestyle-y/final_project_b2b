<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>상품 후기</title>

<!-- Font Awesome for star icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
	/* 검색창 스타일 */
	#search-input {
		display: block;
		margin: 0 auto 30px auto;
		padding: 10px;
		width: 300px;
		border-radius: 6px;
		border: 1px solid #ccc;
		font-size: 1em;
	}

	.pagination {
	    margin-top: 20px;
	    display: flex;
	    justify-content: center;
	    gap: 5px;
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

	<section id="product-details" class="product-details section">
     <div class="container" data-aos="fade-up" data-aos-delay="100">
       <!-- Information Tabs -->
       <div class="row" data-aos="fade-up" data-aos-delay="300">
         <div class="col-12">
           <div class="info-tabs-container">
             <nav class="tabs-navigation nav">
               <button class="nav-link active" data-bs-toggle="tab" data-bs-target="#ecommerce-product-details-5-customer-reviews" type="button">상품 리뷰 (${fn:length(reviewList)})</button>
             </nav>

             <div class="tab-content">
               <!-- Reviews Tab -->
               <div class="tab-pane fade show active" id="ecommerce-product-details-5-customer-reviews">
                 <div class="reviews-content">

                   <div class="customer-reviews-list">     
                     <div id="review-list">
				      <c:forEach var="item" items="${reviewList}">
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
				
				    <c:if test="${empty reviewList}">
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
    


</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- jQuery CDN -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function () {
		const itemsPerPage = 4;
		let currentPage = 1;

		const $reviewList = $('#review-list');
		let cards = $reviewList.find('.review-card').toArray();
		let filteredCards = cards;

		function renderPage(page) {
			$(cards).hide();
			const start = (page - 1) * itemsPerPage;
			const end = start + itemsPerPage;

			$(filteredCards).slice(start, end).show();
			renderPagination();
		}

		function renderPagination() {
	        const totalPages = Math.ceil(filteredCards.length / itemsPerPage);
	        const pagination = $('#review-pagination');
	        pagination.empty();

	        if (totalPages <= 1) return; // 페이지가 하나면 표시 안 함

	        const maxVisible = 3; // 현재 페이지 기준으로 보여줄 버튼 개수 (홀수 권장)
	        let start = Math.max(1, currentPage - Math.floor(maxVisible / 2));
	        let end = start + maxVisible - 1;
	        if (end > totalPages) {
	            end = totalPages;
	            start = Math.max(1, end - maxVisible + 1);
	        }

	        // ◀ 이전 버튼
	        if (currentPage > 1) {
	            pagination.append(
	                $('<button>').text('◀ 이전').on('click', function() {
	                    currentPage--;
	                    renderPage(currentPage);
	                })
	            );
	        }

	        // 1페이지 표시
	        if (start > 1) {
	            pagination.append(
	                $('<button>').text(1).on('click', function() {
	                    currentPage = 1;
	                    renderPage(currentPage);
	                })
	            );
	            if (start > 2) pagination.append($('<span>').text('...'));
	        }

	        // 중간 페이지들
	        for (let i = start; i <= end; i++) {
	            const btn = $('<button>').text(i);
	            if (i === currentPage) btn.addClass('active');
	            btn.on('click', function() {
	                currentPage = i;
	                renderPage(currentPage);
	            });
	            pagination.append(btn);
	        }

	        // 마지막 페이지 표시
	        if (end < totalPages) {
	            if (end < totalPages - 1) pagination.append($('<span>').text('...'));
	            pagination.append(
	                $('<button>').text(totalPages).on('click', function() {
	                    currentPage = totalPages;
	                    renderPage(currentPage);
	                })
	            );
	        }

	        // 다음 ▶ 버튼
	        if (currentPage < totalPages) {
	            pagination.append(
	                $('<button>').text('다음 ▶').on('click', function() {
	                    currentPage++;
	                    renderPage(currentPage);
	                })
	            );
	        }
	    }

		function filterCards(keyword) {
			filteredCards = cards.filter(card => {
				const text = $(card).text().toLowerCase();
				return text.includes(keyword.toLowerCase());
			});
			currentPage = 1;
			renderPage(currentPage);
		}

		const $search = $('<input type="text" id="search-input" placeholder="상품명 검색...">')
		.css({
			display: 'block',
			margin: '0 auto 30px auto',
			padding: '10px',
			width: '300px',
			borderRadius: '6px',
			border: '1px solid #ccc',
			fontSize: '1em'
		})
		.on('input', function () {
			filterCards($(this).val());
		});

		// 검색창을 review-list 위에 삽입
		$('#review-list').before($search);
		
		// 초기 페이지 렌더링
		renderPage(currentPage);
	});
</script>

</body>
</html>