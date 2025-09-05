<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>계약서 목록</title>

<!-- 폰트/라이브러리 -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

<style>
  :root { --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0; }
  body { font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif; }
  .table-wrap{ max-width:1200px; margin:0 auto; }

  #contractTable_wrapper .dataTables_scroll, #contractTable{
    border:1px solid var(--tbl-border); border-radius:10px; overflow:hidden; background:#fff; font-size:.92rem;
  }

  /* 실제 헤더(2행) */
  #contractTable thead tr:nth-child(2) th{
    background:var(--tbl-head) !important; font-weight:700; color:#111827;
    border-bottom:1px solid var(--tbl-border) !important; vertical-align:middle;
    padding:.55rem .75rem; white-space:nowrap; text-align:center;
  }

  /* 멀티헤더(1행: 그룹행) — 항상 가운데 정렬 */
  #contractTable thead tr.dt-group-header th,
  #contractTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th{
    box-sizing:border-box; min-width:0;
    border-top:none !important; border-bottom:1px solid var(--tbl-border) !important;
    padding:.45rem .75rem;
    text-align:center !important;
    vertical-align:middle !important;
    display:table-cell !important;
    pointer-events:none; /* 그룹행 클릭/정렬 비활성 */
  }

  /* 본문 */
  #contractTable tbody td{
    border-top:1px solid var(--tbl-border); color:#111827; vertical-align:middle;
    height:40px; padding:.45rem .75rem; text-align:center;
    white-space:normal; word-break:keep-all; overflow-wrap:anywhere;
  }
  #contractTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
  #contractTable tbody tr:hover{ background:var(--tbl-hover); }

  /* 숫자/날짜는 한 줄 고정 */
  #contractTable td.nowrap-cell{
    white-space:nowrap !important; word-break:normal !important; overflow-wrap:normal !important;
    text-overflow:clip; overflow:hidden;
  }

  /* 스크롤바 */
  div.dataTables_scrollBody{ scrollbar-width:thin; }
  div.dataTables_scrollBody::-webkit-scrollbar{ height:10px; width:10px; }
  div.dataTables_scrollBody::-webkit-scrollbar-thumb{ background:#D1D5DB; border-radius:6px; }
  div.dataTables_scrollBody::-webkit-scrollbar-track{ background:#F3F4F6; }

  /* 빈 셀 강조 */
  td.cell-empty{ background:var(--tbl-empty) !important; }

  /* 폭 계산 안정화 */
  #contractTable,
  #contractTable_wrapper .dataTables_scrollHead table,
  #contractTable_wrapper .dataTables_scrollBody table{ table-layout:fixed; }

  a{ color:#4c59ff; text-decoration:none; }

  /* 열별 최소/고정 폭 */
  /* 1선택 2계약번호 3견적번호 4계약금 5입금상태 6입금날짜 7잔금 8입금상태 9납기일 10작성자 11작성일자 */
  #contractTable th:nth-child(1), #contractTable td:nth-child(1){
    width:40px !important; min-width:40px !important; max-width:40px !important;
    padding-left:.25rem !important; padding-right:.25rem !important;
  }
  #contractTable td:nth-child(1) input[type="radio"]{ margin:0; display:inline-block; }

  /* 번호열(ch) 기준 고정 */
  #contractTable th:nth-child(2), #contractTable td:nth-child(2),
  #contractTable th:nth-child(3), #contractTable td:nth-child(3){
    width:10ch !important; min-width:10ch !important; max-width:10ch !important;
    white-space:nowrap !important; padding-left:.5rem; padding-right:.5rem;
  }

  /* ── 금액/잔금: 헤더는 가운데, 데이터는 우측 정렬 ── */
  /* 헤더(2행) */
  #contractTable thead tr:nth-child(2) th:nth-child(4),
  #contractTable thead tr:nth-child(2) th:nth-child(7){
    min-width:220px; text-align:center !important;
  }
  /* 데이터 */
  #contractTable tbody td:nth-child(4),
  #contractTable tbody td:nth-child(7){
    min-width:220px; text-align:right !important;
    font-size: 0.75rem; font-weight: bold;
  }

  /* 날짜 최소 폭 */
  #contractTable th:nth-child(6), #contractTable td:nth-child(6){ min-width:130px; }
  #contractTable th:nth-child(9), #contractTable td:nth-child(9){ min-width:130px; }
  #contractTable th:nth-child(11),#contractTable td:nth-child(11){ min-width:130px; }
#contractTable thead tr:nth-child(2) th:nth-child(4),
#contractTable_wrapper .dataTables_scrollHead thead tr:nth-child(2) th:nth-child(4) {
  text-align: center !important;
}
/* [수정] 멀티헤더(1행) '계약금'(4번째)과 '잔금'(5번째) 가운데 정렬 - 원본 thead */
#contractTable thead tr.dt-group-header th:nth-child(4),
#contractTable thead tr.dt-group-header th:nth-child(5) {
  text-align: center !important;
  vertical-align: middle !important;
}


