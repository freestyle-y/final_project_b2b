<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.7/dist/signature_pad.umd.min.js"></script>
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>계약서 작성 - 관리자</title>
<style>
/* 기본 스타일 */
* {
	margin: 0;
	padding: 0;
	box-sizing: border-box;
}

body {
	font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
	font-size: 14px;
	line-height: 1.6;
	color: #333;
	background: #fff;
	padding: 20px;
}

/* 계약서 컨테이너 */
.contract-container {
	max-width: 800px;
	margin: 0 auto;
	background: #fff;
	border: 1px solid #ddd;
	padding: 40px;
	box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
}

/* 헤더 영역 */
.contract-header {
	text-align: center;
	margin-bottom: 40px;
	border-bottom: 2px solid #333;
	padding-bottom: 20px;
}

.company-logo {
	display: flex;
	align-items: center;
	justify-content: center;
	margin-bottom: 20px;
}

.logo-box {
	width: 50px;
	height: 50px;
	border: 3px solid #333;
	border-radius: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	font-size: 24px;
	font-weight: bold;
	color: #333;
	margin-right: 15px;
}

.company-name {
	font-size: 28px;
	font-weight: bold;
	color: #333;
}

.contract-title {
	font-size: 32px;
	font-weight: bold;
	margin: 20px 0;
	color: #333;
}

/* 문서 정보 */
.document-info {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 30px;
}

.info-left {
	flex: 1;
}

.info-right {
	text-align: right;
	min-width: 200px;
}

.info-item {
	margin-bottom: 8px;
	font-size: 14px;
	color: #666;
}

/* 서명 영역 */
.signature-section {
	margin: 40px 0;
	padding: 20px;
	border: 1px solid #ddd;
	border-radius: 8px;
	background: #f9f9f9;
}

.signature-title {
	text-align: center;
	font-size: 18px;
	font-weight: bold;
	margin-bottom: 20px;
	color: #333;
}

.signature-boxes {
	display: flex;
	gap: 20px;
	justify-content: center;
}

.signature-box {
	flex: 1;
	max-width: 250px;
	text-align: center;
}

.signature-label {
	font-size: 14px;
	font-weight: bold;
	margin-bottom: 10px;
	color: #333;
}

.signature-field {
  width: 100%;
  height: 60px;
  border: 2px dashed #999;
  border-radius: 6px;
  display: flex;
  align-items: center;
  justify-content: center;
  background: #fff;
  color: #999;
  font-size: 12px;
  padding: 6px;              /* [수정] 추가 */
  overflow: hidden;          /* [수정] 추가: 혹시 모를 넘침 방지 */
  box-sizing: border-box;    /* 이미 전체에 있으나 안전하게 인지 */
}

.signature-field img {
  display: block;    /* [수정] 인라인 이미지 하단 갭 제거 */
  width: 100%;       /* [수정] 가로 꽉 채움 */
  height: 100%;      /* [수정] 세로 꽉 채움 */
  object-fit: contain;
}

/* 테이블 스타일 */
.contract-table {
	width: 100%;
	border-collapse: collapse;
	margin: 20px 0;
}

.contract-table th, .contract-table td {
	border: 1px solid #ddd;
	padding: 12px;
	text-align: center;
	vertical-align: middle;
}

.contract-table th {
	background: #f5f5f5;
	font-weight: bold;
	color: #333;
}

.contract-table td {
	background: #fff;
}

/* 섹션 제목 */
.section-title{
  display:flex;            /* 선과 텍스트를 같은 라인에 */
  align-items:center;      /* 세로 중앙정렬 */
  gap:12px;                /* 선과 글자 간격 */
  margin:30px 0 15px;
  font-size:18px;
  
  font-weight:700;
  color:#333;
  line-height:1.2;
  /* border-left: 4px solid #333;  <-- 삭제 */
  /* padding-left: 15px;           <-- 삭제 */
}
.section-title::before{
  content:"";
  display:inline-block;
  width:6px;               /* 굵기 */
  height:1.2em;            /* ← 세로 길이 (짧게: 1.0em, 길게: 1.4em 등) */
  background:#333;
  border-radius:3px;
}
/* 하단 문구 */
.contract-footer {
	text-align: center;
	margin-top: 40px;
	padding-top: 20px;
	border-top: 1px solid #ddd;
	color: #666;
	font-size: 14px;
}

