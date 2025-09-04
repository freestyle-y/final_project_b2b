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

  <!-- Daum 우편번호 -->
  <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

  <style>
    /* ===== Password Modal styles ===== */
    #pwdModalOverlay{position:fixed;inset:0;background:rgba(0,0,0,.45);display:none;justify-content:center;align-items:center;z-index:1060}
    body.pwd-modal-open{overflow:hidden}
    .pwd-card{position:relative;width:360px;height:600px;background:#fff;border-radius:16px;box-shadow:0 10px 40px rgba(0,0,0,.25);overflow:hidden;display:flex;flex-direction:column}
    .pwd-close{position:absolute;top:10px;right:10px;width:32px;height:32px;display:inline-flex;align-items:center;justify-content:center;border:none;background:transparent;border-radius:50%;font-size:20px;color:#9aa0a6;cursor:pointer}
    .pwd-close:hover{background:rgba(0,0,0,.06);color:#5f6368}
    .pwd-head{padding:18px 20px 8px;text-align:center}
    .pwd-title{margin:0;font-size:18px;font-weight:700;color:#333}
    .pwd-body{padding:8px 20px 16px;text-align:center}
    .pwd-msg{margin:8px 0 14px;font-size:15px;color:#222}
    .pwd-msg .accent{color:#1f6bd0;font-weight:700}
    .pwd-dots{display:flex;gap:12px;justify-content:center;margin-bottom:14px}
    .pwd-dot{width:12px;height:12px;border-radius:50%;border:1px solid #d0d0d0;background:#fff;transition:background .15s}
    .pwd-dot.filled{background:#333}
    .pwd-keypad-wrap{margin-top:10px;background:#2f66c9;flex:1;display:flex;flex-direction:column}
    .pwd-badge{display:inline-flex;align-items:center;gap:6px;padding:6px 10px;margin:12px auto 0;font-size:12px;color:#fff;background:rgba(255,255,255,.15);border-radius:999px}
    .pwd-keypad{display:grid;grid-template-columns:repeat(3,1fr);grid-template-rows:repeat(4,1fr);gap:14px;padding:18px 20px 22px;flex:1}
    .pwd-keypad button{background:transparent;border:none;outline:none;color:#fff;font-weight:800;font-size:22px;cursor:pointer}
    .pwd-keypad button:active{transform:scale(.98)}
    .pwd-keypad .action{font-weight:600;font-size:16px;opacity:.9}
    .pwd-shake{animation:pwdShake .35s ease}
    @keyframes pwdShake{0%,100%{transform:translateX(0)}20%,60%{transform:translateX(-6px)}40%,80%{transform:translateX(6px)}}
  </style>
</head>

<body class="checkout-page">
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

  <section id="checkout" class="checkout section">
    <div class="container" data-aos="fade-up" data-aos-delay="100">
      <div class="row g-4">

        <!-- 왼쪽 -->
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

                    <!-- 계좌이체 안내 -->
                    <div id="bankInfo" class="border rounded p-3 bg-light mb-3" style="display:none;">
                      <p class="mb-0"><i class="bi bi-bank me-1"></i>기업 계좌번호: <strong>기업은행 977-000803-01-011 (예금주: 노민혁)</strong></p>
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
                                  ${card.financialInstitution} - ****-****-****-${fn:substring(card.accountNumber, card.accountNumber.length()-4, card.accountNumber.length())}
                                  (유효기간: ${card.cardExpiration})
                                </label>
                              </div>
                            </c:forEach>
                          </div>
                          <button type="button" class="btn btn-outline-secondary btn-sm" onclick="document.getElementById('newCardForm').style.display='block'">
                            <i class="bi bi-plus-lg me-1"></i>새 카드 등록
                          </button>

                          <div id="newCardForm" class="border rounded p-3 bg-white mt-3" style="display:none;">
                            <div class="row g-2">
                              <div class="col-md-4"><label class="form-label">카드사</label><input type="text" name="financialInstitution" class="form-control"></div>
                              <div class="col-md-8"><label class="form-label">카드번호</label><input type="text" name="accountNumber" class="form-control"></div>
                              <div class="col-md-4"><label class="form-label">유효기간(YYYY-MM)</label><input type="month" name="cardExpiration" class="form-control"></div>
                              <div class="col-md-4"><label class="form-label">CVC</label><input type="text" name="cardCvc" maxlength="4" class="form-control"></div>
                              <div class="col-md-4"><label class="form-label">비밀번호 앞 2자리</label><input type="password" name="cardPassword" maxlength="2" class="form-control"></div>
                              <div class="col-12">
                                <div class="form-check"><input class="form-check-input" type="checkbox" name="isDefault" value="Y" id="isDefault"><label class="form-check-label" for="isDefault">기본 결제수단으로 등록</label></div>
                              </div>
                              <div class="col-12"><button type="button" class="btn btn-primary btn-sm" onclick="addCard()"><i class="bi bi-check2-circle me-1"></i>카드 등록</button></div>
                            </div>
                          </div>
                        </c:when>
                        <c:otherwise>
                          <p class="fw-semibold mb-2">등록된 카드가 없습니다. 새 카드 정보를 입력하세요.</p>
                          <div id="newCardForm" class="border rounded p-3 bg-white">
                            <div class="row g-2">
                              <div class="col-md-4"><label class="form-label">카드사</label><input type="text" name="financialInstitution" class="form-control"></div>
                              <div class="col-md-8"><label class="form-label">카드번호</label><input type="text" name="accountNumber" class="form-control"></div>
                              <div class="col-md-4"><label class="form-label">유효기간(YYYY-MM)</label><input type="month" name="cardExpiration" class="form-control"></div>
                              <div class="col-md-4"><label class="form-label">CVC</label><input type="text" name="cardCvc" maxlength="4" class="form-control"></div>
                              <div class="col-md-4"><label class="form-label">비밀번호 앞 2자리</label><input type="password" name="cardPassword" maxlength="2" class="form-control"></div>
                              <div class="col-12">
                                <div class="form-check"><input class="form-check-input" type="checkbox" name="isDefault" value="Y" id="isDefault2"><label class="form-check-label" for="isDefault2">기본 결제수단으로 등록</label></div>
                              </div>
                            </div>
                          </div>
                        </c:otherwise>
                      </c:choose>
                    </div>
                  </div>
                </div>

                <!-- 결제 금액 -->
                <div class="checkout-section">
                  <div class="section-header d-flex align-items-center mb-3">
                    <div class="section-number me-2">2</div>
                    <h3 class="mb-0">결제 금액</h3>
                  </div>

                  <div class="section-content border rounded p-3 bg-light">
                    <p class="mb-2">
                      상품 총 금액:
                      <c:set var="total" value="0"/>
                      <c:forEach var="order" items="${orderList}">
                        <c:set var="total" value="${total + (order.price * order.orderQuantity)}"/>
                      </c:forEach>
                      <strong><span id="totalAmount">${total}</span> 원</strong>
                    </p>

                    <div class="row g-2 align-items-end mb-2">
                      <div class="col-md-4"><label class="form-label">사용 가능 적립금</label><input type="text" id="availablePoints" value="${reward}" readonly class="form-control"></div>
                      <div class="col-md-4"><label class="form-label">사용할 적립금</label><input type="number" id="usePoints" name="usePoints" min="0" step="100" class="form-control"></div>
                      <div class="col-md-4"><button type="button" id="useAllBtn" class="btn btn-outline-secondary w-100" onclick="useAllPoints()">전액 사용</button></div>
                    </div>

                    <div id="pointError" class="text-danger small mb-2"></div>
                    <div class="text-muted small" id="pointRuleNote">적립금 사용 규칙 · ① 주문금액 10,000원 이상 · ② 최소 1,000원 · ③ 100원 단위 · ④ 주문금액의 10% 이내</div>
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

                    <!-- 모달 트리거 -->
                    <button type="button" class="btn btn-light mt-2" data-bs-toggle="modal" data-bs-target="#addressModal">
                      <i class="bi bi-pencil-square me-1"></i>배송지 변경
                    </button>

                    <!-- 모달 -->
                    <div class="modal fade" id="addressModal" tabindex="-1" aria-labelledby="addressModalLabel" aria-hidden="true">
                      <div class="modal-dialog modal-lg modal-dialog-centered">
                        <div class="modal-content">
                          <div class="modal-header">
                            <h5 id="addressModalLabel" class="modal-title">내 배송지 선택</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
                          </div>

                          <div class="modal-body p-3">
                            <div class="table-responsive" style="max-height:60vh; overflow:auto;">
                              <table class="table table-sm align-middle text-center">
                                <thead class="table-light">
                                  <tr><th>선택</th><th>주소</th><th>상세주소</th><th>우편번호</th><th>별칭</th><th>기본</th></tr>
                                </thead>
<tbody id="addressTbody">
  <c:forEach var="address" items="${addressList}">
    <tr>
      <td>
        <input type="checkbox" name="selectedAddressChk"
          value="${address.addressNo}"
          data-address="${empty address.address ? '' : address.address}"
          data-detail="${empty address.detailAddress ? '' : address.detailAddress}"
          data-nickname="${empty address.nickname ? '' : address.nickname}"
          onclick="handleCheck(this)">
      </td>
      <td>${empty address.address ? '' : address.address}</td>
      <td>${empty address.detailAddress ? '' : address.detailAddress}</td>
      <td>${empty address.postal ? '' : address.postal}</td>
      <td>${empty address.nickname ? '' : address.nickname}</td>
      <td>
        <c:choose>
          <c:when test="${address.mainAddress eq 'Y'}">✔</c:when>
          <c:otherwise>-</c:otherwise>
        </c:choose>
      </td>
    </tr>
  </c:forEach>
</tbody>

                              </table>
                            </div>

                            <hr class="my-3">

                            <!-- 새 배송지 추가 -->
                            <div class="row g-2">
                              <div class="col-12 d-flex gap-2">
                                <input type="text" id="postal" class="form-control" placeholder="우편번호" readonly>
                                <button type="button" class="btn btn-outline-secondary" onclick="execDaumPostcode()">검색</button>
                              </div>
                              <div class="col-12"><input type="text" id="address" class="form-control" placeholder="주소" readonly></div>
                              <div class="col-12"><input type="text" id="detailAddress" class="form-control" placeholder="상세주소"></div>
                              <div class="col-md-6"><input type="text" id="nickname" class="form-control" placeholder="별칭"></div>
                              <div class="col-md-3">
                                <select id="newOwnerType" class="form-select">
                                  <option value="AC001">개인</option><option value="AC002">기업</option>
                                </select>
                              </div>
                              <div class="col-md-3">
                                <select id="newMainAddress" class="form-select">
                                  <option value="N">기본 아님</option><option value="Y">기본</option>
                                </select>
                              </div>
                              <div class="col-12">
                                <button type="button" class="btn btn-primary w-100" onclick="addAddress()">새 배송지 등록</button>
                              </div>
                            </div>
                          </div>

                          <div class="modal-footer">
                            <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">닫기</button>
                            <button type="button" class="btn btn-primary" onclick="applySelectedFromModal()">선택 적용</button>
                          </div>
                        </div>
                      </div>
                    </div>
                    <!-- /모달 -->
                  </div>
                </div>

                <!-- 배송 요청사항 -->
                <div class="checkout-section">
                  <div class="section-header d-flex align-items-center mb-3">
                    <div class="section-number me-2">4</div>
                    <h3 class="mb-0">배송 요청사항</h3>
                  </div>
                  <div class="section-content">
                    <textarea name="deliveryRequest" rows="3" class="form-control" placeholder="예: 부재 시 경비실에 맡겨주세요.">${orderList[0].deliveryRequest}</textarea>
                  </div>
                </div>

                <!-- 액션 -->
                <div class="d-flex gap-2 mt-4">
                  <input type="button" id="payBtn" class="btn btn-primary" value="결제하기" onclick="showPasswordPopup()">
                  <input type="reset" class="btn btn-outline-secondary" value="취소">
                </div>

              </form>
            </div>
          </div>
        </div>

        <!-- 오른쪽 요약 -->
        <div class="col-lg-5">
          <div class="order-summary card shadow-sm" data-aos="fade-left" data-aos-delay="200">
            <div class="order-summary-header card-header d-flex justify-content-between align-items-center">
              <h3 class="mb-0">Order Summary</h3>
              <span class="item-count"><c:out value="${fn:length(orderList)}"/> Items</span>
            </div>

            <div class="order-summary-content card-body">
              <div class="order-items vstack gap-3 mb-3">
                <c:forEach var="order" items="${orderList}">
                  <div class="order-item d-flex gap-3">
                    <div class="order-item-image" style="width:64px;height:64px;flex:0 0 64px;">
                      <c:set var="imgPath" value="${order.imagePath}"/>
                      <c:if test="${not empty imgPath}">
                        <c:set var="imgPath" value="${fn:replace(imgPath, ' ', '%20')}"/>
                      </c:if>
                      <c:choose>
                        <c:when test="${not empty imgPath and (fn:startsWith(imgPath,'http://') or fn:startsWith(imgPath,'https://'))}">
                          <img src="${imgPath}" alt="${order.productName}" class="img-fluid rounded" style="width:64px;height:64px;object-fit:cover;"/>
                        </c:when>
                        <c:when test="${not empty imgPath}">
                          <img src="${pageContext.request.contextPath}${imgPath}" alt="${order.productName}" class="img-fluid rounded" style="width:64px;height:64px;object-fit:cover;"/>
                        </c:when>
                        <c:otherwise>
                          <img src="${pageContext.request.contextPath}/assets/img/product/product-1.webp" alt="No image" class="img-fluid rounded" style="width:64px;height:64px;object-fit:cover;"/>
                        </c:otherwise>
                      </c:choose>
                    </div>
                    <div class="order-item-details flex-grow-1">
                      <h4 class="h6 mb-1">${order.productName}</h4>
                      <p class="order-item-variant text-muted small mb-1">옵션: ${order.optionName}:${order.optionNameValue}</p>
                      <div class="order-item-price d-flex justify-content-between">
                        <span class="quantity text-muted">${order.orderQuantity} ×</span>
                        <span class="price fw-semibold">${order.price}원</span>
                      </div>
                    </div>
                  </div>
                </c:forEach>
              </div>

              <div class="order-totals vstack gap-2 border-top pt-3">
                <div class="d-flex justify-content-between"><span>상품 총 금액</span><span id="summaryTotal"><strong>${total}</strong> 원</span></div>
                <div class="d-flex justify-content-between"><span>적립금</span><span id="summaryPoints"><strong><fmt:formatNumber value="${total/100}" type="number"/></strong> 원</span></div>
                <div class="d-flex justify-content-between"><span>예상 결제 금액</span><span><strong><span id="summaryFinal">${total}</span></strong> 원</span></div>
              </div>

              <div class="secure-checkout border-top mt-3 pt-3 d-flex justify-content-between align-items-center">
                <div class="secure-checkout-header d-flex align-items-center gap-2"><i class="bi bi-shield-lock"></i><span>Secure Checkout</span></div>
                <div class="payment-icons d-flex gap-2 fs-5"><i class="bi bi-credit-card-2-front"></i><i class="bi bi-paypal"></i><i class="bi bi-apple"></i></div>
              </div>
            </div>
          </div>
        </div>

      </div><!-- row -->
    </div><!-- container -->
  </section>
</main>

<!-- ===== Password Modal (inline) ===== -->
<div id="pwdModalOverlay" aria-hidden="true">
  <div class="pwd-card" role="dialog" aria-modal="true">
    <button type="button" class="pwd-close" id="pwdCloseBtn" aria-label="닫기" title="닫기">×</button>
    <div class="pwd-head"><h3 class="pwd-title" id="pwdTitle">비밀번호 입력</h3></div>
    <div class="pwd-body">
      <div class="pwd-msg" id="pwdMsg"><span class="accent">현재</span> 비밀번호를 입력해주세요.</div>
      <div class="pwd-dots" id="pwdDots">
        <div class="pwd-dot" id="pwdDot1"></div><div class="pwd-dot" id="pwdDot2"></div>
        <div class="pwd-dot" id="pwdDot3"></div><div class="pwd-dot" id="pwdDot4"></div>
      </div>
    </div>
    <div class="pwd-keypad-wrap">
      <div class="pwd-badge">보안키패드 작동 중</div>
      <div class="pwd-keypad" id="pwdKeypad"><!-- JS 생성 --></div>
    </div>
  </div>
</div>
<!-- /Password Modal -->

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- Libs -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/php-email-form/validate.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/swiper/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/aos/aos.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/drift-zoom/Drift.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/vendor/purecounter/purecounter_vanilla.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js"></script>

<script>
  /* ---------- 우편번호 ---------- */
  function execDaumPostcode(){
    new daum.Postcode({
      oncomplete: function(data){
        document.getElementById("postal").value = data.zonecode;
        document.getElementById("address").value = data.roadAddress || data.jibunAddress;
        document.getElementById("detailAddress").focus();
      }
    }).open();
  }

  /* ---------- 주소 테이블 렌더 및 새로고침 ---------- */
  function handleCheck(chk){
    document.querySelectorAll("input[name='selectedAddressChk']").forEach(cb=>{ if(cb!==chk) cb.checked=false; });
  }

  function renderAddressRows(list){
	  const tbody = document.getElementById("addressTbody");
	  let html = "";
	  list.forEach(a=>{
	    html +=
	      '<tr>'
	    +   '<td><input type="checkbox" name="selectedAddressChk"'
	    +   ' value="' + a.addressNo + '"'
	    +   ' data-address="' + (a.address || '') + '"'
	    +   ' data-detail="' + (a.detailAddress || '') + '"'
	    +   ' data-nickname="' + (a.nickname || '') + '"'
	    +   ' onclick="handleCheck(this)"></td>'
	    +   '<td>' + (a.address || '') + '</td>'
	    +   '<td>' + (a.detailAddress || '') + '</td>'
	    +   '<td>' + (a.postal || '') + '</td>'
	    +   '<td>' + (a.nickname || '') + '</td>'
	    +   '<td>' + (a.mainAddress === 'Y' ? '✔' : '-') + '</td>'
	    + '</tr>';
	  });
	  tbody.innerHTML = html;
	}


  function refreshAddressTable(){
    fetch("/api/address/list")
      .then(res => res.json())
      .then(renderAddressRows)
      .catch(()=> alert("배송지 목록을 불러오지 못했습니다."));
  }

  /* ---------- 새 배송지 등록 ---------- */
  function addAddress(){
    const data = {
      address: document.getElementById("address").value,
      detailAddress: document.getElementById("detailAddress").value,
      postal: document.getElementById("postal").value,
      nickname: document.getElementById("nickname").value,
      ownerType: document.getElementById("newOwnerType").value,
      mainAddress: document.getElementById("newMainAddress").value,
      useStatus: "Y"
    };
    if(!data.postal || !data.address){
      alert("주소 검색 후 등록하세요."); return;
    }
    fetch("/api/address/add", {
      method:"POST",
      headers:{ "Content-Type":"application/json" },
      body: JSON.stringify(data)
    })
    .then(res=>res.json())
    .then(res=>{
      if(res.status === "success"){
        // 입력 폼 초기화 & 목록 갱신
        ["postal","address","detailAddress","nickname"].forEach(id => document.getElementById(id).value="");
        document.getElementById("newOwnerType").value = "AC001";
        document.getElementById("newMainAddress").value = "N";
        refreshAddressTable();
        alert("새 배송지가 등록되었습니다.");
      }else{
        alert("등록 실패"); 
      }
    })
    .catch(()=> alert("배송지 등록 중 오류가 발생했습니다."));
  }

  /* ---------- 선택 적용 ---------- */
  function applySelectedFromModal(){
    const selected = document.querySelector("input[name='selectedAddressChk']:checked");
    if(!selected){ alert("배송지를 선택하세요."); return; }
    const id    = selected.value;
    const addr  = selected.dataset.address;
    const detail= selected.dataset.detail;
    const nick  = selected.dataset.nickname;

    document.querySelector("#selectedAddress").innerText = addr + " " + detail;
    document.querySelector("#selectedAddressNickname").innerText = nick;
    document.querySelector("#selectedAddressId").value = id;

    const modalEl = document.getElementById("addressModal");
    const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
    modal.hide();
    
    document.body.classList.remove("modal-open");
    document.querySelectorAll(".modal-backdrop").forEach(el => el.remove());
  }

  /* ---------- 적립금 계산/결제 로직 (기존 유지) ---------- */
  function getPointRuleError(usePoint, total, available){
    if(!usePoint || usePoint <= 0) return "";
    if(total < 10000) return "물품 가격이 10,000원 이상이어야 적립금을 사용할 수 있습니다.";
    if(usePoint < 1000) return "적립금은 최소 1,000원 이상 사용 가능합니다.";
    if(usePoint % 100 !== 0) return "적립금은 100원 단위로만 사용 가능합니다.";
    const maxPoint = Math.floor((total * 0.1) / 100) * 100;
    if(usePoint > maxPoint) return `적립금은 구매 가격의 10%(${maxPoint}원)를 넘을 수 없습니다.`;
    if(usePoint > available) return "보유 적립금을 초과했습니다.";
    return "";
  }
  function updateFinalAmount(){
    const total = parseInt(document.getElementById("totalAmount").innerText);
    const available = parseInt(document.getElementById("availablePoints").value);
    let usePoint = parseInt(document.getElementById("usePoints").value || 0);
    if(usePoint < 0) usePoint = 0;
    const err = getPointRuleError(usePoint, total, available);
    const errorDiv = document.getElementById("pointError");
    const payBtn = document.getElementById("payBtn");
    if(err){
      errorDiv.textContent = err;
      document.getElementById("finalAmount").innerText = total;
      document.getElementById("summaryFinal").innerText = total;
      payBtn.disabled = true;
    }else{
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
  function refreshPointControls(){
    const total = parseInt(document.getElementById("totalAmount").innerText);
    const available = parseInt(document.getElementById("availablePoints").value);
    const maxByRate = Math.floor((total * 0.1) / 100) * 100;
    const maxUsable = Math.min(available, maxByRate);
    const eligible = (total >= 10000) && (maxUsable >= 1000);
    document.getElementById("usePoints").disabled = !eligible;
    document.getElementById("useAllBtn").disabled = !eligible;
  }
  function useAllPoints(){
    const total = parseInt(document.getElementById("totalAmount").innerText);
    const available = parseInt(document.getElementById("availablePoints").value);
    if(total < 10000){
      document.getElementById("usePoints").value = 0; updateFinalAmount(); return;
    }
    const cap = Math.floor((total * 0.1) / 100) * 100;
    let usePoint = Math.min(available, cap);
    usePoint = Math.floor(usePoint / 100) * 100;
    if(usePoint < 1000){ document.getElementById("usePoints").value = 0; updateFinalAmount(); return; }
    document.getElementById("usePoints").value = usePoint; updateFinalAmount();
  }

  /* ---------- 비밀번호 모달 ---------- */
  let pwdMode="input", pwdValue="";
  function openPasswordModal(mode){ pwdMode=mode||"input"; pwdValue=""; updatePwdDots(0); renderPwdTexts(); buildPwdKeypad(); document.getElementById("pwdModalOverlay").style.display="flex"; document.body.classList.add("pwd-modal-open"); }
  function closePasswordModal(){ document.getElementById("pwdModalOverlay").style.display="none"; document.body.classList.remove("pwd-modal-open"); }
  (function bindPwd(){
    const ov=document.getElementById("pwdModalOverlay");
    ov.addEventListener("click",(e)=>{ if(e.target===ov) closePasswordModal(); });
    document.getElementById("pwdCloseBtn").addEventListener("click", closePasswordModal);
    document.addEventListener("keydown",(e)=>{ if(e.key==="Escape" && ov.style.display==="flex") closePasswordModal(); });
  })();
  function renderPwdTexts(){
    const title=document.getElementById("pwdTitle"), msg=document.getElementById("pwdMsg");
    if(pwdMode==="input"){ title.textContent="비밀번호 입력"; msg.innerHTML='<span class="accent">현재</span> 비밀번호를 입력해주세요.'; }
    else{ title.textContent="간편 비밀번호 등록"; msg.textContent="새로운 4자리 비밀번호를 설정해주세요."; }
  }
  function buildPwdKeypad(){
    const nums=[...Array(10).keys()].sort(()=>Math.random()-0.5), pad=document.getElementById("pwdKeypad");
    pad.innerHTML="";
    for(let i=0;i<9;i++){ const b=document.createElement("button"); b.textContent=nums[i]; b.onclick=()=>addPwdDigit(nums[i]); pad.appendChild(b); }
    const clearBtn=document.createElement("button"); clearBtn.textContent="전체삭제"; clearBtn.className="action"; clearBtn.onclick=clearPwd; pad.appendChild(clearBtn);
    const centerBtn=document.createElement("button"); centerBtn.textContent=nums[9]; centerBtn.onclick=()=>addPwdDigit(nums[9]); pad.appendChild(centerBtn);
    const delBtn=document.createElement("button"); delBtn.className="action"; delBtn.setAttribute("aria-label","지우기"); delBtn.setAttribute("title","지우기");
    delBtn.innerHTML=`<svg width="22" height="18" viewBox="0 0 22 18" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
      <path d="M8 1L2 9L8 17H18C19.657 17 21 15.657 21 14V4C21 2.343 19.657 1 18 1H8Z" fill="none" stroke="white" stroke-width="2" />
      <path d="M12 6L16 10M16 6L12 10" stroke="white" stroke-width="2" stroke-linecap="round"/></svg>`;
    delBtn.onclick=removePwdDigit; pad.appendChild(delBtn);
  }
  function addPwdDigit(n){ if(pwdValue.length>=4) return; pwdValue+=String(n); updatePwdDots(pwdValue.length); if(pwdValue.length===4) submitPwd(); }
  function removePwdDigit(){ if(!pwdValue.length) return; pwdValue=pwdValue.slice(0,-1); updatePwdDots(pwdValue.length); }
  function clearPwd(){ pwdValue=""; updatePwdDots(0); }
  function updatePwdDots(len){ for(let i=1;i<=4;i++){ document.getElementById("pwdDot"+i).classList.toggle("filled", i<=len); } }
  function shakeDots(){ const d=document.getElementById("pwdDots"); d.classList.add("pwd-shake"); setTimeout(()=>d.classList.remove("pwd-shake"),350); }
  function submitPwd(){
    const userId="${orderList[0].userId}";
    if(pwdMode==="input"){
      $.ajax({ type:"POST", url:"/personal/payment/validate-password", data:{ userId, pw: pwdValue }, dataType:"json",
        success:function(valid){ if(valid){ closePasswordModal(); completePayment(); } else { shakeDots(); clearPwd(); alert("비밀번호가 일치하지 않습니다."); } },
        error:function(){ shakeDots(); clearPwd(); alert("비밀번호 검증 실패"); }
      });
    }else{
      $.ajax({ type:"POST", url:"/personal/payment/registerSimplePassword",
        data: JSON.stringify({ userId, password: pwdValue }), contentType:"application/json",
        success:function(){ alert("비밀번호가 등록되었습니다. 등록한 비밀번호를 입력해주세요."); pwdMode="input"; renderPwdTexts(); clearPwd(); },
        error:function(){ shakeDots(); clearPwd(); alert("비밀번호 등록 실패"); }
      });
    }
  }

  /* ---------- 결제 버튼 동작 (기존 유지) ---------- */
  function updateDeliveryRequest(){
    const orderNo="${orderList[0].orderNo}";
    const deliveryRequest=document.querySelector("textarea[name='deliveryRequest']").value.trim();
    return $.ajax({ type:"POST", url:"/personal/payment/deliveryRequest", data: JSON.stringify({ orderNo, deliveryRequest }), contentType:"application/json" });
  }
  function showPasswordPopup(){
    const method=document.querySelector("input[name='paymentMethod']:checked").value;
    const addressNo=parseInt(document.getElementById("selectedAddressId").value);

    if(method==="bank"){
      updateDeliveryRequest().done(function(){
        const total=parseInt(document.getElementById("totalAmount").innerText);
        const available=parseInt(document.getElementById("availablePoints").value);
        let usePoint=parseInt(document.getElementById("usePoints").value || 0);
        const err=getPointRuleError(usePoint,total,available); if(err){ alert(err); return; }
        const maxPoint=Math.floor((total*0.1)/100)*100;
        usePoint=Math.max(0,Math.min(usePoint,available,maxPoint));
        usePoint=Math.floor(usePoint/100)*100;

        $.ajax({ type:"POST", url:"/personal/payment/saveMethodAndPoints", contentType:"application/json", dataType:"json",
          data: JSON.stringify({ orderNo:"${orderList[0].orderNo}", paymentMethod:"bank", usePoint, addressNo }),
          success:function(res){ location.href=(res && res.redirectUrl) ? res.redirectUrl : "/personal/orderList"; },
          error:function(xhr){ const msg=(xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : "결제수단/적립금 저장 실패"; alert(msg); if(msg.includes("재고 부족")) location.href="/personal/mainPage"; }
        });
      }).fail(function(){ alert("배송요청 저장 실패"); });
      return;
    }

    const userId="${orderList[0].userId}";
    $.ajax({ type:"GET", url:"/personal/payment/simplePassword", data:{ userId }, dataType:"json",
      success:function(hasPassword){ openPasswordModal(hasPassword ? "input" : "register"); },
      error:function(){ alert("비밀번호 등록 유무 확인 중 오류 발생"); }
    });
  }

  function completePayment(){
    updateDeliveryRequest().done(function(){
      const method=document.querySelector("input[name='paymentMethod']:checked").value;
      const total=parseInt(document.getElementById("totalAmount").innerText);
      const available=parseInt(document.getElementById("availablePoints").value);
      const addressNo=parseInt(document.getElementById("selectedAddressId").value);
      let usePoint=parseInt(document.getElementById("usePoints").value || 0);
      const err=getPointRuleError(usePoint,total,available); if(err){ alert(err); return; }
      const maxPoint=Math.floor((total*0.1)/100)*100;
      usePoint=Math.max(0,Math.min(usePoint,available,maxPoint));
      usePoint=Math.floor(usePoint/100)*100;

      const data={ orderNo:"${orderList[0].orderNo}", name:"${orderList[0].productName}", totalPrice:Math.max(0,total-usePoint), usePoint, userId:"${orderList[0].userId}", paymentMethod:method, addressNo };

      if(method==="card"){
        const selected=document.querySelector("input[name='cardNo']:checked");
        if(!selected){ alert("사용할 카드를 선택하세요."); return; }
        data.cardMethodNo=parseInt(selected.value,10);
      }

      if(method==="card"){
        $.ajax({ type:"POST", url:"/personal/payment/saveMethodAndPoints", contentType:"application/json", dataType:"json", data: JSON.stringify(data),
          success:function(res){ location.href=(res && res.redirectUrl) ? res.redirectUrl : "/personal/orderList"; },
          error:function(xhr){ const msg=(xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : "결제수단/적립금 저장 실패"; alert(msg); if(msg.includes("재고 부족")) location.href="/personal/mainPage"; }
        });
        return;
      }

      if(method==="kakaopay"){
        const payWin=window.open("", "kakaoPayPopup", "width=520,height=720");
        if(!payWin || payWin.closed){ alert("팝업이 차단되었습니다. 브라우저 팝업 허용을 켜주세요."); return; }
        $.ajax({ type:"POST", url:"/personal/payment/saveMethodAndPoints", contentType:"application/json", data: JSON.stringify(data),
          success:function(){
            $.ajax({ type:"POST", url:"/personal/payment/ready", contentType:"application/json", data: JSON.stringify({ orderNo:data.orderNo, name:data.name, totalPrice:data.totalPrice }),
              success:function(resp){ const redirectUrl=resp.next_redirect_pc_url||resp.next_redirect_mobile_url||resp.next_redirect_app_url; if(redirectUrl) payWin.location.replace(redirectUrl); else{ payWin.close(); alert("카카오페이 결제 요청 실패"); } },
              error:function(xhr){ payWin.close(); alert((xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : "카카오페이 결제 중 오류 발생"); }
            });
          },
          error:function(xhr){ payWin.close(); const msg=(xhr.responseJSON && xhr.responseJSON.message) ? xhr.responseJSON.message : "결제수단/적립금 저장 실패"; alert(msg); if(msg.includes("재고 부족")) location.href="/personal/mainPage"; }
        });
        return;
      }
    }).fail(function(){ alert("배송요청 저장 실패"); });
  }

  /* ---------- 초기화 ---------- */
  window.onload = function(){
    // 결제수단 토글
    document.querySelectorAll("input[name='paymentMethod']").forEach(radio=>{
      radio.addEventListener("change", function(){
        document.getElementById("bankInfo").style.display = (this.value === "bank") ? "block" : "none";
        document.getElementById("cardInfo").style.display = (this.value === "card") ? "block" : "none";
      });
    });

    document.getElementById("usePoints").addEventListener("input", updateFinalAmount);

    updateFinalAmount();
    refreshPointControls();

    const total=document.getElementById("totalAmount").innerText;
    document.getElementById("summaryTotal").querySelector("strong").innerText = total;

    // 모달 열릴 때마다 최신 목록 fetch (서버값 변경 시 대비)
    const addressModal = document.getElementById('addressModal');
    addressModal.addEventListener('shown.bs.modal', refreshAddressTable);
  };

  /* header dropdown fix (원래 코드 유지) */
  (function ensureBtnType(){
    const sel = [
      'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
      '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
      'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]',
      '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
    ].join(',');
    document.querySelectorAll(sel).forEach(btn => { if(!btn.hasAttribute('type')) btn.setAttribute('type','button'); });
  })();
  (function forceDropdownToggle(){
    const getBtns = () => Array.from(document.querySelectorAll(
      'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
      '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
      'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"],' +
      '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
    ));
    function inside(rect,x,y){ return x>=rect.left && x<=rect.right && y>=rect.top && y<=rect.bottom; }
    document.addEventListener('click', function(ev){
      const x=ev.clientX, y=ev.clientY;
      const btn=getBtns().find(b=>inside(b.getBoundingClientRect(),x,y));
      if(!btn) return; ev.preventDefault();
      try{ bootstrap.Dropdown.getOrCreateInstance(btn).toggle(); }
      catch(e){ setTimeout(()=> bootstrap.Dropdown.getOrCreateInstance(btn).toggle(), 0); }
    }, true);
  })();
</script>
</body>
</html>