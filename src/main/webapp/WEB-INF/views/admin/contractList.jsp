<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>계약서 목록</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<h1>관리자 계약서 목록</h1>
<form id="contractForm">
<table border="1" style="border-collapse:collapse; text-align:center;">
	<thead>
		<tr>
			<th>선택</th>
			<th>계약번호</th>
			<th>견적번호</th>
			<th>계약금</th>
			<th>계약금 입금 상태</th>
			<th>계약금 입금 날짜</th>
			<th>잔금</th>
			<th>잔금 입금 상태</th>
			<th>잔금 납입일</th>
			<th>작성자</th>
			<th>작성일자</th>
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
				<td>${con.formattedDownPaymentDate}</td>
				<td>${con.finalPayment} 원</td>
				<td>
					<c:choose>
						<c:when test="${con.finalPaymentStatus == 'PS001'}">입금전</c:when>
						<c:when test="${con.finalPaymentStatus == 'PS002'}">입금완료</c:when>
						<c:otherwise>-</c:otherwise>
					</c:choose>
				</td>
				<td>${con.formattedFinalPaymentDate}</td>
				<td>${con.createUser}</td>
				<td>${con.createDate}</td>
			</tr>
		</c:forEach>
	</tbody>
</table>

<button type="button" onclick="modifyContract()">수정</button>
<button type="button" onclick="deleteContract()">삭제</button>
<button type="button" onclick="insertDownPayment()">계약금 입금 확인</button>
<button type="button" onclick="insertFinalPayment()">잔금 입금 확인</button>
<button type="button" onclick="insertContainer()">컨테이너 상품 입력</button>
</form>

<script>
	function getCheckedContract() {
		const checkedItems = document.querySelectorAll("input[name='selectedContracts']:checked");
		if (checkedItems.length === 0) {
			alert("계약을 선택하세요.");
			return null;
		}
		if (checkedItems.length > 1) {
			alert("하나의 계약만 선택할 수 있습니다.");
			return null;
		}
		return checkedItems[0];
	}

	function modifyContract() {
		const checked = getCheckedContract();
		if (!checked) return;
		const contractNo = checked.value;
		const row = checked.closest("tr");
		const quotationNo = row.querySelector(".quotationNo").value;

		location.href = "/admin/modifyContractForm?contractNo=" + contractNo + "&quotationNo=" + quotationNo;
	}

	function deleteContract() {
		const checked = getCheckedContract();
		if (!checked) return;
		if (!confirm("정말 삭제하시겠습니까?")) return;

		const contractNo = checked.value;
		const row = checked.closest("tr");
		const quotationNo = row.querySelector(".quotationNo").value;

		const form = document.getElementById("contractForm");
		form.action = "/admin/deleteContract?quotationNo=" + quotationNo + "&contractNo=" + contractNo;
		form.method = "post";
		form.submit();
	}

	function insertDownPayment() {
		const checked = getCheckedContract();
		if (!checked) return;
		const contractNo = checked.value;

		const form = document.getElementById("contractForm");
		form.action = "/admin/insertDownPayment?contractNo=" + contractNo;
		form.method = "post";
		form.submit();
	}

	function insertFinalPayment() {
		const checked = getCheckedContract();
		if (!checked) return;
		const contractNo = checked.value;

		const form = document.getElementById("contractForm");
		form.action = "/admin/insertFinalPayment?contractNo=" + contractNo;
		form.method = "post";
		form.submit();
	}

	function insertContainer() {
		const checked = document.querySelector("input[name='selectedContracts']:checked");
		if(!checked) {
			alert("컨테이너에 입력할 상품을 선택하세요.");
			return;
		}
		const contractNo = checked.value;
		location.href = "/admin/insertContainer?contractNo=" + contractNo;
	}
</script>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
