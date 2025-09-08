<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>교환/반품 신청</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

	<!-- Contact 2 Section -->
	<section id="contact-2" class="contact-2 section">

		<!-- Contact Form Section -->
		<div class="container">
			<div class="row justify-content-center" data-aos="fade-up" data-aos-delay="300">
				<div class="col-lg-6">
					<div class="contact-form-wrapper">
						<h2 class="text-center mb-4">교환/반품 신청</h2>
						
							<form action="/personal/exchangeReturn" method="post">
							<input type="hidden" name="orderNo" value="${orderNo}">
							<input type="hidden" name="subOrderNo" value="${subOrderNo}">
							<div class="row g-3">
								<div class="col-md-12">
									<div class="form-group">
											<select id="deliveryStatus" name="deliveryStatus" class="form-select" required onchange="toggleReason()">
											<option value="DS006" selected>교환</option>
											<option value="DS004">반품</option>
										</select>
									</div>
								</div>
								<!-- 교환 -->
								<div id="exchangeBox">
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-text-left"></i>
											<input type="number" class="form-control" id="exchangeQuantity" name="exchangeQuantity" min="1" max="${orderQuantity}" placeholder="교환 수량 입력" required>
										</div>
									</div>
								</div>
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-pencil-square"></i>
											<input type="text" class="form-control" id="exchangeReason" name="exchangeReason" placeholder="교환 사유 입력" required>
										</div>
									</div>
								</div>
								</div>
								<!-- 반품 -->
								<div id="returnBox" style="display:none;">
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-text-left"></i>
											<input type="number" class="form-control" id="returnQuantity" name="returnQuantity" min="1" max="${orderQuantity}" placeholder="반품 수량 입력" disabled required>
										</div>
									</div>
								</div>
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-pencil-square"></i>
											<input type="text" class="form-control" id="returnReason" name="returnReason" placeholder="반품 사유 입력" disabled required>
										</div>
									</div>
								</div>
								</div>
								<!-- 버튼 -->
								<section class="register py-1">
									<div class="d-grid">
										<button type="submit" class="btn btn-register">신청</button>
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
	
</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
	function toggleReason() {
	    const deliveryStatus = document.getElementById("deliveryStatus").value;
	
	    const exchangeBox = document.getElementById("exchangeBox");
	    const returnBox = document.getElementById("returnBox");
	
	    const exchangeQuantity = document.getElementById("exchangeQuantity");
	    const returnQuantity = document.getElementById("returnQuantity");
	    const exchangeReason = document.getElementById("exchangeReason");
	    const returnReason = document.getElementById("returnReason");
	
	    if (deliveryStatus === "DS006") { // 교환
	        exchangeBox.style.display = "block";
	        exchangeQuantity.disabled = false;
	        exchangeQuantity.required = true;
	        exchangeReason.disabled = false;
	        exchangeReason.required = true;
	
	        returnBox.style.display = "none";
	        returnQuantity.disabled = true;
	        returnQuantity.required = false;
	        returnReason.disabled = true;
	        returnReason.required = false;
	    } else { // 반품
	        returnBox.style.display = "block";
	        returnQuantity.disabled = false;
	        returnQuantity.required = true;
	        returnReason.disabled = false;
	        returnReason.required = true;
	
	        exchangeBox.style.display = "none";
	        exchangeQuantity.disabled = true;
	        exchangeQuantity.required = false;
	        exchangeReason.disabled = true;
	        exchangeReason.required = false;
	    }
	}
</script>

</body>
</html>