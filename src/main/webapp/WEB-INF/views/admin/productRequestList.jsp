<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>관리자 상품 요청 목록</title>

<!-- SUIT 폰트 -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- DataTables CSS -->
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

<style>
:root{
  --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0;
}

body{
  font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif;
}

/* [수정] 전체 폭 살짝 축소 */
.table-wrap{ max-width:1000px; margin:0 auto; }

#productRequestTable_wrapper .dataTables_scroll, #productRequestTable{
  border:1px solid var(--tbl-border); border-radius:10px; overflow:hidden; background:#fff; font-size:.92rem;
}

/* 헤더 */
#productRequestTable thead th{
  background:var(--tbl-head) !important; font-weight:700; color:#111827;
  border-bottom:1px solid var(--tbl-border) !important; vertical-align:middle;
  padding:.55rem .75rem;
}

/* 멀티 헤더(그룹행) */
#productRequestTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th,
#productRequestTable thead tr.dt-group-header th{
  box-sizing:border-box; min-width:0;
  border-top:none !important; border-bottom:1px solid var(--tbl-border) !important;
  padding:.45rem .75rem;
  
}

/* 본문 */
#productRequestTable tbody td{
  border-top:1px solid var(--tbl-border); color:#111827; vertical-align:middle;
  height:40px; padding:.45rem .75rem;
}
#productRequestTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
#productRequestTable tbody tr:hover{ background:var(--tbl-hover); }