/* 계약 조건 조항 */
.contract-terms {
	margin: 15px 0;
	page-break-inside: avoid;
	break-inside: avoid;
}

.term-item {
	margin-bottom: 8px;
	padding: 6px 10px;
	border: 1px solid #eee;
	border-radius: 4px;
	background: #fafafa;
	page-break-inside: avoid;
	break-inside: avoid;
}

.term-item h4 {
	color: #333;
	font-size: 13px;
	font-weight: bold;
	margin-bottom: 3px;
	border-bottom: 1px solid #007bff;
	padding-bottom: 2px;
}

.term-item p {
	color: #555;
	font-size: 12px;
	line-height: 1.2;
	margin: 0;
	text-align: justify;
}

/* 계약 당사자 섹션 */
.contract-parties-section {
	page-break-inside: avoid;
	break-inside: avoid;
	margin: 20px 0;
	page-break-before: auto;
	page-break-after: auto;
}

.contract-parties-section .section-title {
	page-break-after: avoid;
	break-after: avoid;
	margin-bottom: 15px;
}

.contract-parties-section .contract-table {
	page-break-inside: avoid;
	break-inside: avoid;
	margin-bottom: 30px;
}

/* 계약 조건 조항 섹션 */
.contract-terms-section {
	page-break-inside: avoid;
	break-inside: avoid;
	margin: 20px 0;
	page-break-before: auto;
	page-break-after: auto;
}

.contract-terms-section .section-title {
	page-break-after: avoid;
	break-after: avoid;
	margin-bottom: 15px;
}

.contract-terms-section .contract-terms {
	page-break-inside: avoid;
	break-inside: avoid;
	margin-bottom: 0;
}

/* 툴바 */
.toolbar {
	position: sticky;
	top: 0;
	background: #fff;
	border-bottom: 1px solid #ddd;
	padding: 15px 0;
	margin-bottom: 20px;
	z-index: 1000;
	text-align: center;
}


.btn-primary {
	background: #007bff;
	color: #fff;
	border-color: #007bff;
}

.btn-primary:hover {
	background: #0056b3;
	border-color: #0056b3;
}

