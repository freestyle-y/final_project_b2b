<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/common/head.jsp"%>
	<title>기업 메인 페이지</title>
<style>
	body {
	    font-family: Arial, sans-serif;
	    margin: 20px;
	}
	
	#search-input {
	    padding: 10px;
	    width: 300px;
	    margin-bottom: 20px;
	    border-radius: 6px;
	    border: 1px solid #ccc;
	}
	
	.product-container {
	    display: grid;
	    grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
	    gap: 20px;
	}
	
	.product-card {
	    border: 1px solid #ddd;
	    border-radius: 10px;
	    padding: 15px;
	    text-align: center;
	    box-shadow: 0 2px 6px rgba(0,0,0,0.1);
	    transition: transform 0.2s;
	    background-color: #fff;
	}
	
	.product-card:hover {
	    transform: translateY(-5px);
	    box-shadow: 0 6px 12px rgba(0,0,0,0.15);
	}
	
	.product-name {
	    font-size: 16px;
	    font-weight: bold;
	    margin: 10px 0;
	}
	
	.product-name a {
	    text-decoration: none;
	    color: black;
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
	
	<input type="text" id="search-input" placeholder="상품명 검색..." />
	
		<div class="product-container" id="product-container">
	    <c:forEach var="item" items="${productList}">
	        <div class="product-card" data-name="${item.productName}">
	
	            <div class="product-image" style="width: 100%; height: 150px; display: flex; justify-content: center; align-items: center;">
				    <c:choose>
				        <c:when test="${not empty item.imagePath}">
				            <img src="${pageContext.request.contextPath}${item.imagePath}" 
				                 alt="${item.productName}" 
				                 style="max-width: 100%; max-height: 100%; object-fit: contain;" />
				        </c:when>
				        <c:otherwise>
				            <!-- 비어 있는 이미지 박스 유지 -->
				            <span style="color: #ccc; font-size: 14px;">이미지 없음</span>
				        </c:otherwise>
				    </c:choose>
				</div>

	            <!-- 상품 이름 -->
	            <div class="product-name">
	                <c:choose>
	                    <c:when test="${item.productStatus == 'GS003'}">
	                        <span style="color:gray; cursor: default;">
	                            ${item.productName}<br>(일시품절)
	                        </span>
	                    </c:when>
	                    <c:otherwise>
	                        <a href="/biz/productOne?productNo=${item.productNo}">
	                            ${item.productName}
	                        </a>
	                    </c:otherwise>
	                </c:choose>
	            </div>
	
	            <!-- 찜 수 -->
	            <div class="wish-count">❤️ ${item.wishCount}</div>
	        </div>
	    </c:forEach>
	</div>
	
	<div class="pagination" id="pagination"></div>
	
	</main>
	
	<!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
	$(document).ready(function() {
	    const container = $('#product-container');
	    const cards = container.children('.product-card').toArray();
	    const itemsPerPage = 6;
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