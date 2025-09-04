<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>기업회원 견적서 상세</title>

<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
:root{
  --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA;
  --badge-green:#10b981; --badge-yellow:#f59e0b; --badge-red:#ef4444; --badge-gray:#6b7280;
}
body{font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif;background:#fff;}
.wrap{max-width:1200px;margin:24px auto;padding:0 12px;}

/* 패널 */
.panel{border:1px solid var(--tbl-border); border-radius:14px; background:#fff; box-shadow:0 2px 10px rgba(0,0,0,.03); overflow:hidden;}
.panel-header{padding:16px 20px; border-bottom:1px solid var(--tbl-border); display:flex; gap:12px; align-items:center; justify-content:space-between;}
.panel-title{margin:0; font-size:1.1rem; font-weight:700;}

/* 상태 뱃지 */
.status-badge{display:inline-block; padding:6px 12px; border-radius:999px; color:#fff; font-size:.85rem; font-weight:700; letter-spacing:.3px;}
.status-승인{background:var(--badge-green);}
.status-승인전{background:var(--badge-yellow);}
.status-승인거절{background:var(--badge-red);}
.status-기타{background:var(--badge-gray);}

/* 표 */
.table-clip{border-radius:14px; overflow:hidden;}
table.detail{width:100%; table-layout:fixed; border-collapse:collapse; font-size:.95rem; background:#fff;}
table.detail thead th{
  background:var(--tbl-head); border-bottom:1px solid var(--tbl-border); border-right:1px solid var(--tbl-border);
  padding:.6rem .8rem; text-align:center; white-space:nowrap; color:#111827; font-weight:700;
}
table.detail thead th:last-child{border-right:0;}
table.detail tbody td{
  border-top:1px solid var(--tbl-border); border-right:1px solid var(--tbl-border);
  padding:.55rem .8rem; vertical-align:middle; text-align:center; color:#111827; height:42px;
}
table.detail tbody td:last-child{border-right:0;}
table.detail tbody tr:nth-child(even){background:var(--tbl-zebra);}
table.detail tbody tr:hover{background:var(--tbl-hover);}
table.detail tfoot td{background:#fafafa; font-weight:700;}

/* 폭 */
table.detail col:nth-child(1){width:34%;}
table.detail col:nth-child(2){width:18%;}
table.detail col:nth-child(3){width:10%;}
table.detail col:nth-child(4){width:14%;}
table.detail col:nth-child(5){width:14%;}

/* 유틸 */
.nowrap{white-space:nowrap !important;}
.text-end{text-align:right !important;}

/* 오프캔버스(거절) UI */
.reason-chip{ min-width:96px; }
.counter{ font-size:.85rem; color:#6b7280; }
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="wrap">

  <!-- 상단: 제목/상태/작성자/작성일 + 버튼들(인쇄 없음) -->
  <div class="panel mb-3">
    <div class="panel-header">
      <div>
        <h1 class="panel-title">
          견적서 번호: <span class="text-primary">${quotationOne.quotationNo}</span>
        </h1>
        <div class="small text-muted mt-1">
          상태:
          <c:choose>
            <c:when test="${quotationOne.status eq '승인'}"><span class="status-badge status-승인">승인</span></c:when>
            <c:when test="${quotationOne.status eq '승인거절'}"><span class="status-badge status-승인거절">승인거절</span></c:when>
            <c:when test="${quotationOne.status eq '승인전'}"><span class="status-badge status-승인전">승인전</span></c:when>
            <c:otherwise><span class="status-badge status-기타"><c:out value="${quotationOne.status}"/></span></c:otherwise>
          </c:choose>
        </div>
      </div>

      <div class="text-end">
        <div class="small">작성자: <strong><c:out value="${quotationOne.createUser}"/></strong></div>
        <div class="small text-muted">작성일자: <strong><c:out value="${quotationOne.createDate}"/></strong></div>

        <div class="mt-2 d-flex gap-2 justify-content-end">
          <a class="btn btn-outline-secondary btn-sm rounded-pill fw-bold" href="${pageContext.request.contextPath}/biz/quotationList">목록</a>

          <c:if test="${quotationOne.status ne '승인'}">
            <form action="${pageContext.request.contextPath}/biz/quotationApprove" method="post" class="m-0" onsubmit="return confirm('이 견적서를 승인하시겠습니까?')">
              <c:if test="${not empty _csrf}">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
              </c:if>
              <input type="hidden" name="quotationNo" value="${quotationOne.quotationNo}"/>
              <button type="submit" class="btn btn-primary btn-sm rounded-pill fw-bold">승인</button>
            </form>
          </c:if>

          <c:if test="${quotationOne.status ne '승인거절'}">
            <!-- 거절: 오른쪽 오프캔버스 열기 -->
            <button type="button"
                    class="btn btn-danger btn-sm rounded-pill fw-bold"
                    data-bs-toggle="offcanvas"
                    data-bs-target="#rejectDrawer"
                    data-quotation-no="${quotationOne.quotationNo}">
              거절
            </button>
          </c:if>
        </div>
      </div>
    </div>
  </div>

  <!-- 품목 테이블 -->
  <div class="panel">
    <div class="table-clip">
      <table class="detail">
        <colgroup><col><col><col><col><col></colgroup>
        <thead>
          <tr>
            <th>상품명</th>
            <th>옵션</th>
            <th>수량</th>
            <th>가격</th>
            <th>소계</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${empty quotationOne.items}">
              <tr>
                <td colspan="5" class="text-muted">등록된 품목이 없습니다.</td>
              </tr>
            </c:when>
            <c:otherwise>
              <c:set var="grandTotal" value="0"/>
              <c:forEach var="item" items="${quotationOne.items}">
                <c:set var="rowTotal" value="${item.price}"/>
                <c:set var="grandTotal" value="${grandTotal + rowTotal}"/>
                <tr>
                  <td style="text-align:left"><c:out value="${item.productName}"/></td>
                  <td><c:out value="${item.productOption}"/></td>
                  <td class="nowrap"><c:out value="${item.productQuantity}"/></td>
                  <td class="nowrap text-end">₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/></td>
                  <td class="nowrap text-end">₩<fmt:formatNumber value="${rowTotal}" type="number" groupingUsed="true"/></td>
                </tr>
              </c:forEach>
              <tr>
                <td colspan="4" class="text-end">총액</td>
                <td class="nowrap text-end">₩<fmt:formatNumber value="${grandTotal}" type="number" groupingUsed="true"/></td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
    </div>
  </div>

</div>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- ===== 거절 오프캔버스 ===== -->
<div class="offcanvas offcanvas-end" tabindex="-1" id="rejectDrawer" aria-labelledby="rejectDrawerLabel">
  <div class="offcanvas-header">
    <h5 class="offcanvas-title" id="rejectDrawerLabel">견적서 거절 사유 입력</h5>
    <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="닫기"></button>
  </div>
  <div class="offcanvas-body">
    <form action="${pageContext.request.contextPath}/biz/quotationReject"
          method="post" id="rejectForm" onsubmit="return validateRejection();">

      <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      </c:if>
      <input type="hidden" name="quotationNo" id="rejectQuotationNo" value="${quotationOne.quotationNo}"/>
      <input type="hidden" name="rejectionCategory" id="rejectionCategory" value=""/>

      <!-- 상세 사유 -->
      <div class="mb-1 d-flex justify-content-between align-items-center">
        <label for="rejectionReason" class="form-label fw-bold mb-0">상세 사유</label>
        <div class="counter"><span id="reasonCount">0</span> / 500</div>
      </div>
      <textarea class="form-control" id="rejectionReason" name="rejectionReason"
                rows="6" maxlength="500"
                required></textarea>
      <div class="form-text">• 최소 5자 이상 입력 • 최대 500자</div>

      <div class="mt-3 d-flex gap-2">
        <button type="button" class="btn btn-light" data-bs-dismiss="offcanvas">취소</button>
        <button type="submit" class="btn btn-danger">거절 제출</button>
      </div>
    </form>
  </div>
</div>

<!-- JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // 오프캔버스 열릴 때 quotationNo 세팅 & 입력 초기화
  const rejectDrawer = document.getElementById('rejectDrawer');
  const rejectQuotationNo = document.getElementById('rejectQuotationNo');
  const rejectionCategory = document.getElementById('rejectionCategory');
  const rejectionReason = document.getElementById('rejectionReason');
  const reasonCount = document.getElementById('reasonCount');

  rejectDrawer.addEventListener('show.bs.offcanvas', function (event) {
    const triggerBtn = event.relatedTarget;
    const qNo = triggerBtn?.getAttribute('data-quotation-no') || '${quotationOne.quotationNo}';
    rejectQuotationNo.value = qNo;

    // 초기화
    rejectionCategory.value = '';
    rejectionReason.value = '';
    reasonCount.textContent = '0';
  });
  // 글자수 카운트
  rejectionReason.addEventListener('input', function(){
    reasonCount.textContent = String(this.value.length);
  });

  // 검증
  function validateRejection(){
    const text = rejectionReason.value.trim();
    if(text.length < 5){
      alert('상세 사유를 최소 5자 이상 입력해주세요.');
      rejectionReason.focus();
      return false;
    }
    if(text.length > 500){
      alert('상세 사유는 500자 이내로 입력해주세요.');
      rejectionReason.focus();
      return false;
    }
    return true;
  }
</script>
<script>
/* 1) 드롭다운 토글 버튼이면 type="button" 강제(폼 submit 방지) */
(function ensureBtnType(){
  const sel = [
    'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
    '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
    'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]',
    '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
  ].join(',');

  document.querySelectorAll(sel).forEach(btn => {
    if (!btn.hasAttribute('type')) btn.setAttribute('type','button');
  });
})();

/* 2) 캡처링 단계에서 좌표 기반 hit-test로 드롭다운 강제 토글 */
(function forceDropdownToggle(){
  const getBtns = () => Array.from(document.querySelectorAll(
    'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
    '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
    'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"],' +
    '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
  ));

  function inside(rect, x, y){
    return x >= rect.left && x <= rect.right && y >= rect.top && y <= rect.bottom;
  }

  // 캡처링 단계(true)로 등록 → 위에 뭔가 덮여 있어도 좌표로 판별해 토글
  document.addEventListener('click', function(ev){
    const x = ev.clientX, y = ev.clientY;
    const btn = getBtns().find(b => inside(b.getBoundingClientRect(), x, y));
    if (!btn) return;

    // 기본 동작(폼 제출/포커스 등) 막고 Bootstrap 드롭다운을 직접 토글
    ev.preventDefault();
    // ev.stopPropagation(); // 필요시 주석 해제. 기본에선 버블링 유지.

    try {
      const dd = bootstrap.Dropdown.getOrCreateInstance(btn);
      dd.toggle();
    } catch (e) {
      // bootstrap이 아직 로드 전이면 다음 틱에 재시도
      setTimeout(() => {
        const dd = bootstrap.Dropdown.getOrCreateInstance(btn);
        dd.toggle();
      }, 0);
    }
  }, true);
})();
</script>

</body>
</html>