/* 스크롤바 */
div.dataTables_scrollBody{ scrollbar-width:thin; }
div.dataTables_scrollBody::-webkit-scrollbar{ height:10px; width:10px; }
div.dataTables_scrollBody::-webkit-scrollbar-thumb{ background:#D1D5DB; border-radius:6px; }
div.dataTables_scrollBody::-webkit-scrollbar-track{ background:#F3F4F6; }

/* 빈 셀 표시 */
td.cell-empty{ background:var(--tbl-empty) !important; }

/* 요청번호 시각 병합(시각적으로만) */
td.group-col.visually-merged{
  border-top-color:transparent !important; color:transparent; text-shadow:none; pointer-events:none;
}

/* [수정] 글자 길이에 맞춘 너비(콘텐츠 기반) */
#productRequestTable th:nth-child(1), #productRequestTable td:nth-child(1){ width:8ch;  min-width:8ch;  white-space:nowrap; text-align:center; } /* 요청번호 */
#productRequestTable th:nth-child(2), #productRequestTable td:nth-child(2){ width:18ch; min-width:12ch; white-space:nowrap; } /* 상품명 */
#productRequestTable th:nth-child(3), #productRequestTable td:nth-child(3){ width:14ch; min-width:10ch; white-space:nowrap; } /* 옵션 */
#productRequestTable th:nth-child(4), #productRequestTable td:nth-child(4){ width:6ch;  min-width:6ch;  white-space:nowrap; } /* 수량 */
#productRequestTable th:nth-child(5), #productRequestTable td:nth-child(5){ width:12ch; min-width:10ch; white-space:nowrap; } /* 작성자 */
#productRequestTable th:nth-child(6), #productRequestTable td:nth-child(6){ width:10ch; min-width:9ch;  white-space:nowrap; text-align:center; } /* 상태 */

/* [수정] 테이블 계산을 콘텐츠 기준으로 */
#productRequestTable,
#productRequestTable_wrapper .dataTables_scrollHead table,
#productRequestTable_wrapper .dataTables_scrollBody table{
  table-layout:auto; /* fixed → auto */
}

a{ color:#4c59ff; text-decoration:none; }
</style>
</head>
<body>
<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">상품 요청 목록 페이지</h1>

    <table id="productRequestTable" class="table table-striped table-hover table-bordered align-middle nowrap w-100">
      <thead class="table-light">
        <tr class="dt-group-header">
          <th></th>                <!-- 요청번호 -->
          <th></th>                <!-- 상품명 -->
          <th colspan="3" class="text-center">상세 정보</th> <!-- 옵션/수량/작성자 -->
          <th></th>                <!-- 견적서 상태 -->
        </tr>
        <tr>
          <th>요청번호</th>
          <th>상품명</th>
          <th>옵션</th>
          <th>수량</th>
          <th>작성자</th>
          <th>견적서 상태</th>
        </tr>
      </thead>

      <tbody>
        <c:forEach var="productList" items="${groupedList.values()}">
          <c:set var="firstProduct" value="${productList[0]}" />
          <c:forEach var="p" items="${productList}" varStatus="status">
            <tr>
              <td class="group-col" data-value="${firstProduct.productRequestNo}">
                <c:choose>
                  <c:when test="${empty firstProduct.quotationStatus}">
                    <a href="${pageContext.request.contextPath}/admin/quotationList?productRequestNo=${firstProduct.productRequestNo}">
                      ${firstProduct.productRequestNo}
                    </a>
                  </c:when>
                  <c:otherwise>
                    ${firstProduct.productRequestNo}
                  </c:otherwise>
                </c:choose>
              </td>
              <td>${p.productName}</td>
              <td>${p.productOption}</td>
              <td>${p.productQuantity}</td>
              <td>${p.createUser}</td>
              <!-- 상태 pill 배지 -->
              <td class="text-center"
                  data-order="${empty p.quotationStatus ? 0 : (p.quotationStatus == '승인거절' ? 1 : (p.quotationStatus == '승인' ? 2 : 0))}">
                <c:choose>
                  <c:when test="${empty p.quotationStatus}">
                    <span class="badge rounded-pill text-bg-secondary">미작성</span>
                  </c:when>
                  <c:when test="${p.quotationStatus == '승인'}">
                    <span class="badge rounded-pill text-bg-success">승인</span>
                  </c:when>
                  <c:when test="${p.quotationStatus == '승인거절'}">
                    <span class="badge rounded-pill text-bg-danger">승인거절</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge rounded-pill text-bg-primary">${p.quotationStatus}</span>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- 스크립트 -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  function visuallyGroupFirstColumn(dtApi){
    let lastVal = null;
    dtApi.column(0,{ page:'current' }).nodes().each(function(cell){
      const $cell = $(cell);
      const raw = $cell.data('value') ?? $cell.text().trim();
      $cell.removeClass('visually-merged').removeAttr('aria-hidden');
      if(lastVal !== null && String(raw) === String(lastVal)){
        $cell.addClass('visually-merged').attr('aria-hidden','true');
      }
      lastVal = raw;
    });
  }

  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).find('td').each(function(){
      const $td = $(this);
      if($td.hasClass('group-col') && $td.hasClass('visually-merged')){
        $td.removeClass('cell-empty').removeAttr('title'); return;
      }
      const text = ($td.text()||'').replace(/\u00a0/g,' ').trim().toLowerCase();
      if(text === '' || text === 'null' || text === 'undefined'){
        $td.addClass('cell-empty').attr('title','데이터 없음');
      }else{
        $td.removeClass('cell-empty').removeAttr('title');
      }
    });
  }

  // 멀티 헤더(그룹행) ↔ 실제 헤더 폭 동기화
  function syncGroupHeaderWidths(api){
    const $head = $('#productRequestTable_wrapper .dataTables_scrollHead thead');
    const $row2 = $head.find('tr').eq(1);
    if($row2.length === 0) return;

    const ths = $row2.children('th');
    const w0 = Math.round(ths.eq(0).outerWidth());
    const w1 = Math.round(ths.eq(1).outerWidth());
    const w2 = Math.round(ths.eq(2).outerWidth());
    const w3 = Math.round(ths.eq(3).outerWidth());
    const w4 = Math.round(ths.eq(4).outerWidth());
    const w5 = Math.round(ths.eq(5).outerWidth());

    const $grp = $head.find('tr.dt-group-header'); const $g = $grp.children('th');
    $g.eq(0).css({ width:w0+'px', minWidth:w0+'px', maxWidth:w0+'px' });
    $g.eq(1).css({ width:w1+'px', minWidth:w1+'px', maxWidth:w1+'px' });
    const sum = w2 + w3 + w4;
    $g.eq(2).css({ width:sum+'px', minWidth:sum+'px', maxWidth:sum+'px' });
    $g.eq(3).css({ width:w5+'px', minWidth:w5+'px', maxWidth:w5+'px' });
  }

  $(function(){
    const table = $('#productRequestTable').DataTable({
      ordering:true,
      searching:true,
      paging:true,
      pageLength:10,
      lengthMenu:[10,25,50,100],
      info:true,
      /* [수정] 콘텐츠 기반 자동 폭 계산 */
      autoWidth:true,
      scrollX:true,
      scrollY:'50vh',
      scrollCollapse:true,
      /* [수정] 고정 폭 지정 제거 */
      columnDefs:[],
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
        visuallyGroupFirstColumn(api);
        highlightEmptyCells(api);
        syncGroupHeaderWidths(api);
      },
      initComplete:function(){
        const api = this.api();
        visuallyGroupFirstColumn(api);
        highlightEmptyCells(api);
        setTimeout(()=>{ api.columns.adjust().draw(false); syncGroupHeaderWidths(api); },0);
        $(window).on('resize', ()=> syncGroupHeaderWidths(api));
        api.table().on('column-sizing.dt columns-visibility.dt', ()=> syncGroupHeaderWidths(api));
      }
    });
  });
</script>
</body>
</html>