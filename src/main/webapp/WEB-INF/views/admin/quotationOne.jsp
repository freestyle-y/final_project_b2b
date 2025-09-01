<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>관리자 견적서 상세</title>

<link
	href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<style>
:root {
	--tbl-border: #E5E7EB;
	--tbl-head: #F9FAFB;
	--tbl-hover: #F3F4F6;
	--tbl-zebra: #FAFAFA;
	--badge-green: #10b981;
	--badge-yellow: #f59e0b;
	--badge-red: #ef4444;
	--badge-gray: #6b7280;
}

body {
	font-family: "SUIT", -apple-system, BlinkMacSystemFont, "Segoe UI",
		Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial,
		sans-serif;
	background: #fff;
}

.wrap {
	max-width: 1400px;
	margin: 24px auto;
	padding: 0 12px;
}

.panel {
	border: 1px solid var(--tbl-border);
	border-radius: 14px;
	background: #fff;
	box-shadow: 0 2px 10px rgba(0, 0, 0, .03);
	overflow: hidden;
}

.panel-header {
	padding: 16px 20px;
	border-bottom: 1px solid var(--tbl-border);
	display: flex;
	gap: 12px;
	align-items: center;
	justify-content: space-between;
}

.panel-title {
	margin: 0;
	font-size: 1.1rem;
	font-weight: 700;
}

.table-clip {
	border-radius: 14px;
	overflow: hidden;
}

table.detail {
	width: 100%;
	table-layout: fixed;
	border-collapse: collapse;
	font-size: .95rem;
	background: #fff;
}

table.detail thead th {
	background: var(--tbl-head);
	border-bottom: 1px solid var(--tbl-border);
	border-right: 1px solid var(--tbl-border);
	padding: .6rem .8rem;
	text-align: center;
	white-space: nowrap;
	color: #111827;
	font-weight: 700;
}

table.detail thead th:last-child {
	border-right: 0;
}

table.detail tbody td {
	border-top: 1px solid var(--tbl-border);
	border-right: 1px solid var(--tbl-border);
	padding: .55rem .8rem;
	vertical-align: middle;
	text-align: center;
	color: #111827;
	white-space: normal;
	word-break: keep-all;
	overflow-wrap: anywhere;
	height: 42px;
}

table.detail tbody td:last-child {
	border-right: 0;
}

table.detail tbody tr:nth-child(even) {
	background: var(--tbl-zebra);
}

table.detail tbody tr:hover {
	background: var(--tbl-hover);
}

/* 1 번호 2 상태 3 작성자 4 작성일자 5 상품명 6 옵션 7 수량 8 가격 9 액션 */
table.detail col:nth-child(1) {
	width: 8%;
}

table.detail col:nth-child(2) {
	width: 10%;
}

table.detail col:nth-child(3) {
	width: 10%;
}

table.detail col:nth-child(4) {
	width: 16%;
}

table.detail col:nth-child(5) {
	width: 22%;
}

table.detail col:nth-child(6) {
	width: 12%;
}

table.detail col:nth-child(7) {
	width: 6%;
}

table.detail col:nth-child(8) {
	width: 10%;
}

table.detail col:nth-child(9) {
	width: 6%;
}

.nowrap {
	white-space: nowrap !important;
}

.text-end {
	text-align: right !important;
}

.status-badge {
	display: inline-block;
	padding: 6px 12px;
	border-radius: 999px;
	color: #fff;
	font-size: .85rem;
	font-weight: 700;
	letter-spacing: .3px;
}

.status-승인 {
	background: var(--badge-green);
}

.status-승인전 {
	background: var(--badge-yellow);
}

.status-승인거절 {
	background: var(--badge-red);
}

