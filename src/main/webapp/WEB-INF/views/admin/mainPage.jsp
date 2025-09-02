<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>관리자 메인 페이지</title>
<style>
	body { font-family: Roboto, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial, sans-serif; }
</style>
</head>
<body class="index-page">

<!-- 공통 헤더 -->
<%@ include file="/WEB-INF/common/header/header.jsp"%>

	<main class="main">
		<div class="container py-5">

			<div class="text-center mb-5">
				<h1 class="fw-bold">
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<span><sec:authentication property="name" /> 관리자님, 환영합니다!</span>
					</sec:authorize>
				</h1>
				<p class="text-secondary fs-5">관리 항목을 빠르고 정확하게 처리하세요.</p>
			</div>

			<!-- 그리드 -->
			<div class="row g-4">

				<!-- 회원 관리 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-people-fill fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">회원 관리</h5>
						<a href="/admin/manageUser" class="stretched-link"></a>
					</div>
				</div>

				<!-- 상품 요청 목록 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-bag-plus fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">상품 요청 목록</h5>
						<a href="/admin/productRequestList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 견적서 목록 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-receipt fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">견적서 목록</h5>
						<a href="/admin/quotationList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 계약서 목록 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-file-earmark-text fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">계약서 목록</h5>
						<a href="/admin/contractList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 잔금 확인 페이지 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-cash-coin fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">잔금 확인</h5>
						<a href="/admin/finalPaymentHistory" class="stretched-link"></a>
					</div>
				</div>

				<!-- 컨테이너 목록 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-box-seam fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">컨테이너 목록</h5>
						<a href="/admin/containerList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 회수 상품 목록 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-arrow-counterclockwise fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">회수 상품 목록</h5>
						<a href="/admin/recallProductList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 로그인 이력 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-clock-history fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">로그인 이력</h5>
						<a href="/admin/loginHistory" class="stretched-link"></a>
					</div>
				</div>

				<!-- 공지사항 관리 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-megaphone fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">공지사항</h5>
						<a href="/admin/noticeList" class="stretched-link"></a>
					</div>
				</div>

				<!-- QNA 관리 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<div class="position-relative d-inline-block mb-3">
							<i class="bi bi-chat-dots fs-2"></i>
							<c:if test="${not empty noCommentQnaCount}">
								<span class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">${noCommentQnaCount}</span>
							</c:if>
						</div>
						<h5 class="fw-semibold mb-0">문의 내역</h5>
						<a href="/admin/QNAList" class="stretched-link"></a>
					</div>
				</div>

				<!-- FAQ 관리 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-chat-text fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">자주 묻는 질문</h5>
						<a href="/admin/FAQList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 개인 회원 배송 관리 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-truck fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">개인 회원 배송 관리</h5>
						<a href="/admin/personalDeliveryList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 기업 회원 배송 관리 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-buildings fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">기업 회원 배송 관리</h5>
						<a href="/admin/bizDeliveryList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 알림 목록 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-bell fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">알림 목록</h5>
						<a href="/admin/alarmList" class="stretched-link"></a>
					</div>
				</div>

				<!-- 알림 등록 -->
				<div class="col-12 col-sm-6 col-md-4 col-lg-3">
					<div class="card h-100 text-center p-4 border-2 shadow-sm">
						<i class="bi bi-bell fs-2 mb-3"></i>
						<h5 class="fw-semibold mb-0">알림 등록</h5>
						<a href="/admin/alarmWrite" class="stretched-link"></a>
					</div>
				</div>

			</div>
		</div>
	</main>


	<!-- 공통 풋터 -->
<%@ include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>