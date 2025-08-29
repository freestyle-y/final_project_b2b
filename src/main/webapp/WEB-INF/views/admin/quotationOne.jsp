<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
    --tbl-border:#E5E7EB;
    --tbl-head:#F9FAFB;
    --tbl-hover:#F3F4F6;
    --tbl-zebra:#FAFAFA;
    --badge-green:#10b981; --badge-yellow:#f59e0b; --badge-red:#ef4444; --badge-gray:#6b7280;
  }
  body{
    font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif;
    background:#fff;
  }

  .detail-wrap{ max-width:1400px; margin:24px auto; padding:0 12px; }

  /* 카드 패널 — 둥근 모서리 밖으로 내용이 안 튀도록 클리핑 */
  .panel{
    border:1px solid var(--tbl-border);
    border-radius:14px;
    background:#fff;
    box-shadow:0 2px 10px rgba(0,0,0,.03);
    overflow:hidden; /* ★ 수정: 모서리 클리핑 */
  }
  .panel-header{
    padding:16px 20px; border-bottom:1px solid var(--tbl-border);
    display:flex; align-items:center; justify-content:space-between;
  }
  .panel-title{ margin:0; font-size:1.1rem; font-weight:700; }

  /* 테이블 클리핑 래퍼 — 패널 라운드와 동일 반경으로 한 번 더 보호 */
  .table-clip{ border-radius:14px; overflow:hidden; } /* ★ 추가 */

  /* 표 — 화면 폭 100%에 맞는 고정 레이아웃, 줄바꿈으로 넘침 방지 */
  table.detail-table{
    width:100%;
    table-layout:fixed;          /* 열 폭을 colgroup 기준으로 고정 */
    border-collapse:collapse;    /* 수직선 정확 */
    font-size:.95rem;
    background:#fff;
  }

  /* 헤더/본문 스타일 */
  table.detail-table thead th{
    background:var(--tbl-head);
    border-bottom:1px solid var(--tbl-border);
    border-right:1px solid var(--tbl-border);
    padding:.6rem .8rem; text-align:center; white-space:nowrap; color:#111827; font-weight:700;
  }
  table.detail-table thead th:last-child{ border-right:0; } /* ★ 오른쪽 라운드에 선 안 겹치게 */

  table.detail-table tbody td{
    border-top:1px solid var(--tbl-border);
    border-right:1px solid var(--tbl-border);
    padding:.55rem .8rem; vertical-align:middle; text-align:center; color:#111827;
    white-space:normal; word-break:keep-all; overflow-wrap:anywhere; height:42px;
  }
  table.detail-table tbody td:last-child{ border-right:0; } /* ★ 동일 */

  table.detail-table tbody tr:nth-child(even){ background:var(--tbl-zebra); }
  table.detail-table tbody tr:hover{ background:var(--tbl-hover); }

  /* 열 폭(%): 합계 100% — 필요시 숫자만 조절하세요 */
  /* 1 번호 2 상태 3 작성자 4 작성일자 5 상품명 6 옵션 7 수량 8 가격 */
  table.detail-table col:nth-child(1){ width:8%;  }
  table.detail-table col:nth-child(2){ width:10%; }
  table.detail-table col:nth-child(3){ width:10%; }
  table.detail-table col:nth-child(4){ width:16%; }
  table.detail-table col:nth-child(5){ width:24%; }
  table.detail-table col:nth-child(6){ width:14%; }
  table.detail-table col:nth-child(7){ width:8%;  }
  table.detail-table col:nth-child(8){ width:10%; }

  .nowrap-cell{ white-space:nowrap !important; }
  .text-end{ text-align:right !important; }

  /* 상태 배지 */
  .status-badge{
    display:inline-block; padding:6px 12px; border-radius:999px;
    color:#fff; font-size:.85rem; font-weight:700; letter-spacing:.3px;
  }
  .status-승인{ background:var(--badge-green); }
  .status-승인전{ background:var(--badge-yellow); }
  .status-승인거절{ background:var(--badge-red); }
  .status-기타{ background:var(--badge-gray); }
</style>
</head>
<body>

<%@ include file="/WEB-INF/common/header/header.jsp"%>

