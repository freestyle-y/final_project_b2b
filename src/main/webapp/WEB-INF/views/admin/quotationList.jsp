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
<link
	href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

<style>
:root {
	--tbl-border: #E5E7EB;
	--tbl-head: #F9FAFB;
	--tbl-hover: #F3F4F6;
	--tbl-zebra: #FAFAFA;
	--tbl-empty: #FFF0F0;
}

body {
	font-family: "SUIT", -apple-system, BlinkMacSystemFont, "Segoe UI",
		Roboto, "Apple SD Gothic Neo", "Noto Sans KR", "Malgun Gothic", Arial,
		sans-serif;
}

.table-wrap {
	max-width: 1000px;
	margin: 0 auto;
}

#quotationTable_wrapper .dataTables_scroll, #quotationTable {
	border: 1px solid var(--tbl-border);
	border-radius: 10px;
	overflow: hidden;
	background: #fff;
	font-size: .92rem;
}

/* 실제 헤더(2행) */
#quotationTable thead tr:nth-child(2) th {
	background: var(--tbl-head) !important;
	font-weight: 700;
	color: #111827;
	border-bottom: 1px solid var(--tbl-border) !important;
	vertical-align: middle;
	padding: .55rem .75rem;
	white-space: nowrap;
}

/* 멀티 헤더(1행: 그룹행) — 보더/포인터/상자모델 정리 */
#quotationTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th,
	#quotationTable thead tr.dt-group-header th {
	box-sizing: border-box;
	min-width: 0;
	border-top: none !important;
	border-bottom: 1px solid var(--tbl-border) !important; /* 아래선만 */
	/* 좌우 보더는 유지하여 세로선 일치 */
	padding: .45rem .75rem;
	text-align: center;
	pointer-events: none; /* 그룹행에서는 정렬/클릭 비활성 */
}

#quotationTable tbody td {
	border-top: 1px solid var(--tbl-border);
	color: #111827;
	vertical-align: middle;
	height: 40px;
	padding: .45rem .75rem;
}

#quotationTable tbody tr:nth-child(even) {
	background: var(--tbl-zebra);
}

#quotationTable tbody tr:hover {
	background: var(--tbl-hover);
}

div.dataTables_scrollBody {
	scrollbar-width: thin;
}

div.dataTables_scrollBody::-webkit-scrollbar {
	height: 10px;
	width: 10px;
}

div.dataTables_scrollBody::-webkit-scrollbar-thumb {
	background: #D1D5DB;
	border-radius: 6px;
}

div.dataTables_scrollBody::-webkit-scrollbar-track {
	background: #F3F4F6;
}

td.cell-empty {
	background: var(--tbl-empty) !important;
}

/* price 셀: 내용 길면 내부 스크롤 */
td.price-cell {
	max-height: 120px;
	overflow: auto;
	text-align: left;
	white-space: normal;
	line-height: 1.4;
}

td.price-cell .item-line {
	display: block;
}

/* 가로폭 계산 안정화 */
#quotationTable, #quotationTable_wrapper .dataTables_scrollHead table,
	#quotationTable_wrapper .dataTables_scrollBody table {
	table-layout: fixed;
}

a {
	color: #4c59ff;
	text-decoration: none;
}
</style>
</head>
<body>
	<%@include file="/WEB-INF/common/header/header.jsp"%>

	<div class="container-xl py-3">
		<div class="table-wrap">
			<h1 class="h4 mb-3">견적서</h1>

			<table id="quotationTable"
				class="table table-striped table-hover table-bordered align-middle w-100">
				<thead class="table-light">
					<!-- [추가] 멀티 헤더(그룹행) -->
					<tr class="dt-group-header">
						<th></th>
						<!-- 상품요청번호 -->
						<th></th>
						<!-- 견적번호 -->
						<th></th>
						<!-- price -->
						<th colspan="4" class="text-center">요청 정보</th>
						<!-- 요청한 회원 + status + createUser + createDate -->
					</tr>
					<!-- 실제 헤더(정렬/검색 기준) -->
					<tr>
						<th>상품요청번호</th>
						<th>견적번호</th>
						<th>price</th>
						<th>요청한 회원</th>
						<th>status</th>
						<th>createUser</th>
						<th>createDate</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="q" items="${quotationList}">
						<tr>
							<td><a
								href="${pageContext.request.contextPath}/admin/quotationOne?quotationNo=${q.quotationNo}">
									${q.productRequestNo} </a></td>
							<td>${q.quotationNo}</td>
							<td class="price-cell"><c:forEach var="item"
									items="${q.items}">
									<span class="item-line"> ${item.productName}
										(${item.productQuantity}) <br> ₩<fmt:formatNumber
											value="${item.price}" type="number" groupingUsed="true" />
									</span>
								</c:forEach></td>
							<td>${q.requestCompanyName}(${q.requestCompanyUser})</td>
							<td class="text-center"
    data-order="${empty q.status ? 0 : (q.status eq '승인거절' ? 1 : (q.status eq '승인' ? 2 : 0))}">
  <c:choose>
    <c:when test="${empty q.status}">
      <span class="badge rounded-pill text-bg-secondary">미작성</span>
    </c:when>
    <c:when test="${q.status eq '승인'}">
      <span class="badge rounded-pill text-bg-success">승인</span>
    </c:when>
    <c:when test="${q.status eq '승인거절'}">
      <span class="badge rounded-pill text-bg-danger">승인거절</span>
    </c:when>
    <c:otherwise>
      <!-- 그 외 상태(검토중 등)는 파란 배지로 표시 -->
      <span class="badge rounded-pill text-bg-info">${q.status}</span>
    </c:otherwise>
  </c:choose>
