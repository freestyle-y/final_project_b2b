<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>배송 처리(개인)</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

	<!-- Page Title -->
	<div class="page-title light-background">
		<div class="container d-lg-flex justify-content-between align-items-center">
			<h1 class="mb-2 mb-lg-0">배송 처리(개인)</h1>
			<nav class="breadcrumbs">
				<ol>
					<li><%@include file="/WEB-INF/common/home.jsp"%></li>
					<li class="current">Delivery</li>
				</ol>
			</nav>
		</div>
	</div>
	<!-- End Page Title -->
	
	<!-- Contact 2 Section -->
	<section id="contact-2" class="contact-2 section">

		<!-- Contact Form Section -->
		<div class="container">
			<div class="row justify-content-center" data-aos="fade-up" data-aos-delay="300">
				<div class="col-lg-6">
					<div class="contact-form-wrapper">
						<h2 class="text-center mb-4">배송 처리(개인)</h2>
						
							<form action="/admin/personalDeliveryUpdate" method="post">
							<input type="hidden" name="orderNo" value="${orderNo}">
							<input type="hidden" name="subOrderNo" value="${subOrderNo}">
							<div class="row g-3">
								<!-- 택배사 입력 -->
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-text-left"></i>
											<input type="text" class="form-control" name="deliveryCompany" id="deliveryCompany" placeholder="택배사 입력" required>
										</div>
									</div>
								</div>
								<!-- 운송장 번호 입력 -->
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-text-left"></i>
											<input type="text" class="form-control" name="trackingNo" id="trackingNo" placeholder="운송장 번호 입력" required>
										</div>
									</div>
								</div>
								<!-- 버튼 -->
								<div class="col-12 text-center">
									<button type="submit" class="btn btn-primary btn-submit">배송 처리</button>
								</div>
							</div>
						</form>
						
					</div>
				</div>
			</div>
		</div>

	</section>
	<!-- /Contact 2 Section -->
	
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
   
</body>
</html>