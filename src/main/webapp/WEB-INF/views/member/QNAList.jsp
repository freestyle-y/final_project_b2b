<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>문의 내역</title>
<!-- font -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<!-- Bootstrap5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<style>
	body { font-family: "SUIT", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial, sans-serif;
		background: #fff; }
	a { text-decoration: none; }
	.board-wrap { max-width: 1040px; margin: 0 auto; padding: 24px 12px; }
	.board-tools { display:flex; gap:8px; align-items:center; justify-content:flex-end; margin-bottom:12px; }
	.board-total { color:#6c757d; font-size:.9rem; margin-right:auto; }
	.board-search { display:flex; gap:6px; }
	.board-table { width:100%; border-top:2px solid #111; }
	.board-table th, .board-table td { padding:14px 12px; border-bottom:1px solid #e9ecef; }
	.col-no { width:80px; text-align:center; color:#666; }
	.col-date { width:250px; text-align:center; color:#666; }
	.col-title { text-align:left; }
	.title-ellipsis { display:inline-block; max-width:100%; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; vertical-align:bottom; }
	.badge-status { margin-left:6px; vertical-align:middle; }
	.lock { margin-left:6px; color:#adb5bd; }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

	<!-- Page Title -->
	<div class="page-title light-background">
		<div class="container d-lg-flex justify-content-between align-items-center">
			<h1 class="mb-2 mb-lg-0">문의 내역</h1>
			<nav class="breadcrumbs">
				<ol>
					<li><%@include file="/WEB-INF/common/home.jsp"%></li>
					<li class="current">QNA</li>
				</ol>
			</nav>
		</div>
	</div>
	<!-- End Page Title -->
		
	<div class="board-wrap">
	
		<!-- 총 건수 / 문의 등록 페이지 / 검색 -->
		<div class="board-tools">
			<div class="board-total">총 ${page.totalCount}건</div>
		    <a href="/member/QNAWrite" class="btn btn-primary btn-sm">
				<i class="bi bi-pencil-square"></i> 새 문의
			</a>
			<div class="board-search">
				<select class="form-select form-select-sm" style="width: 110px;">
					<option selected>제목</option>
					<!-- ※ 현재는 제목 검색만 사용. 서버에서 필드 분기 안 하면 고정 유지 -->
				</select>
				<input type="text" id="searchWord" value="${page.searchWord}" class="form-control form-control-sm" placeholder="검색어 입력">
				<button type="button" id="searchBtn" class="btn btn-dark btn-sm">
					<i class="bi bi-search"></i>
				</button>
			</div>
		</div>
		
		<!-- 목록 테이블 -->
		<table class="board-table">
			<thead>
				<tr>
					<th class="col-no">번호</th>
					<th class="col-title">제목</th>
					<th class="col-date">등록일</th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${empty QNAList}">
					<tr>
						<td colspan="4" class="text-center py-5 text-muted">
							<i class="bi bi-inbox"></i> 등록된 문의가 없습니다.
						</td>
					</tr>
				</c:if>

				<c:forEach var="qna" items="${QNAList}">
					<c:choose>
						<c:when test="${qna.commentCount > 0}">
							<c:set var="statusText" value="답변 완료" />
							<c:set var="statusClass" value="success" />
						</c:when>
						<c:otherwise>
							<c:set var="statusText" value="답변 대기" />
							<c:set var="statusClass" value="secondary" />
						</c:otherwise>
					</c:choose>

					<tr>
						<td class="col-no">${qna.boardNo}</td>
						<td class="col-title">
							<a href="/member/QNAOne?boardNo=${qna.boardNo}" class="text-decoration-none text-dark">
								<span class="title-ellipsis">${qna.boardTitle}</span>
							</a>
							<span class="badge bg-${statusClass} badge-status">${statusText}</span>
						</td>
						<td class="col-date">${qna.createDate}</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>

		<!-- 페이징 영역 -->
		<div class="category-pagination mt-4">
			<nav>
				<ul class="justify-content-center">
					<!-- 이전 버튼 -->
					<c:if test="${page.hasPrevBlock()}">
						<li>
							<a href="?currentPage=${page.startPage - 1}&searchWord=${page.searchWord}">
								<i class="bi bi-arrow-left"></i>
								<span class="d-none d-sm-inline">이전</span>
							</a>
						</li>
					</c:if>
	
					<!-- 페이지 번호 -->
					<c:forEach begin="${page.startPage}" end="${page.endPage}" var="i">
						<li class="${i == page.currentPage ? 'active' : ''}">
							<a href="?currentPage=${i}&searchWord=${page.searchWord}">${i}</a>
						</li>
					</c:forEach>
	
					<!-- 다음 버튼 -->
					<c:if test="${page.hasNextBlock()}">
						<li>
							<a href="?currentPage=${page.endPage + 1}&searchWord=${page.searchWord}">
								<span class="d-none d-sm-inline">다음</span>
								<i class="bi bi-arrow-right"></i>
							</a>
						</li>
					</c:if>
				</ul>
			</nav>
		</div>
		
	</div>
	
</main>

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