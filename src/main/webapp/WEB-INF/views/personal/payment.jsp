<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8" />
  <%@ include file="/WEB-INF/common/head.jsp"%>
  <title>결제 페이지</title>
</head>
<body class="checkout-page">

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

  <div class="page-title light-background">
    <div class="container d-lg-flex justify-content-between align-items-center">
      <h1 class="mb-2 mb-lg-0">Checkout</h1>
      <nav class="breadcrumbs">
        <ol>
          <li><a href="${pageContext.request.contextPath}/">Home</a></li>
          <li class="current">Checkout</li>
        </ol>
      </nav>
    </div>
  </div>

  <!-- Checkout Section -->
  <section id="checkout" class="checkout section">
    <div class="container" data-aos="fade-up" data-aos-delay="100">
      <div class="row g-4">

        <!-- 왼쪽: 결제 폼 -->
        <div class="col-lg-7">
          <div class="checkout-container card shadow-sm" data-aos="fade-up">
            <div class="card-body">

              <h2 class="fw-bold mb-4">결제하기</h2>

              <form id="paymentForm" class="checkout-form">

                <!-- 결제수단 -->
                <div class="checkout-section" id="payment-method">
                  <div class="section-header d-flex align-items-center mb-3">
                    <div class="section-number me-2">1</div>
                    <h3 class="mb-0">결제수단</h3>
                  </div>

                  <div class="section-content">
                    <div class="d-flex flex-wrap gap-3 mb-3">
                      <div class="form-check">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="pm-kakao" value="kakaopay" checked>
                        <label class="form-check-label" for="pm-kakao">카카오페이</label>
                      </div>
                      <div class="form-check">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="pm-bank" value="bank">
                        <label class="form-check-label" for="pm-bank">계좌이체</label>
                      </div>
                      <div class="form-check">
                        <input class="form-check-input" type="radio" name="paymentMethod" id="pm-card" value="card">
                        <label class="form-check-label" for="pm-card">카드결제</label>
                      </div>
                    </div>

                    <!-- 계좌이체 정보 -->
                    <div id="bankInfo" class="border rounded p-3 bg-light mb-3" style="display:none;">
                      <p class="mb-0">
                        <i class="bi bi-bank me-1"></i>
                        기업 계좌번호:
                        <strong>기업은행 977-000803-01-011 (예금주: 노민혁)</strong>
                      </p>
                    </div>

                    <!-- 카드결제 정보 -->
                    <div id="cardInfo" class="border rounded p-3 bg-light mb-3" style="display:none;">
                      <c:choose>
                        <c:when test="${not empty cardList}">
                          <p class="fw-semibold mb-2">등록된 카드 선택</p>
                          <div class="vstack gap-2 mb-3">
                            <c:forEach var="card" items="${cardList}">
                              <div class="form-check">
                                <input class="form-check-input" type="radio" name="cardNo" id="card-${card.paymentMethodNo}" value="${card.paymentMethodNo}"
                                       <c:if test="${card.isDefault == 'Y'}">checked</c:if>>
                                <label class="form-check-label" for="card-${card.paymentMethodNo}">
                                  ${card.financialInstitution}
                                  - ****-****-****-${fn:substring(card.accountNumber, card.accountNumber.length()-4, card.accountNumber.length())}
                                  (유효기간: ${card.cardExpiration})
                                </label>
                              </div>
                            </c:forEach>
                          </div>

                          <button type="button" class="btn btn-outline-secondary btn-sm"
                                  onclick="document.getElementById('newCardForm').style.display='block'">
                            <i class="bi bi-plus-lg me-1"></i>새 카드 등록
                          </button>

                          <div id="newCardForm" class="border rounded p-3 bg-white mt-3" style="display:none;">
                            <div class="row g-2">
                              <div class="col-md-4">
                                <label class="form-label">카드사</label>
                                <input type="text" name="financialInstitution" class="form-control">
                              </div>
                              <div class="col-md-8">
                                <label class="form-label">카드번호</label>
                                <input type="text" name="accountNumber" class="form-control">
                              </div>
                              <div class="col-md-4">
                                <label class="form-label">유효기간(YYYY-MM)</label>
                                <input type="month" name="cardExpiration" class="form-control">
                              </div>
                              <div class="col-md-4">
                                <label class="form-label">CVC</label>
                                <input type="text" name="cardCvc" maxlength="4" class="form-control">
                              </div>
                              <div class="col-md-4">
                                <label class="form-label">비밀번호 앞 2자리</label>
                                <input type="password" name="cardPassword" maxlength="2" class="form-control">
                              </div>
                              <div class="col-12">
                                <div class="form-check">
                                  <input class="form-check-input" type="checkbox" name="isDefault" value="Y" id="isDefault">
                                  <label class="form-check-label" for="isDefault">기본 결제수단으로 등록</label>
                                </div>
                              </div>
                              <div class="col-12">
                                <button type="button" class="btn btn-primary btn-sm" onclick="addCard()">
                                  <i class="bi bi-check2-circle me-1"></i>카드 등록
                                </button>
                              </div>
                            </div>
                          </div>
                        </c:when>
                        <c:otherwise>
                          <p class="fw-semibold mb-2">등록된 카드가 없습니다. 새 카드 정보를 입력하세요.</p>
                          <div id="newCardForm" class="border rounded p-3 bg-white">
                            <div class="row g-2">
                              <div class="col-md-4">
                                <label class="form-label">카드사</label>
                                <input type="text" name="financialInstitution" class="form-control">
                              </div>
                              <div class="col-md-8">
                                <label class="form-label">카드번호</label>
                                <input type="text" name="accountNumber" class="form-control">
                              </div>
                              <div class="col-md-4">
                                <label class="form-label">유효기간(YYYY-MM)</label>
                                <input type="month" name="cardExpiration" class="form-control">
                              </div>
                              <div class="col-md-4">
                                <label class="form-label">CVC</label>
                                <input type="text" name="cardCvc" maxlength="4" class="form-control">
                              </div>
                              <div class="col-md-4">
                                <label class="form-label">비밀번호 앞 2자리</label>
                                <input type="password" name="cardPassword" maxlength="2" class="form-control">
                              </div>
                              <div class="col-12">
                                <div class="form-check">
                                  <input class="form-check-input" type="checkbox" name="isDefault" value="Y" id="isDefault2">
                                  <label class="form-check-label" for="isDefault2">기본 결제수단으로 등록</label>
                                </div>
                              </div>
                            </div>
                          </div>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                </div>

                <!-- 결제 금액/적립금 -->
                <div class="checkout-section">
                  <div class="section-header d-flex align-items-center mb-3">
                    <div class="section-number me-2">2</div>
                    <h3 class="mb-0">결제 금액</h3>
                  </div>

                  <div class="section-content border rounded p-3 bg-light">
                    <p class="mb-2">
                      상품 총 금액:
                      <c:set var="total" value="0" />
                      <c:forEach var="order" items="${orderList}">
                        <c:set var="total" value="${total + (order.price * order.orderQuantity)}" />
                      </c:forEach>
                      <strong><span id="totalAmount">${total}</span> 원</strong>
                    </p>
                    <div class="row g-2 align-items-end mb-2">
                      <div class="col-md-4">
                        <label class="form-label">사용 가능 적립금</label>
                        <input type="text" id="availablePoints" value="${reward}" readonly class="form-control">
                      </div>
                      <div class="col-md-4">
                        <label class="form-label">사용할 적립금</label>
                        <input type="number" id="usePoints" name="usePoints" min="0" step="100" class="form-control">
                      </div>
                      <div class="col-md-4">
                        <button type="button" id="useAllBtn" class="btn btn-outline-secondary w-100" onclick="useAllPoints()">전액 사용</button>
                      </div>
                    </div>

                    <div id="pointError" class="text-danger small mb-2"></div>
                    <div class="text-muted small" id="pointRuleNote">
                      적립금 사용 규칙 · ① 주문금액 10,000원 이상 · ② 최소 1,000원 · ③ 100원 단위 · ④ 주문금액의 10% 이내
                    </div>
                    <div class="text-muted small" id="pointMaxNote"></div>

                    <p class="fw-bold mt-3 mb-0">최종 결제 금액: <span id="finalAmount">${total}</span> 원</p>
                  </div>
                </div>

                <!-- 배송지 -->
                <div class="checkout-section">
                  <div class="section-header d-flex align-items-center mb-3">
                    <div class="section-number me-2">3</div>
                    <h3 class="mb-0">배송지</h3>
                  </div>

                  <div class="section-content border rounded p-3 bg-light">
                    <c:forEach var="add" items="${mainAddress}">
                      <p class="mb-1">기본 배송지: <strong id="selectedAddress">${add.address} ${add.detailAddress}</strong></p>
                      <p class="mb-0">별칭 : <strong id="selectedAddressNickname">${add.nickname}</strong></p>
                    </c:forEach>
                    <input type="hidden" id="selectedAddressId" name="addressNo" value="${mainAddress[0].addressNo}">
                    <button type="button" class="btn btn-light mt-2" onclick="openAddressPopup()">
                      <i class="bi bi-pencil-square me-1"></i>배송지 변경
                    </button>
                  </div>
                </div>

                <!-- 배송 요청사항 -->
                <div class="checkout-section">
                  <div class="section-header d-flex align-items-center mb-3">
                    <div class="section-number me-2">4</div>
                    <h3 class="mb-0">배송 요청사항</h3>
                  </div>
                  <div class="section-content">
                    <textarea name="deliveryRequest" rows="3" class="form-control"
                              placeholder="예: 부재 시 경비실에 맡겨주세요.">${orderList[0].deliveryRequest}</textarea>
                  </div>
                </div>

                <!-- 액션 버튼 -->
                <div class="d-flex gap-2 mt-4">
                  <input type="button" id="payBtn" class="btn btn-primary" value="결제하기" onclick="showPasswordPopup()">
                  <input type="reset" class="btn btn-outline-secondary" value="취소">
                </div>

              </form>
            </div>
          </div>
        </div>

        <!-- 오른쪽: 주문 요약 -->
        <div class="col-lg-5">
          <div class="order-summary card shadow-sm" data-aos="fade-left" data-aos-delay="200">
            <div class="order-summary-header card-header d-flex justify-content-between align-items-center">
              <h3 class="mb-0">Order Summary</h3>
              <span class="item-count">
                <c:out value="${fn:length(orderList)}"/> Items
              </span>
            </div>

            <div class="order-summary-content card-body">
              <!-- 아이템 목록 -->
              <div class="order-items vstack gap-3 mb-3">
                <c:forEach var="order" items="${orderList}">
                  <div class="order-item d-flex gap-3">
                    <div class="order-item-image" style="width:64px;height:64px;flex:0 0 64px;">
					  <c:set var="imgPath" value="${order.imagePath}" />
					  <c:if test="${not empty imgPath}">
					    <c:set var="imgPath" value="${fn:replace(imgPath, ' ', '%20')}" />
					  </c:if>
					  <c:choose>
					    <c:when test="${not empty imgPath and (fn:startsWith(imgPath,'http://') or fn:startsWith(imgPath,'https://'))}">
					      <img src="${imgPath}" alt="${order.productName}" class="img-fluid rounded"
					           style="width:64px;height:64px;object-fit:cover;" />
					    </c:when>
					    <c:when test="${not empty imgPath}">
					      <img src="${pageContext.request.contextPath}${imgPath}" alt="${order.productName}" class="img-fluid rounded"
					           style="width:64px;height:64px;object-fit:cover;" />
					    </c:when>
					    <c:otherwise>
					      <img src="${pageContext.request.contextPath}/assets/img/product/product-1.webp"
					           alt="No image" class="img-fluid rounded"
					           style="width:64px;height:64px;object-fit:cover;" />
					    </c:otherwise>
					  </c:choose>
					</div>
                    <div class="order-item-details flex-grow-1">
                      <h4 class="h6 mb-1">${order.productName}</h4>
                      <p class="order-item-variant text-muted small mb-1">
                        옵션: ${order.optionName}:${order.optionNameValue}
                      </p>
                      <div class="order-item-price d-flex justify-content-between">
                        <span class="quantity text-muted">${order.orderQuantity} ×</span>
                        <span class="price fw-semibold">${order.price}원</span>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>

              <!-- 합계 -->
              <div class="order-totals vstack gap-2 border-top pt-3">
                <div class="d-flex justify-content-between">
                  <span>상품 총 금액</span>
                  <span id="summaryTotal"><strong>${total}</strong> 원</span>
                </div>
                
                <div class="d-flex justify-content-between">
                  <span>적립금</span>
                  <span id="summaryTotal">
				  	<strong><fmt:formatNumber value="${total/100}" type="number" /></strong> 원
				  </span>
                </div>
                
                <div class="d-flex justify-content-between">
                  <span>예상 결제 금액</span>
                  <span><strong><span id="summaryFinal">${total}</span></strong> 원</span>
                </div>
              </div>

              <!-- 보안 표기 -->
              <div class="secure-checkout border-top mt-3 pt-3 d-flex justify-content-between align-items-center">
                <div class="secure-checkout-header d-flex align-items-center gap-2">
                  <i class="bi bi-shield-lock"></i>
                  <span>Secure Checkout</span>
                </div>
                <div class="payment-icons d-flex gap-2 fs-5">
                  <i class="bi bi-credit-card-2-front"></i>
                  <i class="bi bi-paypal"></i>
                  <i class="bi bi-apple"></i>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div><!-- row -->
    </div><!-- container -->
  </section>
