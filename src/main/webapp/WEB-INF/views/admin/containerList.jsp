<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <%@ include file="/WEB-INF/common/head.jsp"%>
  <title>컨테이너 목록</title>

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
    .table-wrap{ max-width:1100px; margin:0 auto; }

    /* DataTables 컨테이너 + 실제 테이블 공통 외곽선/라운드 */
    #containerTable_wrapper .dataTables_scroll,
    #containerTable{
      border:1px solid var(--tbl-border);
      border-radius:10px;
      overflow:hidden;
      background:#fff;
      font-size:.94rem;
    }

    /* 헤더(단일) */
    #containerTable thead th{
      background:var(--tbl-head) !important;
      font-weight:700; color:#111827;
      border-bottom:1px solid var(--tbl-border) !important;
      vertical-align:middle;
      padding:.55rem .75rem;
      white-space:nowrap; text-align:center;
    }

    /* 본문 */
    #containerTable tbody td{
      border-top:1px solid var(--tbl-border);
      color:#111827; vertical-align:middle;
      height:42px; padding:.45rem .75rem; text-align:center;
      white-space:normal; word-break:keep-all; overflow-wrap:anywhere;
    }
    #containerTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
    #containerTable tbody tr:hover{ background:var(--tbl-hover); }

    /* 빈 셀 강조 */
    td.cell-empty{ background:var(--tbl-empty) !important; }

    /* 링크 톤 */
    a{ color:#4c59ff; text-decoration:none; }

    /* 폭 계산 안정화 */
    #containerTable,
    #containerTable_wrapper .dataTables_scrollHead table,
    #containerTable_wrapper .dataTables_scrollBody table{ table-layout:fixed; }

    /* 열별 폭 지정: 수직선/멀티 디바이스 안정 */
    #containerTable th:nth-child(1), #containerTable td:nth-child(1){  /* 선택 */
      width:64px !important; min-width:64px !important; max-width:64px !important;
      white-space:nowrap !important;
    }
    #containerTable th:nth-child(2), #containerTable td:nth-child(2){  /* 컨테이너 번호 */
      width:12ch !important; min-width:12ch !important; max-width:16ch !important;
      white-space:nowrap !important;
    }
    #containerTable th:nth-child(3), #containerTable td:nth-child(3){  /* 위치 */
      width:28ch !important; min-width:22ch !important; max-width:36ch !important;
    }
    #containerTable th:nth-child(4), #containerTable td:nth-child(4){  /* 계약서 주문번호 */
      width:14ch !important; min-width:12ch !important; max-width:18ch !important;
      white-space:nowrap !important;
    }

    /* 상단 버튼 */
    .page-actions .btn{
      border-radius:20px; font-weight:600;
    }
    .btn-action{
      background:linear-gradient(135deg,#667eea 0%,#764ba2 100%);
      border:none; color:#fff;
      box-shadow:0 4px 12px rgba(0,0,0,.15);
    }
    .btn-action:hover{ color:#fff; transform:translateY(-1px); box-shadow:0 6px 16px rgba(0,0,0,.2); }

    /* 스크롤바(가로/세로) */
    div.dataTables_scrollBody{ scrollbar-width:thin; }
    div.dataTables_scrollBody::-webkit-scrollbar{ height:10px; width:10px; }
    div.dataTables_scrollBody::-webkit-scrollbar-thumb{ background:#D1D5DB; border-radius:6px; }
    div.dataTables_scrollBody::-webkit-scrollbar-track{ background:#F3F4F6; }
  </style>
</head>
<body>

<!-- 공통 헤더 -->
<%@ include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <div class="table-wrap">
    <div class="d-flex align-items-center justify-content-between mb-3">
      <h1 class="h4 m-0">컨테이너 목록</h1>
      <div class="page-actions d-flex gap-2">
        <button type="button" class="btn btn-secondary" id="btnModify">수정</button>
        <button type="button" class="btn btn-action" id="btnDelete">삭제</button>
      </div>
    </div>

    <form id="containerForm" class="m-0">
      <table id="containerTable" class="table table-striped table-hover table-bordered align-middle w-100">
        <thead>
          <tr>
            <th>선택</th>
            <th>컨테이너 번호</th>
            <th>위치</th>
            <th>계약서 주문번호</th>
          </tr>
        </thead>
        <tbody>
          <c:forEach var="con" items="${containerList}">
            <tr>
              <td>
                <!-- 체크박스에 값을 실어두고, hidden은 두지 않습니다. (선택된 것만 전송) -->
                <input type="radio" name="rowSelect" value="${con.containerNo}">
              </td>
              <td>${con.containerNo}</td>
              <td>
                <c:choose>
                  <c:when test="${empty con.containerLocation}"><span class="text-muted">-</span></c:when>
                  <c:otherwise>${con.containerLocation}</c:otherwise>
                </c:choose>
              </td>
              <td>
              	<a href="/admin/contractOne?contractNo=${con.contractOrderNo}">
	              	${con.contractOrderNo}
              	</a>	
              </td>
            </tr>
          </c:forEach>
        </tbody>
      </table>
    </form>
  </div>
</div>

<!-- 공통 풋터 -->
<%@ include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  // 빈 셀 강조
  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).each(function(){
      $(this).children('td').each(function(colIdx){
        const $td = $(this);
        if (colIdx === 0) { $td.removeClass('cell-empty'); return; } // 선택 컬럼 제외
        const hasElem = $td.find('input,button,select,textarea,a,span').length > 0;
        const text = ($td.text() || '').replace(/\u00a0/g,' ').trim().toLowerCase();
        const emptyText = (text === '' || text === 'null' || text === 'undefined' || text === '-');
        if (!hasElem && emptyText) $td.addClass('cell-empty').attr('title','데이터 없음');
        else $td.removeClass('cell-empty').removeAttr('title');
      });
    });
  }

  $(function(){
    const table = $('#containerTable').DataTable({
      ordering: true,
      searching: true,
      paging: true,
      pageLength: 10,
      lengthMenu: [10, 25, 50, 100],
      info: true,
      autoWidth: false,
      // 컨텐츠가 네 칼럼이라 가로 스크롤 불필요: scrollX 비활성
      scrollX: false,
      // 세로 스크롤은 상황에 따라 활성화 (원하면 주석 해제)
      // scrollY: '55vh', scrollCollapse: true,

      // 열 정렬 & 폭 힌트
      columnDefs: [
        { targets: 0, orderable:false, className:'text-center' },
        { targets: 1, className:'text-center' },
        { targets: 2, className:'text-center' },
        { targets: 3, className:'text-center' }
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
        paginate: { first:'처음', last:'마지막', next:'다음', previous:'이전' },
        loadingRecords: '불러오는 중...',
        processing: '처리 중...'
      },
      drawCallback: function(){ highlightEmptyCells(this.api()); },
      initComplete: function(){
        const api = this.api();
        highlightEmptyCells(api);
        // 초기 폭 보정
        setTimeout(()=>{ api.columns.adjust().draw(false); },0);
      }
    });

    // 수정 버튼: 정확히 1개 선택 요구
    $('#btnModify').on('click', function(){
      const api = $('#containerTable').DataTable();
      const $checked = api.$('input[name="rowSelect"]:checked', { page:'all' });
      if ($checked.length === 0){ alert('수정할 컨테이너를 선택하세요.'); return; }
      if ($checked.length > 1){ alert('수정은 한 번에 하나만 가능합니다. 하나만 선택하세요.'); return; }
      const containerNo = $checked.first().val();
      const ctx = '${pageContext.request.contextPath}';
      location.href = ctx + '/admin/modifyContainerForm?containerNo=' + encodeURIComponent(containerNo);
    });

    // 삭제 버튼: 다중 선택 가능, 선택된 것만 전송
    $('#btnDelete').on('click', function(){
      const api = $('#containerTable').DataTable();
      const $checked = api.$('input[name="rowSelect"]:checked', { page:'all' });
      if ($checked.length === 0){ alert('삭제할 컨테이너를 선택하세요.'); return; }
      if (!confirm('정말 삭제하시겠습니까?')) return;

      const form = document.getElementById('containerForm');
      // 기존 hidden 제거
      [...form.querySelectorAll('input[type="hidden"][name="containerNo"]')].forEach(el => el.remove());
      // 선택된 것만 hidden으로 추가
      $checked.each(function(){
        const hidden = document.createElement('input');
        hidden.type = 'hidden';
        hidden.name = 'containerNo';       // 서버에서 배열 형태로 받도록 같은 name 반복
        hidden.value = this.value;
        form.appendChild(hidden);
      });

      const ctx = '${pageContext.request.contextPath}';
      form.action = ctx + '/admin/deleteContainer';
      form.method = 'post';
      form.submit();
    });
  });
</script>
</body>
</html>
