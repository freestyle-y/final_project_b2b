<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %> 
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %> 
<!DOCTYPE html>
<html lang="ko">
<c:if test="${popRedirect}">
<script>
  // ✅ 팝업 창에서 열렸다면 메인 창으로 이동시키고 팝업은 닫습니다.
  if (window.opener && !window.opener.closed) {
    // 메인 창에 결과 페이지를 띄움 (pg_token 없이도 세션에 값 저장되어 있음)
    window.opener.location.replace('<c:url value="/personal/payment/orderResult"/>?orderNo=${orderList[0].orderNo}');
    window.close();
  }
</script>
</c:if>
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <%@ include file="/WEB-INF/common/head.jsp"%>

  <!-- Pretendard (KR) : 한글 기본 폰트 -->
  <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/variable/pretendardvariable.css"
        crossorigin>

  <style>
    /* Korean typography baseline */
    html, body, button, input, select, textarea {
      font-family: "Pretendard Variable","Pretendard","Noto Sans KR",
                   "Apple SD Gothic Neo",-apple-system,BlinkMacSystemFont,
                   "Segoe UI",Roboto,"Malgun Gothic",Arial,sans-serif;
      line-height: 1.5;
      -webkit-font-smoothing: antialiased;
      -moz-osx-font-smoothing: grayscale;
      font-optical-sizing: auto;
      text-rendering: optimizeLegibility;
      word-break: keep-all; /* 한글 줄바꿈 자연스럽게 */
    }
    /* 숫자(가격/수량/주문번호) 탭 간격 고정 */
    .num, .price, [data-price], #subtotal, #chargedCashOrCard, #realPaidAmount,
    #summaryTotal, #summaryFinal {
      font-variant-numeric: tabular-nums;
      font-feature-settings: "tnum" 1;
    }
    h1,h2,h3 { font-weight: 700; letter-spacing: -0.1px; }
    button,.btn { font-weight: 500; }
  </style>

  <title>주문 확인</title>
</head>

