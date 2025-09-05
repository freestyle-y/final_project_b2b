<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <%@ include file="/WEB-INF/common/head.jsp" %>
  <title>상품 요청 목록</title>

  <link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

  <style>
    :root{ --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0; }
    body{ font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif; }
    .table-wrap{ max-width:1000px; margin:0 auto; }

    /* 한 개의 테이블만 사용 (헤더/바디 분리 X) */
    #productRequestTable{
      width:100%;
      border:1px solid var(--tbl-border);
      border-radius:10px;
      overflow:hidden;
      background:#fff;
      font-size:.92rem;
      table-layout:fixed;          /* 열폭 고정 */
      border-collapse:collapse;
    }
    #productRequestTable thead th{
      background:var(--tbl-head) !important;
      font-weight:700; color:#111827;
      border-bottom:1px solid var(--tbl-border) !important;
      vertical-align:middle; white-space:nowrap;
      padding:.55rem .75rem;
    }
    #productRequestTable tbody td{
      vertical-align:middle; padding:.55rem .75rem;
    }
    #productRequestTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
    #productRequestTable tbody tr:hover{ background:var(--tbl-hover); }

    /* 같은 요청번호는 텍스트만 투명 처리(라인 유지) */
    td.group-col.visually-merged{
      color:transparent !important; text-shadow:none !important;
      pointer-events:none !important; user-select:none !important;
      background-color:transparent !important; border-color:inherit !important;
    }
    td.cell-empty{ background:var(--tbl-empty) !important; }
    a{ color:#4c59ff; text-decoration:none; }
    
      #productRequestTable_wrapper .pagination{
  --bs-pagination-active-bg: #000;        /* 활성 페이지 배경 = 검정 */
  --bs-pagination-active-border-color: #000;
  --bs-pagination-active-color: #fff;     /* 활성 페이지 숫자 = 흰색 */
  --bs-pagination-focus-box-shadow: 0 0 0 .25rem rgba(0,0,0,.25);
}
  </style>
</head>
<body>

<%@ include file="/WEB-INF/common/header/header.jsp" %>

<div class="container-xl py-4">
  <h2 class="mb-4 text-center">상품 요청 목록</h2>

  <div class="table-wrap">
    <table id="productRequestTable" class="table table-striped table-hover table-bordered align-middle">
      <colgroup>
        <col style="width:9ch;">
        <col>                      <col style="width:16ch;">  <col style="width:10ch;">  </colgroup>
      <thead class="table-light">
        <tr>
          <th class="text-center">번호</th>
          <th class="text-start">상품명</th>
          <th class="text-start">옵션</th>
          <th class="text-end">수량</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="productList" items="${groupedRequests.values()}">
          <c:forEach var="p" items="${productList}" varStatus="status">
            <tr>
              <td class="group-col text-center">
                <c:choose>
                  <c:when test="${status.first}">
                    <a href="${pageContext.request.contextPath}/biz/requestDetail?requestNo=${p.productRequestNo}">
                      ${p.productRequestNo}
                    </a>
                  </c:when>
                  <c:otherwise>${p.productRequestNo}</c:otherwise>
                </c:choose>
              </td>
              <td class="text-start">${p.productName}</td>
              <td class="text-start">${p.productOption}</td>
              <td class="text-end">${p.productQuantity}</td>
            </tr>
          </c:forEach>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/WEB-INF/common/footer/footer.jsp" %>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  // 숫자를 쉼표 형식으로 변환하는 함수
  function formatNumberWithCommas(num) {
    return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
  }
  
  function visuallyGroupFirstColumn(api){
    let last = null;
    api.column(0, { page:'current' }).nodes().each(function(cell){
      const $c = $(cell), v = $c.text().trim();
      $c.removeClass('visually-merged').removeAttr('aria-hidden');
      if(last !== null && v === last){ $c.addClass('visually-merged').attr('aria-hidden','true'); }
      else{ last = v; }
    });
  }
  function highlightEmptyCells(api){
    const rows = api.rows({ page:'current' }).nodes();
    $(rows).find('td').each(function(){
      const $td = $(this);
      if($td.hasClass('group-col') && $td.hasClass('visually-merged')) return;
      const t = ($td.text()||'').trim().toLowerCase();
      if(t === '' || t === 'null' || t === 'undefined'){ $td.addClass('cell-empty').attr('title','데이터 없음'); }
      else{ $td.removeClass('cell-empty').removeAttr('title'); }
    });
  }
  
  // 수량 컬럼의 숫자를 포맷팅하는 새로운 함수
  function formatQuantityColumn(api) {
      // 수량 컬럼 (네 번째 컬럼, 인덱스 3)의 모든 셀에 대해 반복
      api.column(3, { page: 'current' }).nodes().each(function(cell) {
          const $c = $(cell);
          // 텍스트에서 쉼표를 제거하고 숫자로 변환
          const quantity = parseInt($c.text().trim().replace(/,/g, ''), 10);
          
          if (!isNaN(quantity)) {
              // 유효한 숫자일 경우, 포맷팅 함수를 적용
              $c.text(formatNumberWithCommas(quantity));
          }
      });
  }

  $(function(){
    const dt = $('#productRequestTable').DataTable({
      paging:true, pageLength:10, lengthMenu:[10,25,50,100],
      ordering:true, searching:true, info:true,
      autoWidth:false,           // colgroup 폭 사용
      responsive:false,
      dom:'<"row mb-2"<"col-md-6"l><"col-md-6 text-end"f>>t<"row mt-2"<"col-md-5"i><"col-md-7"p>>',
      order:[[0,'desc']],
      language:{
        lengthMenu:'_MENU_ 개씩 보기', search:'검색:', info:'총 _TOTAL_건 중 _START_–_END_',
        infoEmpty:'0건', infoFiltered:'(전체 _MAX_건 중 필터링됨)',
        zeroRecords:'일치하는 데이터가 없습니다.',
        paginate:{ first:'처음', last:'마지막', next:'다음', previous:'이전' }
      },
      drawCallback:function(){
        const api=this.api();
        visuallyGroupFirstColumn(api);
        highlightEmptyCells(api);
        // ✅ 페이지가 그려질 때마다 수량 포맷팅 함수 호출
        formatQuantityColumn(api);
      },
      initComplete:function(){
        const api=this.api();
        visuallyGroupFirstColumn(api);
        highlightEmptyCells(api);
        // ✅ DataTables 초기화가 완료되었을 때 수량 포맷팅 함수 호출
        formatQuantityColumn(api);
        // 폰트 로딩 이후 1회 보정
        const adjust = () => api.columns.adjust();
        setTimeout(adjust,0);
        if(document.fonts && document.fonts.ready) document.fonts.ready.then(adjust);
        $(window).on('resize', adjust);
      }
    });
  });
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