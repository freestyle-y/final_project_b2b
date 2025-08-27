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
		body {
			font-family: Arial, sans-serif;
			background-color: #f4f4f4;
			margin: 0;
			padding: 0;
		}

		.review-container {
			margin-top: 60px;
			padding: 0 20px;
		}

		.review-card {
			background-color: #fff;
			border-radius: 10px;
			padding: 20px;
			margin-bottom: 30px;
			box-shadow: 0 2px 6px rgba(0, 0, 0, 0.1);
			max-width: 800px;
			margin-left: auto;
			margin-right: auto;
		}

		.review-card .name {
			font-weight: bold;
			margin-bottom: 8px;
		}

		.review-card .product {
			font-size: 1.1em;
			margin-bottom: 5px;
			color: #333;
		}

		.review-card .option {
			font-size: 0.9em;
			color: #777;
			margin-bottom: 8px;
		}

		.review-card .content {
			margin-bottom: 10px;
		}

		.review-card .grade i {
			color: #f39c12;
			font-size: 18px;
			margin-right: 2px;
		}

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

		/* 페이징 버튼 스타일 */
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

	<div class="review-container">
		<!-- 검색 입력창은 여기서 자바스크립트로 추가할 수도 있고 JSP 내에서 넣을 수도 있음 -->
		<c:forEach var="item" items="${reviewList}">
			<div class="review-card">
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

				<!-- 상품명 -->
				<div class="product">${item.productName}</div>

				<!-- 옵션 -->
				<div class="option">${item.optionNameValue}</div>

				<!-- 후기 내용 -->
				<div class="content">${item.review}</div>

				<!-- 별점 표시 -->
				<div class="grade">
					<c:set var="grade" value="${item.grade}" />
					<c:set var="fullStars" value="${fn:substringBefore(grade, '.')}" />
					<c:set var="decimal" value="${grade - fullStars}" />
					<c:set var="hasHalf" value="${decimal >= 0.5}" />
					<c:set var="emptyStars" value="${5 - fullStars - (hasHalf ? 1 : 0)}" />

					<!-- 꽉 찬 별 -->
					<c:forEach begin="1" end="${fullStars}" var="i">
						<i class="fas fa-star"></i>
					</c:forEach>

					<!-- 반 별 -->
					<c:if test="${hasHalf}">
						<i class="fas fa-star-half-alt"></i>
					</c:if>

					<!-- 빈 별 -->
					<c:forEach begin="1" end="${emptyStars}" var="i">
						<i class="far fa-star"></i>
					</c:forEach>
				</div>
			</div>
		</c:forEach>
	</div>
	
	</main>
	
	<!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>
	
	<!-- jQuery CDN -->
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$(document).ready(function () {
			const itemsPerPage = 5;
			let currentPage = 1;

			const container = $('.review-container');
			const cards = container.find('.review-card').toArray();
			let filteredCards = cards;

			function renderPage(page) {
				container.find('.review-card').hide();
				const start = (page - 1) * itemsPerPage;
				const end = start + itemsPerPage;

				$(filteredCards).slice(start, end).show();
				renderPagination();
			}

			function renderPagination() {
				$('#pagination').remove();
				const totalPages = Math.ceil(filteredCards.length / itemsPerPage);
				const $pagination = $('<div id="pagination" class="pagination"></div>');
				for (let i = 1; i <= totalPages; i++) {
					const $btn = $('<button>').text(i);
					if (i === currentPage) $btn.addClass('active');
					$btn.on('click', function () {
						currentPage = i;
						renderPage(currentPage);
					});
					$pagination.append($btn);
				}
				container.after($pagination);
			}

			function filterCards(keyword) {
				filteredCards = cards.filter(card => {
					const name = $(card).find('.product').text().toLowerCase();
					return name.includes(keyword.toLowerCase());
				});
				currentPage = 1;
				renderPage(currentPage);
			}

			// 검색 입력창 생성 및 이벤트 바인딩
			const $search = $('<input type="text" id="search-input" placeholder="상품명 검색...">').on('input', function () {
				filterCards($(this).val());
			});

			container.before($search);

			// 초기 페이지 렌더링
			renderPage(currentPage);
		});
	</script>

</body>
</html>