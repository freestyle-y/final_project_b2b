<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>계약서 수정</title>
</head>
<body>
<%@ include file="/WEB-INF/common/header/header.jsp"%>
<%@ include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h1>계약서 수정</h1>
	<form action="${pageContext.request.contextPath}/admin/modifyContract" method="post">
		<input type="hidden" name="contractNo" value="${contract.contractNo}" />
		<input type="hidden" name="quotationNo" value="${quotationNo}" />
		<table border="1" style="border-collapse: collapse; text-align: left;">
			<tr>
				<th>계약금</th>
				<td>
					<input type="text" name="downPayment" value="${contract.downPayment}" />
				</td>
				<th>계약금 입금 상태</th>
				<td>
					<input type="checkbox" name="DPStatus" id="dPStatus">
					<input type="hidden" name="downPaymentDate" id="downPaymentDate" />
				</td>
			</tr>
			<tr>
				<th>잔금</th>
				<td>
					<input type="text" name="finalPayment" value="${contract.finalPayment}" />
				</td>
				<th>잔금 입금 상태</th>
				<td>
					<input type="checkbox" name="FPStatus" id="fPStatus">
					<input type="hidden" name="finalPaymentDate" id="finalPaymentDate" />
				</td>
			</tr>
		</table>
		<br>
		<button type="submit">수정 완료</button>
	</form>
<script>
	// 오늘 날짜 yyyy-mm-dd 형식으로 반환
	function getTodayDate() {
		const today = new Date();
		const yyyy = today.getFullYear();
		const mm = String(today.getMonth() + 1).padStart(2, '0');
		const dd = String(today.getDate()).padStart(2, '0');
		return `${yyyy}-${mm}-${dd}`;
	}

	document.addEventListener('DOMContentLoaded', function () {
		const dpCheckbox = document.getElementById('dPStatus');
		const fpCheckbox = document.getElementById('fPStatus');
		const dpDateInput = document.getElementById('downPaymentDate');
		const fpDateInput = document.getElementById('finalPaymentDate');

		if (dpCheckbox) {
			dpCheckbox.addEventListener('change', function () {
				dpDateInput.value = dpCheckbox.checked ? getTodayDate() : '';
			});
		}
		
		if (fpCheckbox) {
			fpCheckbox.addEventListener('change', function () {
				fpDateInput.value = fpCheckbox.checked ? getTodayDate() : '';
			});
		}
	});
</script>	
<%@ include file="/WEB-INF/common/footer/footer.jsp"%>
</body>
</html>
