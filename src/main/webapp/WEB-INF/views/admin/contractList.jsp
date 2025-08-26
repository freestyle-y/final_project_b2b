<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계약서 목록</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>관리자 계약서 목록</h1>
	<form id="contractForm">
	<table border="1" style="border-collapse:collapse; text-align:center;">
		<thead>
			<tr>
				<th>선택</th>
				<th>계약번호</th>
				<th>견적번호</th>
				<th>계약금</th>
				<th>입금 상태</th>
				<th>잔금</th>
				<th>잔금 납입일</th>
				<th>작성자</th>
				<th>작성일자</th>
				<th>컨테이너 상품 입력</th>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="con" items="${contractList}">
				<tr>
					<td>
						<input type="checkbox" name="selectedContracts" value="${con.contractNo}" />
						<input type="hidden" class="quotationNo" value="${con.quotationNo}" />
					</td>
					<td>
						<a href="${pageContext.request.contextPath}/admin/contractOne?contractNo=${con.contractNo}">
							${con.contractNo}
						</a>
					</td>
					<td>${con.quotationNo}</td>
					<td>${con.downPayment} 원</td>
					<td>
						<c:choose>
							<c:when test="${con.downPaymentStatus == 'PS001'}">입금전</c:when>
							<c:when test="${con.downPaymentStatus == 'PS002'}">입금완료</c:when>
							<c:otherwise>-</c:otherwise>
						</c:choose>
					</td>
					<td>${con.finalPayment} 원</td>
					<td>${con.finalPaymentDate}</td>
					<td>${con.createUser}</td>
					<td>${con.createDate}</td>
					<!-- 컨테이너 입력 form -->
					<td>
						<form method="get" action="/admin/insertContainer" style="display:inline;">
							<input type="hidden" name="contractNo" value="${con.contractNo}" />
							<button type="submit">컨테이너 입력</button>
						</form>
					</td>
				</tr>

			</c:forEach>
		</tbody>
	</table>
	<button type="button" onclick="modifyContract()">수정</button>
	<button type="button" onclick="deleteContract()">삭제</button>
	</form>
<script>
	function modifyContract() {
		const checked = document.querySelector("input[name='selectedContracts']:checked");
		if (!checked) {
			alert("수정할 계약을 선택하세요.");
			return;
		}
		const contractNo = checked.value;
		const row = checked.closest("tr");
		const quotationNo = row.querySelector(".quotationNo").value;
	
		location.href = "/admin/modifyContractForm?contractNo=" + contractNo + "&quotationNo=" + quotationNo;
	}

	function deleteContract(){
		if (!confirm("정말 삭제하시겠습니까?")) return;

		const form = document.getElementById("contractForm");
		form.action = "/admin/deleteContract";
		form.method = "post";
		form.submit();
	}
</script>
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>