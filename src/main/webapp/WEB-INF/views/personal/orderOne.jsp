<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>  <!-- ✅ [추가] 숫자 포맷용 -->

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <%@ include file="/WEB-INF/common/head.jsp"%>
  <title>주문 상세</title> <!-- ✅ [수정] 페이지 타이틀 한글화/간결화 -->
  <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

  <!-- ✅ [추가] Pretendard Variable 폰트 적용 -->
  <link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
  <link rel="stylesheet"
        href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/variable/pretendardvariable.css"
        crossorigin>

  <style>
  /* ===== 테이블 톤(잔금 확인 페이지 느낌) ===== */
  :root{
    --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0;
    --brand-500:#6366f1; --brand-600:#4f46e5;
    --ink-900:#0f172a; --ink-700:#334155; --ink-500:#64748b; --ink-300:#cbd5e1;
    --bg-50:#f8fafc; --bg-100:#f1f5f9;
    --radius-xl:16px; --radius-lg:12px; --radius-md:10px;
    --shadow-sm:0 1px 2px rgba(0,0,0,.06); --shadow-md:0 6px 18px rgba(15,23,42,.08);
  }

  /* ✅ [수정] 폰트: Pretendard Variable 우선 */
  body{
    font-family: "Pretendard Variable","Pretendard","Noto Sans KR","Apple SD Gothic Neo",
                 -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Malgun Gothic",Arial,sans-serif;
  }
  .table-wrap{ max-width:1200px; margin:0 auto; }

  .main{ background:#fff; padding:24px; }
  .main > h1{ font-size:26px; font-weight:700; color:var(--ink-900); margin:0 0 18px; letter-spacing:-.2px; }

  /* ===== 공통 테이블(카드형) ===== */
  .main table{
    width:100%;
    background:#fff;
    border:1px solid var(--tbl-border) !important;
    border-radius:10px;
    border-collapse:collapse !important;
    box-shadow:var(--shadow-md);
    overflow:hidden;
    margin-bottom:20px !important;
    font-size:.95rem;
  }

  /* 헤더 */
  .main table thead th,
  .main table tr th[colspan]{
    background:var(--tbl-head) !important;
    color:#111827; font-weight:700;
    border-bottom:1px solid var(--tbl-border) !important;
    padding:12px 14px; white-space:nowrap; text-align:center; vertical-align:middle;
  }

  /* 바디 셀 */
  .main table tbody td{
    border-bottom:1px solid var(--tbl-border) !important;
    color:#111827; vertical-align:middle;
    padding:12px 14px; text-align:left;
    word-break:keep-all; overflow-wrap:anywhere;
  }
  .main table tbody tr:last-child td{ border-bottom:none !important; }
  .main table tbody tr:nth-child(even){ background:var(--tbl-zebra); }
  .main table tbody tr:hover{ background:var(--tbl-hover); }

  /* 첫 번째(요약) 테이블: 좌측 라벨 폭 */
  .main > table:first-of-type td:first-child{ width:180px; color:var(--ink-500); white-space:nowrap; }

  /* ✅ [수정] 두 번째(상세) 테이블 정렬: 현재 컬럼 구조(옵션=2, 수량=3, 가격=4)에 맞춤 */
  .main table + table td:nth-child(3){ text-align:center; }                 /* 수량 */
  .main table + table td:nth-child(4){ text-align:right; white-space:nowrap; } /* 가격 */
  .main table + table td:nth-child(5){ text-align:center; }
  .main table + table td:nth-child(6){ text-align:center; }

  /* 금액 강조 */
  .main table td.amount{ font-weight:700; color:var(--ink-900); }

  /* ===== 셀 클래스 기반(안전) ===== */
  .td-status, .td-order{ white-space:nowrap; min-width:120px; }
  .td-status .chip, .td-order .chip{ display:inline-flex; align-items:center; gap:8px; }
  .td-status .chip::before, .td-order .chip::before{
    content:""; width:6px; height:6px; border-radius:50%; background:#9ca3af; flex:0 0 6px;
  }

  .td-actions{
    display:flex; align-items:center; gap:8px;
    flex-wrap:wrap; justify-content:flex-start;
  }
  .td-actions .note{ font-size:12px; color:#94a3b8; white-space:nowrap; align-self:center; }

  /* 버튼 블랙 톤 */
  .main table button{
    appearance:none; border:1px solid #111827;
    background:#111827; color:#fff;
    padding:8px 12px; border-radius:10px;
    cursor:pointer; transition:transform .16s ease, box-shadow .16s ease, filter .16s ease;
    box-shadow:var(--shadow-sm);
  }
  .main table button:hover{ transform:translateY(-1px); box-shadow:var(--shadow-md); filter:brightness(1.05); }
  .main table button:active{ transform:translateY(0); box-shadow:var(--shadow-sm); }
  .main table button[disabled],
  .main table button[disabled]:hover{
    background:#eef2f7; border-color:#e5e7eb; color:#94a3b8; cursor:not-allowed; transform:none; box-shadow:var(--shadow-sm);
  }
  .main table .btn-confirm{ background:#111827; border-color:#111827; color:#fff; font-weight:700; }

  @media (max-width: 992px){
    .main{ padding:16px; }
    .main > h1{ font-size:22px; }
    .main table{ display:block; overflow-x:auto; -webkit-overflow-scrolling:touch; }
    .main > table:first-of-type td:first-child{ width:140px; }
  }
  </style>
</head>

<body>
  <%@include file="/WEB-INF/common/header/header.jsp"%>

  <main class="main table-wrap">
    <h1>주문 상세</h1> <!-- ✅ [수정] 헤더 텍스트 -->

    <!-- 받는 사람/결제 정보 -->
    <table style="text-align:left; width:100%; margin-bottom:20px;">
      <tbody>
        <tr><th colspan="2">받는 사람 정보</th></tr>
        <tr><td>받는 사람</td><td>${orderDetailList[0].name}</td></tr>
        <tr><td>연락처</td><td>${orderDetailList[0].phone}</td></tr>
        <tr><td>받는 주소</td><td>${orderDetailList[0].address} ${orderDetailList[0].detailAddress}</td></tr>
        <tr><td>배송 요청사항</td><td>${orderDetailList[0].deliveryRequest}</td></tr>
        <tr><th colspan="2">결제 정보</th></tr>
<tr><td>결제 수단</td><td>${orderDetailList[0].paymentType}</td></tr>

<!-- ✅ 추가: 상품합계 -->
<tr><td>상품 합계</td>
    <td><fmt:formatNumber value="${subtotal}" type="number"/>원</td></tr>

<!-- 기존: 적립금 사용 -->
<tr><td>적립금 사용</td>
    <td><fmt:formatNumber value="${usedPoint}" type="number"/>원</td></tr>

<!-- ✅ 추가: 카카오페이 포인트 사용 -->
<c:if test="${usedKakaoPoint > 0}">
  <tr>
    <td>카카오페이 포인트 사용</td>
    <td><fmt:formatNumber value="${usedKakaoPoint}" type="number"/>원</td>
  </tr>
</c:if>

<!-- ✅ 수정: 총 결제금액 = subtotal - usedPoint - usedKakaoPoint -->
<tr><td>총 결제금액</td>
    <td><strong><fmt:formatNumber value="${finalPay}" type="number"/></strong>원</td></tr>
      </tbody>
    </table>

    <!-- 주문 상세 목록 -->
    <table style="text-align:center; width:100%;">
      <thead>
        <tr>
          <th>상품명</th>
          <th>옵션</th>
          <th>수량</th>
          <th>가격</th>
          <th>배송상태</th>
          <th>구매상태</th>
          <th></th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="order" items="${orderDetailList}">
          <tr>
            <td style="text-align:left;">${order.productName}</td>
            <td>${order.optionName} ${order.optionNameValue}</td>
            <td>${order.orderQuantity}</td>
            <td style="text-align:right;"><fmt:formatNumber value="${order.price}" type="number"/>원</td> <!-- ✅ [수정] 콤마/원 -->

            <!-- 배송상태 -->
            <td class="td-status">
              <span class="chip">
                <c:choose>
                  <c:when test="${order.deliveryStatus == 'DS010'}">반품중</c:when>
                  <c:when test="${order.deliveryStatus == 'DS008'}">교환완료</c:when>
                  <c:when test="${order.deliveryStatus == 'DS007'}">교환중</c:when>
                  <c:when test="${order.deliveryStatus == 'DS006'}">교환대기</c:when>
                  <c:when test="${order.deliveryStatus == 'DS005'}">반품완료</c:when>
                  <c:when test="${order.deliveryStatus == 'DS004'}">반품대기</c:when>
                  <c:when test="${order.deliveryStatus == 'DS003'}">배송완료</c:when>
                  <c:when test="${order.deliveryStatus == 'DS002'}">배송중</c:when>
                  <c:when test="${order.deliveryStatus == 'DS001'}">배송대기</c:when>
                </c:choose>
              </span>
            </td>

            <!-- 구매상태 -->
            <td class="td-order">
              <span class="chip">
                <c:choose>
                  <c:when test="${order.orderStatus == 'OS001'}">결제대기</c:when>
                  <c:when test="${order.orderStatus == 'OS002'}">결제완료</c:when>
                  <c:when test="${order.orderStatus == 'OS003'}">구매확정</c:when>
                </c:choose>
              </span>
            </td>

            <!-- 처리(액션) -->
            <td class="td-actions">
              <button onclick="location.href='/personal/deliveryOne?orderNo=${order.orderNo}&subOrderNo=${order.subOrderNo}'">배송조회</button>

              <c:choose>
                <c:when test="${order.deliveryStatus eq 'DS003' && order.orderStatus ne 'OS003'}">
                  <button onclick="location.href='/personal/exchangeReturn?orderNo=${order.orderNo}&subOrderNo=${order.subOrderNo}&orderQuantity=${order.orderQuantity}'">교환/반품</button>
                </c:when>
                <c:otherwise>
                  <button disabled>교환/반품</button>
                </c:otherwise>
              </c:choose>

              <c:choose>
                <c:when test="${order.orderStatus == 'OS003'}">
                  <button
                    type="button"
                    class="btn-review"
                    data-bs-toggle="offcanvas"
                    data-bs-target="#reviewDrawer"
                    data-order-no="${order.orderNo}"
                    data-sub-order-no="${order.subOrderNo}">
                    리뷰 작성
                  </button>
                </c:when>
                <c:otherwise>
                  <button disabled title="구매확정 후 작성 가능합니다.">리뷰 작성</button>
                </c:otherwise>
              </c:choose>

              <button onclick="location.href='/member/QNAWrite'">상품 문의</button>
              <c:choose>
				  <c:when test="${order.orderStatus == 'OS003'}">
				    <button type="button" class="btn-confirm" disabled>확정 완료</button>
				  </c:when>
				
				  <c:otherwise>
				    <button type="button" class="btn-confirm"
				            onclick="confirmProduct('${order.orderNo}', '${order.subOrderNo}', this)">
				      구매 확정
				    </button>
				    <span class="note">(1% 적립 예정)</span>
				  </c:otherwise>
				</c:choose>

            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </main>

  <!-- Offcanvas (테이블 밖) -->
  <div class="offcanvas offcanvas-end" tabindex="-1" id="reviewDrawer" aria-labelledby="reviewDrawerLabel">
    <div class="offcanvas-header">
      <h5 class="offcanvas-title" id="reviewDrawerLabel">리뷰 작성</h5>
      <button type="button" class="btn-close" data-bs-dismiss="offcanvas" aria-label="닫기"></button>
    </div>
    <div class="offcanvas-body">
      <form method="post" action="/personal/addReview" id="reviewForm">
        <input type="hidden" name="orderNo" id="reviewOrderNo" value="">
        <input type="hidden" name="subOrderNo" id="reviewSubOrderNo" value="">

        <div class="mb-3">
          <label for="reviewGrade" class="form-label fw-bold">별점</label>
          <select name="grade" id="reviewGrade" class="form-select">
            <option value="5.0">★★★★★ (5.0)</option>
            <option value="4.5">★★★★☆ (4.5)</option>
            <option value="4.0">★★★★ (4.0)</option>
            <option value="3.5">★★★☆ (3.5)</option>
            <option value="3.0">★★★ (3.0)</option>
            <option value="2.5">★★☆ (2.5)</option>
            <option value="2.0">★★ (2.0)</option>
            <option value="1.5">★☆ (1.5)</option>
            <option value="1.0">★ (1.0)</option>
            <option value="0.5">☆ (0.5)</option>
          </select>
        </div>

        <div class="mb-3">
          <label for="reviewText" class="form-label fw-bold">리뷰 내용</label>
          <textarea name="review" id="reviewText" rows="4" class="form-control" maxlength="500"
                    placeholder="리뷰를 입력하세요 (최대 500자)"></textarea>
          <div class="form-text"><span id="reviewCount">0</span> / 500</div>
        </div>

        <div class="d-flex gap-2">
          <button type="button" class="btn btn-light" data-bs-dismiss="offcanvas">취소</button>
          <button type="submit" class="btn btn-primary">등록</button>
        </div>
      </form>
    </div>
  </div>

  <%@include file="/WEB-INF/common/footer/footer.jsp"%>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

  <script>
    // Offcanvas 열릴 때 orderNo/subOrderNo 세팅
    const reviewDrawer   = document.getElementById('reviewDrawer');
    const reviewOrderNo  = document.getElementById('reviewOrderNo');
    const reviewSubOrderNo = document.getElementById('reviewSubOrderNo');
    const reviewText     = document.getElementById('reviewText');
    const reviewCount    = document.getElementById('reviewCount');

    reviewDrawer.addEventListener('show.bs.offcanvas', function (event) {
      const btn = event.relatedTarget;
      if (!btn) return;
      reviewOrderNo.value    = btn.getAttribute('data-order-no') || '';
      reviewSubOrderNo.value = btn.getAttribute('data-sub-order-no') || '';
      reviewText.value = "";
      reviewCount.textContent = "0";
    });

    // 글자수 카운트
    reviewText.addEventListener('input', function(){
      reviewCount.textContent = String(this.value.length);
    });

    function confirmProduct(orderNo, subOrderNo) {
      $.ajax({
        type: "POST",
        url: "/personal/order/confirmProduct",
        data: { orderNo: orderNo, subOrderNo: subOrderNo },
        success: function(){
          alert("구매 확정이 되었습니다.");
          location.reload();
        },
        error: function(){
          alert("구매확정 처리 중 오류가 발생했습니다.");
        }
      });
    }
  </script>

  <!-- 헤더 드롭다운 이슈 대응 -->
  <script>
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

  (function forceDropdownToggle(){
    const getBtns = () => Array.from(document.querySelectorAll(
      'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
      '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
      'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"],' +
      '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
    ));
    function inside(rect, x, y){ return x>=rect.left && x<=rect.right && y>=rect.top && y<=rect.bottom; }
    document.addEventListener('click', function(ev){
      const x = ev.clientX, y = ev.clientY;
      const btn = getBtns().find(b => inside(b.getBoundingClientRect(), x, y));
      if (!btn) return;
      ev.preventDefault();
      try {
        const dd = bootstrap.Dropdown.getOrCreateInstance(btn);
        dd.toggle();
      } catch (e) {
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