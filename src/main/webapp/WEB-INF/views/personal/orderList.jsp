<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>주문 내역</title>

<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/variable/pretendardvariable.css"
      crossorigin>

<style>
/* ===== base typography ===== */
html, body, button, input, select, textarea {
  font-family:"Pretendard Variable","Pretendard","Noto Sans KR","Apple SD Gothic Neo",
               -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Malgun Gothic",Arial,sans-serif;
  line-height:1.5;
  -webkit-font-smoothing:antialiased;
  -moz-osx-font-smoothing:grayscale;
  font-optical-sizing:auto;
  text-rendering:optimizeLegibility;
  word-break:keep-all;
}
.num, .price, [data-price]{ font-variant-numeric:tabular-nums; font-feature-settings:"tnum" 1; letter-spacing:.1px; }
h1,h2,h3{ font-weight:700; letter-spacing:-.1px; }
.section-header h2{ font-weight:600; }
button,.btn{ font-weight:500; }

/* ===== 상세보기(주문 상세) 컴팩트 리스트 ===== */
.order-details .order-items{ display:grid; grid-template-columns:1fr; gap:12px; }
.order-details .order-items .item{
  display:grid; grid-template-columns:64px 1fr auto; align-items:center; gap:12px;
  padding:10px 12px; border:1px solid #eef2f5; border-radius:10px; background:#fff;
}
.order-details .order-items .item img{ width:64px; height:64px; object-fit:cover; border-radius:8px; }
.order-details .order-items .item .item-meta{ font-size:.9rem; color:#6b7280; }
@media (min-width:992px){ .order-details .order-items{ grid-template-columns:1fr 1fr; } }

/* ===== 주문번호 UI 업그레이드 ===== */
.order-header{ display:flex; justify-content:space-between; gap:12px; align-items:center; padding:12px 12px 0; }
.order-header[data-detail-href]{ cursor:pointer; }
.order-id{ display:flex; align-items:center; gap:8px; flex-wrap:wrap; }
.order-id .label{ color:#6b7280; font-weight:500; }
.order-id .order-link{
  display:inline-flex; align-items:center; gap:6px; padding:1px 3px;
  border-radius:9999px; background:#111827; color:#fff !important; text-decoration:none;
  font-weight:600; letter-spacing:.1px; transition:transform .16s ease, box-shadow .16s ease, filter .16s ease;
}
.order-id .order-link:hover{ transform:translateY(-1px); filter:brightness(1.06); box-shadow:0 6px 18px rgba(15,23,42,.08); }
.order-id .order-link:focus-visible{ outline:2px solid #111827; outline-offset:2px; }
.order-id .copy-btn{
  border:1px solid #e5e7eb; background:#fff; color:#6b7280; padding:6px 8px; border-radius:8px; line-height:1;
}
.order-id .copy-btn:hover{ background:#f3f4f6; color:#111827; }
.order-date{ color:#6b7280; font-size:.95rem; }
/* (참고) orders-grid/order-card는 기존 템플릿 스타일 사용 */
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
<%@ include file="/WEB-INF/common/header/header.jsp" %>

<main class="main">

  <!-- Page Title -->
  <div class="page-title light-background">
    <div class="container d-lg-flex justify-content-between align-items-center">
      <h1 class="mb-2 mb-lg-0">주문 내역</h1>
      <nav class="breadcrumbs">
        <ol>
          <li><a href="<c:url value='/personal/mainPage'/>">홈</a></li>
          <li class="current">주문</li>
        </ol>
      </nav>
    </div>
  </div>

  <section id="account" class="account section">
    <div class="container" data-aos="fade-up" data-aos-delay="100">
      <!-- 모바일 좌측 메뉴 토글 -->
      <div class="mobile-menu d-lg-none mb-4">
        <button class="mobile-menu-toggle" type="button" data-bs-toggle="collapse" data-bs-target="#profileMenu"
                aria-expanded="false" aria-controls="profileMenu">
          <i class="bi bi-grid" aria-hidden="true"></i>
          <span>메뉴</span>
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

            <nav class="menu-nav">
              <ul class="nav flex-column" role="tablist">
                <li class="nav-item">
                  <a class="nav-link ${ordersActive ? 'active' : ''}" href="<c:url value='/personal/orderList'/>">
                    <i class="bi bi-box-seam"></i>
                    <span>주문</span>
                    <span class="badge"><c:out value="${orderCount}"/></span>
                  </a>
                  <a class="nav-link ${wishlistActive ? 'active' : ''}" href="<c:url value='/personal/wishList'/>">
                    <i class="bi bi-heart"></i>
                    <span>찜</span>
                    <span class="badge">${fn:length(wishList)}</span>
                  </a>
                  <a class="nav-link ${paymentsActive ? 'active' : ''}" href="<c:url value='/personal/paymentCard'/>">
                    <i class="bi bi-credit-card-2-front"></i>
                    <span>카드관리</span>
                    <span class="badge">${cardCount}</span>
                  </a>
                </li>
              </ul>
            </nav>
          </div>
        </div>

        <!-- ===== 우측 컨텐츠: 주문 목록 ===== -->
        <div class="col-lg-9">
          <div class="content-area">

            <!-- 섹션 헤더 -->
            <div class="section-header" data-aos="fade-up">
              <div class="header-actions d-flex align-items-center gap-2">
                <div class="search-box">
                  <i class="bi bi-search" aria-hidden="true"></i>
                  <input id="orderSearch" type="text" placeholder="검색(주문번호/상품명/배송)" aria-label="주문 검색">
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

            <!-- 주문 카드 리스트 -->
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
                <c:set var="statusText"  value="상태 정보 없음" />
                <c:choose>
                  <c:when test="${first.deliveryStatus eq 'DS001'}">
                    <c:set var="statusClass" value="processing"/><c:set var="statusText" value="배송 준비 중"/>
                  </c:when>
                  <c:when test="${first.deliveryStatus eq 'DS002'}">
                    <c:set var="statusClass" value="shipped"/><c:set var="statusText" value="배송 중"/>
                  </c:when>
                  <c:when test="${first.deliveryStatus eq 'DS003'}">
                    <c:set var="statusClass" value="delivered"/><c:set var="statusText" value="배송 완료"/>
                  </c:when>
                </c:choose>
                <c:if test="${not empty first.orderStatus and fn:contains(first.orderStatus, 'CANCEL')}">
                  <c:set var="statusClass" value="cancelled" />
                  <c:set var="statusText"  value="Cancelled" />
                </c:if>

                <!-- 시간 문자열 -->
                <c:set var="orderTimeRaw" value="${first.orderTime}" />
                <c:set var="orderTimeStr" value="${fn:replace(first.orderTime, 'T', ' ')}" />

                <!-- ===== 카드 래퍼 (정렬/페이징용) ===== -->
                <div class="order-card"
                     data-aos="fade-up"
                     data-status="${statusClass}"
                     data-order-no="${orderNo}"
                     data-order-ts="${fn:escapeXml(orderTimeRaw)}">

                  <!-- 주문번호 헤더(전체 클릭 이동) -->
                  <div class="order-header"
                       data-detail-href="<c:url value='/personal/orderOne?orderNo=${orderNo}'/>">
                    <div class="order-id">
                      <span class="label">주문 번호</span>
                      <a class="order-link"
                         href="<c:url value='/personal/orderOne?orderNo=${orderNo}'/>"
                         aria-label="주문 상세로 이동: #${orderNo}">
                        <i class="bi bi-hash" aria-hidden="true"></i>${orderNo}
                        <i class="bi bi-arrow-right-short" aria-hidden="true"></i>
                      </a>
                      <button type="button" class="copy-btn"
                              data-copy="${orderNo}" aria-label="주문번호 복사">
                        <i class="bi bi-clipboard" aria-hidden="true"></i>
                      </button>
                    </div>
                    <div class="order-date">${fn:substring(orderTimeStr, 0, 10)}</div>
                  </div>

                  <!-- 내용 -->
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
                        <span>배송 상태</span>
                        <span class="status ${statusClass}">${statusText}</span>
                      </div>
                      <div class="info-row">
                        <span>수량</span>
                        <span>${fn:length(items)} 개</span>
                      </div>
                      <div class="info-row">
                        <span>합계</span>
                        <span class="price">₩<fmt:formatNumber value="${orderTotal}" type="number"/></span>
                      </div>
                    </div>
                  </div>

                  <!-- 푸터 -->
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
                          <c:when test="${first.deliveryStatus eq 'DS002'}"><li>🚚 배송 중</li></c:when>
                          <c:when test="${first.deliveryStatus eq 'DS003'}"><li>🏠 배송 완료</li></c:when>
                          <c:otherwise><li>상태 정보 없음</li></c:otherwise>
                        </c:choose>
                      </ul>
                    </div>

                    <!-- Details -->
                    <div class="collapse order-details" id="details_${orderNo}" data-bs-parent="#acc_${orderNo}">
                      <div class="details-content">
                        <h6 class="mb-2">상품 (${fn:length(items)})</h6>

                        <div class="order-items">
                          <c:forEach var="it" items="${items}">
                            <div class="item">
                              <img src="<c:out value='${empty it.imagePath ? "/assets/img/product/placeholder.webp" : it.imagePath}'/>"
                                   alt="<c:out value='${it.productName}'/>" loading="lazy">
                              <div class="item-info">
                                <div class="fw-semibold"><c:out value="${it.productName}"/></div>
                                <div class="item-meta">
                                  <span class="sku">옵션: <c:out value="${it.optionName}"/> <c:out value="${it.optionNameValue}"/></span>
                                  <br>
                                  <span>수량: <c:out value="${it.orderQuantity}"/>개</span>
                                </div>
                              </div>
                              <div class="ms-auto fw-semibold">
                                금액: <fmt:formatNumber value="${it.price * it.orderQuantity}" type="number"/>원 <br>
                                <span class="text-muted" style="font-weight:400">
                                  (<fmt:formatNumber value="${it.price}" type="number"/> × ${it.orderQuantity})
                                </span>
                              </div>
                            </div>
                          </c:forEach>
                        </div>

                        <div class="row mt-3">
                          <div class="col-md-6">
                            <h6>배송 주소</h6>
                            <p class="mb-0">
                              받는 사람: <c:out value="${first.name}"/><br>
                              받는 주소: <c:out value="${first.address}"/> <c:out value="${first.detailAddress}"/><br>
                              연락처: <span class="text-muted"><c:out value="${first.phone}"/></span>
                            <c:if test="${not empty first.deliveryRequest}">
                              <div class="mt-2 text-muted">요청사항: <c:out value="${first.deliveryRequest}"/></div>
                            </c:if>
                            </p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div><!-- /acc -->
                </div><!-- /order-card -->
              </c:forEach>

            </div><!-- /orders-grid -->

            <!-- 빈 상태 -->
            <div id="emptyState" class="text-center text-muted py-5 d-none">조건에 맞는 주문이 없습니다.</div>

            <!-- 페이지네이션 -->
            <div id="pagination" class="pagination-wrapper" data-aos="fade-up"></div>

          </div>
        </div>
      </div>
    </div>
  </section>
</main>

<%@ include file="/WEB-INF/common/footer/footer.jsp"%>
<script src="<c:url value='/assets/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>

<!-- 검색/정렬/필터/페이징 -->
<script>
(function(){
  const grid = document.querySelector('.orders-grid');
  if (!grid) return;

  const cards = Array.from(grid.querySelectorAll('.order-card'));
  const searchInput = document.getElementById('orderSearch');
  const pagination = document.getElementById('pagination');
  const emptyState = document.getElementById('emptyState');
  const pageSizeMenu = document.getElementById('pageSizeMenu');
  const pageSizeLabel = document.getElementById('pageSizeLabel');

  const state = { filter:'all', query:'', page:1, pageSize:5 };

  function matchesFilter(card){ return state.filter==='all' || (card.dataset.status||'').toLowerCase()===state.filter; }
  function matchesQuery(card){
    if (!state.query) return true;
    const q = state.query;
    const orderNo = (card.dataset.orderNo||'').toLowerCase();
    const text = card.textContent.toLowerCase();
    return orderNo.indexOf(q)>-1 || text.indexOf(q)>-1;
  }
  function tsFromAttr(card){
    const raw = (card.dataset.orderTs||'').trim();
    if (!raw) return NaN;
    const iso = raw.includes('T') ? raw : raw.replace(' ','T');
    return Date.parse(iso);
  }
  function tsFromOrderNo(card){
    const no = (card.dataset.orderNo||'').trim();
    const m = no.match(/^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})/);
    if (!m) return NaN;
    const [,y,mo,d,h,mi] = m;
    return new Date(`${y}-${mo}-${d}T${h}:${mi}:00`).getTime();
  }
  function tsOf(card){ let t = tsFromAttr(card); if (isNaN(t)) t = tsFromOrderNo(card); return isNaN(t)?0:t; }
  function getSortedAll(){ return cards.slice().sort((a,b)=>tsOf(b)-tsOf(a)); }
  function getFiltered(sortedAll){ return sortedAll.filter(c=>matchesFilter(c)&&matchesQuery(c)); }

  function render(){
    const sortedAll = getSortedAll();
    const frag = document.createDocumentFragment();
    sortedAll.forEach(c=>frag.appendChild(c));
    grid.appendChild(frag);

    const list = getFiltered(sortedAll);
    cards.forEach(c=>{ c.style.display='none'; });

    const total = list.length;
    const totalPages = Math.max(1, Math.ceil(total/state.pageSize));
    if (state.page>totalPages) state.page = 1;

    const start = (state.page-1)*state.pageSize;
    const end = start + state.pageSize;
    list.slice(start, end).forEach(c=>{ c.style.display=''; });

    emptyState.classList.toggle('d-none', total!==0);
    renderPagination(totalPages);
  }

  function renderPagination(totalPages){
    pagination.innerHTML = '';
    const total = (isFinite(totalPages) && totalPages>0) ? totalPages : 1;

    const prev = document.createElement('button');
    prev.type='button'; prev.className='btn-prev' + (state.page===1?' disabled':'');
    if (state.page===1) prev.setAttribute('disabled','');
    prev.setAttribute('aria-label','이전 페이지');
    prev.innerHTML = '<i class="bi bi-chevron-left"></i>';
    prev.addEventListener('click', ()=>{ if(state.page>1){ state.page--; render(); }});
    pagination.appendChild(prev);

    const pagesWrap = document.createElement('div');
    pagesWrap.className = 'page-numbers';
    const win = 2;
    let s = Math.max(1, state.page-win);
    let e = Math.min(total, state.page+win);
    if (state.page<=win) e = Math.min(total, 1+2*win);
    if (state.page+win>total) s = Math.max(1, total-2*win);

    function addBtn(p){
      const b = document.createElement('button');
      b.type='button';
      if (p===state.page) b.classList.add('active');
      b.setAttribute('aria-label', p+'페이지');
      b.textContent=String(p);
      b.addEventListener('click', ()=>{ state.page=p; render(); });
      pagesWrap.appendChild(b);
    }
    if (s>1){ addBtn(1); if (s>2){ const gap1=document.createElement('span'); gap1.className='gap'; gap1.textContent='…'; pagesWrap.appendChild(gap1);} }
    for (let p=s; p<=e; p++) addBtn(p);
    if (e<total){ if (e<total-1){ const gap2=document.createElement('span'); gap2.className='gap'; gap2.textContent='…'; pagesWrap.appendChild(gap2);} addBtn(total); }
    if (total===1 && pagesWrap.children.length===0) addBtn(1);
    pagination.appendChild(pagesWrap);

    const next = document.createElement('button');
    next.type='button'; next.className='btn-next' + (state.page===total?' disabled':'');
    if (state.page===total) next.setAttribute('disabled','');
    next.setAttribute('aria-label','다음 페이지');
    next.innerHTML = '<i class="bi bi-chevron-right"></i>';
    next.addEventListener('click', ()=>{ if(state.page<total){ state.page++; render(); }});
    pagination.appendChild(next);
  }

  // 검색
  document.addEventListener('input', function(e){
    if (e.target===searchInput){
      state.query = (e.target.value||'').trim().toLowerCase();
      state.page = 1; render();
    }
  });

  // 페이지당 보기
  document.addEventListener('click', function(e){
    const a = e.target.closest('#pageSizeMenu .js-pagesize');
    if (!a) return;
    e.preventDefault();
    const size = parseInt(a.dataset.size,10);
    if (!isNaN(size)&&size>0){
      state.pageSize = size;
      if (pageSizeLabel) pageSizeLabel.textContent = a.textContent.trim();
      state.page = 1; render();
    }
    const dropdown = a.closest('.dropdown');
    if (dropdown){
      const toggle = dropdown.querySelector('[data-bs-toggle="dropdown"]');
      if (toggle){ const inst = bootstrap.Dropdown.getOrCreateInstance(toggle); inst.hide(); }
    }
  });

  // ✅ 헤더 전체 클릭 & 복사 버튼 처리
  grid.addEventListener('click', function(e){
    // 복사 버튼
    const copyBtn = e.target.closest('.copy-btn');
    if (copyBtn && grid.contains(copyBtn)){
      const val = copyBtn.dataset.copy || '';
      if (val){
        navigator.clipboard?.writeText(val).then(()=>{
          const prev = copyBtn.innerHTML;
          copyBtn.innerHTML = '<i class="bi bi-check2"></i>';
          setTimeout(()=> copyBtn.innerHTML = prev, 1200);
        });
      }
      return;
    }
    // 헤더 영역 아무 곳이나 클릭 → 상세이동 (링크/버튼/토글 제외)
    const header = e.target.closest('.order-card .order-header');
    if (header && grid.contains(header) && !e.target.closest('a,button,.js-collapse-toggle')){
      const href = header.getAttribute('data-detail-href');
      if (href) window.location.assign(href);
      return;
    }
    // 직접 링크 클릭도 정상 동작
    const link = e.target.closest('.order-card .order-id .order-link');
    if (link && grid.contains(link)){
      e.preventDefault();
      window.location.assign(link.getAttribute('href'));
    }
  });

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
    const parentSel = btn.getAttribute('data-parent') || el.getAttribute('data-bs-parent');
    if (parentSel) {
      document.querySelectorAll(parentSel + ' .collapse.show').forEach(function(sib){
        if (sib !== el) bootstrap.Collapse.getOrCreateInstance(sib, { toggle: false }).hide();
      });
    }
    const inst = bootstrap.Collapse.getOrCreateInstance(el, { toggle: false });
    el.classList.contains('show') ? inst.hide() : inst.show();
  });
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

<!-- 헤더 드롭다운 이슈 대응 -->
<script>
(function ensureBtnType(){
  const sel = [
    'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
    '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
    'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]',
    '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
  ].join(',');
  document.querySelectorAll(sel).forEach(btn=>{ if(!btn.hasAttribute('type')) btn.setAttribute('type','button'); });
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
    const btn = getBtns().find(b=>inside(b.getBoundingClientRect(),x,y));
    if(!btn) return;
    ev.preventDefault();
    try{ bootstrap.Dropdown.getOrCreateInstance(btn).toggle(); }
    catch(e){ setTimeout(()=>bootstrap.Dropdown.getOrCreateInstance(btn).toggle(),0); }
  }, true);
})();
</script>

</body>
</html>
