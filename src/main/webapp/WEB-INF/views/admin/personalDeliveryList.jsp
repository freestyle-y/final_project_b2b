<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>개인 회원 배송 현황</title>
<style>
    table {
        width: 100%;
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
	
	<h1>개인 회원 배송 현황</h1>
	<table>
		<tr>
			<th>주문번호</th>
			<th>서브주문번호</th>
			<th>상품</th>
			<th>옵션</th>
			<th>수량</th>
			<th>가격</th>
			<th>주문상태</th>
			<th>구매자ID</th>
			<th>성함</th>
			<th>연락처</th>
			<th>주소</th>
			<th>상세주소</th>
			<th>우편번호</th>
			<th>배송상태</th>
			<th>배송처리</th>
		</tr>
		<c:forEach var="pd" items="${personalDeliveryList}">
			<tr>
				<td>${pd.orderNo}</td>
				<td>${pd.subOrderNo}</td>
				<td>${pd.productName}</td>
				<td>${pd.optionNameValue}</td>
				<td>${pd.orderQuantity}</td>
				<td>${pd.price}</td>
				<td>${pd.orderStatus}</td>
				<td>${pd.userId}</td>
				<td>${pd.userName}</td>
				<td>${pd.phone}</td>
				<td>${pd.address}</td>
				<td>${pd.detailAddress}</td>
				<td>${pd.postal}</td>
				<td>${pd.deliveryStatus}</td>
				<td>
					<c:choose>
						<c:when test="${pd.deliveryStatusCode eq 'DS001'}">
							<form action="/admin/personalDeliveryUpdate" method="get">
								<input type="hidden" name="orderNo" value="${pd.orderNo}">
								<input type="hidden" name="subOrderNo" value="${pd.subOrderNo}">
								<button type="submit">배송처리</button>
							</form>
						</c:when>
						<c:otherwise>
							<button type="button" disabled>배송처리</button>
						</c:otherwise>
					</c:choose>
				</td>
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
		<input type="text" id="searchWord" value="${page.searchWord}" placeholder="주문번호, ID 검색">
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