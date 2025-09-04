<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>상품 목록</title>
<style>
	.pagination {
	    margin-top: 20px;
	    text-align: center;
	    display: block;
	    width: 100%;
	    margin-left: 10%;
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function () {
    let allProducts = [];
    const itemsPerPage = 6;
    let currentPage = 1;
    let filteredProducts = [];

    // 초기 상품 데이터 수집 (기존에 #product-container .product-card가 있으면)
    $('#product-container > div.col-6.col-xl-4').each(function() {
        allProducts.push({
            productName: $(this).data('name'),
            price: parseInt($(this).data('price')),
            productStatus: $(this).data('status'),
            productNo: $(this).data('product-no'),
            imagePath: $(this).find('img').attr('src') || null
        });
    });

    filteredProducts = allProducts.slice();

    // 상품 리스트 렌더링 함수
    function renderPage(page) {
	    const container = $('#product-container');
	    container.empty();
	
	    const start = (page - 1) * itemsPerPage;
	    const end = start + itemsPerPage;
	    const pageItems = filteredProducts.slice(start, end);
	
	    pageItems.forEach(function(item) {
	        const soldOutClass = item.productStatus === "일시품절" ? "sold-out" : "";
	        const formattedPrice = item.price.toLocaleString('ko-KR');
	
	        const imageHtml = item.imagePath
	            ? '<img src="' + item.imagePath + '" alt="' + item.productName + '" class="main-image img-fluid" style="width: 100%; height: 150px; object-fit: cover;" />'
	            : '<span style="color: #ccc; font-size: 12px; display:flex; align-items:center; justify-content:center; height:150px;">이미지 없음</span>';
	
	        const productCardHtml =
	            '<div class="col-6 col-xl-4">' +
	                '<a href="/personal/productOne?productNo=' + item.productNo + '" style="text-decoration: none; color: inherit;">' +
	                    '<div class="product-card ' + soldOutClass + '" data-aos="zoom-in" ' +
	                        'data-name="' + item.productName + '" ' +
	                        'data-price="' + item.price + '" ' +
	                        'data-status="' + item.productStatus + '" ' +
	                        'data-product-no="' + item.productNo + '">' +
	
	                        '<div class="product-image" style="position:relative; width: 100%; height: 150px; display: flex; align-items: center; justify-content: center;">' +
	                            imageHtml +
	                            '<div class="product-overlay">' +
	                                '<div class="product-actions">' +
	                                    '<button type="button" class="action-btn" data-bs-toggle="tooltip" title="Quick View">' +
	                                        '<i class="bi bi-eye"></i>' +
	                                    '</button>' +
	                                    '<button type="button" class="action-btn" data-bs-toggle="tooltip" title="Add to Cart">' +
	                                        '<i class="bi bi-cart-plus"></i>' +
	                                    '</button>' +
	                                '</div>' +
	                            '</div>' +
	                        '</div>' +
	
	                        '<div class="product-details">' +
	                            '<div class="product-category"></div>' +
	                            '<h4 class="product-title">' + item.productName + '</h4>' +
	                            '<div class="product-meta">' +
	                                '<div class="product-price">' + formattedPrice + ' 원</div>' +
	                            '</div>' +
	                            '<div class="product-status">' + item.productStatus + '</div>' +
	                        '</div>' +
	
	                    '</div>' +
	                '</a>' +
	            '</div>';
	
	        container.append(productCardHtml);
	    });
	
	    renderPagination();
	}

    // 페이징 버튼 렌더링
    function renderPagination() {
        const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
        const pagination = $('#pagination');
        pagination.empty();

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

    // 검색 필터
    $('#productSearch').on('input', function() {
        const keyword = $(this).val().toLowerCase();
        filteredProducts = allProducts.filter(item => item.productName.toLowerCase().includes(keyword));
        currentPage = 1;
        renderPage(currentPage);
    });

    $('.category-tree').on('show.bs.collapse', '.subcategory-list', function () {
        const collapseId = $(this).attr('id'); 
        const match = collapseId.match(/categories-(\d+)-subcategories/);
        if (!match) return;

        const categoryId = match[1];
        const $subCategoryList = $(this);

        // 중분류 리스트가 비어있으면 AJAX 호출해서 채우기
        if ($subCategoryList.children().length === 0) {
            $.ajax({
                url: '/product/byCategory?parentId=' + categoryId,
                type: 'GET',
                success: function(data) {
                    let subCategoryHtml = '';
                    data.middleCategoryList.forEach(function(cat) {
                        subCategoryHtml += '<li><a href="javascript:void(0)" class="subcategory-link" data-id="' + cat.categoryId + '">' + cat.categoryName + '</a></li>';
                    });
                    $subCategoryList.html(subCategoryHtml);
                },
                error: function() {
                    alert('중분류를 불러오는 데 실패했습니다.');
                }
            });
        }

        // 상품 리스트는 항상 갱신 (중복 호출 X)
        $.ajax({
            url: '/product/byCategory?parentId=' + categoryId,
            type: 'GET',
            success: function(data) {
                allProducts = data.productList.map(function(item){
                    return {
                        productName: item.productName,
                        price: parseInt(item.price),
                        productStatus: item.productStatus,
                        productNo: item.productNo,
                        imagePath: item.imagePath || null
                    };
                });
                filteredProducts = allProducts.slice();
                currentPage = 1;
                renderPage(currentPage);
            },
            error: function() {
                alert('상품을 불러오는 데 실패했습니다.');
            }
        });
    });


    // 중분류 클릭 시 상품 리스트 AJAX 호출
    $('.category-tree').on('click', '.subcategory-link', function() {
        const middleCategoryId = $(this).data('id');

        $.ajax({
            url: '/product/byCategory?middleId=' + middleCategoryId,
            type: 'GET',
            success: function(data) {
                allProducts = data.productList.map(function(item){
                    return {
                        productName: item.productName,
                        price: parseInt(item.price),
                        productStatus: item.productStatus,
                        productNo: item.productNo,
                        imagePath: item.imagePath || null
                    };
                });
                filteredProducts = allProducts.slice();
                currentPage = 1;
                renderPage(currentPage);
            },
            error: function() {
                alert('상품을 불러오는 데 실패했습니다.');
            }
        });
    });

    // 초기 상품 렌더링
    renderPage(currentPage);
});

</script>

</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

    <!-- Page Title -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">카테고리</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="/personal/mainPage">Home</a></li>
            <li class="current">카테고리</li>
          </ol>
        </nav>
      </div>
    </div><!-- End Page Title -->

    <div class="container">
      <div class="row">

        <div class="col-lg-4 sidebar">

          <div class="widgets-container">

            <!-- Product Categories Widget -->
            <div class="product-categories-widget widget-item">

              <h3 class="widget-title">카테고리</h3>

              <ul class="category-tree list-unstyled mb-0">

                <c:forEach var="major" items="${majorCategoryList}">
				    <li class="category-item">
				      <div class="d-flex justify-content-between align-items-center category-header collapsed"
				           data-bs-toggle="collapse"
				           data-bs-target="#categories-${major.categoryId}-subcategories"
				           aria-expanded="false"
				           aria-controls="categories-${major.categoryId}-subcategories"
				           data-id="${major.categoryId}">
				        <a href="javascript:void(0)" class="category-link">${major.categoryName}</a>
				        <span class="category-toggle">
				          <i class="bi bi-chevron-down"></i>
				          <i class="bi bi-chevron-up"></i>
				        </span>
				      </div>
				      <ul id="categories-${major.categoryId}-subcategories" class="subcategory-list list-unstyled collapse ps-3 mt-2">
				        <!-- 중분류 AJAX로 채워질 곳 -->
				      </ul>
				    </li>
				  </c:forEach>
              </ul>

            </div><!--/Product Categories Widget -->
          </div>
        </div>

        <div class="col-lg-8">

          <!-- Category Header Section -->
          <section id="category-header" class="category-header section">

            <div class="container" data-aos="fade-up">

              <!-- Filter and Sort Options -->
              <div class="filter-container mb-4" data-aos="fade-up" data-aos-delay="100">
                <div class="row g-3">
                  <div class="col-12 col-md-6 col-lg-4">
                    <div class="filter-item search-form">
                      <label for="productSearch" class="form-label mb-2">Search Products</label>
                       <input type="text" class="form-control" id="productSearch" placeholder="상품명 검색..." aria-label="Search for products">
                    </div>
                  </div>
                </div>

                <div class="row mt-3">
                  <div class="col-12" data-aos="fade-up" data-aos-delay="200">
                    <div class="active-filters">
                      <span class="active-filter-label">Active Filters:</span>
                      <div class="filter-tags">
                        <button class="clear-all-btn">Clear All</button>
                      </div>
                    </div>
                  </div>
                </div>

              </div>

            </div>

          </section><!-- /Category Header Section -->

          <!-- Category Product List Section -->
          <section id="category-product-list" class="category-product-list section">

            <div class="container" data-aos="fade-up" data-aos-delay="100">

              <div class="row g-4">
                <!-- Product -->
                <div id="product-container" class="row g-4">
				    <c:forEach var="item" items="${productList}">
					    <div class="col-6 col-xl-4"
					         data-name="${item.productName}"
					         data-price="${item.price}"
					         data-status="${item.productStatus}"
					         data-product-no="${item.productNo}"
					         data-image="${pageContext.request.contextPath}${item.imagePath}">
					         
					        <a href="/personal/productOne?productNo=${item.productNo}" style="text-decoration: none; color: inherit;">
					            <div class="product-card ${item.productStatus == '일시품절' ? 'sold-out' : ''}" data-aos="zoom-in">
					
					                <div class="product-image" style="position: relative; width: 100%; height: 150px; display: flex; align-items: center; justify-content: center;">
					                    <c:choose>
					                        <c:when test="${not empty item.imagePath}">
					                            <img src="${pageContext.request.contextPath}${item.imagePath}" class="main-image img-fluid" alt="${item.productName}" style="width: 100%; height: 100%; object-fit: cover;" />
					                        </c:when>
					                        <c:otherwise>
					                            <span style="color: #ccc; font-size: 12px;">이미지 없음</span>
					                        </c:otherwise>
					                    </c:choose>
					
					                    <div class="product-overlay">
					                        <div class="product-actions">
					                            <button type="button" class="action-btn" data-bs-toggle="tooltip" title="Quick View">
					                                <i class="bi bi-eye"></i>
					                            </button>
					                            <button type="button" class="action-btn" data-bs-toggle="tooltip" title="Add to Cart">
					                                <i class="bi bi-cart-plus"></i>
					                            </button>
					                        </div>
					                    </div>
					                </div>
					                <div class="product-details">
					                    <div class="product-category">${item.categoryName != null ? item.categoryName : ''}</div>
					                    <h4 class="product-title">
					                        <a href="/personal/productOne?productNo=${item.productNo}" style="color: inherit; text-decoration: none;">
					                            ${item.productName}
					                        </a>
					                    </h4>
					                    <div class="product-meta">
					                        <div class="product-price">${item.price} 원</div>
					                    </div>
					                    <div class="product-status">${item.productStatus}</div>
					                </div>
					
					            </div>
					        </a>
					    </div>
					</c:forEach>
				</div>               
              </div>
            </div>

          </section><!-- /Category Product List Section -->
        </div>
      </div>
    </div>


	<!-- Scroll Top -->
  	<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
	
	<div class="pagination" id="pagination"></div>
</main>



<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>