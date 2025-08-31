<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>공지사항 상세</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

	<!-- Page Title -->
	<div class="page-title light-background">
		<div class="container d-lg-flex justify-content-between align-items-center">
			<h1 class="mb-2 mb-lg-0">공지사항 상세</h1>
			<nav class="breadcrumbs">
				<ol>
					<li><%@include file="/WEB-INF/common/home.jsp"%></li>
					<li class="current">Notice</li>
				</ol>
			</nav>
		</div>
	</div>
	<!-- End Page Title -->
	
	<div class="container my-4">
		<div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
			<!-- 제목 -->
			<h3 class="mb-0">${noticeOne.boardTitle}</h3>
			<ul class="list-inline mb-0 text-muted small">
				<!-- 작성일시 -->
				<li class="list-inline-item">${noticeOne.createDate}</li>
				<!-- 조회수 -->
				<li class="list-inline-item">조회 ${noticeOne.viewCount}</li>
			</ul>
		</div>
		
		<!-- 본문 -->
		<div class="border-bottom pb-2 mb-3">
			<p>${noticeOne.boardContent}</p>
		</div>
		
		<div class="text-start">
			<a href="/admin/noticeList" class="btn btn-primary">목록</a>
			<a href="/admin/noticeUpdate?boardNo=${noticeOne.boardNo}" class="btn btn-success">수정</a>
			<form action="/admin/noticeDelete" method="post" style="display: inline;">
				<input type="hidden" name="boardNo" value="${noticeOne.boardNo}">
				<button type="submit" class="btn btn-danger" onclick="return confirm('정말 삭제하시겠습니까?');">삭제</button>
			</form>
		</div>
	</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>