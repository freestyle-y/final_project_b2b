<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 내역</title>
<style>
    table {
        width: 50%;
        border-collapse: collapse;
        text-align: center;
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
	
	<h1>문의 내역</h1>
	<table border="1">
		<tr>
			<th>번호</th>
			<th>제목</th>
		</tr>
		
		<c:forEach var="qna" items="${QNAList}">
			<tr>
				<td>${qna.boardNo}</td>
				<td><a href="/member/QNAOne?boardNo=${qna.boardNo}">${qna.boardTitle}</a></td>
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