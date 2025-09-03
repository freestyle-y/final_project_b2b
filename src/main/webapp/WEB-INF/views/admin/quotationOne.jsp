<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>관리자 견적서 상세</title>

<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
:root{
  --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA;
  --badge-green:#10b981; --badge-yellow:#f59e0b; --badge-red:#ef4444; --badge-gray:#6b7280;
}
body{ font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif; }
.wrap{ max-width:1400px; margin:24px auto; padding:0 12px; }

.panel{ border:1px solid var(--tbl-border); border-radius:14px; background:#fff; box-shadow:0 2px 10px rgba(0,0,0,.03); overflow:hidden; }
.panel-header{ padding:16px 20px; border-bottom:1px solid var(--tbl-border); display:flex; gap:12px; align-items:center; }
.panel-title{ margin:0; font-size:1.1rem; font-weight:700; }

.table-clip{ border-radius:14px; overflow:hidden; }
table.detail{ width:100%; table-layout:fixed; border-collapse:collapse; font-size:.95rem; }
table.detail thead th{ background:var(--tbl-head); border-bottom:1px solid var(--tbl-border); border-right:1px solid var(--tbl-border); padding:.6rem .8rem; text-align:center; white-space:nowrap; font-weight:700; }
table.detail thead th:last-child{ border-right:0; }
table.detail tbody td{ border-top:1px solid var(--tbl-border); border-right:1px solid var(--tbl-border); padding:.55rem .8rem; vertical-align:middle; text-align:center; height:42px; }
table.detail tbody td:last-child{ border-right:0; }
table.detail tbody tr:nth-child(even){ background:var(--tbl-zebra); }
table.detail tbody tr:hover{ background:var(--tbl-hover); }

/* 컬럼 폭 */
table.detail col:nth-child(1){ width:8%; }
table.detail col:nth-child(2){ width:12%; }
table.detail col:nth-child(3){ width:10%; }
table.detail col:nth-child(4){ width:16%; }
table.detail col:nth-child(5){ width:22%; }
table.detail col:nth-child(6){ width:12%; }
table.detail col:nth-child(7){ width:6%; }
table.detail col:nth-child(8){ width:10%; }
table.detail col:nth-child(9){ width:6%; }

.nowrap{ white-space:nowrap!important; }
.text-end{ text-align:right!important; }

/* 상태/사유 보기 - 수직 스택 */
.status-cell{ display:flex; flex-direction:column; align-items:center; gap:6px; }
.status-badge{ display:inline-block; padding:6px 12px; border-radius:999px; color:#fff; font-size:.85rem; font-weight:700; letter-spacing:.3px; }
.status-승인   { background:var(--badge-green); }
.status-승인전 { background:var(--badge-yellow); }
.status-승인거절{ background:var(--badge-red); }
.status-기타   { background:var(--badge-gray); }

.btn-xs{ padding:.15rem .5rem; font-size:.75rem; border-radius:999px; line-height:1.1; }
.reason-btn{ font-weight:700; }
</style>
</head>
<body>

<%@ include file="/WEB-INF/common/header/header.jsp"%>

<div class="wrap">
  <!-- 상단 요약 + 전역 버튼 -->
  <div class="panel mb-3">
    <div class="panel-header w-100">
      <h1 class="panel-title m-0">
        상품요청번호: <span class="text-primary">${productRequestNo}</span>
      </h1>
      <div class="ms-auto small text-muted">총 <strong>${fn:length(quotationList)}</strong> 건</div>

      <%-- 승인 견적서 찾기 --%>
      <c:set var="firstApprovedQuotationNo" value="0"/>
      <c:forEach var="q" items="${quotationList}">
        <c:if test="${firstApprovedQuotationNo == 0 and fn:trim(q.status) eq '승인'}">
          <c:set var="firstApprovedQuotationNo" value="${q.quotationNo}"/>
        </c:if>
      </c:forEach>

      <div class="d-flex gap-2">
        <c:if test="${firstApprovedQuotationNo ne 0}">
          <form method="get" action="${pageContext.request.contextPath}/admin/writeContract" class="m-0">
            <c:if test="${not empty _csrf}">
              <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            </c:if>
            <input type="hidden" name="quotationNo" value="${firstApprovedQuotationNo}"/>
            <input type="hidden" name="productRequestNo" value="${productRequestNo}"/>
            <button type="submit" class="btn btn-primary btn-sm rounded-pill fw-bold">계약서 작성</button>
          </form>
        </c:if>
      </div>
    </div>
  </div>

  <!-- 테이블 -->
  <div class="panel">
    <div class="table-clip">
      <table class="detail">
        <colgroup><col><col><col><col><col><col><col><col><col></colgroup>
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
            <tr><td colspan="9" class="text-center text-muted">해당 상품의 견적서가 없습니다.</td></tr>
          </c:if>

          <c:forEach var="qOne" items="${quotationList}">
            <c:set var="rowCount" value="${fn:length(qOne.items)}"/>
            <c:choose>
              <c:when test="${rowCount gt 0}">
                <c:forEach var="item" items="${qOne.items}" varStatus="rs">
                  <tr>
                    <c:if test="${rs.first}">
                      <td rowspan="${rowCount}" class="nowrap">${qOne.quotationNo}</td>

                      <!-- 상태셀 -->
                      <td rowspan="${rowCount}">
                        <div class="status-cell">
                          <c:choose>
                            <c:when test="${fn:trim(qOne.status) eq '승인'}">
                              <span class="status-badge status-승인">승인</span>
                            </c:when>
                            <c:when test="${fn:trim(qOne.status) eq '승인전'}">
                              <span class="status-badge status-승인전">승인전</span>
                            </c:when>
                            <c:when test="${fn:trim(qOne.status) eq '승인거절'}">
                              <span class="status-badge status-승인거절">승인거절</span>
                              <button type="button"
                                      class="btn btn-outline-secondary btn-xs reason-btn"
                                      data-bs-toggle="modal"
                                      data-bs-target="#rejectReason-${qOne.quotationNo}">
                                사유 보기
                              </button>
                            </c:when>
                            <c:otherwise>
                              <span class="status-badge status-기타"><c:out value="${qOne.status}"/></span>
                            </c:otherwise>
                          </c:choose>
                        </div>
                      </td>

                      <td rowspan="${rowCount}" class="nowrap"><c:out value="${qOne.createUser}"/></td>
                      <td rowspan="${rowCount}" class="nowrap">
                        <c:choose>
                          <c:when test="${fn:contains(qOne.createDate,'T')}">${fn:replace(qOne.createDate, 'T', ' ')}</c:when>
                          <c:otherwise>${qOne.createDate}</c:otherwise>
                        </c:choose>
                      </td>
                    </c:if>

                    <td><c:out value="${item.productName}"/></td>
                    <td><c:out value="${item.productOption}"/></td>
                    <td class="nowrap"><c:out value="${item.productQuantity}"/></td>
                    <td class="nowrap text-end">₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/></td>

                    <c:if test="${rs.first}">
                      <td rowspan="${rowCount}">
                        <c:choose>
                          <c:when test="${fn:trim(qOne.status) eq '승인전'}">
                            <div class="d-grid gap-1">
                              <button type="button" class="btn btn-warning btn-sm rounded-pill fw-bold"
                                      onclick="modifyQuotation(${qOne.quotationNo})">수정</button>
                              <button type="button" class="btn btn-danger btn-sm rounded-pill fw-bold"
                                      onclick="deleteQuotation(${qOne.quotationNo})">삭제</button>
                            </div>
                          </c:when>
                          <c:otherwise><span class="text-muted">-</span></c:otherwise>
                        </c:choose>
                      </td>
                    </c:if>
                  </tr>
                </c:forEach>
              </c:when>

              <c:otherwise>
                <tr>
                  <td class="nowrap">${qOne.quotationNo}</td>
                  <td>
                    <div class="status-cell">
                      <c:choose>
                        <c:when test="${fn:trim(qOne.status) eq '승인'}">
                          <span class="status-badge status-승인">승인</span>
                        </c:when>
                        <c:when test="${fn:trim(qOne.status) eq '승인전'}">
                          <span class="status-badge status-승인전">승인전</span>
                        </c:when>
                        <c:when test="${fn:trim(qOne.status) eq '승인거절'}">
                          <span class="status-badge status-승인거절">승인거절</span>
                          <button type="button" class="btn btn-outline-secondary btn-xs reason-btn"
                                  data-bs-toggle="modal" data-bs-target="#rejectReason-${qOne.quotationNo}">
                            사유 보기
                          </button>
                        </c:when>
                        <c:otherwise>
                          <span class="status-badge status-기타"><c:out value="${qOne.status}"/></span>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </td>
                  <td class="nowrap"><c:out value="${qOne.createUser}"/></td>
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

  <!-- 거절 사유 모달 -->
  <c:forEach var="qOne" items="${quotationList}">
    <div class="modal fade" id="rejectReason-${qOne.quotationNo}" tabindex="-1"
         aria-labelledby="rejectReasonLabel-${qOne.quotationNo}" aria-hidden="true">
      <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="rejectReasonLabel-${qOne.quotationNo}">거절 사유</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
          </div>
          <div class="modal-body">
            <c:choose>
              <c:when test="${not empty qOne.refusalReason and fn:length(fn:trim(qOne.refusalReason)) > 0}">
                <pre class="mb-0" style="white-space:pre-wrap;"><c:out value="${qOne.refusalReason}"/></pre>
              </c:when>
              <c:otherwise><span class="text-muted">사유가 입력되지 않았습니다.</span></c:otherwise>
            </c:choose>
          </div>
        </div>
      </div>
    </div>
  </c:forEach>
</div>

<%@ include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
function modifyQuotation(quotationNo){
  location.href = "${pageContext.request.contextPath}/admin/modifyQuotationForm?quotationNo=" + encodeURIComponent(quotationNo);
}
function deleteQuotation(quotationNo){
  if(!confirm("정말 삭제하시겠습니까?")) return;
  const form = document.createElement('form');
  form.method = "post";
  form.action = "${pageContext.request.contextPath}/admin/deleteQuotation";
  <%-- CSRF --%>
  <c:if test="${not empty _csrf}">
    const csrf = document.createElement('input');
    csrf.type = 'hidden'; csrf.name = "${_csrf.parameterName}"; csrf.value = "${_csrf.token}";
    form.appendChild(csrf);
  </c:if>
  const q = document.createElement('input');
  q.type = 'hidden'; q.name = 'quotationNo'; q.value = quotationNo;
  form.appendChild(q);
  document.body.appendChild(form);
  form.submit();
}
function reWriteQuotation(productRequestNo){
  location.href = "${pageContext.request.contextPath}/admin/writeQuotationForm?productRequestNo=" + encodeURIComponent(productRequestNo);
}
</script>
</body>
</html>