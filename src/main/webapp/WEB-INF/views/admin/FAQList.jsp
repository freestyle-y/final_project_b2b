<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>자주 묻는 질문 관리</title>
<!-- font -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<!-- Bootstrap5 + DataTables CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css" rel="stylesheet">
<style>
	body {
		font-family: "SUIT", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial, sans-serif;
		background: #fff;
	}
	
	a {
		text-decoration: none;
		color: inherit;
	}
	
	#table th #table td {
		text-align: center !important;
	}
	
	/* 테이블 헤더 가운데 정렬 */
	table.dataTable thead th {
		text-align: center !important;
		padding-right: 20px !important; /* 아이콘 공간 확보 */
		vertical-align: middle; /* 텍스트와 아이콘 세로 가운데 정렬 */
	}
	
	/* 정렬 아이콘 위치 조정 */
	table.dataTable thead .sorting:after,
	table.dataTable thead .sorting_asc:after,
	table.dataTable thead .sorting_desc:after {
		right: 5px;  /* 아이콘을 헤더 오른쪽 끝으로 이동 */
		left: auto;
	}
	
	/* 검색창 길이 설정 */
	.dataTables_filter input {
		width: 300px !important;
	}
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<!-- Page Title -->
<div class="page-title light-background">
	<div class="container d-lg-flex justify-content-between align-items-center">
		<h1 class="mb-2 mb-lg-0">자주 묻는 질문 관리</h1>
		<nav class="breadcrumbs">
			<ol>
				<li><%@include file="/WEB-INF/common/home.jsp"%></li>
				<li class="current">FAQ</li>
			</ol>
		</nav>
	</div>
</div>
<!-- End Page Title -->

<div class="container-fluid py-4">

	<table id="table" class="table table-bordered table-hover datatable text-center">
		<thead class="table-light">
			<tr>
				<th>번호</th>
				<th>제목</th>
				<th>작성자</th>
				<th>작성일시</th>
				<th>수정자</th>
				<th>수정일시</th>
				<th>사용 여부</th>
				<th>조회수</th>
			</tr>
		</thead>
		<tbody>
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
		</tbody>
	</table>
	
	<div class="text-first mt-3">
		<a href="/admin/FAQWrite" class="btn btn-primary">FAQ 등록</a>
	</div>
	
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>
<script>
	$(function() {
		$('#table').DataTable({
			searching : true, // 검색창 표시 여부
			ordering : true, // 정렬 기능(컬럼 헤더 클릭 시 오름/내림차순 정렬)
			paging : true, // 페이징
			pageLength : 10, // 페이지당 행 수
			lengthMenu : [10, 25, 50], // 페이징당 행 수 선택 옵션
			info : true, // "총 x건 중 n–m" 정보 표시
			autoWidth : false, // 자동 열 너비 계산 비활성화 (CSS width 우선 적용)

			// 한글 옵션
			language : {
				search : '<i class="bi bi-search"></i>', // 검색창 왼쪽 레이블
				lengthMenu : '_MENU_ 개씩 보기', // 페이지당 행 개수 드롭다운 문구
				info : '총 _TOTAL_건 중 _START_–_END_', // 페이지 정보 문구
				infoEmpty : '조회된 데이터가 없습니다.', // 데이터가 없을 때 info 영역 문구
				zeroRecords : '일치하는 데이터가 없습니다.', // 검색 결과가 없을 때 문구
				paginate : { // 페이지네이션 버튼 텍스트
					first : '처음', last : '마지막', next : '다음', previous : '이전'
				}
			}
		});
	});
</script>

</body>
</html>