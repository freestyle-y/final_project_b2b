<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>고객센터</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

	<!-- Page Title -->
	<div class="page-title light-background">
		<div class="container d-lg-flex justify-content-between align-items-center">
			<h1 class="mb-2 mb-lg-0">고객센터</h1>
			<nav class="breadcrumbs">
				<ol>
					<li><%@include file="/WEB-INF/common/home.jsp"%></li>
					<li class="current">Helpdesk</li>
				</ol>
			</nav>
		</div>
	</div>
	<!-- End Page Title -->

	<!-- Support Section -->
	<section id="support" class="support section">

		<div class="container" data-aos="fade-up">

			<!-- Support Header -->
			<div class="support-header" data-aos="fade-up">
				<div class="header-content">
					<h2>고객센터</h2>
					<p>자주 묻는 질문과 1:1 문의, 공지사항을 통해 도움을 받으실 수 있습니다.</p>
				</div>
			</div>

			<!-- Quick Support Actions -->
			<div class="quick-support" data-aos="fade-up" data-aos-delay="100">
				<div class="action-item live-chat">
					<div class="action-content">
						<i class="bi bi-chat-text"></i>
						<h4>자주 묻는 질문</h4>
						<p>궁금한 내용을 빠르게 확인하세요.</p>
						<a href="/public/FAQList" class="action-button">FAQ 보기</a>
					</div>
				</div>

				<div class="action-item email">
					<div class="action-content">
						<i class="bi bi-chat-dots"></i>
						<h4>1:1 문의</h4>
						<p>해결되지 않은 문제는 직접 문의하세요.</p>
						<a href="/member/QNAList" class="action-button">문의하기</a>
					</div>
				</div>

				<div class="action-item phone">
					<div class="action-content">
						<i class="bi bi-megaphone"></i>
						<h4>공지사항</h4>
						<p>최신 소식과 안내를 확인하세요.</p>
						<a href="/public/noticeList" class="action-button">공지사항 보기</a>
					</div>
				</div>
			</div>
		</div>

	</section>
	<!-- /Support Section -->

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>