</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- jQuery (기존 코드 의존) -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- ▼ 템플릿 JS -->
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/php-email-form/validate.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/swiper/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/drift-zoom/Drift.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/purecounter/purecounter_vanilla.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>
<!-- ▲ 템플릿 메인 -->

<script type="text/javascript">
  // ===== 적립금 규칙/계산 =====
  function getPointRuleError(usePoint, total, available) {
    if (!usePoint || usePoint <= 0) return "";
    if (total < 10000) return "물품 가격이 10,000원 이상이어야 적립금을 사용할 수 있습니다.";
    if (usePoint < 1000) return "적립금은 최소 1,000원 이상 사용 가능합니다.";
    if (usePoint % 100 !== 0) return "적립금은 100원 단위로만 사용 가능합니다.";
    const maxPoint = Math.floor((total * 0.1) / 100) * 100;
    if (usePoint > maxPoint) return `적립금은 구매 가격의 10%(${maxPoint}원)를 넘을 수 없습니다.`;
    if (usePoint > available) return "보유 적립금을 초과했습니다.";
    return "";
  }

  function updateFinalAmount() {
    const total = parseInt(document.getElementById("totalAmount").innerText);
    const available = parseInt(document.getElementById("availablePoints").value);
    let usePoint = parseInt(document.getElementById("usePoints").value || 0);
    if (usePoint < 0) usePoint = 0;

    const err = getPointRuleError(usePoint, total, available);
    const errorDiv = document.getElementById("pointError");
    const payBtn = document.getElementById("payBtn");

    if (err) {
      errorDiv.textContent = err;
      document.getElementById("finalAmount").innerText = total;
      document.getElementById("summaryFinal").innerText = total;
      payBtn.disabled = true;
    } else {
      errorDiv.textContent = "";
      const maxPoint = Math.floor((total * 0.1) / 100) * 100;
      usePoint = Math.min(usePoint, available, maxPoint);
      usePoint = Math.floor(usePoint / 100) * 100;
      document.getElementById("usePoints").value = usePoint;
      const final = total - usePoint;
      document.getElementById("finalAmount").innerText = final;
      document.getElementById("summaryFinal").innerText = final;
      payBtn.disabled = false;
    }
    refreshPointControls();
  }

  function refreshPointControls() {
    const total = parseInt(document.getElementById("totalAmount").innerText);
    const available = parseInt(document.getElementById("availablePoints").value);
    const maxByRate = Math.floor((total * 0.1) / 100) * 100;
    const maxUsable = Math.min(available, maxByRate);
    const eligible = (total >= 10000) && (maxUsable >= 1000);
    document.getElementById("usePoints").disabled = !eligible;
    document.getElementById("useAllBtn").disabled = !eligible;
  }

  function useAllPoints() {
    const total = parseInt(document.getElementById("totalAmount").innerText);
    const available = parseInt(document.getElementById("availablePoints").value);
    if (total < 10000) {
      document.getElementById("usePoints").value = 0;
      updateFinalAmount();
      return;
    }
    const tenPctCap = Math.floor((total * 0.1) / 100) * 100;
    let usePoint = Math.min(available, tenPctCap);
    usePoint = Math.floor(usePoint / 100) * 100;
    if (usePoint < 1000) {
      document.getElementById("usePoints").value = 0;
      updateFinalAmount();
      return;
    }
    document.getElementById("usePoints").value = usePoint;
    updateFinalAmount();
  }

  // ===== 배송지/결제 API 연동 =====
  function openAddressPopup() {
    let userId = "${orderList[0].userId}";
    window.open("/personal/addressPopup?user_id=" + userId, "addressPopup", "width=800,height=600,scrollbars=yes");
  }

  function updateDeliveryRequest() {
    const orderNo = "${orderList[0].orderNo}";
    const deliveryRequest = document.querySelector("textarea[name='deliveryRequest']").value.trim();
    return $.ajax({
      type: "POST",
      url: "/personal/payment/deliveryRequest",
      data: JSON.stringify({ orderNo, deliveryRequest }),
      contentType: "application/json"
    });
  }

  function showPasswordPopup() {
    const method = document.querySelector("input[name='paymentMethod']:checked").value;
    const addressNo = parseInt(document.getElementById("selectedAddressId").value);

    if (method === "bank") {
      updateDeliveryRequest().done(function () {
        const total = parseInt(document.getElementById("totalAmount").innerText);
        const available = parseInt(document.getElementById("availablePoints").value);
        let usePoint = parseInt(document.getElementById("usePoints").value || 0);
        const err = getPointRuleError(usePoint, total, available);
        if (err) { alert(err); return; }
        const maxPoint = Math.floor((total * 0.1) / 100) * 100;
        usePoint = Math.max(0, Math.min(usePoint, available, maxPoint));
        usePoint = Math.floor(usePoint / 100) * 100;

        $.ajax({
          type: "POST",
          url: "/personal/payment/saveMethodAndPoints",
          contentType: "application/json",
          dataType: 'json',
          data: JSON.stringify({
            orderNo: "${orderList[0].orderNo}",
            paymentMethod: "bank",
            usePoint: usePoint,
            addressNo: addressNo
          }),
          success: function (res) {
        	  if (res && res.redirectUrl) {
        	    location.href = res.redirectUrl;
        	  } else {
        	    location.href = "/personal/orderList"; // 안전망
        	  }
        	},
          error: function (xhr) {
            const msg = xhr.responseJSON && xhr.responseJSON.message ? xhr.responseJSON.message : "결제수단/적립금 저장 실패";
            alert(msg);
            if (msg.includes("재고 부족")) { location.href = "/personal/mainPage"; }
          }
        });
      }).fail(function () { alert("배송요청 저장 실패"); });
      return;
    }

    const total = parseInt(document.getElementById("totalAmount").innerText);
    const available = parseInt(document.getElementById("availablePoints").value);
    const usePoint = parseInt(document.getElementById("usePoints").value || 0);
    const err = getPointRuleError(usePoint, total, available);
    if (err) { alert(err); return; }

    const userId = "${orderList[0].userId}";
    $.ajax({
      type: "GET",
      url: "/personal/payment/simplePassword",
      data: { userId },
      dataType: "json",
      success: function () {
        window.open("/personal/passwordPopup?userId=" + userId, "passwordPopup", "width=400, height=300");
      },
      error: function () { alert("비밀번호 등록 유무 확인 중 오류 발생"); }
    });
  }

  function completePayment() {
    updateDeliveryRequest().done(function () {
      const method = document.querySelector("input[name='paymentMethod']:checked").value;
      const total = parseInt(document.getElementById("totalAmount").innerText);
      const available = parseInt(document.getElementById("availablePoints").value);
      const addressNo = parseInt(document.getElementById("selectedAddressId").value);
      let usePoint = parseInt(document.getElementById("usePoints").value || 0);
      const err = getPointRuleError(usePoint, total, available);
      if (err) { alert(err); return; }
      const maxPoint = Math.floor((total * 0.1) / 100) * 100;
      usePoint = Math.max(0, Math.min(usePoint, available, maxPoint));
      usePoint = Math.floor(usePoint / 100) * 100;

      const data = {
        orderNo: "${orderList[0].orderNo}",
        name: "${orderList[0].productName}",
        totalPrice: Math.max(0, total - usePoint),
        usePoint: usePoint,
        userId: "${orderList[0].userId}",
        paymentMethod: method,
        addressNo: addressNo
      };
      if (method === "card") {
          const selected = document.querySelector("input[name='cardNo']:checked");
          if (!selected) { alert("사용할 카드를 선택하세요."); return; }
          data.cardMethodNo = parseInt(selected.value, 10);
        }
      if (method === "card") {
        $.ajax({
          type: "POST",
          url: "/personal/payment/saveMethodAndPoints",
          contentType: "application/json",
          dataType: 'json',
          data: JSON.stringify(data),
          success: function (res) {             // ✅ 수정
        	  if (res && res.redirectUrl) {
        	    location.href = res.redirectUrl;  // ✅ 수정
        	  } else {
        	    location.href = "/personal/orderList";
        	  }
        	},
          error: function (xhr) {
            const msg = xhr.responseJSON && xhr.responseJSON.message ? xhr.responseJSON.message : "결제수단/적립금 저장 실패";
            alert(msg);
            if (msg.includes("재고 부족")) location.href = "/personal/mainPage";
          }
        });
        return;
      }

      if (method === "kakaopay") {
    	  // ✅ 수정: 팝업을 "먼저" 띄워서 브라우저 팝업 차단 회피
    	  const payWin = window.open("", "kakaoPayPopup", "width=520,height=720");
    	  if (!payWin || payWin.closed) {
    	    alert("팝업이 차단되었습니다. 브라우저 팝업 허용을 켜주세요.");
    	    return;
    	  }

    	  $.ajax({
    	    type: "POST",
    	    url: "/personal/payment/saveMethodAndPoints",
    	    contentType: "application/json",
    	    data: JSON.stringify(data),
    	    success: function () {
    	      $.ajax({
    	        type: "POST",
    	        url: "/personal/payment/ready",
    	        contentType: "application/json",
    	        data: JSON.stringify({
    	          orderNo: data.orderNo,
    	          name: data.name,
    	          totalPrice: data.totalPrice
    	        }),
    	        success: function (response) {
    	          const redirectUrl =
    	            response.next_redirect_pc_url ||
    	            response.next_redirect_mobile_url ||
    	            response.next_redirect_app_url;

    	          if (redirectUrl) {
    	            // ✅ 수정: 팝업 창으로 카카오 결제창 로드
    	            payWin.location.replace(redirectUrl);
    	          } else {
    	            payWin.close();
    	            alert("카카오페이 결제 요청 실패");
    	          }
    	        },
    	        error: function (xhr) {
    	          payWin.close();
    	          alert((xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : "카카오페이 결제 중 오류 발생");
    	        }
    	      });
    	    },
    	    error: function (xhr) {
    	      payWin.close();
    	      const msg = xhr.responseJSON && xhr.responseJSON.message ? xhr.responseJSON.message : "결제수단/적립금 저장 실패";
    	      alert(msg);
    	      if (msg.includes("재고 부족")) location.href = "/personal/mainPage";
    	    }
    	  });
    	  return;
    	}
    }).fail(function () { alert("배송요청 저장 실패"); });
  }

  // ===== 초기 바인딩 =====
  window.onload = function () {
    // 결제수단 토글
    document.querySelectorAll("input[name='paymentMethod']").forEach(radio => {
      radio.addEventListener("change", function () {
        document.getElementById("bankInfo").style.display = (this.value === "bank") ? "block" : "none";
        document.getElementById("cardInfo").style.display = (this.value === "card") ? "block" : "none";
      });
    });

    // 적립금 입력 변화
    document.getElementById("usePoints").addEventListener("input", updateFinalAmount);

    // 합계 초기화
    updateFinalAmount();
    refreshPointControls();

    // 요약 영역 Total 동기화
    const total = document.getElementById("totalAmount").innerText;
    document.getElementById("summaryTotal").querySelector("strong").innerText = total;
  };
</script>
<script>
/* 1) 드롭다운 토글 버튼이면 type="button" 강제(폼 submit 방지) */
(function ensureBtnType(){
  const sel = [
    'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
    '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
    'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]',
    '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
  ].join(',');

  document.querySelectorAll(sel).forEach(btn => {
    if (!btn.hasAttribute('type')) btn.setAttribute('type','button');
  });
})();

/* 2) 캡처링 단계에서 좌표 기반 hit-test로 드롭다운 강제 토글 */
(function forceDropdownToggle(){
  const getBtns = () => Array.from(document.querySelectorAll(
    'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
    '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
    'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"],' +
    '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
  ));

  function inside(rect, x, y){
    return x >= rect.left && x <= rect.right && y >= rect.top && y <= rect.bottom;
  }

  // 캡처링 단계(true)로 등록 → 위에 뭔가 덮여 있어도 좌표로 판별해 토글
  document.addEventListener('click', function(ev){
    const x = ev.clientX, y = ev.clientY;
    const btn = getBtns().find(b => inside(b.getBoundingClientRect(), x, y));
    if (!btn) return;

    // 기본 동작(폼 제출/포커스 등) 막고 Bootstrap 드롭다운을 직접 토글
    ev.preventDefault();
    // ev.stopPropagation(); // 필요시 주석 해제. 기본에선 버블링 유지.

    try {
      const dd = bootstrap.Dropdown.getOrCreateInstance(btn);
      dd.toggle();
    } catch (e) {
      // bootstrap이 아직 로드 전이면 다음 틱에 재시도
      setTimeout(() => {
        const dd = bootstrap.Dropdown.getOrCreateInstance(btn);
        dd.toggle();
      }, 0);
    }
  }, true);
})();
</script>

</body>
</html>