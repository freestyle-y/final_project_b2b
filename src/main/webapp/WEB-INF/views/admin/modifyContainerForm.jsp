<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>컨테이너 수정</title>

<style>
  :root{
    --border:#E5E7EB; --head:#F9FAFB; --zebra:#FAFAFA; --hover:#F3F4F6;
    --text:#111827; --muted:#6B7280; --brand:#2563EB; --brand-dark:#1D4ED8;
  }
  *{box-sizing:border-box}
  body{
    font-family:"SUIT","Malgun Gothic","Apple SD Gothic Neo",system-ui,-apple-system,Segoe UI,Roboto,Arial,sans-serif;
    background:#fff; color:var(--text); margin:0;
  }

  /* 레이아웃 */
  .page-wrap{max-width:980px; margin:24px auto; padding:0 16px;}
  .page-title{font-size:1.5rem; font-weight:800; margin:8px 0 16px;}
  .card{
    background:#fff; border:1px solid var(--border); border-radius:12px;
    box-shadow:0 6px 24px rgba(0,0,0,.06);
    padding:20px;
  }

  /* 테이블 폼 */
  .edit-table{width:100%; border-collapse:collapse; margin-top:4px;}
  .edit-table th,
  .edit-table td{border:1px solid var(--border); padding:12px 14px; vertical-align:middle;}
  .edit-table th{
    width:200px; background:var(--head); text-align:center; font-weight:700; white-space:nowrap;
  }
  .edit-table tr:nth-child(even) td{background:var(--zebra);}
  .edit-table tr:hover td{background:var(--hover);}

  /* 입력 요소 */
  .form-input{
    width:100%; height:40px; border:1px solid var(--border); border-radius:8px;
    padding:0 12px; font-size:0.95rem; color:var(--text); background:#fff; outline:0;
    transition:border-color .2s, box-shadow .2s;
  }
  .form-input:focus{
    border-color:var(--brand);
    box-shadow:0 0 0 3px rgba(37,99,235,.15);
  }
  input[type="number"].form-input{
    -moz-appearance:textfield;
  }
  input[type="number"].form-input::-webkit-outer-spin-button,
  input[type="number"].form-input::-webkit-inner-spin-button{
    -webkit-appearance:none; margin:0;
  }

  /* 버튼 & 액션 영역 */
  .actions{
    display:flex; gap:10px; justify-content:flex-end; margin-top:18px;
  }
  .btn{
    display:inline-flex; align-items:center; justify-content:center;
    padding:10px 18px; border-radius:10px; border:1px solid var(--border);
    background:#fff; font-weight:700; cursor:pointer; transition:all .2s;
  }
  .btn:hover{background:#F8FAFF}
  .btn-primary{
    color:#fff; border-color:transparent;
    background:linear-gradient(135deg, #3B82F6 0%, #6366F1 100%);
    box-shadow:0 6px 16px rgba(59,130,246,.25);
  }
  .btn-primary:hover{filter:brightness(.97)}
  .btn-ghost{color:var(--muted);}

  /* 반응형 */
  @media (max-width:640px){
    .edit-table th{width:130px}
    .page-wrap{padding:0 12px}
  }
</style>
</head>
<body>
<%@ include file="/WEB-INF/common/header/header.jsp" %>

<div class="page-wrap">
  <h1 class="page-title">컨테이너 수정</h1>

  <div class="card">
    <form action="${pageContext.request.contextPath}/admin/modifyContainer" method="post" onsubmit="return validateForm(this)">
      <input type="hidden" name="containerNo" value="${container.containerNo}" />

      <table class="edit-table">
        <tr>
          <th scope="row">위치</th>
          <td>
            <input id="containerLocation" type="text" name="containerLocation"
                   class="form-input" value="${container.containerLocation}" placeholder="예) A동 3층 창고 좌측" />
          </td>
        </tr>
        <tr>
          <th scope="row">계약서 주문번호</th>
          <td>
            <input id="contractOrderNo" type="number" name="contractOrderNo"
                   class="form-input" value="${container.contractOrderNo}" min="0" step="1" placeholder="숫자만 입력" />
          </td>
        </tr>
      </table>

      <div class="actions">
        <button type="button" class="btn btn-ghost" onclick="history.back()">취소</button>
        <button type="submit" class="btn btn-primary">수정 완료</button>
      </div>
    </form>
  </div>
</div>

<%@ include file="/WEB-INF/common/footer/footer.jsp" %>

<script>
  // 간단 유효성 검사
  function validateForm(f){
    const loc = f.containerLocation.value.trim();
    const order = f.contractOrderNo.value;

    if(!loc){
      alert('위치를 입력해 주세요.');
      f.containerLocation.focus();
      return false;
    }
    if(order !== '' && Number(order) < 0){
      alert('계약서 주문번호는 0 이상의 숫자여야 합니다.');
      f.contractOrderNo.focus();
      return false;
    }
    return true;
  }
</script>
</body>
</html>