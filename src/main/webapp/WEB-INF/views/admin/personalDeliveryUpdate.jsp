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

	<!-- Contact 2 Section -->
	<section id="contact-2" class="contact-2 section">

		<!-- Contact Form Section -->
		<div class="container">
			<div class="row justify-content-center" data-aos="fade-up" data-aos-delay="300">
				<div class="col-lg-6">
					<div class="contact-form-wrapper">
						<h2 class="text-center mb-4">배송 처리(개인)</h2>
						
							<form id="personalDeliveryForm" action="/admin/personalDeliveryUpdate" method="post">
							<input type="hidden" name="orderNo" value="${orderNo}">
							<input type="hidden" name="subOrderNo" value="${subOrderNo}">
							<div class="row g-3">
								<!-- 택배사 입력 -->
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-text-left"></i>
											<input type="text" class="form-control" name="deliveryCompany" id="deliveryCompany" placeholder="택배사 입력">
										</div>
									</div>
								</div>
								<!-- 운송장 번호 입력 -->
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-text-left"></i>
											<input type="text" class="form-control" name="trackingNo" id="trackingNo" placeholder="운송장 번호 입력">
										</div>
									</div>
								</div>
								<!-- 버튼 -->
								<section class="register py-1">
									<div class="d-grid">
										<button type="submit" class="btn btn-register">배송 처리</button>
									</div>
								</section>
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

<script>
	// 유효성 검사
	document.getElementById("personalDeliveryForm").addEventListener("submit", function(e) {
		const company = document.getElementById("deliveryCompany").value.trim();
		const trackingNo = document.getElementById("trackingNo").value.trim();

		// 택배사 입력 확인
		if(!company) {
			e.preventDefault();
			alert("택배사를 입력해주세요.");
			document.getElementById("deliveryCompany").focus();
			return;
		}

		// 운송장 번호 입력 확인
		if(!trackingNo) {
			e.preventDefault();
			alert("운송장 번호를 입력해주세요.");
			document.getElementById("trackingNo").focus();
			return;
		}

		// 운송장 번호 숫자만 허용
		const numberRegex = /^[0-9]+$/;
		if(!numberRegex.test(trackingNo)) {
			e.preventDefault();
			alert("운송장 번호는 숫자만 입력 가능합니다.");
			document.getElementById("trackingNo").focus();
			return;
		}
	});
</script>

</body>
</html>