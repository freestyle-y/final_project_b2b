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

  /* 헤더 공통 */
  #contractTable,
  #contractTable_wrapper .dataTables_scrollHead table,
  #contractTable_wrapper .dataTables_scrollBody table{
    table-layout:fixed !important;
    border-collapse:collapse !important;
  }

  /* 실제 헤더(2행) */
  #contractTable thead tr:nth-child(2) th{
    background:var(--tbl-head) !important; font-weight:700; color:#111827;
    border-bottom:1px solid var(--tbl-border) !important; vertical-align:middle;
    padding:.55rem .75rem; white-space:nowrap; text-align:center;
  }

  /* 그룹 헤더(1행) */
  #contractTable thead tr.dt-group-header th,
  #contractTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th{
    box-sizing:border-box; min-width:0;
    border-top:none !important; border-bottom:1px solid var(--tbl-border) !important;
    padding:.45rem .75rem; text-align:center !important; vertical-align:middle !important;
    display:table-cell !important; pointer-events:none;
    background:#fff;
  }

  /* 본문 */
  #contractTable tbody td{
    border-top:1px solid var(--tbl-border); color:#111827; vertical-align:middle;
    height:40px; padding:.45rem .75rem; text-align:center;
  }
  #contractTable tbody td:nth-child(2),
  #contractTable tbody td:nth-child(5){ text-align:right !important; }
  #contractTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
  #contractTable tbody tr:hover{ background:var(--tbl-hover); }

  /* 숫자/날짜 한 줄 */
  #contractTable td.nowrap-cell{ white-space:nowrap !important; overflow:hidden; text-overflow:clip; }

  /* 스크롤바 */
  div.dataTables_scrollBody{ scrollbar-width:thin; }
  div.dataTables_scrollBody::-webkit-scrollbar{ height:10px; width:10px; }
  div.dataTables_scrollBody::-webkit-scrollbar-thumb{ background:#D1D5DB; border-radius:6px; }
  div.dataTables_scrollBody::-webkit-scrollbar-track{ background:#F3F4F6; }

  a{ color:#4c59ff; text-decoration:none; }

  /* ====== 고정 폭(px) — 헤더/바디/colgroup 동기화 전제 ====== */
  /* (1) colgroup에서 지정 — JS가 헤더/바디 테이블에도 복제함 */
  /* (2) 혹시 모를 계산 틀어짐 대비 nth-child로도 못박음 */

  /* 1: 계약번호 */   #contractTable th:nth-child(1), #contractTable td:nth-child(1){ width:70px !important; min-width:70px !important; max-width:70px !important; }
  /* 2: 계약금 */     #contractTable th:nth-child(2), #contractTable td:nth-child(2){ width:140px !important; min-width:140px !important; max-width:140px !important; }
  /* 3: 입금상태 */   #contractTable th:nth-child(3), #contractTable td:nth-child(3){ width:110px !important; min-width:110px !important; max-width:110px !important; }
  /* 4: 입금날짜 */   #contractTable th:nth-child(4), #contractTable td:nth-child(4){ width:130px !important; min-width:130px !important; max-width:130px !important; }
  /* 5: 잔금 */       #contractTable th:nth-child(5), #contractTable td:nth-child(5){ width:140px !important; min-width:140px !important; max-width:140px !important; }
  /* 6: 잔금상태 */   #contractTable th:nth-child(6), #contractTable td:nth-child(6){ width:110px !important; min-width:110px !important; max-width:110px !important; }
  /* 7: 납기일 */     #contractTable th:nth-child(7), #contractTable td:nth-child(7){ width:130px !important; min-width:130px !important; max-width:130px !important; }
  /* 8: 작성일자 */   #contractTable th:nth-child(8), #contractTable td:nth-child(8){ width:140px !important; min-width:140px !important; max-width:140px !important; }
  /* 9: 서명 */       #contractTable th:nth-child(9), #contractTable td:nth-child(9){ width:60px  !important; min-width:60px  !important; max-width:60px  !important; padding-left:4px !important; padding-right:4px !important; }
  #contractTable tbody td:nth-child(9) a{ display:inline-block; width:100%; text-align:center; font-size:12px; line-height:1.2; }
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">계약서 목록</h1>

    <table id="contractTable" class="table table-striped table-hover table-bordered align-middle w-100">
      <!-- 고정 폭 colgroup (총 1060px) -->
      <colgroup>
        <col style="width:70px">
        <col style="width:140px">
        <col style="width:110px">
        <col style="width:130px">
        <col style="width:140px">
        <col style="width:110px">
        <col style="width:130px">
        <col style="width:140px">
        <col style="width:60px">   <!-- 서명 -->
      </colgroup>

      <thead class="table-light">
        <!-- 그룹 헤더 -->
        <tr class="dt-group-header">
          <th></th> <!-- 계약번호 -->
          <th colspan="3" class="text-center">계약금</th>
          <th colspan="3" class="text-center">잔금</th>
          <th colspan="2" class="text-center"></th> <!-- 작성일자 + 서명 -->
        </tr>
        <!-- 실제 헤더 -->
        <tr>
          <th>번호</th>
          <th>계약금</th>
          <th>입금 상태</th>
          <th>입금 날짜</th>
          <th>잔금</th>
          <th>입금 상태</th>
          <th>납기일</th>
          <th>작성일자</th>
          <th>서명</th>
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
            <td><a href="${pageContext.request.contextPath}/biz/writeContract?contractNo=${con.contractNo}">작성</a></td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  /* 빈 셀 강조(옵션) */
  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).each(function(){
      $(this).children('td').each(function(colIdx){
        const $td = $(this);
        if (colIdx === 0) { $td.removeClass('cell-empty'); return; }
        const hasElem = $td.find('input,button,select,textarea,a,span.status-badge,span.payment-badge').length > 0;
        const text = ($td.text() || '').replace(/\u00a0/g,' ').trim().toLowerCase();
        const emptyText = (text === '' || text === 'null' || text === 'undefined' || text === '-');
        if (!hasElem && emptyText) $td.addClass('cell-empty').attr('title','데이터 없음');
        else $td.removeClass('cell-empty').removeAttr('title');
      });
    });
  }

  /* colgroup을 스크롤 헤더/바디 테이블로 복제 */
  function syncColgroup(){
    const $src = $('#contractTable colgroup').clone(true);
    const $wrap = $('#contractTable_wrapper');

    $wrap.find('.dataTables_scrollHead table colgroup').remove();
    $wrap.find('.dataTables_scrollHead table').prepend($src.clone(true));

    $wrap.find('.dataTables_scrollBody table colgroup').remove();
    $wrap.find('.dataTables_scrollBody table').prepend($src.clone(true));
  }

  /* 그룹헤더 폭을 2행 합계로 정확히 맞춤 */
  function syncGroupHeader(){
    const $head = $('#contractTable_wrapper .dataTables_scrollHead thead');
    const $row2 = $head.find('tr').eq(1);           // 실제 헤더
    const $row1 = $head.find('tr.dt-group-header'); // 그룹행
    if ($row1.length === 0 || $row2.length === 0) return;

    const widths = $row2.children('th').map(function(){ return Math.round($(this).outerWidth()); }).get();
    let idx = 0;
    $row1.children('th').each(function(){
      const span = parseInt(this.getAttribute('colspan') || '1', 10);
      let sum = 0; for (let i=0;i<span;i++) sum += (widths[idx+i] || 0);
      idx += span;
      this.style.width = sum + 'px';
      this.style.minWidth = sum + 'px';
      this.style.maxWidth = sum + 'px';
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
      scrollCollapse: false,  // 남는 폭 강제분배 방지
      columnDefs: [
        { targets: 0, width: 70, className: 'text-center' },
        { targets: 1, width: 140, className: 'nowrap-cell text-center' },
        { targets: 2, width: 110, className: 'text-center' },
        { targets: 3, width: 130, className: 'nowrap-cell text-center' },
        { targets: 4, width: 140, className: 'nowrap-cell text-center' },
        { targets: 5, width: 110, className: 'text-center' },
        { targets: 6, width: 130, className: 'nowrap-cell text-center' },
        { targets: 7, width: 140, className: 'nowrap-cell text-center' },
        { targets: 8, width: 60,  className: 'nowrap-cell text-center' } // 서명
      ],
      order: [[0, 'desc']],
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
      initComplete: function(){
        const api = this.api();
        syncColgroup();
        api.columns.adjust();
        syncGroupHeader();
        highlightEmptyCells(api);

        $(window).on('resize', function(){
          api.columns.adjust();
          syncColgroup();
          syncGroupHeader();
        });

        api.table().on('column-sizing.dt columns-visibility.dt', function(){
          syncColgroup();
          syncGroupHeader();
        });
      },
      drawCallback: function(){
        const api = this.api();
        syncColgroup();
        api.columns.adjust();
        syncGroupHeader();
      }
    });
  });
</script>
</body>
</html>
