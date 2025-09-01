<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>견적서 목록</title>

<!-- 폰트/라이브러리 -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

<style>
  :root { --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0; }
  body { font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif; }
  .table-wrap{ max-width:1400px; margin:0 auto; }

  #quotationTable_wrapper .dataTables_scroll, #quotationTable{
    border:1px solid var(--tbl-border); border-radius:10px; overflow:hidden; background:#fff; font-size:.92rem;
  }

  #quotationTable thead tr:nth-child(2) th{
    background:var(--tbl-head) !important; font-weight:700; color:#111827;
    border-bottom:1px solid var(--tbl-border) !important; vertical-align:middle;
    padding:.55rem .75rem; white-space:nowrap; text-align:center;
  }

  #quotationTable thead tr.dt-group-header th,
  #quotationTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th{
    box-sizing:border-box; min-width:0;
    border-top:none !important; border-bottom:1px solid var(--tbl-border) !important;
    padding:.45rem .75rem;
    text-align:center !important;
    vertical-align:middle !important;
    display:table-cell !important;
    pointer-events:none;
  }

  #quotationTable tbody td{
    border-top:1px solid var(--tbl-border); color:#111827; vertical-align:middle;
    height:40px; padding:.45rem .75rem; text-align:center;
    white-space:normal; word-break:keep-all; overflow-wrap:anywhere;
  }
  #quotationTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
  #quotationTable tbody tr:hover{ background:var(--tbl-hover); }

  #quotationTable td.nowrap-cell{
    white-space:nowrap !important; word-break:normal !important; overflow-wrap:normal !important;
    text-overflow:clip; overflow:hidden;
  }

  div.dataTables_scrollBody{ scrollbar-width:thin; }
  div.dataTables_scrollBody::-webkit-scrollbar{ height:10px; width:10px; }
  div.dataTables_scrollBody::-webkit-scrollbar-thumb{ background:#D1D5DB; border-radius:6px; }
  div.dataTables_scrollBody::-webkit-scrollbar-track{ background:#F3F4F6; }

  td.cell-empty{ background:var(--tbl-empty) !important; }

  #quotationTable,
  #quotationTable_wrapper .dataTables_scrollHead table,
  #quotationTable_wrapper .dataTables_scrollBody table{ table-layout:fixed; }

  a{ color:#4c59ff; text-decoration:none; }

  #quotationTable th:nth-child(1), #quotationTable td:nth-child(1){
    width:10ch !important; min-width:10ch !important; max-width:10ch !important;
    white-space:nowrap !important; padding-left:.5rem; padding-right:.5rem;
  }
  #quotationTable th:nth-child(2), #quotationTable td:nth-child(2){
    width:8ch !important; min-width:8ch !important; max-width:8ch !important;
    white-space:nowrap !important; padding-left:.5rem; padding-right:.5rem;
  }

  #quotationTable th:nth-child(3), #quotationTable td:nth-child(3){
    min-width:300px; text-align:left !important;
  }

  #quotationTable th:nth-child(7), #quotationTable td:nth-child(7){ min-width:130px; }

  .btn-quotation-write {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    color: white;
    padding: 12px 24px;
    border-radius: 25px;
    font-weight: 600;
    transition: all 0.3s ease;
    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
  }
  .btn-quotation-write:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(0,0,0,0.3);
    color: white;
  }

  .status-badge {
    padding: 6px 12px;
    border-radius: 20px;
    font-size: 0.85rem;
    font-weight: 600;
    text-transform: uppercase;
    letter-spacing: 0.5px;
  }
  .status-approved { background: #10b981; color: white; }
  .status-pending { background: #f59e0b; color: white; }
  .status-rejected { background: #ef4444; color: white; }
  .status-draft { background: #6b7280; color: white; }
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">견적서 목록</h1>

    <table id="quotationTable" class="table table-striped table-hover table-bordered align-middle w-100">
      <thead class="table-light">
        <tr class="dt-group-header">
          <th></th>
          <th></th>
          <th colspan="2" class="text-center">상품 정보</th>
          <th></th>
          <th></th>
          <th></th>
        </tr>
        <tr>
          <th>번호</th>
          <th>견적</th>
          <th>상품 및 가격</th>
          <th>요청한 회원</th>
          <th>상태</th>
          <th>작성자</th>
          <th>작성일자</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="q" items="${quotationList}">
          <tr>
            <td>
              <a href="/admin/quotationOne?quotationNo=${q.quotationNo }&productRequestNo=${q.productRequestNo}">
                ${q.productRequestNo}
              </a>
            </td>
            <td>${q.quotationNo}</td>
            <td>
              <c:forEach var="item" items="${q.items}" varStatus="status">
                <div class="mb-1">
                  <strong>${item.productName}</strong> 
                  <span class="text-muted">(${item.productQuantity}개)</span>
                  <span class="text-primary fw-bold">
                    ₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/>
                  </span>
                </div>
                <c:if test="${!status.last}"><hr class="my-1"></c:if>
              </c:forEach>
            </td>
            <td>
              <div class="fw-bold">${q.requestCompanyName}</div>
              <small class="text-muted">${q.requestCompanyUser}</small>
            </td>
            <td>
              <c:choose>
                <c:when test="${q.status eq '승인'}">
                  <span class="status-badge status-approved">승인</span>
                </c:when>
                <c:when test="${q.status eq '승인거절'}">
                  <span class="status-badge status-rejected">거절</span>
                </c:when>
                <c:when test="${q.status eq '승인전'}">
                  <span class="status-badge status-pending">승인전</span>
                </c:when>
              </c:choose>
            </td>
            <td class="nowrap-cell">${q.createUser}</td>
            <td class="nowrap-cell" data-order="${q.createDate}">
              <c:choose>
                <c:when test="${fn:contains(q.createDate,'T')}">${fn:substringBefore(q.createDate,'T')}</c:when>
                <c:otherwise>${fn:substringBefore(q.createDate,' ')}</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
    <c:set var="hasPreApproved" value="false" />
	<c:forEach var="qq" items="${quotationList}">
	  <c:if test="${qq.status eq '승인전'}">
	    <c:set var="hasPreApproved" value="true" />
	  </c:if>
	</c:forEach>
	<c:if test="${not empty productRequestNo and not hasPreApproved}">
	  <div class="d-flex justify-content-center mt-4">
	    <button type="button" class="btn btn-quotation-write" onclick="openWriteQuotationPage()">
	      <i class="fas fa-plus me-2"></i>견적서 작성
	    </button>
	  </div>
	</c:if>
  </div>
</div>

<script>
  const productRequestNo = "${param.productRequestNo != null ? param.productRequestNo : 0}";
  const quotationNo = "${param.quotationNo != null ? param.quotationNo : 0}";
  const subProductRequestNo = "${param.subProductRequestNo != null ? param.subProductRequestNo : 0}";

  function openWriteQuotationPage() {
    const url = "${pageContext.request.contextPath}/admin/writeQuotationForm"
              + "?productRequestNo=" + productRequestNo
              + "&quotationNo=" + quotationNo
              + "&subProductRequestNo=" + subProductRequestNo;
    location.href = url;
  }
</script>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).each(function(){
      $(this).children('td').each(function(colIdx){
        const $td = $(this);
        if (colIdx === 0 || colIdx === 1) { $td.removeClass('cell-empty'); return; }
        const hasElem = $td.find('input,button,select,textarea,a,span.status-badge').length > 0;
        const text = ($td.text() || '').replace(/\u00a0/g,' ').trim().toLowerCase();
        const emptyText = (text === '' || text === 'null' || text === 'undefined' || text === '-');
        if (!hasElem && emptyText) $td.addClass('cell-empty').attr('title','데이터 없음');
        else $td.removeClass('cell-empty').removeAttr('title');
      });
    });
  }

  function syncAnyGroupHeaderWidths(){
    const $head = $('#quotationTable_wrapper .dataTables_scrollHead thead');
    const $row2 = $head.find('tr').eq(1);
    const $row1 = $head.find('tr.dt-group-header');
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
    const table = $('#quotationTable').DataTable({
      stateSave: true,   // ✅ 검색조건, 페이징, 정렬 상태 저장
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
        { targets: 0, width: '120px', className: 'text-center' },
        { targets: 1, width: '100px', className: 'text-center' },
        { targets: 2, width: '35%', className: 'text-left' },
        { targets: 3, width: '20%', className: 'text-center' },
        { targets: 4, width: '100px', className: 'text-center' },
        { targets: 5, width: '100px', className: 'text-center' },
        { targets: 6, width: '130px', className: 'text-center' }
      ],
      order: [[1, 'desc']],
      dom: '<"row mb-2"<"col-12 col-md-6"l><"col-12 col-md-6"f>>t<"row mt-2"<"col-12 col-md-5"i><"col-12 col-md-7"p>>',
      language: {
        lengthMenu: '_MENU_ 개씩 보기',
        search: '검색:',
        info: '총 _TOTAL_건 중 _START_–_END_',
        infoEmpty: '0건',
        infoFiltered: '(필터링: _MAX_건 중)',
        zeroRecords: '일치하는 데이터가 없습니다.',
        paginate: {
          first: '처음',
          last: '마지막',
          next: '다음',
          previous: '이전'
        },
        loadingRecords: '불러오는 중...',
        processing: '처리 중...'
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