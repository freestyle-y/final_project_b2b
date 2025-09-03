<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>견적서 수정</title>

<!-- 폰트/부트스트랩 -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
  :root{
    --tbl-border:#E5E7EB;
    --tbl-head:#F9FAFB;
    --tbl-hover:#F3F4F6;
    --tbl-zebra:#FAFAFA;
  }
  body{
    font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif;
    background:#fff;
  }

  .edit-wrap{ max-width:1100px; margin:28px auto; padding:0 12px; }

  /* 카드 패널 */
  .panel{
    border:1px solid var(--tbl-border);
    border-radius:14px;
    background:#fff;
    box-shadow:0 2px 10px rgba(0,0,0,.03);
    overflow:hidden;                 /* 둥근 모서리 밖 내용 클리핑 */
  }
  .panel-header{
    padding:16px 20px;
    border-bottom:1px solid var(--tbl-border);
    display:flex; align-items:center; justify-content:space-between;
  }
  .panel-title{ margin:0; font-size:1.1rem; font-weight:700; }

  .table-clip{ border-radius:14px; overflow:hidden; } /* 테이블 라운드 보호 */

  /* 폼 테이블 */
  table.form-table{
    width:100%;
    table-layout:fixed;               /* 폭 고정 + 줄바꿈 안정 */
    border-collapse:collapse;         /* 수직선 정확 */
    font-size:.95rem;
    background:#fff;
  }
  table.form-table thead th{
    background:var(--tbl-head);
    border-bottom:1px solid var(--tbl-border);
    border-right:1px solid var(--tbl-border);
    padding:.6rem .8rem;
    text-align:center; white-space:nowrap; color:#111827; font-weight:700;
  }
  table.form-table thead th:last-child{ border-right:0; }
  table.form-table tbody td{
    border-top:1px solid var(--tbl-border);
    border-right:1px solid var(--tbl-border);
    padding:.55rem .8rem;
    vertical-align:middle; text-align:center; color:#111827;
    white-space:normal; word-break:keep-all; overflow-wrap:anywhere; height:44px;
  }
  table.form-table tbody td:last-child{ border-right:0; }
  table.form-table tbody tr:nth-child(even){ background:var(--tbl-zebra); }
  table.form-table tbody tr:hover{ background:var(--tbl-hover); }

  /* 열 폭(3열) — 합계 100% */
  /* 상품명 | 옵션 | 가격입력 */
  table.form-table col:nth-child(1){ width:45%; }
  table.form-table col:nth-child(2){ width:30%; }
  table.form-table col:nth-child(3){ width:25%; } /* 가격 */

  /* 숫자 입력 UI */
  .price-input.form-control{
    text-align:right;                 /* 금액 오른쪽 정렬 */
  }
  /* 스핀버튼 제거(크롬 등) */
  input[type="number"].form-control::-webkit-outer-spin-button,
  input[type="number"].form-control::-webkit-inner-spin-button{ -webkit-appearance: none; margin:0; }
  input[type="number"].form-control{ appearance:textfield; }

  /* 하단 버튼 영역 */
  .panel-footer{
    padding:16px 20px;
    border-top:1px solid var(--tbl-border);
    display:flex; gap:8px; justify-content:flex-end;
    background:#fff;
  }
</style>
</head>
<body>

<div class="edit-wrap">
  <div class="panel">
    <div class="panel-header">
      <h1 class="panel-title">견적서 수정</h1>
    </div>

    <form action="/admin/modifyQuotation" method="post" id="editForm" class="m-0">
      <input type="hidden" name="quotationNo" value="${quotation.quotationNo}">
      <input type="hidden" name="productRequestNo" value="${quotation.productRequestNo}">
      <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
      </c:if>

      <div class="table-clip">
        <table class="form-table">
          <colgroup>
            <col><col><col> <!-- (수정) 3열로 정정 -->
          </colgroup>
          <thead>
            <tr>
              <th>상품명</th>
              <th>옵션</th>
              <th>가격(원)</th>
            </tr>
          </thead>
          <tbody>
            <c:forEach var="item" items="${quotation.items}">
              <tr>
                <td><c:out value="${item.productName}"/></td>
                <td><c:out value="${item.productOption}"/></td>
                <td>
                  <input
                    type="number"
                    name="price"
                    class="form-control price-input"
                    value="${item.price}"
                    min="0" step="1" required
                    aria-label="가격 입력">
                  <!-- (수정) 숨김 필드를 td 내부로 이동해 유효 마크업 보장 -->
                  <input type="hidden" name="itemId" value="${item.itemId}">
                  <input type="hidden" name="productRequestNo" value="${item.productRequestNo}">
                </td>
              </tr>
            </c:forEach>
          </tbody>
        </table>
      </div>

      <div class="panel-footer">
        <button type="button" class="btn btn-outline-secondary" onclick="history.back()">취소</button>
        <button type="submit" class="btn btn-primary">수정 완료</button>
      </div>
    </form>
  </div>
</div>

</body>
</html>