<c:set var="order" value="${orderList[0]}"/>
<body class="order-confirmation-page">
  <!-- 공통 헤더 -->
  <%@ include file="/WEB-INF/common/header/header.jsp" %>

  <main class="main">
    <!-- Page Title -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">주문 확인</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="<c:url value='/personal/mainPage'/>">Home</a></li>
            <li class="current">주문 확인</li>
          </ol>
        </nav>
      </div>
    </div>
    
    <!-- Order Confirmation Section -->
    <section id="order-confirmation" class="order-confirmation section">
      <div class="container" data-aos="fade-up" data-aos-delay="100">
        <div class="order-confirmation-3">
          <div class="row g-0">
            <!-- Left sidebar with order summary -->
            <div class="col-lg-4 sidebar" data-aos="fade-right">
              <div class="sidebar-content">
                <div class="success-animation">
                  <i class="bi bi-check-lg"></i>
                </div>
                <div class="order-id">
                  <h4>주문번호 #${order.orderNo}</h4>
                  <div class="order-date">
                    <fmt:formatDate value="${orderDate}" pattern="yyyy-MM-dd HH:mm"/>
                  </div>
                </div>

                <!-- 진행 단계 -->
                <div class="order-progress">
                  <div class="stepper-container">
                    <div class="stepper-item completed">
                      <div class="stepper-icon">1</div>
                      <div class="stepper-text">결제 확인</div>
                    </div>
                    <div class="stepper-item current">
                      <div class="stepper-icon">2</div>
                      <div class="stepper-text">배송 준비 중</div>
                    </div>
                    <div class="stepper-item">
                      <div class="stepper-icon">3</div>
                      <div class="stepper-text">배송 중</div>
                    </div>
                  </div>
                </div>

                <!-- 가격 요약 -->
				<div class="price-summary">
				  <h5>주문 요약</h5>
				  <ul class="summary-list">
				    <li>
				      <span>총 상품 가격</span>
				      <span><fmt:formatNumber value="${subtotal}" />원</span>
				    </li>
				
				    <li>
				      <span>사용한 적립금</span>
				      <span><fmt:formatNumber value="${usedPoint}" type="number" /> P</span>
				    </li>
				
				    <c:if test="${order.paymentType eq '카카오페이'}">
				      <li>
				        <span>카카오페이 포인트</span>
				        <span><fmt:formatNumber value="${empty usedKakaoPoint ? 0 : usedKakaoPoint}" type="number" /> P</span>
				      </li>
				    </c:if>
				
				    <li class="total">
				      <span>결제 금액</span>
				      <c:choose>
				        <c:when test="${order.paymentType eq '카카오페이'}">
				          <span><fmt:formatNumber value="${chargedCashOrCard}" type="number" />원</span> <!-- ✅ 수정 -->
				        </c:when>
				        <c:otherwise>
				          <span><fmt:formatNumber value="${realPaidAmount}" type="number" />원</span>    <!-- 적립금만 반영 -->
				        </c:otherwise>
				      </c:choose>
				    </li>
				  </ul>
				</div>

				<!-- 배송 정보 -->
				<div class="delivery-info">
				  <h5>배송 정보</h5>
				  <p><c:out value="${productName}"/></p>
				
				  <!-- 상태별 텍스트/아이콘 세팅 -->
				  <c:set var="deliveryText" value="상태 미정"/>
				  <c:set var="deliveryIcon" value="bi-question-circle"/>
				
				  <c:choose>
				    <c:when test="${order.deliveryStatus eq 'DS001'}">
				      <c:set var="deliveryText" value="배송 준비 중"/>
				      <c:set var="deliveryIcon" value="bi-calendar-check"/>
				    </c:when>
				    <c:when test="${order.deliveryStatus eq 'DS002'}">
				      <c:set var="deliveryText" value="배송중"/>
				      <c:set var="deliveryIcon" value="bi-truck"/>
				    </c:when>
				    <c:when test="${order.deliveryStatus eq 'DS003'}">
				      <c:set var="deliveryText" value="배송완료"/>
				      <c:set var="deliveryIcon" value="bi-house-door"/>
				    </c:when>
				  </c:choose>
				
				  <p class="delivery-estimate">
				    <i class="bi ${deliveryIcon}"></i>
				    <span>${deliveryText}</span>
				  </p>
				
				  <p class="shipping-method">
				    <i class="bi bi-truck"></i>
				    <span>일반 배송</span>
				  </p>
				</div>

                <!-- 고객센터 -->
                <div class="customer-service">
                  <h5>고객 센터</h5>
                  <a href="/public/FAQList" class="help-link">
                    <i class="bi bi-question-circle"></i>
                    <span>FAQ</span>
                  </a>
                  <a href="/public/QNAList" class="help-link">
                    <i class="bi bi-question-circle"></i>
                    <span>1:1 문의</span>
                  </a>
                </div>
              </div>
            </div>

            <!-- Main content area -->
            <div class="col-lg-8 main-content" data-aos="fade-in">
              
              <!-- 배송지 정보 -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3><i class="bi bi-geo-alt"></i> 배송 정보</h3>
                </div>
                <div class="card-body">
                  <div class="row g-4">
                    <div class="col-md-6">
                      <div class="detail-group">
                        <label>배송지</label>
                        <address>
                          ${order.name}<br>
                          ${order.address} ${order.detailAddress}<br>
                          ${order.deliveryRequest}
                        </address>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="detail-group">
                        <label>연락처</label>
                        <div class="contact-info">
                          <p><i class="bi bi-envelope"></i> ${order.email}</p>
                          <p><i class="bi bi-telephone"></i> ${order.phone}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 결제 정보 -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3><i class="bi bi-credit-card"></i> 결제 정보</h3>
                </div>
                <div class="card-body">
                  <div class="payment-method">
                    <div class="payment-icon">
                      <i class="bi bi-credit-card-2-front"></i>
                    </div>
					<div class="payment-details">
					  <div class="card-type">${order.paymentType}</div>
					  <div class="card-number">
					    <c:choose>
					      <c:when test="${order.paymentCode eq 'CARD'}">
					        **** **** **** ${order.accountNumber.substring(order.accountNumber.length() - 4)}
					      </c:when>
					
					      <c:otherwise>
					        ${order.paymentCode}
					      </c:otherwise>
					    </c:choose>
					  </div>
					</div>

                  </div>

                </div>
              </div>

              <!-- 주문 상품 목록 -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3><i class="bi bi-bag-check"></i> 주문 상품</h3>
                </div>
                <div class="card-body">
                  <c:forEach var="item" items="${orderList}">
                    <div class="order-item d-flex align-items-center mb-3">
                      <div class="item-image me-3">
                        <img src="<c:url value='${item.imagePath}'/>" alt="${item.productName}" style="width:80px; height:80px; object-fit:cover;">
                      </div>
                      <div class="item-info">
                        <h6>${item.productName}</h6>
                        <p>옵션: ${item.optionName} ${item.optionNameValue}</p>
                        <p>수량: ${item.orderQuantity}개 | <fmt:formatNumber value="${item.price}" />원</p>
                      </div>
                    </div>
                  </c:forEach>
                </div>
              </div>

              <!-- 버튼 -->
              <div class="action-area" data-aos="fade-up">
                <div class="row g-3">
                  <div class="col-md-6">
                    <a href="<c:url value='/personal/mainPage'/>" class="btn btn-back">
                      <i class="bi bi-arrow-left"></i>쇼핑 계속하기
                    </a>
                  </div>
                  <div class="col-md-6">
                    <a href="<c:url value='/personal/orderList'/>" class="btn btn-account">
                      <span>주문 내역 보기</span>
                      <i class="bi bi-arrow-right"></i>
                    </a>
                  </div>
                </div>
              </div>

            </div><!-- /col-lg-8 -->
          </div>
        </div>
      </div>
    </section>
  </main>

  <%@ include file="/WEB-INF/common/footer/footer.jsp" %>

  <script src="<c:url value='/assets/vendor/bootstrap/js/bootstrap.bundle.min.js' />"></script>
  <script src="<c:url value='/assets/vendor/php-email-form/validate.js' />"></script>
  <script src="<c:url value='/assets/vendor/swiper/swiper-bundle.min.js' />"></script>
  <script src="<c:url value='/assets/vendor/aos/aos.js' />"></script>
  <script src="<c:url value='/assets/vendor/glightbox/js/glightbox.min.js' />"></script>
  <script src="<c:url value='/assets/vendor/drift-zoom/Drift.min.js' />"></script>
  <script src="<c:url value='/assets/vendor/purecounter/purecounter_vanilla.js' />"></script>
  <script src="<c:url value='/assets/js/main.js' />"></script>
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