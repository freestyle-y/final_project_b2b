<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %> <!-- [수정] JSTL functions 사용 -->

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>컨테이너 목록</title>

<!-- Toast UI Grid CDN -->
<link rel="stylesheet" href="https://uicdn.toast.com/tui-grid/latest/tui-grid.css" />
<script src="https://uicdn.toast.com/tui-grid/latest/tui-grid.js"></script>

<style>
  /* 화면 폭에 맞추고 내부는 스크롤 */
  #gridWrap { max-width: 1100px; margin: 20px auto; }
  .toolbar { max-width: 1100px; margin: 8px auto 24px; text-align: right; }
  .btn {
    display:inline-block; padding:8px 14px; border:1px solid #ddd; background:#fff;
    border-radius:6px; cursor:pointer;
  }
  .btn + .btn { margin-left:8px; }
  .btn:hover { background:#f7f7f7; }
</style>
</head>
<body>
<%@include file="/WEB-INF/common/header/header.jsp"%>

<h1 style="text-align:center;">컨테이너 목록</h1>

<div id="gridWrap">
  <div id="grid"></div>
</div>

<div class="toolbar">
  <button type="button" class="btn" onclick="modifyContainer()">수정</button>
  <button type="button" class="btn" onclick="deleteContainer()">삭제</button>
</div>

<form id="hiddenForm" method="post" style="display:none;"></form>

<script>
  // ===== 0) 테마를 먼저 적용 =====
  // [수정] 테마는 Grid 생성 전에 적용하는 것이 안전합니다.
  tui.Grid.applyTheme('default', {
    cell: {
      header: { background: '#fafafa', border: '#e5e5e5' },
      normal: { border: '#eee' },
      evenRow: { background: '#f8f8f8' },
      oddRow:  { background: '#ffffff' }
    }
  });

  // 옅은 노랑 배경(특정 컬럼)
  // [수정] 컬럼별 배경은 CSS로 주입
  (function(){
    const style = document.createElement('style');
    style.textContent = `
      .tui-grid-cell[data-column-name="containerLocation"],
      .tui-grid-cell[data-column-name="contractOrderNo"] { background:#fffbe6; }
    `;
    document.head.appendChild(style);
  })();

  // ===== 1) 서버 데이터 → JS 배열로 변환 =====
  // [수정] null 안전 처리: JS literal null / 빈 문자열로 변환
  const rows = [
    <c:forEach var="con" items="${containerList}" varStatus="s">
      {
        containerNo: ${empty con.containerNo ? 'null' : con.containerNo},
        containerLocation: "${empty con.containerLocation ? '' : fn:escapeXml(con.containerLocation)}",
        contractOrderNo: ${empty con.contractOrderNo ? 'null' : con.contractOrderNo}
      }<c:if test="${!s.last}">,</c:if>
    </c:forEach>
  ];

  // ===== 2) Grid 생성 (정렬 + 가로/세로 스크롤) =====
  const grid = new tui.Grid({
    el: document.getElementById('grid'),
    data: rows,
    rowHeaders: ['checkbox'],              // 체크박스 선택
    bodyHeight: 420,                       // 세로 스크롤
    scrollX: true,                         // 가로 스크롤
    scrollY: true,
    columns: [
      { header: '컨테이너 번호', name: 'containerNo', width: 160, align: 'center', sortable: true },
      { header: '위치',         name: 'containerLocation', minWidth: 300, sortable: true },
      { header: '계약서 주문번호', name: 'contractOrderNo', width: 180, align: 'center', sortable: true }
    ],
    columnOptions: {
      resizable: true                      // 열 너비 조정
    }
  });

  // ===== 3) 버튼 동작 =====
  function getChecked() {
    return grid.getCheckedRows(); // [{rowKey, containerNo, ...}, ...]
  }

  window.modifyContainer = function() {
    const checked = getChecked();
    if (checked.length === 0) { alert('수정할 컨테이너를 선택하세요.'); return; }
    if (checked.length > 1)    { alert('하나만 선택하여 수정하세요.');   return; }

    const no = checked[0].containerNo;
    if (no == null) { alert('선택한 항목의 컨테이너 번호가 없습니다.'); return; } // [수정] 방어
    location.href = '/admin/modifyContainerForm?containerNo=' + encodeURIComponent(no);
  }

  window.deleteContainer = function() {
    const checked = getChecked();
    if (checked.length === 0) { alert('삭제할 컨테이너를 선택하세요.'); return; }
    if (!confirm('정말 삭제하시겠습니까?')) return;

    const form = document.getElementById('hiddenForm');
    form.action = '/admin/deleteContainer';
    form.innerHTML = ''; // 초기화

    checked.forEach(r => {
      if (r.containerNo != null) {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'selectedContainerNo';
        input.value = r.containerNo;
        form.appendChild(input);
      }
    });

    form.submit();
  }
</script>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>
</body>
</html>
