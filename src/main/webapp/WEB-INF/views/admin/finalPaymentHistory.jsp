<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>잔금 확인 페이지</title>
</head>
<body>
<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>잔금 확인 페이지</h1>
	<form id="containerForm">
		<table border="1" id="paymentTable">
			<!-- 헤더 (th) -->
			<tr>
				<th>계약 번호</th>
				<th>계약금</th>
				<th>계약금 입금 상태</th>
				<th>계약금 입금 날짜</th>
				<th>잔금</th>
				<th>잔금 입금 상태</th>
				<th>잔금 입금 날짜</th>
				<th>회수 버튼</th>
				<th>배송입력상태</th>
			</tr>
			<!-- 데이터 (td) -->
			<c:forEach var="list" items="${list}">
				<tr>
					<td>${list.contractNo}</td>
					<td>${list.downPayment}</td>
					<td><c:choose>
							<c:when test="${list.downPaymentStatus == 'PS001'}">입금전</c:when>
							<c:when test="${list.downPaymentStatus == 'PS002'}">입금완료</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
					<td>${list.formattedDownPaymentDate}</td>
					<td>${list.finalPayment}</td>
					<td><c:choose>
							<c:when test="${list.finalPaymentStatus == 'PS001'}">입금전</c:when>
							<c:when test="${list.finalPaymentStatus == 'PS002'}">입금완료</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose></td>
					<td class="final-payment-date">${list.formattedFinalPaymentDate}</td>
					<td><c:if test="${list.contractDeliveryStatus ne 'DS009'}">
							<button type="button" class="retrieval-btn"
								style="display: none;" data-container-no="${list.containerNo}"
								onclick="recallProduct(this)">상품회수</button>
						</c:if> <c:if test="${list.contractDeliveryStatus eq 'DS009'}">
							<button type="button" data-container-no="${list.containerNo}"
								onclick="recallProductCancel(this)">회수취소</button>
						</c:if></td>
				</tr>
			</c:forEach>
		</table>
	</form>
	<script>
	window.addEventListener('DOMContentLoaded', function () {
		const today = new Date().toISOString().split('T')[0]; // yyyy-MM-dd 기준
		const rows = document.querySelectorAll('#paymentTable tr');
		
		rows.forEach(row => {
			const dateCell = row.querySelector('.final-payment-date'); // 🔥 여기!
			const btn = row.querySelector('.retrieval-btn');
			
			if (dateCell && btn) {
				const finalPaymentDate = dateCell.textContent.trim();
				if (finalPaymentDate && finalPaymentDate < today) {
					btn.style.display = 'inline-block';
				}
			}
		});
	});
	
	function recallProduct(button) {
		const containerNo = button.dataset.containerNo;
		
		const form = document.getElementById("containerForm");
		form.action = "/admin/recallProduct?containerNo=" + encodeURIComponent(containerNo); // <-- encode 추가(권장)
		form.method = "post";
		form.submit();
	 }
	
	 // 🔧 [수정] 취소도 동일하게 처리
	 function recallProductCancel(button) {
		const containerNo = button.dataset.containerNo;
		
		const form = document.getElementById("containerForm");
		form.action = "/admin/recallProductCancel?containerNo=" + encodeURIComponent(containerNo); // <-- encode 추가(권장)
		form.method = "post";
		form.submit();
	 }
</script>

	<!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
