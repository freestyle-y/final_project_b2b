<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>계약서 목록</title>

<!-- 폰트 / 라이브러리 -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

<style>
:root{
  --tbl-border:#E5E7EB;
  --tbl-head:#F9FAFB;
  --tbl-hover:#F3F4F6;
  --tbl-zebra:#FAFAFA;
  --tbl-empty:#FFF0F0;
}

body{
  font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif;
}

.container-xl{ max-width:1300px; } /* [수정] 화면 폭 여유 */
.table-wrap{ margin:0 auto; }

#contractTable_wrapper .dataTables_scroll,
#contractTable{
  border:1px solid var(--tbl-border);
  border-radius:10px;
  overflow:hidden;
  background:#fff;
  font-size:.92rem;
}

/* 그룹 헤더(1행) */
#contractTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th,
#contractTable thead tr.dt-group-header th{
  background:#fff;
  border-top:none !important;
  border-bottom:1px solid var(--tbl-border) !important;
  text-align:center;
  font-weight:700;
  padding:.45rem .75rem;
  pointer-events:none;
}

/* 실제 헤더(2행) */
#contractTable thead tr:nth-child(2) th{
  background:var(--tbl-head) !important;
  border-bottom:1px solid var(--tbl-border) !important;
  color:#111827;
  font-weight:700;
  vertical-align:middle;
  padding:.55rem .75rem;
  white-space:nowrap;
}

/* 본문 셀 */
#contractTable tbody td{
  border-top:1px solid var(--tbl-border);
  color:#111827;
  vertical-align:middle;
  height:40px;
  padding:.45rem .75rem;
}
#contractTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
#contractTable tbody tr:hover{ background:var(--tbl-hover); }

.nowrap-cell{ white-space:nowrap; }

/* [수정] 금액 칼럼 전용: 좌우 넓게 + 줄바꿈 금지 */
.amount-col{
  white-space:nowrap;
  font-weight:600;
}
.dp-amt{ min-width: 180px; }  /* 계약금 금액 */
.bl-amt{ min-width: 180px; }  /* 잔금   금액 */

