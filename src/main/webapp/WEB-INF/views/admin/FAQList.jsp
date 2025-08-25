<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자주 묻는 질문</title>
<style>
    table {
        width: 70%;
        border-collapse: collapse;
        text-align: left;
        margin: auto;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
    }
    .pagination {
        margin: 20px auto;
        text-align: center;
    }
    .pagination a {
        display: inline-block;
        margin: 0 5px;
        padding: 5px 10px;
        border: 1px solid #ccc;
        text-decoration: none;
        color: #333;
    }
    .pagination a.active {
        background: #333;
        color: #fff;
        font-weight: bold;
    }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
	
	<h1>자주 묻는 질문</h1>
	
	<a href="/public/FAQList">자주 묻는 질문</a> /
	<a href="/member/QNAList">문의 내역</a> /
	<a href="/member/QNAWrite">1:1 문의</a> /
	<a href="/public/noticeList">공지사항</a>
	
	<table>
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일시</th>
				<th>수정자</th>
				<th>수정일시</th>
				<th>사용여부</th>
				<th>조회수</th>
			</tr>
			<c:forEach var="faq" items="${FAQList}">
				<tr>
					<td>${faq.boardNo}</td>
					<td><a href="/admin/FAQOne?boardNo=${faq.boardNo}">${faq.boardTitle}</a></td>
					<td>${faq.createUser}</td>
					<td>${faq.createDate}</td>
					<td>${faq.updateUser}</td>
					<td>${faq.updateDate}</td>
					<td>${faq.useStatus}</td>
					<td>${faq.viewCount}</td>
				</tr>
			</c:forEach>
	</table>

	<!-- 페이징 영역 -->
	<div class="pagination">
		<c:if test="${page.hasPrevBlock()}">
			<a href="?currentPage=${page.startPage - 1}&searchWord=${page.searchWord}">이전</a>
		</c:if>

		<c:forEach begin="${page.startPage}" end="${page.endPage}" var="i">
			<a href="?currentPage=${i}&searchWord=${page.searchWord}" class="${i == page.currentPage ? 'active' : ''}">${i}</a>
		</c:forEach>

		<c:if test="${page.hasNextBlock()}">
			<a href="?currentPage=${page.endPage + 1}&searchWord=${page.searchWord}">다음</a>
		</c:if>
	</div>

	<!-- 검색 영역 -->
	<div style="text-align: center;">
		<input type="text" id="searchWord" value="${page.searchWord}" placeholder="제목 검색">
		<button type="button" id="searchBtn">검색</button>
	</div>

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

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>