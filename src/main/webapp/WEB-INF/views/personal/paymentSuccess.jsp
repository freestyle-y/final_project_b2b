<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="ko_KR" />
<jsp:useBean id="now" class="java.util.Date" />


<c:set var="vName"        value="${empty name            ? '고객님'  : name}" />
<c:set var="vOrderNo"     value="${empty orderNo         ? '-'       : orderNo}" />
<c:set var="vOrderDate"   value="${empty orderDate       ? now       : orderDate}" />
<c:set var="vReal"        value="${empty realPaidAmount  ? 0         : realPaidAmount}" />
<c:set var="vUsedPoint"   value="${empty usedPoint       ? 0         : usedPoint}" />
<c:set var="vUsedKakao"   value="${empty usedKakaoPoint  ? 0         : usedKakaoPoint}" />
<c:set var="vShipping"    value="${empty shippingFee     ? 0         : shippingFee}" />
<c:set var="vReturnUrl"   value="${empty returnUrl       ? '/'       : returnUrl}" />
<c:set var="vAccountUrl"  value="${empty accountUrl      ? '/personal/orderList' : accountUrl}" />

<!-- 상품 총액(추정): 실결제(현금/카드 등) + 카카오페이 포인트 -->
<c:set var="estimatedSubtotal" value="${vReal + vUsedKakao}" />
<!-- 실 결제액(현금/카드/계좌 등): realPaidAmount - usedKakaoPoint -->
<c:set var="actualPaid" value="${vReal - vUsedKakao}" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>주문 확인 - 결제 성공</title>

  <!-- Favicons (선택) -->
  <link href="assets/img/favicon.png" rel="icon">
  <link href="assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Fonts -->
  <link href="https://fonts.googleapis.com" rel="preconnect">
  <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700;900&family=Montserrat:wght@400;500;600;700;800;900&family=Poppins:wght@300;400;500;600;700;800;900&display=swap" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
  <link href="assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
  <link href="assets/vendor/drift-zoom/drift-basic.css" rel="stylesheet">

  <!-- Main CSS File (NiceShop) -->
  <link href="assets/css/main.css" rel="stylesheet">

  <!-- 페이지 커스텀(선택) -->
  <style>
    .order-confirmation .success-animation{
      width:64px;height:64px;border-radius:50%;
      border:2px solid #28a745;display:flex;align-items:center;justify-content:center;
      margin:0 auto 16px;color:#28a745;font-size:28px;
    }
    .order-confirmation .order-id h4{ margin-bottom:4px; }
    .order-confirmation .price-summary ul{ list-style:none;padding-left:0;margin-bottom:0; }
    .order-confirmation .price-summary li{
      display:flex;justify-content:space-between; padding:6px 0; border-bottom:1px dashed #eee;
      font-size:14px;
    }
    .order-confirmation .price-summary li.total{ font-weight:700; border-bottom:none; padding-top:10px; }
    .order-confirmation .details-card{ border:1px solid #eee; border-radius:10px; margin-bottom:16px; overflow:hidden; }
    .order-confirmation .details-card .card-header{
      padding:14px 16px; background:#fafafa; display:flex; align-items:center; justify-content:space-between; cursor:default;
    }
    .order-confirmation .details-card .card-body{ padding:16px; background:#fff; }
    .order-confirmation .item{ display:flex; gap:14px; padding:10px 0; border-bottom:1px solid #f2f2f2; }
    .order-confirmation .item:last-child{ border-bottom:none; }
    .order-confirmation .item-image img{ width:72px; height:72px; object-fit:cover; border-radius:8px; }
    .order-confirmation .item-details h4{ font-size:16px; margin:0 0 4px; }
    .order-confirmation .item-meta{ color:#6b7280; font-size:13px; display:flex; gap:10px; flex-wrap:wrap; }
    .order-confirmation .item-price{ margin-top:6px; font-weight:600; }
    .order-confirmation .action-area .btn{ width:100%; display:flex; align-items:center; justify-content:center; gap:8px; }
    .order-confirmation .thank-you-message h1{ font-size:28px; margin-bottom:8px; }
    .order-confirmation .thank-you-message p{ color:#6b7280; margin-bottom:0; }
    .order-confirmation .sidebar .sidebar-content{ padding:20px; border:1px solid #eee; border-radius:12px; }
    .page-title.light-background{ background:#f7f7f9; padding:18px 0; }
    .sitename{ font-weight:800; }
  </style>
</head>

<body class="order-confirmation-page">
  <!-- 상단 헤더 (템플릿 그대로 사용 가능) -->
  <header id="header" class="header sticky-top">
    <div class="main-header">
      <div class="container-fluid container-xl">
        <div class="d-flex py-3 align-items-center justify-content-between">
          <a href="${pageContext.request.contextPath}/" class="logo d-flex align-items-center">
            <h1 class="sitename">NiceShop</h1>
          </a>
          <div class="header-actions d-flex align-items-center justify-content-end">
            <a href="${vReturnUrl}" class="header-action-btn"><i class="bi bi-cart3"></i></a>
          </div>
        </div>
      </div>
    </div>
    <div class="header-nav">
      <div class="container-fluid container-xl position-relative">
        <nav id="navmenu" class="navmenu">
          <ul>
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li><a href="${pageContext.request.contextPath}/category">Category</a></li>
            <li><a href="${pageContext.request.contextPath}/cart">Cart</a></li>
            <li><a href="${pageContext.request.contextPath}/checkout">Checkout</a></li>
            <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
          </ul>
        </nav>
      </div>
    </div>
  </header>

  <main class="main order-confirmation">
    <!-- 페이지 타이틀 -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">주문 확인</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="${pageContext.request.contextPath}/">Home</a></li>
            <li class="current">Order Confirmation</li>
          </ol>
        </nav>
      </div>
    </div>

    <!-- 주문 확인 섹션 -->
    <section id="order-confirmation" class="section">
      <div class="container" data-aos="fade-up" data-aos-delay="100">
        <div class="order-confirmation-3">
          <div class="row g-0">

            <!-- 왼쪽 사이드바 -->
            <div class="col-lg-4 sidebar" data-aos="fade-right">
              <div class="sidebar-content">
                <div class="success-animation"><i class="bi bi-check-lg"></i></div>
                <div class="order-id">
                  <h4>주문번호 #<c:out value="${vOrderNo}" /></h4>
                  <div class="order-date">
                    <fmt:formatDate value="${vOrderDate}" pattern="yyyy-MM-dd HH:mm" />
                  </div>
                </div>

                <div class="order-progress mt-3">
                  <div class="stepper-container d-flex justify-content-between text-center">
                    <div class="stepper-item completed">
                      <div class="stepper-icon">1</div>
                      <div class="stepper-text">주문완료</div>
                    </div>
                    <div class="stepper-item current">
                      <div class="stepper-icon">2</div>
                      <div class="stepper-text">결제확인</div>
                    </div>
                    <div class="stepper-item">
                      <div class="stepper-icon">3</div>
                      <div class="stepper-text">배송중</div>
                    </div>
                    <div class="stepper-item">
                      <div class="stepper-icon">4</div>
                      <div class="stepper-text">배송완료</div>
                    </div>
                  </div>
                </div>

                <!-- 가격 요약 -->
                <div class="price-summary mt-4">
                  <h5>주문 요약</h5>
                  <ul class="summary-list">
                    <li><span>상품금액(추정)</span><span><fmt:formatNumber value="${estimatedSubtotal}" type="number" /> 원</span></li>
                    <li><span>내 포인트 사용</span><span><fmt:formatNumber value="${vUsedPoint}" type="number" /> P</span></li>
                    <li><span>카카오페이 포인트</span><span><fmt:formatNumber value="${vUsedKakao}" type="number" /> P</span></li>
                    <li><span>배송비</span><span><fmt:formatNumber value="${vShipping}" type="number" /> 원</span></li>
                    <li class="total"><span>총 결제금액</span><span><fmt:formatNumber value="${vReal}" type="number" /> 원</span></li>
                    <li><span>실 결제액(카드/계좌)</span><span><fmt:formatNumber value="${actualPaid}" type="number" /> 원</span></li>
                  </ul>
                </div>

                <!-- 배송 정보 요약 -->
                <div class="delivery-info mt-4">
                  <h5>배송 정보</h5>
                  <p class="delivery-estimate"><i class="bi bi-calendar-check"></i>
                    <span>예상 배송일: 주문 후 2~3영업일</span>
                  </p>
                  <p class="shipping-method"><i class="bi bi-truck"></i>
                    <span>기본 배송</span>
                  </p>
                </div>

                <!-- 고객 지원 -->
                <div class="customer-service mt-4">
                  <h5>도움이 필요하신가요?</h5>
                  <a href="${pageContext.request.contextPath}/support" class="help-link d-block mb-1">
                    <i class="bi bi-chat-dots"></i> <span>문의하기</span>
                  </a>
                  <a href="${pageContext.request.contextPath}/faq" class="help-link d-block">
                    <i class="bi bi-question-circle"></i> <span>자주 묻는 질문</span>
                  </a>
                </div>
              </div>
            </div>

            <!-- 오른쪽 메인 -->
            <div class="col-lg-8 main-content" data-aos="fade-in">
              <!-- 감사 메시지 -->
              <div class="thank-you-message mb-4">
                <h1>결제가 완료되었습니다 🎉</h1>
                <p><strong><c:out value="${vName}" /></strong>님의 주문을 접수했습니다. 주문 진행 상황은 이메일 또는 마이페이지에서 확인하실 수 있습니다.</p>
              </div>

              <!-- 배송 상세 -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3><i class="bi bi-geo-alt"></i> 배송지 정보</h3>
                </div>
                <div class="card-body">
                  <div class="row g-4">
                    <div class="col-md-6">
                      <div class="detail-group">
                        <label>수령인</label>
                        <address class="mb-0">
                          <c:out value="${empty receiverName ? vName : receiverName}" /><br/>
                          <c:if test="${not empty postcode}">(<c:out value="${postcode}" />) </c:if>
                          <c:out value="${empty addr1 ? '주소 미입력' : addr1}" /><br/>
                          <c:out value="${empty addr2 ? '' : addr2}" />
                        </address>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="detail-group">
                        <label>연락처</label>
                        <div class="contact-info">
                          <p class="mb-1"><i class="bi bi-envelope"></i> <c:out value="${empty receiverEmail ? '-' : receiverEmail}" /></p>
                          <p class="mb-0"><i class="bi bi-telephone"></i> <c:out value="${empty receiverPhone ? '-' : receiverPhone}" /></p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>

              <!-- 결제 상세 -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3><i class="bi bi-credit-card"></i> 결제 정보</h3>
                </div>
                <div class="card-body">
                  <div class="payment-method d-flex align-items-center gap-3">
                    <div class="payment-icon"><i class="bi bi-credit-card-2-front" style="font-size:24px;"></i></div>
                    <div class="payment-details">
                      <div class="card-type fw-semibold">KakaoPay</div>
                      <div class="card-number text-muted">카카오페이 포인트 사용: <fmt:formatNumber value="${vUsedKakao}" type="number" /> P</div>
                    </div>
                  </div>
                  <div class="billing-address mt-3">
                    <h5 class="mb-1">결제 요약</h5>
                    <div>내 포인트 사용: <fmt:formatNumber value="${vUsedPoint}" type="number" /> P</div>
                    <div>총 결제금액: <fmt:formatNumber value="${vReal}" type="number" /> 원</div>
                    <div>실 결제액(카드/계좌): <fmt:formatNumber value="${actualPaid}" type="number" /> 원</div>
                  </div>
                </div>
              </div>

              <!-- 주문 상품 -->
              <div class="details-card" data-aos="fade-up">
                <div class="card-header">
                  <h3><i class="bi bi-bag-check"></i> 주문 상품</h3>
                </div>
                <div class="card-body">
                  <c:choose>
                    <c:when test="${not empty orderItems}">
                      <c:forEach var="item" items="${orderItems}">
                        <div class="item">
                          <div class="item-image">
                            <img src="<c:out value='${empty item.imageUrl ? "assets/img/product/product-7.webp" : item.imageUrl}'/>" alt="상품이미지" loading="lazy">
                          </div>
                          <div class="item-details">
                            <h4><c:out value="${empty item.name ? productName : item.name}" /></h4>
                            <div class="item-meta">
                              <c:if test="${not empty item.optionColor}"><span>색상: <c:out value="${item.optionColor}" /></span></c:if>
                              <c:if test="${not empty item.optionSize}"><span>사이즈: <c:out value="${item.optionSize}" /></span></c:if>
                            </div>
                            <div class="item-price">
                              <span class="quantity"><c:out value="${empty item.quantity ? 1 : item.quantity}" /> ×</span>
                              <span class="price"><fmt:formatNumber value="${empty item.price ? 0 : item.price}" type="number" /> 원</span>
                            </div>
                          </div>
                        </div>
                      </c:forEach>
                    </c:when>
                    <c:otherwise>
                      <div class="item">
                        <div class="item-image">
                          <img src="assets/img/product/product-7.webp" alt="상품이미지" loading="lazy">
                        </div>
                        <div class="item-details">
                          <h4><c:out value="${empty productName ? '상품명 미지정' : productName}" /></h4>
                          <div class="item-meta"><span>수량: 1</span></div>
                          <div class="item-price">
                            <span class="quantity">1 ×</span>
                            <span class="price"><fmt:formatNumber value="${estimatedSubtotal}" type="number" /> 원</span>
                          </div>
                        </div>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>

              <!-- 액션 버튼 -->
              <div class="action-area" data-aos="fade-up">
                <div class="row g-3">
                  <div class="col-md-6">
                    <a href="${vReturnUrl}" class="btn btn-outline-secondary btn-back">
                      <i class="bi bi-arrow-left"></i> 쇼핑 계속하기
                    </a>
                  </div>
                  <div class="col-md-6">
                    <a href="${vAccountUrl}" class="btn btn-primary btn-account">
                      <span>마이페이지에서 보기</span> <i class="bi bi-arrow-right"></i>
                    </a>
                  </div>
                </div>
              </div>

              <!-- 추천 상품 (데모) -->
              <div class="recommended mt-4" data-aos="fade-up">
                <h3>이런 상품은 어떠세요?</h3>
                <div class="row g-4">
                  <div class="col-6 col-md-4">
                    <div class="product-card text-center">
                      <div class="product-image">
                        <img src="assets/img/product/product-11.webp" alt="추천상품" loading="lazy">
                      </div>
                      <h5>무선 이어버드</h5>
                      <div class="product-price">59,900 원</div>
                      <a href="#" class="btn btn-sm btn-outline-dark mt-2">
                        <i class="bi bi-plus"></i> 장바구니
                      </a>
                    </div>
                  </div>
                  <div class="col-6 col-md-4">
                    <div class="product-card text-center">
                      <div class="product-image">
                        <img src="assets/img/product/product-10.webp" alt="추천상품" loading="lazy">
                      </div>
                      <h5>휴대용 충전기</h5>
                      <div class="product-price">34,900 원</div>
                      <a href="#" class="btn btn-sm btn-outline-dark mt-2">
                        <i class="bi bi-plus"></i> 장바구니
                      </a>
                    </div>
                  </div>
                  <div class="col-6 col-md-4 d-none d-md-block">
                    <div class="product-card text-center">
                      <div class="product-image">
                        <img src="assets/img/product/product-8.webp" alt="추천상품" loading="lazy">
                      </div>
                      <h5>스마트 워치</h5>
                      <div class="product-price">149,900 원</div>
                      <a href="#" class="btn btn-sm btn-outline-dark mt-2">
                        <i class="bi bi-plus"></i> 장바구니
                      </a>
                    </div>
                  </div>
                </div>
              </div>

            </div><!-- /col-lg-8 -->
          </div><!-- /row -->
        </div><!-- /order-confirmation-3 -->
      </div><!-- /container -->
    </section>
  </main>

  <!-- 푸터(간단 버전) -->
  <footer id="footer" class="footer dark-background mt-5">
    <div class="footer-main py-4">
      <div class="container text-center">
        <p class="mb-0">© <strong class="sitename">NiceShop</strong>. All Rights Reserved.</p>
      </div>
    </div>
  </footer>

  <!-- Scroll Top -->
  <a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center">
    <i class="bi bi-arrow-up-short"></i>
  </a>

  <!-- Preloader -->
  <div id="preloader"></div>

  <!-- Vendor JS Files -->
  <script src="assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
  <script src="assets/vendor/php-email-form/validate.js"></script>
  <script src="assets/vendor/swiper/swiper-bundle.min.js"></script>
  <script src="assets/vendor/aos/aos.js"></script>
  <script src="assets/vendor/glightbox/js/glightbox.min.js"></script>
  <script src="assets/vendor/drift-zoom/Drift.min.js"></script>
  <script src="assets/vendor/purecounter/purecounter_vanilla.js"></script>

  <!-- Main JS File -->
  <script src="assets/js/main.js"></script>
</body>
</html>