/* 스크롤 바 */
div.dataTables_scrollBody{ scrollbar-width:thin; }
div.dataTables_scrollBody::-webkit-scrollbar{ height:10px; width:10px; }
div.dataTables_scrollBody::-webkit-scrollbar-thumb{ background:#D1D5DB; border-radius:6px; }
div.dataTables_scrollBody::-webkit-scrollbar-track{ background:#F3F4F6; }

/* 빈 셀 시 하이라이트 */
td.cell-empty{ background:var(--tbl-empty) !important; }

/* 테이블 레이아웃: 고정 대신 자동(금액 칼럼 넓게 반영) */
#contractTable,
#contractTable_wrapper .dataTables_scrollHead table,
#contractTable_wrapper .dataTables_scrollBody table{
  table-layout:auto; /* [수정] fixed -> auto */
}
</style>
</head>
<body>
<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">관리자 계약서 목록</h1>

    <table id="contractTable" class="table table-striped table-hover table-bordered align-middle w-100">
      <thead>
        <!-- 1행(그룹 헤더) : 스크린샷 구조 반영 -->
        <tr class="dt-group-header">
          <th></th>                    <!-- 계약번호 -->
          <th></th>                    <!-- 견적번호 -->
          <th colspan="3">계약금</th>  <!-- 금액 / 입금 상태 / 입금 날짜 -->
          <th colspan="2">잔금</th>    <!-- 금액 / 입금 상태 -->
          <th></th>                    <!-- 납기일 -->
          <th colspan="2">작성 정보</th> <!-- 작성자 / 작성일자 -->
        </tr>
        <!-- 2행(실제 헤더) -->
        <tr>
          <th>계약번호</th>
          <th>견적번호</th>
          <th>금액</th>           <!-- 계약금 -->
          <th>입금 상태</th>      <!-- 계약금 -->
          <th>입금 날짜</th>      <!-- 계약금 -->
          <th>금액</th>           <!-- 잔금 -->
          <th>입금 상태</th>      <!-- 잔금 -->
          <th>납기일</th>
          <th>작성자</th>
          <th>작성일자</th>
        </tr>
      </thead>
      <tbody>
        <!-- 프로젝트 변수명에 맞춰 items값만 교체해서 쓰세요 -->
        <c:forEach var="c" items="${contractList}">
          <tr>
            <td class="text-center nowrap-cell">
              <a href="${pageContext.request.contextPath}/admin/contractOne?contractNo=${c.contractNo}">
                ${c.contractNo}
              </a>
            </td>
            <td class="text-center nowrap-cell">${c.quotationNo}</td>

            <!-- 계약금 -->
            <td class="amount-col dp-amt">
              <fmt:formatNumber value="${c.downPayment}" type="number" groupingUsed="true" />₩
            </td>
            <td class="text-center nowrap-cell">
              <c:choose>
                <c:when test="${c.downPaymentStatus eq '완료'}">
                  <span class="badge rounded-pill text-bg-success">입금완료</span>
                </c:when>
                <c:when test="${c.downPaymentStatus eq '대기'}">
                  <span class="badge rounded-pill text-bg-secondary">대기</span>
                </c:when>
                <c:otherwise>
                  <span class="badge rounded-pill text-bg-info">${c.downPaymentStatus}</span>
                </c:otherwise>
              </c:choose>
            </td>
            <td class="text-center nowrap-cell" data-order="${c.downPaymentDate}">
              ${fn:substringBefore(c.downPaymentDate,' ')}
            </td>

            <!-- 잔금 -->
            <td class="amount-col bl-amt">
              <fmt:formatNumber value="${c.balance}" type="number" groupingUsed="true" />₩
            </td>
            <td class="text-center nowrap-cell">
              <c:choose>
                <c:when test="${c.balanceStatus eq '완료'}">
                  <span class="badge rounded-pill text-bg-success">입금완료</span>
                </c:when>
                <c:when test="${c.balanceStatus eq '대기'}">
                  <span class="badge rounded-pill text-bg-secondary">대기</span>
                </c:when>
                <c:otherwise>
                  <span class="badge rounded-pill text-bg-info">${c.balanceStatus}</span>
                </c:otherwise>
              </c:choose>
            </td>

            <td class="text-center nowrap-cell" data-order="${c.dueDate}">
              ${fn:substringBefore(c.dueDate,' ')}
            </td>

            <td class="text-center nowrap-cell">${c.createUser}</td>
            <td class="text-center nowrap-cell" data-order="${c.createDate}">
              ${fn:substringBefore(c.createDate,' ')}
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<!-- 푸터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  function highlightEmptyCells(api){
    const rows = api.rows({page:'current'}).nodes();
    $(rows).find('td').each(function(){
      const $td = $(this);
      const text = ($td.text()||'').replace(/\u00a0/g,' ').trim().toLowerCase();
      if(text===''||text==='null'||text==='undefined'){
        $td.addClass('cell-empty').attr('title','데이터 없음');
      }else{
        $td.removeClass('cell-empty').removeAttr('title');
      }
    });
  }

  // 그룹헤더 ↔ 실제헤더 폭 동기화(멀티헤더용)
  function syncGroupHeaderWidths(api){
    const $head = $('#contractTable_wrapper .dataTables_scrollHead thead');
    const $row2 = $head.find('tr').eq(1);
    const $row1 = $head.find('tr.dt-group-header');
    if($row1.length===0||$row2.length===0) return;

    const w = $row2.children('th').map(function(){ return Math.round($(this).outerWidth()); }).get();
    let idx = 0;
    $row1.children('th').each(function(){
      const span = parseInt($(this).attr('colspan')||'1',10);
      let sum = 0;
      for(let i=0;i<span;i++) sum += (w[idx+i]||0);
      idx += span;
      $(this).css({width:sum+'px',minWidth:sum+'px',maxWidth:sum+'px'});
    });
  }

  $(function(){
    const table = $('#contractTable').DataTable({
      ordering:true,
      order:[[0,'desc']],
      searching:true,
      paging:true,
      pageLength:10,
      lengthMenu:[10,25,50,100],
      info:true,
      autoWidth:false,
      scrollX:true,
      scrollY:'55vh',
      scrollCollapse:true,

      /* [수정] 칼럼 폭 재배치: 금액/날짜 칼럼을 넓힘 */
      columnDefs:[
        { targets:0,  width:'9%',  className:'text-center nowrap-cell' },   // 계약번호
        { targets:1,  width:'9%',  className:'text-center nowrap-cell' },   // 견적번호
        { targets:2,  width:'16%', className:'amount-col dp-amt' },         // 계약금 금액 [수정]
        { targets:3,  width:'9%',  className:'text-center nowrap-cell' },   // 계약금 입금상태
        { targets:4,  width:'12%', className:'text-center nowrap-cell' },   // 계약금 입금날짜 [수정]
        { targets:5,  width:'16%', className:'amount-col bl-amt' },         // 잔금 금액 [수정]
        { targets:6,  width:'9%',  className:'text-center nowrap-cell' },   // 잔금 입금상태
        { targets:7,  width:'10%', className:'text-center nowrap-cell' },   // 납기일 [수정]
        { targets:8,  width:'5%',  className:'text-center nowrap-cell' },   // 작성자
        { targets:9,  width:'10%', className:'text-center nowrap-cell' }    // 작성일자
      ],

      dom:'<"row mb-2"<"col-12 col-md-6"l><"col-12 col-md-6"f>>t<"row mt-2"<"col-12 col-md-5"i><"col-12 col-md-7"p>>',
      language:{
        lengthMenu:'_MENU_ 개씩 보기',
        search:'검색:',
        info:'총 _TOTAL_건 중 _START_–_END_',
        infoEmpty:'0건',
        infoFiltered:'(필터링: _MAX_건 중)',
        zeroRecords:'일치하는 데이터가 없습니다.',
        paginate:{ first:'처음', last:'마지막', next:'다음', previous:'이전' },
        loadingRecords:'불러오는 중...', processing:'처리 중...'
      },
      drawCallback:function(){
        const api=this.api();
        highlightEmptyCells(api);
        syncGroupHeaderWidths(api);
      },
      initComplete:function(){
        const api=this.api();
        highlightEmptyCells(api);
        setTimeout(()=>{
          api.columns.adjust().draw(false);
          syncGroupHeaderWidths(api);
        },0);
        $(window).on('resize', ()=>syncGroupHeaderWidths(api));
        api.table().on('column-sizing.dt columns-visibility.dt', ()=>syncGroupHeaderWidths(api));
      }
    });
  });
</script>
</body>
</html>
