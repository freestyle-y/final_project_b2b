<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <%@ include file="/WEB-INF/common/head.jsp" %>
  <title>상품 요청 목록</title>

  <!-- libs -->
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
  </style>
</head>
<body>

<%@ include file="/WEB-INF/common/header/header.jsp" %>

<div class="container-xl py-4">
  <h2 class="mb-4 text-center">상품 요청 목록</h2>

  <div class="table-wrap">
    <table id="productRequestTable" class="table table-striped table-hover table-bordered align-middle">
      <!-- 열 폭을 colgroup으로 ‘한 번만’ 정의 → 헤더/바디 완전 일치 -->
      <colgroup>
        <col style="width:9ch;">
        <col>                      <!-- 상품명(가변) -->
        <col style="width:16ch;">  <!-- 옵션 -->
        <col style="width:10ch;">  <!-- 수량 -->
      </colgroup>
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
      drawCallback:function(){ const api=this.api(); visuallyGroupFirstColumn(api); highlightEmptyCells(api); },
      initComplete:function(){
        const api=this.api();
        visuallyGroupFirstColumn(api); highlightEmptyCells(api);
        // 폰트 로딩 이후 1회 보정
        const adjust = () => api.columns.adjust();
        setTimeout(adjust,0);
        if(document.fonts && document.fonts.ready) document.fonts.ready.then(adjust);
        $(window).on('resize', adjust);
      }
    });
  });
</script>
</body>
</html>