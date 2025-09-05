<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>공지사항 상세</title>
<style>
	body { font-family: Roboto, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial, sans-serif; }
	.list-inline-item + .list-inline-item::before {
		content: "";
		display: inline-block;
		width: 1px;
		height: 0.9em;
		background: #ccc;
		margin: 0 8px 0 0; /* 오른쪽만 여백 */
		vertical-align: middle;
	}
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">
	
	<!-- Page Title -->
	<div class="page-title light-background">
		<div class="container d-lg-flex justify-content-between align-items-center">
			<h1 class="mb-2 mb-lg-0">공지사항</h1>
			<nav class="breadcrumbs">
				<ol>
					<li><%@include file="/WEB-INF/common/home.jsp"%></li>
					<li class="current">공지사항</li>
				</ol>
			</nav>
		</div>
	</div>
	<!-- End Page Title -->

	<div class="container my-4">
		<c:forEach var="notice" items="${noticeOne}">
		<div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
			<!-- 제목 -->
			<h3 class="mb-0">${notice.boardTitle}</h3>
			<ul class="list-inline mb-0 text-muted small">
				<!-- 작성일시 -->
				<li class="list-inline-item">${notice.createDate}</li>
				<!-- 조회수 -->
				<li class="list-inline-item">조회 <span>${notice.viewCount}</span></li>
			</ul>
		</div>
		
		<!-- 본문 -->
		<div class="border-bottom pb-2 mb-3">
			<p>${notice.boardContent}</p>
		</div>
		</c:forEach>
		
		<div class="text-start">
			<a href="/public/noticeList" class="btn btn-primary">목록</a>
		</div>
	</div>
	
</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>