<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>자주 묻는 질문</title>
<style>
	body { font-family: Roboto, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial, sans-serif; }
</style>
</head>
<body class="faq-page">

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

	<main class="main">

		<!-- Page Title -->
		<div class="page-title light-background">
			<div class="container d-lg-flex justify-content-between align-items-center">
				<h1 class="mb-2 mb-lg-0">자주 묻는 질문</h1>
				<nav class="breadcrumbs">
					<ol>
						<li><%@include file="/WEB-INF/common/home.jsp"%></li>
						<li class="current">자주 묻는 질문</li>
					</ol>
				</nav>
			</div>
		</div>
		<!-- End Page Title -->

		<!-- Faq Section -->
		<section id="faq" class="faq section">

			<div class="container" data-aos="fade-up" data-aos-delay="100">

				<div class="row gy-4 justify-content-between">
					<div class="col-lg-8">
						<div class="faq-list">
						<c:forEach var="faq" items="${FAQList}">
							<div class="faq-item" data-aos="fade-up" data-aos-delay="100">
								<h3>Q. ${faq.boardTitle}</h3>
								<div class="faq-content">
									<p>A. ${faq.boardContent}</p>
								</div>
								<i class="bi bi-plus faq-toggle"></i>
							</div>
							<!-- End FAQ Item-->

						</c:forEach>
						</div>

					</div>

					<div class="col-lg-4" data-aos="fade-up" data-aos-delay="200">
						<div class="faq-card">
							<i class="bi bi-chat-dots-fill"></i>
							<h3 class="my-4">찾으시는 답변이 없으신가요?</h3>
							<p style="text-align:left;">
								고객님의 소중한 문의는 언제든 환영합니다.<br><br>
								궁금하신 점이 있다면 고객센터를 통해 문의해 주세요.
								전문 상담원이 신속하고 정확하게 도와드리겠습니다.<br><br>
								1:1 문의를 남겨주시면 확인 후 빠른 시간 내에 답변을 드리며,
								더 나은 서비스를 제공할 수 있도록 항상 노력하겠습니다.
							</p>
							<a href="/member/QNAList" class="btn btn-primary mt-4">1:1 문의</a>
						</div>
					</div>
				</div>

			</div>

		</section>
		<!-- /Faq Section -->

	</main>

	<!-- 페이징 영역 -->
	<div class="category-pagination">
		<nav>
			<ul class="justify-content-center">
				<!-- 이전 버튼 -->
				<c:if test="${page.hasPrevBlock()}">
					<li>
						<a href="?currentPage=${page.startPage - 1}&searchWord=${page.searchWord}">
							<i class="bi bi-chevron-left"></i>
						</a>
					</li>
				</c:if>

				<!-- 페이지 번호 -->
				<c:forEach begin="${page.startPage}" end="${page.endPage}" var="i">
					<li>
						<a href="?currentPage=${i}&searchWord=${page.searchWord}" class="${i == page.currentPage ? 'active' : ''}">${i}</a>
					</li>
				</c:forEach>

				<!-- 다음 버튼 -->
				<c:if test="${page.hasNextBlock()}">
					<li>
						<a href="?currentPage=${page.endPage + 1}&searchWord=${page.searchWord}">
							<i class="bi bi-chevron-right"></i>
						</a>
					</li>
				</c:if>
			</ul>
		</nav>
	</div>

	<!-- 검색 영역 -->
	<section id="category-header" class="category-header section pt-0">
		<div class="filter-container mb-4" data-aos="fade-up" data-aos-delay="100">
			<div class="filter-item search-form">
				<div class="row justify-content-center">
					<div class="col-md-5 col-lg-4">
						<div class="input-group w-50 mx-auto">
							<input type="text" class="form-control" id="searchWord" value="${page.searchWord}" placeholder="제목 검색" aria-label="검색">
							<button type="button" class="btn search-btn" id="searchBtn">
								<i class="bi bi-search"></i>
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
	</section>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
	$(document).ready(function() {
		// 검색 기능
		function targetSearch() {
			const searchWord = $('#searchWord').val();
			const url = new URL(window.location.href);

			url.searchParams.set('searchWord', searchWord);
			url.searchParams.set('currentPage', 1);

			location.href = url.toString();
		}

		// 버튼 클릭 시 검색
		$('#searchBtn').click(targetSearch);

		// 엔터 키 입력 시 검색
		$('#searchWord').keypress(function(e) {
			if (e.which === 13) { // 13 = Enter 키 코드
				targetSearch();
			}
		});
	});
</script>

</body>
</html>