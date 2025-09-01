<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>관리자 메인 페이지</title>
</head>
<body class="index-page">

<!-- 공통 헤더 -->
<%@ include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">
	<div class="container">
        <h1>admin mainPage</h1>
		<a href="/admin/productRequestList">상품 요청 목록</a> /
		<a href="/admin/quotationList">견적서 목록</a> / 
		<a href="/admin/contractList">계약서 목록</a> / 
		<a href="/admin/manageUser">회원관리</a> /
		<a href="/admin/finalPaymentHistory">잔금 확인 페이지</a> /
		<a href="/admin/containerList">컨테이너 목록</a> / 
		<a href="/admin/recallProductList">회수 상품 목록</a>
		<br>
		<br>
		<a href="/admin/helpDesk">고객센터 관리</a> /
		<a href="/admin/personalDeliveryList">개인 회원 배송 관리</a> /
		<a href="/admin/bizDeliveryList">기업 회원 배송 관리</a> /
		<a href="/admin/loginHistory">로그인 이력</a> /
		<a href="/admin/alarmList">알림 목록</a> /
		<a href="/admin/alarmWrite">알림 등록</a> /
	</div>
	
	<!-- Scroll Top -->
  	<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
</main>

<!-- 공통 풋터 -->
<%@ include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>