/* [수정] 멀티헤더(1행) '계약금'(4번째)과 '잔금'(5번째) 가운데 정렬 - 스크롤 헤더 복제 thead */
#contractTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th:nth-child(4),
#contractTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th:nth-child(5) {
  text-align: center !important;
  vertical-align: middle !important;
}
#contractTable_wrapper .dataTables_scrollHead thead tr:nth-child(2) th {
  text-align: center !important;
}

  #contractTable_wrapper .pagination{
  --bs-pagination-active-bg: #000;        /* 활성 페이지 배경 = 검정 */
  --bs-pagination-active-border-color: #000;
  --bs-pagination-active-color: #fff;     /* 활성 페이지 숫자 = 흰색 */
  --bs-pagination-focus-box-shadow: 0 0 0 .25rem rgba(0,0,0,.25);
}
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">관리자 계약서 목록</h1>

    <form id="contractForm">
      <table id="contractTable" class="table table-striped table-hover table-bordered align-middle w-100">
        <thead class="table-light">
          <!-- 멀티 헤더(그룹행) -->
          <tr class="dt-group-header">
            <th></th>          <!-- 선택 -->
            <th></th>          <!-- 계약번호 -->
            <th></th>          <!-- 견적번호 -->
            <th colspan="3" class="text-center">계약금</th>
            <th colspan="3" class="text-center">잔금</th>
            <th colspan="2" class="text-center">작성 정보</th>
          </tr>
          <!-- 실제 헤더 -->
          <tr>
            <th></th>
            <th>계약번호</th>
            <th>견적번호</th>
            <th>계약금</th>
            <th>입금 상태</th>
            <th>입금 날짜</th>
            <th>잔금</th>
            <th>입금 상태</th>
            <th>납기일</th>
            <th>작성자</th>
            <th>작성일자</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="con" items="${contractList}">
            <tr>
              <td>
                <input type="radio" name="selectedContracts" value="${con.contractNo}" />
                <input type="hidden" class="quotationNo" value="${con.quotationNo}" />
              </td>
              <td>
                <a href="${pageContext.request.contextPath}/admin/contractOne?contractNo=${con.contractNo}">
                  ${con.contractNo}
                </a>
              </td>
              <td>${con.quotationNo}</td>

              <td class="nowrap-cell"><fmt:formatNumber value="${con.downPayment}" type="number" groupingUsed="true"/>₩</td>
              <td>
                <c:choose>
                  <c:when test="${con.downPaymentStatus == 'PS001'}"><span class="badge text-bg-secondary">입금전</span></c:when>
                  <c:when test="${con.downPaymentStatus == 'PS002'}"><span class="badge text-bg-success">입금완료</span></c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td class="nowrap-cell">${con.formattedDownPaymentDate}</td>

              <td class="nowrap-cell"><fmt:formatNumber value="${con.finalPayment}" type="number" groupingUsed="true"/>₩</td>
              <td>
                <c:choose>
                  <c:when test="${con.finalPaymentStatus == 'PS001'}"><span class="badge text-bg-secondary">입금전</span></c:when>
                  <c:when test="${con.finalPaymentStatus == 'PS002'}"><span class="badge text-bg-success">입금완료</span></c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>
              <td class="nowrap-cell">${con.formattedFinalPaymentDate}</td>

              <td class="nowrap-cell">${con.createUser}</td>
              <td class="nowrap-cell" data-order="${con.createDate}">
                <c:choose>
                  <c:when test="${fn:contains(con.createDate,'T')}">${fn:substringBefore(con.createDate,'T')}</c:when>
                  <c:otherwise>${fn:substringBefore(con.createDate,' ')}</c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>

      <div class="d-flex gap-2 mt-3">
        <button type="button" class="btn btn-outline-danger" onclick="deleteContract()">파기</button>
        <button type="button" class="btn btn-dark" onclick="insertDownPayment()">계약금 입금 확인</button>
        <button type="button" class="btn btn-dark" onclick="insertFinalPayment()">잔금 입금 확인</button>
        <button type="button" class="btn btn-dark" onclick="insertContainer()">컨테이너 상품 입력</button>
      </div>
    </form>
  </div>
</div>

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

	function deleteContract() {
	  const checked = getCheckedContract(); if (!checked) return;
	  if (!confirm("정말 파기하시겠습니까?")) return;

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

	  const row = checked.closest("tr");
	  const statusCell = row.cells[4]; // 계약금 입금 상태 열
	  const statusText = statusCell ? statusCell.innerText.trim() : "";

	  if (statusText.includes("입금완료")) {
	    alert("이미 계약금 입금이 완료된 계약입니다.");
	    return;
	  }

	  const form = document.getElementById("contractForm");
	  form.action = "/admin/insertDownPayment?contractNo=" + checked.value;
	  form.method = "post"; 
	  form.submit();
	}

	function insertFinalPayment() {
	  const checked = getCheckedContract(); 
	  if (!checked) return;

	  const row = checked.closest("tr");
	  const statusCell = row.cells[7]; // 잔금 입금 상태 열
	  const statusText = statusCell ? statusCell.innerText.trim() : "";

	  if (statusText.includes("입금완료")) {
	    alert("이미 잔금 입금이 완료된 계약입니다.");
	    return;
	  }

	  const form = document.getElementById("contractForm");
	  form.action = "/admin/insertFinalPayment?contractNo=" + checked.value;
	  form.method = "post"; 
	  form.submit();
	}

	function insertContainer() {
	  const checked = document.querySelector("input[name='selectedContracts']:checked");
	  if(!checked) { 
	    alert("컨테이너에 입력할 상품을 선택하세요."); 
	    return; 
	  }
	  location.href = "/admin/insertContainer?contractNo=" + checked.value;
	}

