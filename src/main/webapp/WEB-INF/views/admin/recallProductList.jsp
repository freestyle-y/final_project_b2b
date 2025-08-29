<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <%@ include file="/WEB-INF/common/head.jsp"%>
  <title>회수 상품 목록</title>

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
      background:#fff;
    }

    /* 페이지 폭 전체 사용 → 오른쪽 짤림 방지 */
    .table-wrap{ max-width:100%; margin:0 auto; }

    /* 한 테이블만 사용(헤더/바디 분리 안 함) → 수직선 어긋남 방지 */
    table#recallTable{
      table-layout:fixed;      /* 고정 레이아웃: 폭 기준으로 wrap */
      width:100%;
      border-collapse:collapse;/* 수직선 정확히 맞춤 */
      background:#fff;
      border:1px solid var(--tbl-border);
      border-radius:10px;
      overflow:hidden;         /* 상단 라운드 유지 */
      font-size:.95rem;
    }

    /* 헤더 */
    #recallTable thead th{
      background:var(--tbl-head) !important;
      font-weight:700; color:#111827;
      border-bottom:1px solid var(--tbl-border) !important;
      border-right:1px solid var(--tbl-border) !important;
      vertical-align:middle; text-align:center;
      padding:.55rem .75rem; white-space:nowrap;
    }
    #recallTable thead th:last-child{ border-right:none !important; }

    /* 바디 */
    #recallTable tbody td{
      border-top:1px solid var(--tbl-border);
      border-right:1px solid var(--tbl-border);
      color:#111827; vertical-align:middle; text-align:center;
      height:42px; padding:.45rem .75rem;
      /* 긴 주소/단어도 줄바꿈되도록 */
      white-space:normal; word-break:break-word; overflow-wrap:anywhere;
    }
    #recallTable tbody td:last-child{ border-right:none; }
    #recallTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
    #recallTable tbody tr:hover{ background:var(--tbl-hover); }

    /* 빈 셀 강조(옵션) */
    td.cell-empty{ background:var(--tbl-empty) !important; }

    /* 열 폭: 합계 100% → 화면 너비 내에서 wrap
       (필요 시 비율만 조절하세요) */
    #recallTable th:nth-child(1), #recallTable td:nth-child(1){ width:7%;  }
    #recallTable th:nth-child(2), #recallTable td:nth-child(2){ width:22%; }
    #recallTable th:nth-child(3), #recallTable td:nth-child(3){ width:10%; }
    #recallTable th:nth-child(4), #recallTable td:nth-child(4){ width:10%; }
    #recallTable th:nth-child(5), #recallTable td:nth-child(5){ width:27%; }
    #recallTable th:nth-child(6), #recallTable td:nth-child(6){ width:12%; }
    #recallTable th:nth-child(7), #recallTable td:nth-child(7){ width:6%;  }
    #recallTable th:nth-child(8), #recallTable td:nth-child(8){ width:6%;  }

    /* 링크 톤 */
    a{ color:#4c59ff; text-decoration:none; }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-fluid py-3">
  <div class="table-wrap">
    <h1 class="h4 mb-3">회수 상품 목록</h1>

    <table id="recallTable" class="table table-striped table-hover table-bordered align-middle m-0">
      <thead>
        <tr>
          <th>번호</th>
          <th>위치</th>
          <th>구매자 이름</th>
          <th>회사명</th>
          <th>배송지</th>
          <th>상품명</th>
          <th>옵션</th>
          <th>수량</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="g" items="${groups}">
          <c:forEach var="it" items="${g.items}">
            <tr>
              <td>${g.containerNo}</td>
              <td><c:out value="${empty g.containerLocation ? '-' : g.containerLocation}"/></td>
              <td>${g.name}</td>
              <td><c:out value="${empty g.companyName ? '-' : g.companyName}"/></td>
              <td>
                <c:out value="${g.address}"/>
                <c:if test="${not empty g.detailAddress}"> <c:out value="${g.detailAddress}"/></c:if>
              </td>
              <td><c:out value="${empty it.productName ? '-' : it.productName}"/></td>
              <td><c:out value="${empty it.productOption ? '-' : it.productOption}"/></td>
              <td>${it.productQuantity}</td>
            </tr>
          </c:forEach>
        </c:forEach>
      </tbody>
    </table>
  </div>
</div>

<%@ include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  // 빈 셀 강조(선택)
  function highlightEmptyCells(dtApi){
    const rows = dtApi.rows({ page:'current' }).nodes();
    $(rows).each(function(){
      $(this).children('td').each(function(colIdx){
        const $td = $(this);
        const hasElem = $td.find('input,button,select,textarea,a,span').length > 0;
        const text = ($td.text() || '').replace(/\u00a0/g,' ').trim().toLowerCase();
        const emptyText = (text === '' || text === 'null' || text === 'undefined' || text === '-');
        if (!hasElem && emptyText) $td.addClass('cell-empty').attr('title','데이터 없음');
        else $td.removeClass('cell-empty').removeAttr('title');
      });
    });
  }

  $(function(){
    const table = $('#recallTable').DataTable({
      ordering: true,
      searching: true,
      paging: true,
      pageLength: 10,
      lengthMenu: [10, 25, 50, 100],
      info: true,
      autoWidth: false,   // 우리가 지정한 폭 유지
      // scrollX: false  // 기본값 false: 헤더/바디 한 테이블 → 수직선 어긋남 방지
      columnDefs: [
        { targets: [0,2,3,7], className:'text-center' },
        { targets: [1,5,6], className:'text-center' },
        { targets: [4], className:'text-center' }
      ],
      order: [[0,'asc'], [2,'asc']],
      dom: '<"row mb-2"<"col-12 col-md-6"l><"col-12 col-md-6"f>>t<"row mt-2"<"col-12 col-md-5"i><"col-12 col-md-7"p>>',
      language: {
        lengthMenu: '_MENU_ 개씩 보기',
        search: '검색:',
        info: '총 _TOTAL_건 중 _START_–_END_',
        infoEmpty: '0건',
        infoFiltered: '(필터링: _MAX_건 중)',
        zeroRecords: '일치하는 데이터가 없습니다.',
        paginate: { first:'처음', last:'마지막', next:'다음', previous:'이전' },
        loadingRecords: '불러오는 중...', processing:'처리 중...'
      },
      drawCallback: function(){ highlightEmptyCells(this.api()); },
      initComplete: function(){
        const api = this.api();
        // 폰트 로딩/컨테이너 리사이즈 이후 폭 재보정
        setTimeout(()=>{ api.columns.adjust().draw(false); },0);
        $(window).on('resize.recall', ()=> api.columns.adjust());
        highlightEmptyCells(api);
      }
    });
  });
</script>
</body>
</html>