.status-기타 {
	background: var(--badge-gray);
}
</style>
</head>
<body>

	<%@ include file="/WEB-INF/common/header/header.jsp"%>

	<div class="wrap">

		<!-- 상단 요약 + 전역 버튼 -->
		<div class="panel mb-3">
			<div class="panel-header">
				<h1 class="panel-title">
					상품요청번호: <span class="text-primary">${productRequestNo}</span>
				</h1>
				<div class="ms-auto small text-muted">
					총 <strong>${fn:length(quotationList)}</strong> 건
				</div>

				<%-- 전역 상태 계산 --%>
				<c:set var="hasPending" value="false" />
				<c:set var="hasRejected" value="false" />
				<c:set var="firstApprovedQuotationNo" value="0" />
				<c:forEach var="q" items="${quotationList}">
					<c:set var="st" value="${empty q.status ? '' : fn:trim(q.status)}" />
					<c:if test="${st eq '승인전'}">
						<c:set var="hasPending" value="true" />
					</c:if>
					<c:if test="${st eq '승인거절'}">
						<c:set var="hasRejected" value="true" />
					</c:if>
					<c:if test="${firstApprovedQuotationNo == 0 and st eq '승인'}">
						<c:set var="firstApprovedQuotationNo" value="${q.quotationNo}" />
					</c:if>
				</c:forEach>
				<c:set var="allApproved"
					value="${not hasPending and not hasRejected and fn:length(quotationList) gt 0}" />

				<div class="d-flex gap-2">
					<c:choose>
						<%-- 1) 승인전이 하나라도 있으면: 전역 버튼 없음 --%>
						<c:when test="${hasPending}">
							<!-- 아무 버튼도 표시하지 않음 -->
						</c:when>

						<%-- 2) (승인전 없음) 승인거절이 하나라도 있으면: 재작성만 노출 --%>
						<c:when test="${hasRejected}">
							<button type="button"
								class="btn btn-outline-secondary btn-sm rounded-pill fw-bold"
								onclick="reWriteQuotation(${productRequestNo})">견적서 재작성</button>
						</c:when>

						<%-- 3) 전부 승인: 계약서 작성 노출(첫 승인건 기준) --%>
						<c:when test="${allApproved}">
							<form method="get"
								action="${pageContext.request.contextPath}/admin/writeContract"
								class="m-0">
								<c:if test="${not empty _csrf}">
									<input type="hidden" name="${_csrf.parameterName}"
										value="${_csrf.token}" />
								</c:if>
								<input type="hidden" name="quotationNo"
									value="${firstApprovedQuotationNo}" /> <input type="hidden"
									name="productRequestNo" value="${productRequestNo}" />
								<button type="submit"
									class="btn btn-primary btn-sm rounded-pill fw-bold">계약서
									작성</button>
							</form>
						</c:when>

						<c:otherwise>
							<!-- 버튼 없음 -->
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>

		<!-- 단일 테이블 -->
		<div class="panel">
			<div class="table-clip">
				<table class="detail">
					<colgroup>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
						<col>
					</colgroup>
					<thead>
						<tr>
							<th>견적서 번호</th>
							<th>상태</th>
							<th>작성자</th>
							<th>작성일자</th>
							<th>상품명</th>
							<th>옵션</th>
							<th>수량</th>
							<th>가격</th>
							<th>액션</th>
						</tr>
					</thead>
					<tbody>
						<c:if test="${empty quotationList}">
							<tr>
								<td colspan="9" class="text-center text-muted">해당 상품의 견적서가
									없습니다.</td>
							</tr>
						</c:if>

						<c:forEach var="qOne" items="${quotationList}">
							<c:set var="rowCount" value="${fn:length(qOne.items)}" />
							<c:choose>
								<c:when test="${rowCount gt 0}">
									<c:forEach var="item" items="${qOne.items}" varStatus="rs">
										<tr>
											<c:if test="${rs.first}">
												<td rowspan="${rowCount}" class="nowrap">${qOne.quotationNo}</td>
												<td rowspan="${rowCount}"><c:choose>
														<c:when test="${fn:trim(qOne.status) eq '승인'}">
															<span class="status-badge status-승인">승인</span>
														</c:when>
														<c:when test="${fn:trim(qOne.status) eq '승인전'}">
															<span class="status-badge status-승인전">승인전</span>
														</c:when>
														<c:when test="${fn:trim(qOne.status) eq '승인거절'}">
															<span class="status-badge status-승인거절">승인거절</span>
														</c:when>
														<c:otherwise>
															<span class="status-badge status-기타"><c:out
																	value="${qOne.status}" /></span>
														</c:otherwise>
													</c:choose></td>
												<td rowspan="${rowCount}" class="nowrap"><c:out
														value="${qOne.createUser}" /></td>
												<td rowspan="${rowCount}" class="nowrap"><c:choose>
														<c:when test="${fn:contains(qOne.createDate,'T')}">${fn:replace(qOne.createDate, 'T', ' ')}</c:when>
														<c:otherwise>${qOne.createDate}</c:otherwise>
													</c:choose></td>
											</c:if>

											<td><c:out value="${item.productName}" /></td>
											<td><c:out value="${item.productOption}" /></td>
											<td class="nowrap"><c:out
													value="${item.productQuantity}" /></td>
											<td class="nowrap text-end">₩<fmt:formatNumber
													value="${item.price}" type="number" groupingUsed="true" /></td>

											<c:if test="${rs.first}">
												<td rowspan="${rowCount}"><c:choose>
														<%-- 행 단위 액션: 승인전만 수정/삭제 노출 --%>
														<c:when test="${fn:trim(qOne.status) eq '승인전'}">
															<div class="d-grid gap-1">
																<button type="button"
																	class="btn btn-warning btn-sm rounded-pill fw-bold"
																	onclick="modifyQuotation(${qOne.quotationNo})">수정</button>
																<button type="button"
																	class="btn btn-danger btn-sm rounded-pill fw-bold"
																	onclick="deleteQuotation(${qOne.quotationNo})">삭제</button>
															</div>
														</c:when>
														<c:otherwise>
															<span class="text-muted">-</span>
														</c:otherwise>
													</c:choose></td>
											</c:if>
										</tr>
									</c:forEach>
								</c:when>

								<c:otherwise>
									<tr>
										<td class="nowrap">${qOne.quotationNo}</td>
										<td><c:choose>
												<c:when test="${fn:trim(qOne.status) eq '승인'}">
													<span class="status-badge status-승인">승인</span>
												</c:when>
												<c:when test="${fn:trim(qOne.status) eq '승인전'}">
													<span class="status-badge status-승인전">승인전</span>
												</c:when>
												<c:when test="${fn:trim(qOne.status) eq '승인거절'}">
													<span class="status-badge status-승인거절">승인거절</span>
												</c:when>
												<c:otherwise>
													<span class="status-badge status-기타"><c:out
															value="${qOne.status}" /></span>
												</c:otherwise>
											</c:choose></td>
										<td class="nowrap"><c:out value="${qOne.createUser}" /></td>
										<td class="nowrap">${qOne.createDate}</td>
										<td colspan="4" class="text-muted">아이템 없음</td>
										<td><span class="text-muted">-</span></td>
									</tr>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
	</div>

	<%@ include file="/WEB-INF/common/footer/footer.jsp"%>

	<script>
  function modifyQuotation(quotationNo){
    location.href = "${pageContext.request.contextPath}/admin/modifyQuotationForm?quotationNo=" + encodeURIComponent(quotationNo);
  }
  function deleteQuotation(quotationNo){
    if(!confirm("정말 삭제하시겠습니까?")) return;
    const form = document.createElement('form');
    form.method = "post";
    form.action = "${pageContext.request.contextPath}/admin/deleteQuotation";
    <%-- CSRF 토큰 포함 (있을 때만) --%>
    <c:if test="${not empty _csrf}">
      const csrfInput = document.createElement('input');
      csrfInput.type = 'hidden';
      csrfInput.name = "${_csrf.parameterName}";
      csrfInput.value = "${_csrf.token}";
      form.appendChild(csrfInput);
    </c:if>
    const qNoInput = document.createElement('input');
    qNoInput.type = 'hidden';
    qNoInput.name = 'quotationNo';
    qNoInput.value = quotationNo;
    form.appendChild(qNoInput);
    document.body.appendChild(form);
    form.submit();
  }
  function reWriteQuotation(productRequestNo){
    location.href = "${pageContext.request.contextPath}/admin/writeQuotationForm?productRequestNo=" + encodeURIComponent(productRequestNo);
  }
</script>
</body>
</html>