/* 인쇄 스타일 */
@media print {
	body {
		padding: 0;
		background: #fff;
	}
	.no-print {
		display: none !important;
	}
	.contract-container {
		max-width: none;
		margin: 0;
		border: none;
		box-shadow: none;
		padding: 20px;
	}
	.toolbar {
		display: none !important;
	}
	.signature-boxes {
		display: flex !important;
		gap: 20px !important;
		justify-content: center !important;
	}
	.signature-box {
		flex: 1 !important;
		max-width: 250px !important;
	}
	.signature-field {
		border: 2px dashed #999 !important;
		height: 60px !important;
	}
	.contract-table th, .contract-table td {
		border: 1px solid #ddd !important;
		padding: 12px !important;
	}
	.contract-table th {
		background: #f5f5f5 !important;
	}
	.contract-table td {
		background: #fff !important;
	}
	.contract-footer {
		border-top: 1px solid #ddd !important;
	}
	.contract-terms {
		margin: 15px 0 !important;
		page-break-inside: avoid !important;
		break-inside: avoid !important;
	}
	.term-item {
		margin-bottom: 8px !important;
		padding: 6px 10px !important;
		border: 1px solid #eee !important;
		border-radius: 4px !important;
		background: #fafafa !important;
		page-break-inside: avoid !important;
		break-inside: avoid !important;
	}
	.term-item h4 {
		color: #333 !important;
		font-size: 13px !important;
		font-weight: bold !important;
		margin-bottom: 3px !important;
		border-bottom: 1px solid #007bff !important;
		padding-bottom: 2px !important;
	}
	.term-item p {
		color: #555 !important;
		font-size: 12px !important;
		line-height: 1.2 !important;
		margin: 0 !important;
		text-align: justify !important;
	}
	.contract-parties-section {
		page-break-inside: avoid !important;
		break-inside: avoid !important;
		margin: 20px 0 !important;
		page-break-before: auto !important;
		page-break-after: auto !important;
	}
	.contract-terms-section {
		page-break-inside: avoid !important;
		break-inside: avoid !important;
		margin: 20px 0 !important;
		page-break-before: auto !important;
		page-break-after: auto !important;
	}
	.contract-terms-section .section-title {
		page-break-after: avoid !important;
		break-after: avoid !important;
		margin-bottom: 15px !important;
	}
	.contract-terms-section .contract-terms {
		page-break-inside: avoid !important;
		break-inside: avoid !important;
		margin-bottom: 0 !important;
	}
}
/* ===== 버튼 공통 ===== */
.btn-register{
  background:#111; color:#fff; border:0;
  border-radius:14px; padding:.6rem 1rem;
  font-weight:700; line-height:1; display:inline-flex;
  align-items:center; justify-content:center;
  box-shadow:0 2px 8px rgba(0,0,0,.12);
  transition:transform .02s ease, opacity .2s ease, background .2s ease;
}
.btn-register:hover{ background:#0f0f0f; }
.btn-register:active{ transform:translateY(1px); }

/* 지우기 버튼(연한 아웃라인) */
.btn-clear{
  background:#fff; color:#374151;
  border:1px solid #D1D5DB; border-radius:10px;
  padding:.4rem .8rem; font-weight:600;
  transition:background .15s ease, border-color .15s ease;
}
.btn-clear:hover{ background:#F3F4F6; border-color:#9CA3AF; }
.btn-clear:active{ transform:translateY(1px); }

/* 버튼 포커스 링(접근성) */
.btn-register:focus, .btn-clear:focus{
  outline:0; box-shadow:0 0 0 .2rem rgba(17,24,39,.15);
}

/* ===== 테이블 입력 공통 ===== */
.contract-table .form-input{
  width:100%; height:36px;
  padding:6px 10px;
  background:#fff; color:#111827;
  border:1px solid #D1D5DB; border-radius:8px;
  font-size:14px; line-height:1.3;
  outline:none;
  transition:border-color .15s ease, box-shadow .15s ease, background .15s ease;
  box-sizing:border-box;
}
.contract-table .form-input:focus{
  border-color:#111827;
  box-shadow:0 0 0 .2rem rgba(17,24,39,.12);
}
.contract-table .form-input[readonly]{ background:#F9FAFB; color:#6B7280; cursor:default; }

/* number 스피너 제거 */
.contract-table .form-input[type=number]::-webkit-outer-spin-button,
.contract-table .form-input[type=number]::-webkit-inner-spin-button{
  -webkit-appearance:none; margin:0;
}
.contract-table .form-input[type=number]{ -moz-appearance:textfield; }

/* 셀은 가운데 정렬, 입력은 좌측 정렬 */
.contract-table td{ text-align:center; }
.contract-table td .form-input{ text-align:left; }

</style>
</head>
<body>
<div class="no-print">
<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
</div>
<section class="register py-1">
<div class="toolbar no-print text-center">
	<button class="btn btn-register" type="submit" form="contractForm">작성완료</button>
</div>
</section>
<form id="contractForm" method="post" action="${pageContext.request.contextPath}/admin/contract/write">
	<c:if test="${not empty contractOne}">
		<c:set var="first" value="${contractOne[0]}" />
	</c:if>
	<input type="hidden" name="quotationNo" value="${quotationNo}" />
		<div class="contract-container">
			<div class="contract-header">
				<div class="company-logo">
					<div class="logo-box">y</div>
					<div class="company-name">freeStyle</div>
				</div>
				<div class="contract-title">계약서 작성</div>
			</div>
			<div class="document-info">
				<div class="info-left">
					<div class="info-item">
			 			견적서 번호: ${quotationNo}
			 			<br>
					</div>
					<div class="info-item">
						계약일자: <span id="today"></span>
					</div>
				</div>
				<div class="info-right">
					<div class="info-item">
						발행일: <span id="today2"></span>
					</div>
				</div>
			</div>
			<div class="signature-section">
				<div class="signature-title">서명</div>
				<div class="signature-boxes">
					<!-- 갑 서명 -->
					<div class="signature-box" id="sig-supplier">
						<div class="signature-label">공급자</div>
						<div class="signature-field" style="padding: 0">
							<canvas style="width: 100%; height: 60px;"></canvas>
						</div>
						<div class="no-print" style="margin-top: 8px">
							<button type="button" class="btn btn-dark" data-action="clear">지우기</button>
						</div>
						<input type="hidden" name="supplierSignature" />
						<img alt="supplier signature" style="display: none;" />
					</div>
					<!-- 을 서명 -->
					<div class="signature-box" id="sig-buyer">
						<div class="signature-label">수요자</div>
						<div class="signature-field" style="padding: 0">
							관리자는 공급자에<br>
							서명해 주시기 바랍니다.
						</div>
						<input type="hidden" name="buyerSignature" />
						<img alt="buyer signature" style="display: none;" />
					</div>
				</div>
			</div>

			<div class="section-title">계약 개요</div>
			<table class="contract-table">
				<thead>
					<tr>
						<th>계약금</th>
						<th>잔금</th>
						<th>계약 총액</th>
						<th>계약서 작성 일자</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td><input type="number" name="downPayment" required class="form-input"/></td>
						<td><input type="number" name="finalPayment" required class="form-input"/></td>
						<td>
							<span id="totalAmountDisplay">
								₩<fmt:formatNumber value="${totalPrice}" type="number" groupingUsed="true" />
							</span>
							<input type="hidden" name="totalAmount" id="totalAmount" value="${totalPrice}" /></td>
						<td><input type="date" name="createDate" required class="form-input"/></td>
					</tr>
				</tbody>
			</table>

			<div class="section-title">품목 내역</div>
			<table class="contract-table">
				<thead>
					<tr>
						<th>상품명</th>
						<th>옵션</th>
						<th>수량</th>
					</tr>
				</thead>
				<tbody>
					<c:choose>
						<c:when	test="${not empty quotation and not empty quotation.items}">
							<c:forEach var="item" items="${quotation.items}">
								<tr>
									<td style="text-align: left">
										${item.productName}
										<input type="hidden" name="productName" value="${item.productName}" />
									</td>
									<td>
										${item.productOption}
										<input type="hidden" name="productOption" value="${item.productOption}" />
									</td>
									<td>
										${item.productQuantity}
									<input type="hidden" name="productQuantity" value="${item.productQuantity}" />
									</td>
								</tr>
							</c:forEach>
						</c:when>
						<c:otherwise>
							<tr>
								<td><input type="text" name="productName" required class="form-input"/></td>
								<td><input type="text" name="productOption" class="form-input"/></td>
								<td><input type="number" name="productQuantity" required class="form-input"/></td>
							</tr>
						</c:otherwise>
					</c:choose>
				</tbody>
			</table>

			<div class="section-title">계약 당사자</div>
			<table class="contract-table">
				<thead>
					<tr>
						<th>구분</th>
						<th>회사명/성명</th>
						<th>대표자</th>
						<th>연락처</th>
						<th>주소</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>공급자</td>
						<td><span>freeStyle</span></td>
						<td><span>${contractSupplier[0].name}</span></td>
						<td><span>${contractSupplier[0].phone}</span></td>
						<td><span>${contractSupplier[0].address} ${contractSupplier[0].detailAddress}</span></td>
					</tr>
					<tr>
						<td>수요자</td>
						<td><span>${contractUser[0].companyName}</span></td>
						<td><span>${contractUser[0].name}</span></td>
						<td><span>${contractUser[0].phone}</span></td>
						<td><span>${contractUser[0].address} ${contractUser[0].detailAddress}</span></td>
					</tr>
				</tbody>
			</table>

			<div class="section-title">계약 조건</div>
			<table class="contract-table">
				<thead>
					<tr>
						<th>구분</th>
						<th>내용</th>
						<th>비고</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>계약 기간</td>
						<td><input type="text" name="term" value="계약 체결일로부터 1년" readonly class="form-input"/></td>
						<td><input type="text" name="termEtc" value="자동 갱신" readonly class="form-input"/></td>
					</tr>
					<tr>
						<td>납기</td>
						<td><input type="text" name="delivery" value="주문 후 15일 이내" readonly class="form-input"/></td>
						<td><input type="text" name="deliveryEtc" value="부득이 시 연기 가능" 	readonly class="form-input"/></td>
					</tr>
					<tr>
						<td>결제 조건</td>
						<td><input type="text" name="payment" value="계약금 30%, 납품 후 70%" readonly class="form-input"/></td>
						<td><input type="text" name="paymentEtc" value="계약서 명시" readonly class="form-input"/></td>
					</tr>
					<tr>
						<td>품질 보증</td>
						<td><input type="text" name="warranty" value="그런 거 없음" readonly class="form-input"/></td>
						<td><input type="text" name="warrantyEtc" value="하자 시 유감"	readonly class="form-input"/></td>
					</tr>
				</tbody>
			</table>

			<div class="contract-footer">본 문서는 거래 조건 및 품목에 관한 계약 내용을 명시합니다.</div>
		</div>
	</form>
<script>
	(function () {
		const d = new Date();
		const z = n => String(n).padStart(2, '0');
		const today = d.getFullYear() + '-' + z(d.getMonth() + 1) + '-' + z(d.getDate());

		document.getElementById('today').textContent = today;
		document.getElementById('today2').textContent = today;
		document.querySelector('input[name=createDate]').value = today;

		// 총액 실시간 업데이트
		const downEl = document.querySelector('input[name=downPayment]');
		const finalEl = document.querySelector('input[name=finalPayment]');
		const totalHidden = document.getElementById('totalAmount');
		const totalDisplay = document.getElementById('totalAmountDisplay');

		function formatCurrency(n) {
			if (isNaN(n)) return '-';
			return '₩' + n.toLocaleString();
		}

		function updateTotal() {
			const down = Number(downEl.value || 0);
			const fin = Number(finalEl.value || 0);
			const total = down + fin;

			// 계약 총액은 견적서 totalPrice 기반으로 고정
			const baseTotal = Number(totalHidden.value || 0);

			totalDisplay.textContent = formatCurrency(baseTotal);
			totalHidden.value = baseTotal;
		}

		if (downEl && finalEl) {
			downEl.addEventListener('input', updateTotal);
			finalEl.addEventListener('input', updateTotal);
			updateTotal();
		}
	})();

	(function () {
		// 공통 유틸: 캔버스 리사이즈(레티나 대응)
		function fitCanvas(canvas) {
			const ratio = Math.max(window.devicePixelRatio || 1, 1);
			const rect = canvas.getBoundingClientRect();
			canvas.width = Math.max(1, Math.round(rect.width * ratio));
			canvas.height = Math.max(1, Math.round(rect.height * ratio));
			const ctx = canvas.getContext('2d');
			ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
		}

		function makePad(rootId) {
			const root = document.getElementById(rootId);
			const canvas = root.querySelector('canvas');
			const pad = new SignaturePad(canvas, { backgroundColor: 'rgb(255,255,255)' });
			const btnClr = root.querySelector('[data-action="clear"]');
			const hidden = root.querySelector('input[type="hidden"]');
			const imgOut = root.querySelector('img');

			function resize() {
				// 리사이즈 시 기존 선 유지
				const data = pad.toData();
				fitCanvas(canvas);
				pad.clear();
				if (data && data.length) pad.fromData(data);
			}

			resize();
			window.addEventListener('resize', resize);

			btnClr.addEventListener('click', () => {
				pad.clear();
				if (hidden) hidden.value = '';
				if (imgOut) {
					imgOut.src = '';
					imgOut.style.display = 'none';
				}
			});

			// 제출 전 dataURL로 저장
			function persist() {
				if (!hidden) return;
				hidden.value = pad.isEmpty() ? '' : pad.toDataURL('image/png');

				if (imgOut) {
					if (hidden.value) {
						imgOut.src = hidden.value;
						imgOut.style.display = 'block';
					} else {
						imgOut.src = '';
						imgOut.style.display = 'none';
					}
				}
			}

			// 인쇄 전/후 캔버스 대신 이미지로 표시
			function beforePrint() {
				persist(); // 최신 값 저장
				if (imgOut && hidden.value) {
					imgOut.src = hidden.value;
					imgOut.style.display = 'block';
				}
			}

			function afterPrint() {
				// 인쇄 후 캔버스 계속 보이게 유지
			}

			window.addEventListener('beforeprint', beforePrint);
			window.addEventListener('afterprint', afterPrint);

			return { pad, persist };
		}

		const supplier = makePad('sig-supplier');
		

		// 폼 제출 시 두 서명 확정 저장
		const form = document.getElementById('contractForm');
		form.addEventListener('submit', function () {
			supplier.persist();
		
		});
	})();
</script>
<div class="no-print">
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
</div>
</body>
</html>