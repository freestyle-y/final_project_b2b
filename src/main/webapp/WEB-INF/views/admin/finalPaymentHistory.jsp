<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>잔금 확인 페이지</title>

<!-- 폰트/라이브러리 -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

<style>
  :root { --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0; }
  body { font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif; }
  .table-wrap{ max-width:1200px; margin:0 auto; }

  /* 카드형 표 */
  #paymentTable_wrapper .dataTables_scroll, #paymentTable{
    border:1px solid var(--tbl-border); border-radius:10px; overflow:hidden; background:#fff; font-size:.92rem;
  }

  /* 실제 헤더(2행) */
  #paymentTable thead tr:nth-child(2) th{
    background:var(--tbl-head) !important; font-weight:700; color:#111827;
    border-bottom:1px solid var(--tbl-border) !important; vertical-align:middle;
    padding:.55rem .75rem; white-space:nowrap; text-align:center;
  }

  /* 멀티 헤더(1행: 그룹행) */
  #paymentTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th,
  #paymentTable thead tr.dt-group-header th{
    box-sizing:border-box; min-width:0;
    border-top:none !important; border-bottom:1px solid var(--tbl-border) !important;
    padding:.45rem .75rem; text-align:center; pointer-events:none;
  }

  /* 바디 */
  #paymentTable tbody td{
    border-top:1px solid var(--tbl-border); color:#111827; vertical-align:middle;
    height:40px; padding:.45rem .75rem; text-align:center;
    white-space:normal; word-break:keep-all; overflow-wrap:anywhere;
  }
  #paymentTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
  #paymentTable tbody tr:hover{ background:var(--tbl-hover); }

  /* 숫자/날짜 한줄 유지 */
  #paymentTable td.nowrap-cell{ white-space:nowrap !important; }
  #paymentTable td.amount-cell{ text-align:right !important; white-space:nowrap !important; }

  /* 빈 셀 표시(선택) */
  td.cell-empty{ background:var(--tbl-empty) !important; }

  a{ color:#4c59ff; text-decoration:none; }
  .btn + .btn{ margin-left:.35rem; }
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">잔금 확인 페이지</h1>

    <form id="containerForm">
      <table id="paymentTable" class="table table-striped table-hover table-bordered align-middle w-100">
        <thead class="table-light">
          <!-- 멀티 헤더(그룹행) -->
          <tr class="dt-group-header">
            <th></th>                               <!-- 계약 번호 -->
            <th colspan="3" class="text-center">계약금</th>  <!-- 금액/상태/날짜 -->
            <th colspan="3" class="text-center">잔금</th>    <!-- 금액/상태/날짜 -->
            <th colspan="2" class="text-center">배송/회수</th><!-- 배송상태/버튼 -->
          </tr>
          <!-- 실제 헤더 -->
          <tr>
            <th>계약 번호</th>
            <th>계약금</th>
            <th>입금 상태</th>
            <th>입금 날짜</th>
            <th>잔금</th>
            <th>입금 상태</th>
            <th>납기일</th>
            <th>배송입력상태</th>
            <th>회수 버튼</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="row" items="${list}">
            <tr>
              <!-- 숫자 정렬 정확도 위해 data-order 부여 -->
              <td class="nowrap-cell" data-order="${row.contractNo}">
                ${row.contractNo}
              </td>

              <td class="amount-cell" data-order="${row.downPayment}">
                ₩<fmt:formatNumber value="${row.downPayment}" type="number" groupingUsed="true"/>
              </td>

              <td>
                <c:choose>
                  <c:when test="${row.downPaymentStatus == 'PS001'}"><span class="badge rounded-pill text-bg-secondary">입금전</span></c:when>
                  <c:when test="${row.downPaymentStatus == 'PS002'}"><span class="badge rounded-pill text-bg-success">입금완료</span></c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>

              <td class="nowrap-cell" data-order="${row.formattedDownPaymentDate}">
                ${row.formattedDownPaymentDate}
              </td>

              <td class="amount-cell" data-order="${row.finalPayment}">
                ₩<fmt:formatNumber value="${row.finalPayment}" type="number" groupingUsed="true"/>
              </td>

              <td>
                <c:choose>
                  <c:when test="${row.finalPaymentStatus == 'PS001'}"><span class="badge rounded-pill text-bg-secondary">입금전</span></c:when>
                  <c:when test="${row.finalPaymentStatus == 'PS002'}"><span class="badge rounded-pill text-bg-success">입금완료</span></c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </td>

              <td class="nowrap-cell final-payment-date" data-order="${row.formattedFinalPaymentDate}">
                ${row.formattedFinalPaymentDate}
              </td>

              <td>
                <c:choose>
                  <c:when test="${empty row.containerNo}">
                    -
                  </c:when>
                  <c:when test="${row.deliveryExist == 1}">
                    <span class="badge rounded-pill text-bg-success">완료</span>
                  </c:when>
                  <c:otherwise>
                    <span class="badge rounded-pill text-bg-warning text-dark">미입력</span>
                  </c:otherwise>
                </c:choose>
              </td>

              <td>
                <c:choose>
                  <c:when test="${row.deliveryExist == 1}">
                    <button type="button"
                            class="btn btn-outline-secondary btn-sm"
                            data-container-no="${row.containerNo}"
                            onclick="recallProductCancel(this)">회수취소</button>
                  </c:when>
                  <c:otherwise>
                    <!-- 기본은 숨김: draw마다 조건 맞으면 보이게 -->
                    <button type="button"
                            class="btn btn-warning btn-sm retrieval-btn"
                            style="display:none;"
                            data-container-no="${row.containerNo}"
                            onclick="recallProduct(this)">상품회수</button>
                  </c:otherwise>
                </c:choose>
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </form>
  </div>
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  /* 최종입금일이 오늘보다 과거면 '상품회수' 버튼 노출 */
  function applyRetrievalVisibility(rowNodes){
    const today = new Date().toISOString().split('T')[0];
    $(rowNodes).each(function(){
      const $row = $(this);
      const dateText = ($row.find('.final-payment-date').text() || '').trim();
      const $btn = $row.find('.retrieval-btn');
      if ($btn.length === 0) return;               // 이미 완료되어 '회수취소'만 있는 행
      if (dateText && dateText < today) $btn.show();
      else $btn.hide();
    });
  }

  /* 멀티 헤더(1행) ↔ 실제 헤더(2행) 폭 동기화 */
  function syncGroupHeaderWidths(){
    const $head = $('#paymentTable_wrapper .dataTables_scrollHead thead');
    const $row2 = $head.find('tr').eq(1);               // 실제 헤더
    const $row1 = $head.find('tr.dt-group-header');     // 그룹행
    if ($row1.length === 0 || $row2.length === 0) return;

    const w = $row2.children('th').map(function(){ return Math.round($(this).outerWidth()); }).get();
    // 2행은 9개: [0]계약번호, [1..3]계약금, [4..6]잔금, [7..8]배송/회수
    const widths = [
      w[0],
      (w[1]||0)+(w[2]||0)+(w[3]||0),
      (w[4]||0)+(w[5]||0)+(w[6]||0),
      (w[7]||0)+(w[8]||0)
    ];
    $row1.children('th').each(function(i){
      const px = Math.max(0, widths[i]||0);
      $(this).css({ width:px+'px', minWidth:px+'px', maxWidth:px+'px' });
    });
  }

  $(function(){
    const table = $('#paymentTable').DataTable({
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
        { targets:0, width:'9ch', className:'text-center nowrap-cell' }, // 계약번호
        { targets:1, width:'12ch', className:'text-center' },   // 계약금
        { targets:2, width:'9ch', className:'text-center'   },                                       // 계약금 상태
        { targets:3, width:'13ch', className:'nowrap-cell text-center' },              // 계약금 날짜
        { targets:4, width:'12ch', className:'text-center'  },   // 잔금
        { targets:5, width:'9ch', className:'text-center'   },                                       // 잔금 상태
        { targets:6, width:'13ch', className:'nowrap-cell text-center' },              // 잔금 날짜
        { targets:7, width:'9ch', className:'text-center'   },                                       // 배송 상태
        { targets:8, width:'11ch', className:'text-center'  }                                        // 회수 버튼
      ],
      order:[[0,'desc']],
      language:{
        lengthMenu:'_MENU_ 개씩 보기', search:'검색:',
        info:'총 _TOTAL_건 중 _START_–_END_', infoEmpty:'0건',
        infoFiltered:'(필터링: _MAX_건 중)', zeroRecords:'일치하는 데이터가 없습니다.',
        paginate:{ first:'처음', last:'마지막', next:'다음', previous:'이전' },
        loadingRecords:'불러오는 중...', processing:'처리 중...'
      },
      drawCallback:function(){
        const api = this.api();
        applyRetrievalVisibility(api.rows({ page:'current' }).nodes());
        syncGroupHeaderWidths();
      },
      initComplete:function(){
        const api = this.api();
        setTimeout(()=>{ api.columns.adjust().draw(false); syncGroupHeaderWidths(); },0);
        // 첫 렌더링 시 버튼 노출 판단
        applyRetrievalVisibility(api.rows({ page:'current' }).nodes());
        // 폭 변동 시 재동기화
        $(window).on('resize', syncGroupHeaderWidths);
        api.table().on('column-sizing.dt columns-visibility.dt', syncGroupHeaderWidths);
      }
    });
  });

  function recallProduct(button){
    const containerNo = button.dataset.containerNo;
    const form = document.getElementById("containerForm");
    form.action = "/admin/recallProduct?containerNo=" + encodeURIComponent(containerNo);
    form.method = "post";
    form.submit();
  }

  function recallProductCancel(button){
    const containerNo = button.dataset.containerNo;
    const form = document.getElementById("containerForm");
    form.action = "/admin/recallProductCancel?containerNo=" + encodeURIComponent(containerNo);
    form.method = "post";
    form.submit();
  }
</script>
</body>
</html>