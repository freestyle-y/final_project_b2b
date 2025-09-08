<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>찜 리스트</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
	/* Pagination button styles */
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
<script>
 	// 선택된 상품 삭제
 	$(document).on('click', '.btn-remove', function() {
	    const productNo = $(this).data('product-no');
	    const loginUserName = '${loginUserName}'; // 서버에서 로그인 사용자명 받아오기
	
	    if (!productNo) {
	        alert("삭제할 상품 정보가 없습니다.");
	        return;
	    }
	
	    if (!confirm("이 상품을 찜 목록에서 삭제하시겠습니까?")) {
	        return;
	    }
	
	    $.ajax({
	        url: '${pageContext.request.contextPath}/personal/wish/delete',
	        type: 'POST',
	        contentType: 'application/json',
	        data: JSON.stringify({
	            productNoList: [productNo], // 배열로 하나만 넣음
	            userId: loginUserName
	        }),
	        success: function(response) {
	            if (response.success) {
	                alert("삭제가 완료되었습니다.");
	                updateWishCount();
	                location.reload(); // 필요하면 삭제 후 새로고침 또는 UI에서 제거 처리
	            } else {
	                alert("삭제 실패: " + (response.message || "알 수 없는 오류"));
	            }
	        },
	        error: function() {
	            alert("요청 중 오류가 발생했습니다.");
	        }
	    });
	});
	
	// 페이징 구현
	$(document).ready(function () {
		const itemsPerPage = 4; // 한 페이지에 표시할 아이템 수
		let currentPage = 1;

		const $wishlistGrid = $('.wishlist-grid');
		const cards = $wishlistGrid.find('.wishlist-card').toArray();

		function renderPage(page) {
			$(cards).hide();
			const start = (page - 1) * itemsPerPage;
			const end = start + itemsPerPage;

			$(cards).slice(start, end).show();
			renderPagination();
		}

	    function renderPagination() {
	        const totalPages = Math.ceil(cards.length / itemsPerPage);
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

		// 초기 페이지 렌더링
		renderPage(currentPage);
	});
</script>

</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

	<div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">찜 리스트</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="/personal/mainPage">Home</a></li>
            <li class="current">찜 리스트</li>
          </ol>
        </nav>
      </div>
	</div><section id="account" class="account section">

      <div class="container" data-aos="fade-up" data-aos-delay="100">
        <div class="row g-4">
          <div class="col-lg-3">
            <div class="profile-menu collapse d-lg-block" id="profileMenu">
             <div class="user-info" data-aos="fade-right">
                <h4>${name} <span class="status-badge"><i class="bi bi-shield-check"></i></span></h4>
                <div class="user-status">
                  <i class="bi bi-award"></i>
                  <span>개인회원</span>
                </div>
              </div>
              
              <nav class="menu-nav">
                <ul class="nav flex-column" role="tablist">
                  <li class="nav-item">
                    <a class="nav-link ${ordersActive ? 'active' : ''}" href="<c:url value='/personal/orderList'/>">
                      <i class="bi bi-box-seam"></i>
                      <span>주문</span>
                      <span class="badge">${fn:length(orderGroupMap)}</span>
                    </a>
                    <a class="nav-link active" data-bs-toggle="tab" href="#wishlist">
                      <i class="bi bi-heart"></i>
                      <span>찜</span>
                      <span class="badge">${fn:length(wishList)}</span>
                    </a>
                    <a class="nav-link ${paymentsActive ? 'active' : ''}" href="<c:url value='/personal/paymentCard'/>">
                    <i class="bi bi-credit-card-2-front"></i>
                      <span>카드관리</span>
                      <span class="badge">${fn:length(paymentMethodList)}</span>
                    </a>
                  </li>
                </ul>
              </nav>
            </div>
          </div>

          <div class="col-lg-9">
            <div class="content-area">
              <div class="tab-content">
              
                <div class="tab-pane fade show active" id="wishlist">
                  <div class="section-header" data-aos="fade-up">
                    <h2>찜 리스트</h2>
                  </div>

                  <div class="wishlist-grid">
                    <c:forEach var="item" items="${wishList}">
					    <div class="wishlist-card" data-aos="fade-up" data-aos-delay="100">
					        <div class="wishlist-image">
					            <c:choose>
					                <c:when test="${not empty item.imagePath}">
					                    <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.productName}" loading="lazy" />
					                </c:when>
					                <c:otherwise>
					                    <span>이미지 없음</span>
					                </c:otherwise>
					            </c:choose>
					
					            <c:if test="${item.productStatus == 'GS003'}">
					                <div class="out-of-stock-badge">Out of Stock</div>
					            </c:if>
					
					            <button class="btn-remove" type="button" aria-label="Remove from wishlist" data-product-no="${item.productNo}">
					                <i class="bi bi-trash"></i>
					            </button>
					        </div>
					
					        <div class="wishlist-content">
					            <h4>
					                <c:choose>
					                    <c:when test="${item.productStatus == 'GS002'}">
					                        <a href="/personal/productOne?productNo=${item.productNo}">
					                            ${item.productName}
					                        </a>
					                    </c:when>
					                    <c:otherwise>
					                    	<a href="/personal/productOne?productNo=${item.productNo}">
					                            ${item.productName}
					                        </a>
					                        <span style="color: gray; cursor: default;">
						                    <br>(일시품절)
						                    </span>
					                    </c:otherwise>
					                </c:choose>
					            </h4>
					            <div class="product-meta">
					                <div class="price">
					                    <span class="current">
										  <fmt:formatNumber value="${item.price}" type="number" currencySymbol="" groupingUsed="true" />
										  원
										</span>
					                </div>
					            </div>
					            <c:if test="${item.productStatus == 'GS003'}">
					                <button type="button" class="btn-notify">Notify When Available</button>
					            </c:if>
					        </div>
					    </div>
					</c:forEach>
                  </div>
                  <div id="pagination" class="category-pagination justify-content-center mt-4"></div>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>

    </section><a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
	
</main>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>