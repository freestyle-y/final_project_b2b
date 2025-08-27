<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>상품 목록</title>
<style>
	body {
		font-family: Arial, sans-serif;
		padding: 20px;
		background-color: #f9f9f9;
	}

	a {
		text-decoration: none;
		color: inherit;
	}

	.category-list {
		display: flex;
		gap: 15px;
		margin-bottom: 30px;
		flex-wrap: wrap;
	}

	.category-list > div {
		background: none;
		border: none;
		padding: 0;
		cursor: pointer;
		font-weight: 600;
		user-select: none;
		transition: color 0.3s;
		display: inline-block;
		margin-right: 15px;
		font-size: 1em;
		border-radius: 0;
		box-shadow: none;
	}
	
	.category-list > div:hover {
		color: #0056b3;
		text-decoration: underline;
	}

	.product-list {
		display: grid;
		grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
		gap: 20px;
	}

	.product-card {
		background-color: white;
		border-radius: 8px;
		padding: 15px;
		box-shadow: 0 2px 5px rgba(0,0,0,0.1);
		transition: box-shadow 0.3s;
	}
	
	.product-card:hover {
		box-shadow: 0 5px 15px rgba(0,0,0,0.2);
	}
	
	.sold-out {
		background-color: #f0f0f0;
		color: #999;
		pointer-events: none; /* 클릭 비활성화 */
		cursor: default;
	}

	.product-name {
		font-weight: bold;
		margin-bottom: 10px;
		font-size: 1.1em;
		color: #000;
	}
	
	.product-price {
		color: #28a745;
		margin-bottom: 5px;
	}
	
	.product-status {
		font-size: 0.9em;
		color: #555;
	}

	#search-input {
	    padding: 10px;
	    width: 300px;
	    margin-bottom: 20px;
	    border-radius: 6px;
	    border: 1px solid #ccc;
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

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function () {
	let allProducts = [];
	const itemsPerPage = 5;
	let currentPage = 1;
	let filteredProducts = [];

	// 상품 초기 수집
	$('#product-container .product-card').each(function() {
	    allProducts.push({
	        productName: $(this).data('name'),
	        price: parseInt($(this).data('price')),
	        productStatus: $(this).data('status'),
	        productNo: $(this).data('product-no'),
	        imagePath: $(this).find('img').attr('src') || null
	    });
	});

	filteredProducts = allProducts.slice();

	// 페이지 렌더링
	function renderPage(page) {
	    const container = $('#product-container');
	    container.empty();
	    const start = (page - 1) * itemsPerPage;
	    const end = start + itemsPerPage;
	    const pageItems = filteredProducts.slice(start, end);

	    pageItems.forEach(function(item) {
	        const soldOutClass = item.productStatus === "일시품절" ? "sold-out" : "";
	        const formattedPrice = item.price.toLocaleString('ko-KR') + ' 원';

	        const imageHtml = item.imagePath
            ? '<img src="' + item.imagePath + '" alt="' + item.productName + '" style="width: 100%; height: 100%; object-fit: cover;" />'
            : '<span style="color: #ccc; font-size: 12px;">이미지 없음</span>';

            const productCardHtml =
	            '<div class="product-card ' + soldOutClass + '" ' +
	                'data-name="' + item.productName + '" ' +
	                'data-price="' + item.price + '" ' +
	                'data-status="' + item.productStatus + '" ' +
	                'data-product-no="' + item.productNo + '">' +

	                '<div class="product-image" style="width: 100%; height: 150px; display: flex; align-items: center; justify-content: center;">' +
	                    imageHtml +
	                '</div>' +

	                '<div class="product-name">' + item.productName + '</div>' +
	                '<div class="product-price">' + formattedPrice + '</div>' +
	                '<div class="product-status">' + item.productStatus + '</div>' +
	            '</div>';

	        const productHtml = item.productStatus === "일시품절"
	            ? productCardHtml
	            : '<a href="/biz/productOne?productNo=' + item.productNo + '" style="text-decoration: none; color: inherit;">' + productCardHtml + '</a>';

	        container.append(productHtml);
	    });

	    renderPagination();
	}

	
	function renderPagination() {
	    const totalPages = Math.ceil(filteredProducts.length / itemsPerPage);
	    const pagination = $('#pagination');
	    pagination.empty();

	    for (let i = 1; i <= totalPages; i++) {
	        const btn = $('<button>').text(i);
	        if (i === currentPage) btn.addClass('active');
	        btn.on('click', function () {
	            currentPage = i;
	            renderPage(currentPage);
	        });
	        pagination.append(btn);
	    }
	}

	
	$('#search-input').on('input', function () {
	    const keyword = $(this).val().toLowerCase();
	    filteredProducts = allProducts.filter(item => item.productName.toLowerCase().includes(keyword));
	    currentPage = 1;
	    renderPage(currentPage);
	});

	// 대분류 클릭
	$('.major-category-list > div').click(function () {
		const categoryId = $(this).data('id');

		$.ajax({
			url: '/product/byCategory?parentId=' + categoryId,
			type: 'get',
			success: function (data) {
				let categoryHtml = '';
				data.middleCategoryList.forEach(function (cat) {
					categoryHtml += '<div data-id="' + cat.categoryId + '">' + cat.categoryName + '</div>';
				});
				$('.middle-category-list').html(categoryHtml);

				allProducts = data.productList.map(function (item) {
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

				
				$('.middle-category-list > div').off('click').on('click', function () {
					const middleCategoryId = $(this).data('id');
					$.ajax({
						url: '/product/byCategory?middleId=' + middleCategoryId,
						type: 'get',
						success: function (data) {
							allProducts = data.productList.map(function (item) {
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
						error: function () {
							alert('상품을 불러오는 데 실패했습니다.');
						}
					});
				});
			},
			error: function () {
				alert('상품을 불러오는 데 실패했습니다.');
			}
		});
	});

	renderPage(currentPage);
});
</script>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

	<input type="text" id="search-input" placeholder="상품명 검색..." />

	<!-- 대분류 -->
	<div class="category-list major-category-list">
		<c:forEach var="item" items="${majorCategoryList}">
			<div data-id="${item.categoryId}">${item.categoryName}</div>
		</c:forEach>
	</div>

	<!-- 중분류 -->
	<div class="category-list middle-category-list"></div>

	<!-- 상품 리스트 -->
	<div id="product-container" class="product-list">
		<c:forEach var="item" items="${productList}">
			<c:choose>
				<c:when test="${item.productStatus == '일시품절'}">
					<!-- 일시품절: 링크 제거 -->
					<div class="product-card sold-out"
					     data-name="${item.productName}"
					     data-price="${item.price}"
					     data-status="${item.productStatus}"
					     data-product-no="${item.productNo}">
					     
						<!-- ✅ 썸네일 이미지 영역 -->
						<div class="product-image" style="width: 100%; height: 150px; display: flex; align-items: center; justify-content: center;">
							<c:choose>
								<c:when test="${not empty item.imagePath}">
									<img src="${pageContext.request.contextPath}${item.imagePath}"
									     alt="${item.productName}"
									     style="width: 100%; height: 100%; object-fit: cover;" />
								</c:when>
								<c:otherwise>
									<span style="color: #ccc; font-size: 12px;">이미지 없음</span>
								</c:otherwise>
							</c:choose>
						</div>
	
						<!-- 상품 정보 -->
						<div class="product-name">${item.productName}</div>
						<div class="product-price">${item.price}</div>
						<div class="product-status">${item.productStatus}</div>
					</div>
				</c:when>
	
				<c:otherwise>
					<!-- 판매중: 링크 적용 -->
					<a href="/biz/productOne?productNo=${item.productNo}" style="text-decoration: none; color: inherit;">
						<div class="product-card"
						     data-name="${item.productName}"
						     data-price="${item.price}"
						     data-status="${item.productStatus}"
						     data-product-no="${item.productNo}">
						     
							<!-- ✅ 썸네일 이미지 영역 -->
							<div class="product-image" style="width: 100%; height: 150px; display: flex; align-items: center; justify-content: center;">
								<c:choose>
									<c:when test="${not empty item.imagePath}">
										<img src="${pageContext.request.contextPath}${item.imagePath}"
										     alt="${item.productName}"
										     style="width: 100%; height: 100%; object-fit: cover;" />
									</c:when>
									<c:otherwise>
										<span style="color: #ccc; font-size: 12px;">이미지 없음</span>
									</c:otherwise>
								</c:choose>
							</div>
	
							<!-- 상품 정보 -->
							<div class="product-name">${item.productName}</div>
							<div class="product-price">${item.price}</div>
							<div class="product-status">${item.productStatus}</div>
						</div>
					</a>
				</c:otherwise>
			</c:choose>
		</c:forEach>
	</div>

	<div class="pagination" id="pagination"></div>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>