<div class="detail-wrap">
  <div class="panel">
    <div class="panel-header">
      <h1 class="panel-title">견적서 상세</h1>
      <div class="d-flex gap-2">
        <c:if test="${adminQuotationOne.status eq '승인' and exist eq 0}">
          <button type="submit" form="quotationForm" class="btn btn-primary btn-sm rounded-pill fw-bold">계약서 작성</button>
        </c:if>
        <c:if test="${adminQuotationOne.status eq '승인거절' }">
          <button type="button" class="btn btn-outline-secondary btn-sm rounded-pill fw-bold" onclick="reWriteQuotation()">견적서 재작성</button>
        </c:if>
        <c:if test="${adminQuotationOne.status eq '승인전'}">
          <button type="button" class="btn btn-warning btn-sm rounded-pill fw-bold" onclick="modifyQuotation()">수정</button>
          <button type="button" class="btn btn-danger btn-sm rounded-pill fw-bold" onclick="deleteQuotation()">삭제</button>
        </c:if>
      </div>
    </div>

    <form id="quotationForm" method="GET" action="${pageContext.request.contextPath}/admin/writeContract" class="m-0">
      <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      </c:if>

      <input type="hidden" name="quotationNo" value="${adminQuotationOne.quotationNo}"/>
      <input type="hidden" name="productRequestNo" value="${adminQuotationOne.productRequestNo}"/>

      <div class="table-clip"><!-- ★ 추가: 둥근 모서리 클리핑 -->
        <table class="detail-table">
          <colgroup><!-- 폭은 CSS의 col:nth-child()에서 제어 -->
            <col><col><col><col><col><col><col><col>
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
            </tr>
          </thead>
          <tbody>
            <c:set var="rowCount" value="${fn:length(adminQuotationOne.items)}"/>
            <c:forEach var="item" items="${adminQuotationOne.items}" varStatus="status">
              <tr>
                <c:if test="${status.first}">
                  <td rowspan="${rowCount}" class="nowrap-cell">${adminQuotationOne.quotationNo}</td>
                  <td rowspan="${rowCount}">
                    <c:choose>
                      <c:when test="${adminQuotationOne.status eq '승인'}"><span class="status-badge status-승인">승인</span></c:when>
                      <c:when test="${adminQuotationOne.status eq '승인전'}"><span class="status-badge status-승인전">승인전</span></c:when>
                      <c:when test="${adminQuotationOne.status eq '승인거절'}"><span class="status-badge status-승인거절">승인거절</span></c:when>
                      <c:otherwise><span class="status-badge status-기타"><c:out value="${adminQuotationOne.status}"/></span></c:otherwise>
                    </c:choose>
                  </td>
                  <td rowspan="${rowCount}" class="nowrap-cell"><c:out value="${adminQuotationOne.createUser}"/></td>
                  <td rowspan="${rowCount}" class="nowrap-cell">
                    <c:choose>
                      <c:when test="${fn:contains(adminQuotationOne.createDate,'T')}">
                        ${fn:replace(adminQuotationOne.createDate, 'T', ' ')}
                      </c:when>
                      <c:otherwise>${adminQuotationOne.createDate}</c:otherwise>
                    </c:choose>
                  </td>
                </c:if>

                <td><c:out value="${item.productName}"/></td>
                <td><c:out value="${item.productOption}"/></td>
                <td class="nowrap-cell"><c:out value="${item.productQuantity}"/></td>
                <td class="nowrap-cell text-end">₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/></td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>
    </form>
  </div>
</div>

<%@ include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
  function modifyQuotation(){
    const quotationNo = document.querySelector("input[name='quotationNo']").value;
    location.href = "${pageContext.request.contextPath}/admin/modifyQuotationForm?quotationNo=" + encodeURIComponent(quotationNo);
  }
  function deleteQuotation(){
    if(!confirm("정말 삭제하시겠습니까?")) return;
    const form = document.getElementById("quotationForm");
    form.action = "${pageContext.request.contextPath}/admin/deleteQuotation";
    form.method = "post";
    form.submit();
  }
  function reWriteQuotation(){
    const productRequestNo = document.querySelector("input[name='productRequestNo']").value;
    location.href = "${pageContext.request.contextPath}/admin/quotationList?productRequestNo=" + encodeURIComponent(productRequestNo);
  }
</script>
</body>
</html>