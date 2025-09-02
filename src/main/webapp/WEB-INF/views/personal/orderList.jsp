<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <%@ include file="/WEB-INF/common/head.jsp"%>
  <title>주문 목록</title>
</head>
<body class="account-page">

  <%@ include file="/WEB-INF/common/header/header.jsp"%>

  <main class="main">

    <!-- Page Title (Account 템플릿 마크업) -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">주문 목록</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="<c:url value='/personal/mainPage'/>">Home</a></li>
            <li class="current">My Orders</li>
          </ol>
        </nav>
      </div>
    </div>

    <!-- Account 레이아웃 -->
    <section id="account" class="account section">
      <div class="container" data-aos="fade-up" data-aos-delay="100">

        <!-- 모바일 좌측 메뉴 토글 -->
        <div class="mobile-menu d-lg-none mb-4">
          <button class="mobile-menu-toggle" type="button" data-bs-toggle="collapse" data-bs-target="#profileMenu" aria-expanded="false" aria-controls="profileMenu">
            <i class="bi bi-grid" aria-hidden="true"></i>
            <span>Menu</span>
          </button>
        </div>

        <div class="row g-4">

          <!-- ===== 좌측 사이드 ===== -->
          <div class="col-lg-3">
            <div class="profile-menu collapse d-lg-block" id="profileMenu">
              <c:set var="currUri" value="${pageContext.request.requestURI}" />
              <c:set var="ordersActive"   value="${fn:contains(currUri, '/personal/orderList')}" />
              <c:set var="wishlistActive" value="${fn:contains(currUri, '/personal/wishList')}" />
              <c:set var="user" value="${not empty userInformation ? userInformation[0] : null}" />
              <c:set var="displayName" value="${(not empty user and not empty user.name) ? user.name : '회원님'}" />
              <c:set var="orderCount" value="${fn:length(orderGroupMap)}" />
              <c:set var="wishCount"  value="${empty wishlistCount ? 0 : wishlistCount}" />

              <!-- 사용자 카드 (Account 템플릿 클래스) -->
              <div class="user-info" data-aos="fade-right">
                <h4><c:out value="${displayName}"/> <span class="status-badge"><i class="bi bi-shield-check"></i></span></h4>
                <div class="user-status">
                  <i class="bi bi-award"></i>
                  <c:set var="cat" value="${(not empty user and not empty user.customerCategory) ? user.customerCategory : ''}" />
                  <span>
                    <c:choose>
                      <c:when test="${cat eq 'CC003'}">개인회원</c:when>
                      <c:when test="${cat eq 'CC002'}">기업</c:when>
                      <c:when test="${cat eq 'CC001' or cat eq '001'}">관리자</c:when>
                    </c:choose>
                  </span>
                </div>
              </div>

              <!-- 좌측 메뉴 -->
              <nav class="menu-nav">
                <ul class="nav flex-column" role="tablist">
                  <li class="nav-item">
                    <a class="nav-link ${ordersActive ? 'active' : ''}" href="<c:url value='/personal/orderList'/>">
                      <i class="bi bi-box-seam"></i>
                      <span>My Orders</span>
                      <span class="badge"><c:out value="${orderCount}"/></span>
                    </a>
                  </li>
                  <li class="nav-item">
                    <a class="nav-link ${wishlistActive ? 'active' : ''}" href="<c:url value='/personal/wishList'/>">
                      <i class="bi bi-heart"></i>
                      <span>Wishlist</span>
                      <span class="badge"><c:out value="${wishCount}"/></span>
                    </a>
                  </li>
                </ul>
              </nav>
            </div>
          </div>

          <!-- ===== 우측 컨텐츠: 주문 목록 ===== -->
          <div class="col-lg-9">
            <div class="content-area">

              <!-- 섹션 헤더 (검색/필터/페이지당 갯수) -->
              <div class="section-header" data-aos="fade-up">
                <h2>My Orders</h2>
                <div class="header-actions d-flex align-items-center gap-2">
                  <div class="search-box">
                    <i class="bi bi-search" aria-hidden="true"></i>
                    <input id="orderSearch" type="text" placeholder="주문 검색(주문번호/상품명)" aria-label="주문 검색">
                  </div>
                  <div class="dropdown d-none">
                    <button class="filter-btn" data-bs-toggle="dropdown" type="button" aria-haspopup="true" aria-expanded="false">
                      <span id="pageSizeLabel">5개</span>
                      <i class="bi bi-chevron-down toggle-dropdown" aria-hidden="true"></i>
                    </button>
                    <ul class="dropdown-menu dropdown-menu-end" id="pageSizeMenu">
                      <li><a class="dropdown-item js-pagesize" href="#" data-size="5">5개</a></li>
                      <li><a class="dropdown-item js-pagesize" href="#" data-size="10">10개</a></li>
                      <li><a class="dropdown-item js-pagesize" href="#" data-size="20">20개</a></li>
                    </ul>
                  </div>
                </div>
              </div>

              <!-- 주문 카드 리스트 (Account 템플릿 마크업) -->
              <div class="orders-grid">

                <c:forEach var="entry" items="${orderGroupMap}">
                  <c:set var="orderNo" value="${entry.key}" />
                  <c:set var="items"   value="${entry.value}" />
                  <c:set var="first"   value="${items[0]}" />

                  <!-- 합계 -->
                  <c:set var="orderTotal" value="0" />
                  <c:forEach var="it" items="${items}">
                    <c:set var="orderTotal" value="${orderTotal + (it.price * it.orderQuantity)}" />
                  </c:forEach>

                  <!-- 상태 매핑 -->
                  <c:set var="statusClass" value="processing" />
                  <c:set var="statusText"  value="Processing" />
                  <c:choose>
                    <c:when test="${first.deliveryStatus eq 'DS001'}"><c:set var="statusClass" value="processing"/><c:set var="statusText" value="Processing"/></c:when>
                    <c:when test="${first.deliveryStatus eq 'DS002'}"><c:set var="statusClass" value="shipped"/><c:set var="statusText" value="Shipped"/></c:when>
                    <c:when test="${first.deliveryStatus eq 'DS003'}"><c:set var="statusClass" value="delivered"/><c:set var="statusText" value="Delivered"/></c:when>
                  </c:choose>
                  <c:if test="${not empty first.orderStatus and fn:contains(first.orderStatus, 'CANCEL')}">
                    <c:set var="statusClass" value="cancelled" />
                    <c:set var="statusText"  value="Cancelled" />
                  </c:if>

                  <!-- 시간 문자열 (표시용) & 원본(정렬용) -->
                  <c:set var="orderTimeRaw" value="${first.orderTime}" />
                  <c:set var="orderTimeStr" value="${fn:replace(first.orderTime, 'T', ' ')}" />

                  <!-- 카드 (정렬용 data-order-ts 추가) -->
                  <div class="order-card"
                       data-aos="fade-up"
                       data-status="${statusClass}"
                       data-order-no="${orderNo}"
                       data-order-ts="${fn:escapeXml(orderTimeRaw)}">
                    <div class="order-header">
                      <div class="order-id">
                        <span class="label">Order No:</span>
                        <a class="value text-decoration-none" href="<c:url value='/personal/orderOne?orderNo=${orderNo}'/>">#${orderNo}</a>
                      </div>
                      <div class="order-date">
                        ${fn:substring(orderTimeStr, 0, 10)}
                      </div>
                    </div>

                    <div class="order-content">
                      <div class="product-grid">
                        <c:forEach var="it" items="${items}" varStatus="st">
                          <c:if test="${st.index < 3}">
                            <img src="<c:out value='${empty it.imagePath ? "/assets/img/product/placeholder.webp" : it.imagePath}'/>"
                                 alt="<c:out value='${it.productName}'/>" loading="lazy">
                          </c:if>
                        </c:forEach>
                        <c:if test="${fn:length(items) > 3}">
                          <span class="more-items">+${fn:length(items) - 3}</span>
                        </c:if>
                      </div>

                      <div class="order-info">
                        <div class="info-row">
                          <span>Status</span>
                          <span class="status ${statusClass}">${statusText}</span>
                        </div>
                        <div class="info-row">
                          <span>Items</span>
                          <span>${fn:length(items)} items</span>
                        </div>
                        <div class="info-row">
                          <span>Total</span>
                          <span class="price">₩<fmt:formatNumber value="${orderTotal}" type="number"/></span>
                        </div>
                      </div>
                    </div>

                    <div class="order-footer">
                      <button type="button"
                              class="btn-track js-collapse-toggle collapsed"
                              data-target="#tracking_${orderNo}"
                              data-parent="#acc_${orderNo}"
                              aria-expanded="false" aria-controls="tracking_${orderNo}"
                              aria-label="주문추적 토글">
                        <i class="bi bi-truck" aria-hidden="true"></i><span class="ms-1">주문추적</span>
                      </button>

                      <button type="button"
                              class="btn-details js-collapse-toggle collapsed"
                              data-target="#details_${orderNo}"
                              data-parent="#acc_${orderNo}"
                              aria-expanded="false" aria-controls="details_${orderNo}"
                              aria-label="상세보기 토글">
                        <i class="bi bi-card-list" aria-hidden="true"></i><span class="ms-1">상세보기</span>
                      </button>
                    </div>

                    <!-- 아코디언 컨테이너 -->
                    <div id="acc_${orderNo}">
                      <!-- Tracking -->
                      <div class="collapse tracking-info" id="tracking_${orderNo}" data-bs-parent="#acc_${orderNo}">
                        <ul class="list-unstyled mb-0">
                          <li><i class="bi bi-calendar-check me-1"></i> 주문일: ${fn:substring(orderTimeStr, 0, 16)}</li>
                          <c:choose>
                            <c:when test="${first.deliveryStatus eq 'DS001'}"><li>⌛ 배송 준비 중</li></c:when>
                            <c:when test="${first.deliveryStatus eq 'DS002'}"><li>🚚 배송중</li></c:when>
                            <c:when test="${first.deliveryStatus eq 'DS003'}"><li>🏠 배송완료</li></c:when>
                            <c:otherwise><li>상태 정보 없음</li></c:otherwise>
                          </c:choose>
                        </ul>
                      </div>

                      <!-- Details -->
                      <div class="collapse order-details" id="details_${orderNo}" data-bs-parent="#acc_${orderNo}">
                        <div class="details-content">
                          <h6 class="mb-2">Items (${fn:length(items)})</h6>

                          <div class="order-items">
                            <c:forEach var="it" items="${items}">
                              <div class="item">
                                <img src="<c:out value='${empty it.imagePath ? "/assets/img/product/placeholder.webp" : it.imagePath}'/>"
                                     alt="<c:out value='${it.productName}'/>" loading="lazy">
                                <div class="item-info">
                                  <div class="fw-semibold"><c:out value="${it.productName}"/></div>
                                  <div class="item-meta">
                                    <span class="sku">옵션: <c:out value="${it.optionName}"/> <c:out value="${it.optionNameValue}"/></span>
                                    <span class="ms-2">상품번호: <c:out value="${it.productNo}"/></span>
                                    <span class="ms-2">Qty: <c:out value="${it.orderQuantity}"/></span>
                                  </div>
                                </div>
                                <div class="ms-auto fw-semibold">
                                  ₩<fmt:formatNumber value="${it.price * it.orderQuantity}" type="number"/>
                                  <span class="text-muted" style="font-weight:400">
                                    (₩<fmt:formatNumber value="${it.price}" type="number"/> × ${it.orderQuantity})
                                  </span>
                                </div>
                              </div>
                            </c:forEach>
                          </div>

                          <div class="row mt-3">
                            <div class="col-md-6">
                              <h6>Price Details</h6>
                              <div class="price-breakdown">
                                <div class="price-row"><span>Subtotal</span><span>₩<fmt:formatNumber value="${orderTotal}" type="number"/></span></div>
                                <div class="price-row total"><span>Total</span><span>₩<fmt:formatNumber value="${orderTotal}" type="number"/></span></div>
                              </div>
                            </div>
                            <div class="col-md-6">
                              <h6>Shipping Address</h6>
                              <p class="mb-0">
                                <c:out value="${first.name}"/><br>
                                <c:out value="${first.address}"/><br>
                                <c:out value="${first.detailAddress}"/><br>
                                <span class="text-muted"><c:out value="${first.phone}"/></span><br>
                                <span class="text-muted"><c:out value="${first.email}"/></span>
                              </p>
                              <c:if test="${first.mainAddress eq 'Y'}">
                                <span class="badge bg-success mt-2">기본 배송지</span>
                              </c:if>
                              <c:if test="${not empty first.deliveryRequest}"><div class="mt-2 text-muted">요청사항: <c:out value="${first.deliveryRequest}"/></div></c:if>
                            </div>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </c:forEach>

              </div><!-- /orders-grid -->

              <!-- 빈 상태 -->
              <div id="emptyState" class="text-center text-muted py-5 d-none">조건에 맞는 주문이 없습니다.</div>

              <!-- 페이지네이션 (Account 스타일) -->
              <div id="pagination" class="pagination-wrapper" data-aos="fade-up"></div>

            </div>
          </div>

        </div>
      </div>
    </section>
  </main>

  <%@ include file="/WEB-INF/common/footer/footer.jsp"%>

  <!-- Vendor JS -->
  <script src="<c:url value='/assets/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>

  <!-- 검색/정렬/필터/페이징 -->
  <script>
  (function(){
    const grid = document.querySelector('.orders-grid');
    if (!grid) return;

    const cards = Array.from(grid.children).filter(function(el){ return el.classList.contains('order-card'); });
    const searchInput = document.getElementById('orderSearch');
    const pagination = document.getElementById('pagination');
    const emptyState = document.getElementById('emptyState');

    const pageSizeMenu = document.getElementById('pageSizeMenu');
    const pageSizeLabel = document.getElementById('pageSizeLabel');
    // 기존 개별 바인딩 대신 이벤트 위임으로 교체 (버튼 미동작 개선)
    // const pageSizeLinks = pageSizeMenu ? Array.from(pageSizeMenu.querySelectorAll('.js-pagesize')) : [];

    const state = { filter: 'all', query: '', page: 1, pageSize: 5 };

    function matchesFilter(card){
      return state.filter === 'all' || (card.dataset.status||'').toLowerCase() === state.filter;
    }
    function matchesQuery(card){
      if (!state.query) return true;
      const q = state.query;
      const orderNo = (card.dataset.orderNo || '').toLowerCase();
      const text = card.textContent.toLowerCase();
      return orderNo.indexOf(q) > -1 || text.indexOf(q) > -1;
    }
    function tsOf(card){
      // ISO 문자열 / 또는 공백형을 모두 처리
      const raw = (card.dataset.orderTs || '').trim();
      const iso  = raw.includes('T') ? raw : raw.replace(' ', 'T');
      const t = Date.parse(iso);
      return isNaN(t) ? 0 : t;
    }

    // ★ 최신순 정렬 포함
    function getFiltered(){
      return cards
        .filter(function(c){ return matchesFilter(c) && matchesQuery(c); })
        .sort(function(a,b){ return tsOf(b) - tsOf(a); }); // desc
    }

    function render(){
      const list = getFiltered();
      cards.forEach(function(c){ c.style.display = 'none'; });

      const total = list.length;
      const totalPages = Math.max(1, Math.ceil(total / state.pageSize));
      if (state.page > totalPages) state.page = 1;

      const start = (state.page - 1) * state.pageSize;
      const end = start + state.pageSize;
      list.slice(start, end).forEach(function(c){ c.style.display = ''; });

      emptyState.classList.toggle('d-none', total !== 0);
      renderPagination(totalPages);
    }

    function renderPagination(totalPages){
      pagination.innerHTML = '';

      var total = (isFinite(totalPages) && totalPages > 0) ? totalPages : 1;

      // Prev
      var prevDisabled = (state.page === 1);
      var prev = document.createElement('button');
      prev.type = 'button';
      prev.className = 'btn-prev' + (prevDisabled ? ' disabled' : '');
      if (prevDisabled) prev.setAttribute('disabled','');
      prev.setAttribute('aria-label','이전 페이지');
      prev.innerHTML = '<i class="bi bi-chevron-left"></i>';
      prev.addEventListener('click', function(){ if(state.page > 1){ state.page--; render(); }});
      pagination.appendChild(prev);

      // Page numbers
      var pagesWrap = document.createElement('div');
      pagesWrap.className = 'page-numbers';

      var win = 2;
      var s = Math.max(1, state.page - win);
      var e = Math.min(total, state.page + win);
      if (state.page <= win) e = Math.min(total, 1 + 2*win);
      if (state.page + win > total) s = Math.max(1, total - 2*win);

      function addBtn(p){
        var b = document.createElement('button');
        b.type = 'button';
        if (p === state.page) b.classList.add('active');
        b.setAttribute('aria-label', p + '페이지');
        b.textContent = String(p);
        b.addEventListener('click', function(){ state.page = p; render(); });
        pagesWrap.appendChild(b);
      }

      if (s > 1){
        addBtn(1);
        if (s > 2){
          var gap1 = document.createElement('span');
          gap1.className = 'gap';
          gap1.setAttribute('aria-hidden','true');
          gap1.textContent = '…';
          pagesWrap.appendChild(gap1);
        }
      }
      for (var p = s; p <= e; p++) addBtn(p);
      if (e < total){
        if (e < total - 1){
          var gap2 = document.createElement('span');
          gap2.className = 'gap';
          gap2.setAttribute('aria-hidden','true');
          gap2.textContent = '…';
          pagesWrap.appendChild(gap2);
        }
        addBtn(total);
      }

      if (total === 1 && pagesWrap.children.length === 0) addBtn(1);
      pagination.appendChild(pagesWrap);

      // Next
      var nextDisabled = (state.page === total);
      var next = document.createElement('button');
      next.type = 'button';
      next.className = 'btn-next' + (nextDisabled ? ' disabled' : '');
      if (nextDisabled) next.setAttribute('disabled','');
      next.setAttribute('aria-label','다음 페이지');
      next.innerHTML = '<i class="bi bi-chevron-right"></i>';
      next.addEventListener('click', function(){ if(state.page < total){ state.page++; render(); }});
      pagination.appendChild(next);
    }

    // input 검색
    document.addEventListener('input', function(e){
      if (e.target === searchInput){
        state.query = (e.target.value||'').trim().toLowerCase();
        state.page = 1; render();
      }
    });

    // ★ 페이지당 보기: 이벤트 위임으로 클릭 처리 + 드롭다운 닫기
    document.addEventListener('click', function(e){
      const a = e.target.closest('#pageSizeMenu .js-pagesize');
      if (!a) return;
      e.preventDefault();
      const size = parseInt(a.dataset.size, 10);
      if (!isNaN(size) && size > 0){
        state.pageSize = size;
        if (pageSizeLabel) pageSizeLabel.textContent = a.textContent.trim();
        state.page = 1;
        render();
      }
      const dropdown = a.closest('.dropdown');
      if (dropdown){
        const toggle = dropdown.querySelector('[data-bs-toggle="dropdown"]');
        if (toggle){
          const inst = bootstrap.Dropdown.getOrCreateInstance(toggle);
          inst.hide();
        }
      }
    });

    // 초기 렌더(최신순 반영)
    render();
  })();
  </script>

  <!-- Collapse: 배타/재클릭 닫힘/끊김 방지 -->
  <script>
  (function () {
    document.addEventListener('click', function (e) {
      const btn = e.target.closest('.js-collapse-toggle[data-target]');
      if (!btn) return;

      e.preventDefault();
      const sel = btn.getAttribute('data-target');
      const el  = document.querySelector(sel);
      if (!el) return;

      // 같은 카드 내 다른 패널 닫기
      const parentSel = btn.getAttribute('data-parent') || el.getAttribute('data-bs-parent');
      if (parentSel) {
        document.querySelectorAll(parentSel + ' .collapse.show').forEach(function(sib){
          if (sib !== el) bootstrap.Collapse.getOrCreateInstance(sib, { toggle: false }).hide();
        });
      }

      const inst = bootstrap.Collapse.getOrCreateInstance(el, { toggle: false });
      el.classList.contains('show') ? inst.hide() : inst.show();
    });

    // 버튼 상태 동기화
    document.addEventListener('shown.bs.collapse', function (e) {
      const btn = document.querySelector('.js-collapse-toggle[data-target="#' + e.target.id + '"]');
      if (btn) { btn.classList.remove('collapsed'); btn.setAttribute('aria-expanded','true'); }
    });
    document.addEventListener('hidden.bs.collapse', function (e) {
      const btn = document.querySelector('.js-collapse-toggle[data-target="#' + e.target.id + '"]');
      if (btn) { btn.classList.add('collapsed'); btn.setAttribute('aria-expanded','false'); }
    });
  })();
  </script>

</body>
</html>