</script>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  /* 빈 셀 강조(선택 열 0번은 제외, 요소가 있으면 제외) */
  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).each(function(){
      $(this).children('td').each(function(colIdx){
        const $td = $(this);
        if (colIdx === 0) { $td.removeClass('cell-empty'); return; }
        const hasElem = $td.find('input,button,select,textarea,a,span.badge').length > 0;
        const text = ($td.text() || '').replace(/\u00a0/g,' ').trim().toLowerCase();
        const emptyText = (text === '' || text === 'null' || text === 'undefined' || text === '-');
        if (!hasElem && emptyText) $td.addClass('cell-empty').attr('title','데이터 없음');
        else $td.removeClass('cell-empty').removeAttr('title');
      });
    });
  }

  /* 멀티헤더 폭 동기화 (colspan 합산) */
  function syncAnyGroupHeaderWidths(){
    const $head = $('#contractTable_wrapper .dataTables_scrollHead thead');
    const $row2 = $head.find('tr').eq(1);           // 실제 헤더
    const $row1 = $head.find('tr.dt-group-header'); // 그룹행
    if ($row1.length === 0 || $row2.length === 0) return;

    const widths = $row2.children('th').map(function(){ return Math.round($(this).outerWidth()); }).get();
    let idx = 0;
    $row1.children('th').each(function(){
      const $th = $(this);
      const span = parseInt($th.attr('colspan') || '1', 10);
      let sum = 0; for (let i=0;i<span;i++) sum += (widths[idx+i] || 0);
      idx += span;
      const px = Math.max(0, sum);
      $th.css({ width:px+'px', minWidth:px+'px', maxWidth:px+'px' });
    });
  }

  $(function(){
    const table = $('#contractTable').DataTable({
      ordering:true,
      searching:true,
      paging:true,
      pageLength:10,
      lengthMenu:[10,25,50,100],
      info:true,
      autoWidth:false,
      scrollX:true,
      scrollY:'55vh',
      scrollCollapse:true,
      columnDefs:[
    	  { targets:0,  width:'40px', orderable:false },
    	  { targets:1,  width:'70px', className:'text-center' },   // 계약번호
    	  { targets:2,  width:'70px', className:'text-center' },   // 견적번호

    	  { targets:3,  width:'22%', className:'nowrap-cell' },    // [수정] 계약금 16% -> 22%
    	  { targets:4,  width:'7%',  className:'text-center' },    // [수정] 입금상태 8% -> 7%
    	  { targets:5,  width:'11%', className:'nowrap-cell text-center' }, // [수정] 입금날짜 12% -> 11%

    	  { targets:6,  width:'20%', className:'nowrap-cell' },    // [수정] 잔금 12% -> 20%
    	  { targets:7,  width:'7%',  className:'text-center' },    // [수정] 입금상태 8% -> 7%
    	  { targets:8,  width:'11%', className:'nowrap-cell text-center' }, // [수정] 납기일 12% -> 11%
    	  { targets:9,  width:'5%',  className:'nowrap-cell text-center' }, // [수정] 작성자 6% -> 5%
    	  { targets:10, width:'8%',  className:'nowrap-cell text-center' }  // [수정] 작성일자 9% -> 8%
    	],
      order:[[1,'desc']],
      dom:'<"row mb-2"<"col-12 col-md-6"l><"col-12 col-md-6"f>>t<"row mt-2"<"col-12 col-md-5"i><"col-12 col-md-7"p>>',
      language:{
        lengthMenu:'_MENU_ 개씩 보기', search:'검색:',
        info:'총 _TOTAL_건 중 _START_–_END_', infoEmpty:'0건',
        infoFiltered:'(필터링: _MAX_건 중)', zeroRecords:'일치하는 데이터가 없습니다.',
        paginate:{ first:'처음', last:'마지막', next:'다음', previous:'이전' },
        loadingRecords:'불러오는 중...', processing:'처리 중...'
      },
      drawCallback:function(){
        const api = this.api();
        highlightEmptyCells(api);
        syncAnyGroupHeaderWidths();
      },
      initComplete:function(){
        const api = this.api();
        highlightEmptyCells(api);
        setTimeout(()=>{ api.columns.adjust().draw(false); syncAnyGroupHeaderWidths(); }, 0);
        $(window).on('resize', syncAnyGroupHeaderWidths);
        api.table().on('column-sizing.dt columns-visibility.dt', syncAnyGroupHeaderWidths);
      }
    });

    table.columns.adjust().draw(false);
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