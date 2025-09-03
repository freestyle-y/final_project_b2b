<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>컨테이너 상품 입력</title>

<!-- SUIT 폰트 / Bootstrap -->
<link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
:root{
  --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA;
}
body{ font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif; background:#fff; }
.wrap{ max-width:800px; margin:40px auto; padding:0 15px; }

.panel{ border:1px solid var(--tbl-border); border-radius:14px; background:#fff; box-shadow:0 2px 10px rgba(0,0,0,.05); overflow:hidden; }
.panel-header{ padding:16px 20px; border-bottom:1px solid var(--tbl-border); }
.panel-title{ margin:0; font-size:1.2rem; font-weight:700; }

.table-form{ width:100%; border-collapse:collapse; margin:0; font-size:.95rem; }
.table-form th, .table-form td{
  border-bottom:1px solid var(--tbl-border); padding:.75rem 1rem; text-align:left;
}
.table-form th{ width:30%; background:var(--tbl-head); font-weight:600; }
.table-form td input{ width:100%; padding:.5rem .75rem; border:1px solid #ccc; border-radius:8px; font-size:.9rem; }

.btn-submit{
  margin:20px auto; display:block; padding:.6rem 2rem; font-size:1rem; font-weight:600;
  border-radius:999px; background:#4c59ff; color:#fff; border:none;
  transition:.2s ease;
}
.btn-submit:hover{ background:#3b48d4; }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="wrap">
  <div class="panel">
    <div class="panel-header">
      <h1 class="panel-title">컨테이너 상품 입력</h1>
    </div>
    <div class="p-4">
      <form action="/admin/insertContainer" method="post">
        <table class="table-form">
          <tr>
            <th>컨테이너 위치</th>
            <td><input type="text" id="containerLocation" name="containerLocation"></td>
          </tr>
          <tr>
            <th>주문 번호</th>
            <td><input type="text" name="contractNo" value="${contractNo}" readonly></td>
          </tr>
        </table>
        <button type="submit" class="btn-submit">입력</button>
      </form>
    </div>
  </div>
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>