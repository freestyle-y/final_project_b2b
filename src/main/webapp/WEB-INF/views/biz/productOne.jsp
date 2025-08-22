<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업용 상품 상세</title>

<!-- Font Awesome for star icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" />

<style>
    /* 리뷰 카드 스타일 */
    .review-card {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 16px;
        margin-bottom: 20px;
        max-width: 800px;
    }

    .review-card .name {
        font-weight: bold;
        margin-bottom: 4px;
    }

    .review-card .product {
        color: #333;
        font-size: 1.1em;
        margin-bottom: 4px;
    }

    .review-card .option {
        font-size: 0.9em;
        color: #666;
        margin-bottom: 6px;
    }

    .review-card .content {
        margin-bottom: 10px;
    }

    .review-card .grade i {
        color: #f39c12;
        font-size: 18px;
        margin-right: 2px;
    }

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
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h2>${product.productName}</h2>

<!-- 평균 평점 및 리뷰 -->
<div id="review-summary">
    <h3>상품 리뷰</h3>
    <p><strong>평균 평점:</strong> ${avgProductRate} / 5</p>

    <!-- 정렬 드롭다운 -->
    <select id="sort-select">
        <option value="high">별점 높은순</option>
        <option value="low">별점 낮은순</option>
    </select>

    <!-- 리뷰 리스트 -->
    <div id="review-list">
        <c:forEach var="item" items="${productReview}">
            <div class="review-card" data-grade="${item.grade}">
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

                <div class="product">${item.productName}</div>
                <div class="option">옵션: ${item.optionNameValue}</div>
                <div class="content">${item.review}</div>

                <!-- 별점 -->
                <div class="grade">
                    <c:set var="grade" value="${item.grade}" />
                    <c:set var="fullStars" value="${fn:substringBefore(grade, '.')}" />
                    <c:set var="decimal" value="${grade - fullStars}" />
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
            </div>
        </c:forEach>

        <c:if test="${empty productReview}">
            <p>등록된 리뷰가 없습니다.</p>
        </c:if>
    </div>

    <!-- 페이징 영역 -->
    <div id="review-pagination" class="pagination"></div>
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function() {
    const itemsPerPage = 5;
    let currentPage = 1;

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

    // 초기 실행
    initReviewPagination();
});
</script>

</body>
</html>