</td>
							<td>${q.createUser}</td>
							<!-- 날짜 정렬 정확도: data-order로 ISO 유지 -->
							<td data-order="${q.createDate}">
								${fn:substringBefore(q.createDate, ' ')}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<c:choose>
				<c:when test="${empty quotationList}">
					<button type="button" class="btn btn-primary"
						onclick="openWriteQuotationPopup()">견적서 작성</button>
				</c:when>
				<c:when test="${not empty param.productRequestNo}">
					<c:set var="hasReject" value="false" />
					<c:forEach var="q" items="${quotationList}">
						<c:if test="${q.status eq '승인거절'}">
							<c:set var="hasReject" value="true" />
						</c:if>
					</c:forEach>
					<c:if test="${hasReject}">
						<button type="button" class="btn btn-primary"
							onclick="openWriteQuotationPopup()">견적서 작성</button>
					</c:if>
				</c:when>
			</c:choose>
		</div>
	</div>

	<script>
  const productRequestNo = "${param.productRequestNo != null ? param.productRequestNo : 0}";
  const quotationNo = "${param.quotationNo != null ? param.quotationNo : 0}";
  const subProductRequestNo = "${param.subProductRequestNo != null ? param.subProductRequestNo : 0}";
  function openWriteQuotationPopup() {
    const url = "${pageContext.request.contextPath}/admin/writeQuotationForm"
              + "?productRequestNo=" + productRequestNo
              + "&quotationNo=" + quotationNo
              + "&subProductRequestNo=" + subProductRequestNo;
    window.open(url, "writeQuotationPopup", "width=800,height=600,scrollbars=yes");
  }
</script>

	<%@include file="/WEB-INF/common/footer/footer.jsp"%>

	<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
	<script
		src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
	<script
		src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

	<script>
  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).find('td').each(function(){
      const $td = $(this);
      const text = ($td.text() || '').replace(/\u00a0/g,' ').trim().toLowerCase();
      if (text === '' || text === 'null' || text === 'undefined'){
        $td.addClass('cell-empty').attr('title','데이터 없음');
      } else {
        $td.removeClass('cell-empty').removeAttr('title');
      }
    });
  }

  /* [핵심] 멀티 헤더(1행) ↔ 실제 헤더(2행) 폭 동기화 (colspan 자동 합산) */
  function syncAnyGroupHeaderWidths(api){
    const $head = $('#quotationTable_wrapper .dataTables_scrollHead thead');
    const $row2 = $head.find('tr').eq(1);       // 실제 헤더
    const $row1 = $head.find('tr.dt-group-header'); // 그룹행
    if ($row1.length === 0 || $row2.length === 0) return;

    // 2행 헤더 각 열의 외부폭(px) 배열
    const widths = $row2.children('th').map(function(){ return Math.round($(this).outerWidth()); }).get();

    // 1행 그룹행의 각 th에 대응하는 폭 지정 (colspan 합산)
    let idx = 0;
    $row1.children('th').each(function(){
      const $th = $(this);
      const span = parseInt($th.attr('colspan') || '1', 10);
      let sum = 0;
      for (let i=0;i<span;i++) sum += (widths[idx+i] || 0);
      idx += span;
      // 고정(증가 누적 방지): width/min/max 모두 세팅
      const px = Math.max(0, sum);
      $th.css({ width:px+'px', minWidth:px+'px', maxWidth:px+'px' });
    });
  }

  $(function(){
    const table = $('#quotationTable').DataTable({
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
      columnDefs: [
    	  { targets: 0, width:'12%', className:'dt-body-center' }, // 상품요청번호(바디만 센터)
    	  { targets: 1, width:'12%', className:'dt-body-center' }, // 견적번호(바디만 센터)
    	  { targets: 2, width:'28%' },
    	  { targets: 3, width:'21%' },
    	  { targets: 4, width:'10%' },
    	  { targets: 5, width:'8%'  },
    	  { targets: 6, width:'9%'  }
    	],
      order:[[0,'desc']],
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
        const api = this.api();
        highlightEmptyCells(api);
        syncAnyGroupHeaderWidths(api);   // ← 매 그리기 후 동기화
      },
      initComplete:function(){
        const api = this.api();
        highlightEmptyCells(api);
        setTimeout(()=>{
          api.columns.adjust().draw(false);
          syncAnyGroupHeaderWidths(api); // ← 최초 1회(폭 안정화 후)
        },0);

        // 폭이 바뀔 때만 재동기화 (휠 스크롤에는 바인딩하지 않음)
        $(window).on('resize', ()=> syncAnyGroupHeaderWidths(api));
        api.table().on('column-sizing.dt columns-visibility.dt', ()=> syncAnyGroupHeaderWidths(api));
      }
    });
  });
</script>
</body>
</html>