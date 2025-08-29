<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
  .table-wrap{ max-width:1400px; margin:0 auto; }

  #contractTable_wrapper .dataTables_scroll, #contractTable{
    border:1px solid var(--tbl-border); border-radius:10px; overflow:hidden; background:#fff; font-size:.92rem;
  }

  /* 실제 헤더 */
  #contractTable thead tr:nth-child(2) th{
    background:var(--tbl-head) !important; font-weight:700; color:#111827;
    border-bottom:1px solid var(--tbl-border) !important; vertical-align:middle;
    padding:.55rem .75rem; white-space:nowrap; text-align:center;
  }

  /* 멀티헤더(그룹행) */
  #contractTable thead tr.dt-group-header th,
  #contractTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th{
    box-sizing:border-box; min-width:0;
    border-top:none !important; border-bottom:1px solid var(--tbl-border) !important;
    padding:.45rem .75rem;
    text-align:center !important;
    vertical-align:middle !important;
    display:table-cell !important;
    pointer-events:none;
  }

  /* 본문 */
  #contractTable tbody td{
    border-top:1px solid var(--tbl-border); color:#111827; vertical-align:middle;
    height:40px; padding:.45rem .75rem; text-align:center;
    white-space:normal; word-break:keep-all; overflow-wrap:anywhere;
  }
  #contractTable tbody td:nth-child(2),
#contractTable tbody td:nth-child(5){
  text-align: right !important;
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

  /* 열별 최소/고정 폭 (견적번호 제거 후 인덱스 재배치) */
  #contractTable th:nth-child(1), #contractTable td:nth-child(1){ /* 계약번호 */
    width:10ch !important; min-width:10ch !important; max-width:10ch !important;
    white-space:nowrap !important; padding-left:.5rem; padding-right:.5rem;
  }
  #contractTable th:nth-child(2), #contractTable td:nth-child(2){ /* 계약금 */
    min-width:10ch !important; white-space:nowrap !important;
  }

  /* 작성일자 최소 폭 (총 8열이므로 8번째) */
  #contractTable th:nth-child(8), #contractTable td:nth-child(8){ min-width:130px; }
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">계약서 목록</h1>

    <table id="contractTable" class="table table-striped table-hover table-bordered align-middle w-100">
      <thead class="table-light">
        <!-- 멀티 헤더(그룹행) : 견적번호 칼럼 제거에 맞춰 재정렬 -->
        <tr class="dt-group-header">
          <th></th> <!-- 계약번호 -->
          <th colspan="3" class="text-center">계약금</th>
          <th colspan="3" class="text-center">잔금</th>
          <th></th> <!-- 작성일자 -->
        </tr>
        <!-- 실제 헤더 -->
        <tr>
          <th>계약번호</th>
          <th>계약금</th>
          <th>입금 상태</th>
          <th>입금 날짜</th>
          <th>잔금</th>
          <th>입금 상태</th>
          <th>납기일</th>
          <th>작성일자</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="con" items="${contractList}">
          <tr>
            <td>
              <a href="${pageContext.request.contextPath}/biz/contractOne?contractNo=${con.contractNo}">
                ${con.contractNo}
              </a>
            </td>

            <!-- 견적번호 열 제거됨 -->

            <td class="nowrap-cell"><fmt:formatNumber value="${con.downPayment}" type="number" groupingUsed="true"/>₩</td>
            <td>
              <c:choose>
                <c:when test="${con.downPaymentStatus == 'PS001'}"><span class="payment-badge payment-pending">입금전</span></c:when>
                <c:when test="${con.downPaymentStatus == 'PS002'}"><span class="payment-badge payment-completed">입금완료</span></c:when>
                <c:otherwise><span class="payment-badge payment-failed">-</span></c:otherwise>
              </c:choose>
            </td>
            <td class="nowrap-cell">${con.formattedDownPaymentDate}</td>

            <td class="nowrap-cell"><fmt:formatNumber value="${con.finalPayment}" type="number" groupingUsed="true"/>₩</td>
            <td>
              <c:choose>
                <c:when test="${con.finalPaymentStatus == 'PS001'}"><span class="payment-badge payment-pending">입금전</span></c:when>
                <c:when test="${con.finalPaymentStatus == 'PS002'}"><span class="payment-badge payment-completed">입금완료</span></c:when>
                <c:otherwise><span class="payment-badge payment-failed">-</span></c:otherwise>
              </c:choose>
            </td>
            <td class="nowrap-cell">${con.formattedFinalPaymentDate}</td>
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

    <div class="d-flex justify-content-center mt-4">
      <button type="button" class="btn btn-contract-write" onclick="location.href='${pageContext.request.contextPath}/biz/writeContract'">
        <i class="fas fa-plus me-2"></i>계약서 작성
      </button>
    </div>
  </div>
</div>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  /* 빈 셀 강조 */
  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).each(function(){
      $(this).children('td').each(function(colIdx){
        const $td = $(this);
        if (colIdx === 0) { $td.removeClass('cell-empty'); return; } // 계약번호는 제외
        const hasElem = $td.find('input,button,select,textarea,a,span.status-badge,span.payment-badge').length > 0;
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
      ordering: true,
      searching: true,
      paging: true,
      pageLength: 10,
      lengthMenu: [10, 25, 50, 100],
      info: true,
      autoWidth: false,
      scrollX: true,
      scrollY: '55vh',
      scrollCollapse: true,
      columnDefs: [
        { targets: 0, width: '100px', className: 'text-center' },           // 계약번호
        { targets: 1, width: '15%', className: 'nowrap-cell text-center' },             // 계약금
        { targets: 2, width: '10%', className: 'text-center' },             // 계약금 입금 상태
        { targets: 3, width: '12%', className: 'nowrap-cell text-center' }, // 계약금 입금 날짜
        { targets: 4, width: '15%', className: 'nowrap-cell text-center' },             // 잔금
        { targets: 5, width: '10%', className: 'text-center' },             // 잔금 입금 상태
        { targets: 6, width: '12%', className: 'nowrap-cell text-center' }, // 납기일
        { targets: 7, width: '12%', className: 'nowrap-cell text-center' }  // 작성일자
      ],
      order: [[0, 'desc']], // 계약번호 기준 내림차순
      dom: '<"row mb-2"<"col-12 col-md-6"l><"col-12 col-md-6"f>>t<"row mt-2"<"col-12 col-md-5"i><"col-12 col-md-7"p>>',
      language: {
        lengthMenu: '_MENU_ 개씩 보기',
        search: '검색:',
        info: '총 _TOTAL_건 중 _START_–_END_',
        infoEmpty: '0건',
        infoFiltered: '(필터링: _MAX_건 중)',
        zeroRecords: '일치하는 데이터가 없습니다.',
        paginate: { first:'처음', last:'마지막', next:'다음', previous:'이전' },
        loadingRecords: '불러오는 중...', processing: '처리 중...'
      },
      drawCallback: function(){
        const api = this.api();
        highlightEmptyCells(api);
        syncAnyGroupHeaderWidths();
      },
      initComplete: function(){
        const api = this.api();
        highlightEmptyCells(api);
        setTimeout(() => {
          api.columns.adjust().draw(false);
          syncAnyGroupHeaderWidths();
        }, 0);
        $(window).on('resize', syncAnyGroupHeaderWidths);
        api.table().on('column-sizing.dt columns-visibility.dt', syncAnyGroupHeaderWidths);
      }
    });

    table.columns.adjust().draw(false);
  });
</script>
</body>
</html>