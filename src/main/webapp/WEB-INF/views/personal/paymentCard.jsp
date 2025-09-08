<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>결제수단 관리</title>

<link rel="preconnect" href="https://cdn.jsdelivr.net" crossorigin>
<link rel="stylesheet"
      href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard/dist/web/variable/pretendardvariable.css"
      crossorigin>

<style>
/* ===== base ===== */
html, body, button, input, select, textarea {
  font-family:"Pretendard Variable","Pretendard","Noto Sans KR","Apple SD Gothic Neo",
               -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Malgun Gothic",Arial,sans-serif;
  line-height:1.5; -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;
  font-optical-sizing:auto; text-rendering:optimizeLegibility; word-break:keep-all;
}
.num, .mono { font-variant-numeric: tabular-nums; font-feature-settings:"tnum" 1; letter-spacing:.1px; }

/* ===== 좌측 메뉴 ===== */
/* ===== 좌측 메뉴 (첫 번째 스타일과 동일) ===== */
.profile-menu .user-info{
  padding:16px;
  background:transparent;   /* 배경 투명 */
  border:none;              /* 테두리 제거 */
  margin-bottom:12px
}

.menu-nav .nav-link{
  display:flex;
  align-items:center;
  justify-content:space-between;
  gap:8px;
  border:none;              /* ✅ 테두리 제거 */
  border-radius:8px;
  margin-bottom:8px;
  padding:10px 12px;
  background:transparent;   /* 배경 투명 */
  color:#111827;
  font-weight:500;
}

.menu-nav .nav-link.active{
  background:#111827;
  color:#fff;
}

.menu-nav .badge{
  background:#f3f4f6;
  border-radius:999px;
  padding:2px 8px;
  font-size:.8rem
}

.menu-nav .nav-link.active .badge{
  background:rgba(255,255,255,.2);
  color:#fff;
}


/* ===== 상단 툴바 ===== */
.section-header{display:flex;justify-content:space-between;align-items:center;gap:12px;margin-bottom:8px}
.search-box{position:relative;display:flex;align-items:center;background:#fff;border:1px solid #e5e7eb;border-radius:10px;padding:8px 10px;gap:8px;min-width:260px}
.search-box i{color:#6b7280}
.search-box input{border:none;outline:0;width:100%;font-size:.95rem}
.filters{display:flex;align-items:center;gap:8px}
.chip{border:1px solid #e5e7eb;background:#fff;border-radius:999px;padding:6px 10px;font-size:.9rem;color:#374151}
.chip.active{background:#111827;color:#fff;border-color:#111827}

/* ===== 카드 그리드 ===== */
.cards-grid{display:grid;grid-template-columns:1fr;gap:14px}
@media(min-width:768px){ .cards-grid{grid-template-columns:1fr 1fr} }
@media(min-width:1200px){ .cards-grid{grid-template-columns:1fr 1fr 1fr} }

.card-item{border:1px solid #eef2f5;border-radius:14px;background:#fff;box-shadow:0 1px 0 rgba(0,0,0,.02)}
.card-head{display:flex;justify-content:space-between;align-items:center;padding:12px 14px;border-bottom:1px dashed #eef2f5;gap:8px}
.card-id{display:flex;align-items:center;gap:8px;flex-wrap:wrap}
.card-id .label{color:#6b7280;font-weight:500}
.card-id .id-pill{display:inline-flex;align-items:center;gap:6px;padding:2px 6px;border-radius:999px;background:#111827;color:#fff;text-decoration:none;font-weight:600;letter-spacing:.1px}
.copy-btn{border:1px solid #e5e7eb;background:#fff;color:#6b7280;padding:6px 8px;border-radius:8px;line-height:1}
.copy-btn:hover{background:#f3f4f6;color:#111827}

.badge{display:inline-flex;align-items:center;gap:6px;border-radius:999px;padding:4px 8px;font-size:.8rem;font-weight:600}
.badge.default{background:#0ea5e9;color:#fff}
.badge.active{background:#16a34a1a;color:#166534;border:1px solid #bbf7d0}
.badge.inactive{background:#f1f5f9;color:#475569;border:1px solid #e2e8f0}
.badge.expired{background:#fee2e2;color:#991b1b;border:1px solid #fecaca}

.card-body{padding:12px 14px;display:grid;grid-template-columns:1fr;gap:10px}
.rowline{display:flex;justify-content:space-between;gap:12px}
.brand{display:flex;align-items:center;gap:8px;font-weight:600}
.brand .bi{font-size:1rem}
.mask{font-weight:700}
.muted{color:#6b7280}

.card-foot{display:flex;justify-content:space-between;align-items:center;gap:8px;padding:10px 14px;border-top:1px solid #f3f4f6}
.btn-group{display:flex;gap:8px;flex-wrap:wrap}
.btn-sm{padding:6px 10px;border-radius:8px;border:1px solid #e5e7eb;background:#fff}
.btn-sm.primary{background:#111827;color:#fff;border-color:#111827}
.btn-sm.danger{color:#991b1b;border-color:#fecaca;background:#fff}
.btn-sm:hover{filter:brightness(1.06)}
.btn-sm[disabled]{opacity:.6;pointer-events:none}

/* pagination */
.pagination-wrapper{display:flex;justify-content:center;align-items:center;gap:8px;margin-top:16px}
.pagination-wrapper .page-numbers{display:flex;gap:6px}
.pagination-wrapper button{padding:6px 10px;border:1px solid #e5e7eb;background:#fff;border-radius:8px}
.pagination-wrapper button.active{background:#111827;color:#fff;border-color:#111827}
.pagination-wrapper .gap{display:inline-flex;align-items:center;padding:0 4px;color:#9ca3af}

/* collapse details */
.details{padding:0 14px 12px}
.details .kv{display:grid;grid-template-columns:120px 1fr;gap:8px;padding:6px 0;border-bottom:1px dashed #eef2f5}
.details .kv:last-child{border-bottom:none}
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>
<%@ include file="/WEB-INF/common/header/header.jsp" %>

<main class="main">

  <!-- Page Title -->
  <div class="page-title light-background">
    <div class="container d-lg-flex justify-content-between align-items-center">
      <h1 class="mb-2 mb-lg-0">결제수단 관리</h1>
      <nav class="breadcrumbs">
        <ol>
          <li><a href="<c:url value='/personal/mainPage'/>">홈</a></li>
          <li class="current">결제수단</li>
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

      <!-- ✅ row는 container 안에서 시작 -->
      <div class="row g-4">

        <!-- ===== 좌측 사이드 ===== -->
<div class="col-lg-3">
  <div class="profile-menu collapse d-lg-block" id="profileMenu">
    <c:set var="currUri" value="${pageContext.request.requestURI}" />
    <c:set var="ordersActive"   value="${fn:contains(currUri, '/personal/orderList')}" />
    <c:set var="wishlistActive" value="${fn:contains(currUri, '/personal/wishList')}" />
    <c:set var="paymentsActive" value="${fn:contains(currUri, '/personal/paymentCard')}" />

    <!-- ✅ 이름 출력 -->
    <c:set var="displayName"
           value="${(not empty paymentMethodList and not empty paymentMethodList[0].name)
                     ? paymentMethodList[0].name : '회원님'}" />

    <div class="user-info" data-aos="fade-right">
      <h4><c:out value="${displayName}"/> <span class="status-badge"><i class="bi bi-shield-check"></i></span></h4>
      <div class="user-status">
        <i class="bi bi-award"></i>
        <c:set var="cat" value="${(not empty userInformation and not empty userInformation[0].customerCategory)
                                  ? userInformation[0].customerCategory : ''}" />
        <span>
          <c:choose>
            <c:when test="${cat eq 'CC003'}">개인회원</c:when>
            <c:when test="${cat eq 'CC002'}">기업회원</c:when>
            <c:when test="${cat eq 'CC001' or cat eq '001'}">관리자</c:when>
            <c:otherwise>개인회원</c:otherwise>
          </c:choose>
        </span>
      </div>
    </div>

    <!-- ✅ 메뉴 (첫 번째와 동일한 구조) -->
    <nav class="menu-nav">
      <ul class="nav flex-column" role="tablist">
        <li class="nav-item">
          <a class="nav-link ${ordersActive ? 'active' : ''}" href="<c:url value='/personal/orderList'/>">
            <i class="bi bi-box-seam"></i>
            <span>주문</span>
            <span class="badge">${order}</span>
          </a>
          <a class="nav-link ${wishlistActive ? 'active' : ''}" href="<c:url value='/personal/wishList'/>">
            <i class="bi bi-heart"></i>
            <span>찜</span>
            <span class="badge"><c:out value="${empty wishList ? 0 : fn:length(wishList)}"/></span>
          </a>
          <a class="nav-link ${paymentsActive ? 'active' : ''}" href="<c:url value='/personal/paymentCard'/>">
            <i class="bi bi-credit-card-2-front"></i>
            <span>카드관리</span>
            <span class="badge"><c:out value="${empty paymentMethodList ? 0 : fn:length(paymentMethodList)}"/></span>
          </a>
        </li>
      </ul>
    </nav>
  </div>
</div>


        <!-- ===== 우측 컨텐츠: 결제수단 목록 ===== -->
        <div class="col-lg-9">
          <!-- 섹션 헤더 -->
          <div class="section-header" data-aos="fade-up">
            <div class="d-flex align-items-center gap-2">
              <div class="search-box">
                <i class="bi bi-search" aria-hidden="true"></i>
                <input id="searchInput" type="text" placeholder="검색(금융기관/코드/마지막 4자리)" aria-label="결제수단 검색">
              </div>
              <div class="filters">
                <button class="chip active" data-filter="all" type="button">전체</button>
                <button class="chip" data-filter="default" type="button">기본카드</button>
                <button class="chip" data-filter="ACTIVE" type="button">사용중</button>
                <button class="chip" data-filter="EXPIRED" type="button">만료</button>
                <button class="chip" data-filter="INACTIVE" type="button">비활성</button>
              </div>
            </div>
            <div class="dropdown">
              <button class="chip" data-bs-toggle="dropdown" type="button" aria-haspopup="true" aria-expanded="false">
                <span id="pageSizeLabel">6개</span> <i class="bi bi-chevron-down"></i>
              </button>
              <ul class="dropdown-menu dropdown-menu-end" id="pageSizeMenu">
                <li><a class="dropdown-item js-pagesize" href="#" data-size="6">6개</a></li>
                <li><a class="dropdown-item js-pagesize" href="#" data-size="12">12개</a></li>
                <li><a class="dropdown-item js-pagesize" href="#" data-size="24">24개</a></li>
              </ul>
            </div>
          </div>

          <!-- 카드 목록 -->
          <div class="cards-grid" id="cardsGrid">
            <c:forEach var="pm" items="${paymentMethodList}">
              <!-- 서버 필드 → 뷰 모델 -->
              <c:set var="pmNo" value="${pm.paymentMethodNo}" />
              <c:set var="code" value="${pm.paymentCode}" />
              <c:set var="inst" value="${pm.financialInstitution}" />
              <c:set var="acc" value="${pm.accountNumber}" />
              <c:set var="exp" value="${pm.cardExpiration}" />
              <c:set var="isDef" value="${pm.isDefault eq 'Y'}" />
              <c:set var="useStat" value="${pm.useStatus}" />
              <c:set var="createdTs" value="${pm.createDate}" />

              <!-- 마스킹 카드번호 -->
              <c:set var="last4" value="${not empty acc ? fn:substring(acc, fn:length(acc)-4, fn:length(acc)) : ''}" />
              <c:set var="masked" value="${not empty last4 ? '**** **** **** ' += last4 : (not empty acc ? acc : '')}" />

              <!-- 기본 상태(추후 JS에서 EXPIRED 보정) -->
              <c:set var="status" value="${useStat eq 'Y' ? 'ACTIVE' : 'INACTIVE'}" />

              <div class="card-item"
                   data-status="${status}"
                   data-default="${isDef}"
                   data-created-ts="${fn:escapeXml(createdTs)}"
                   data-code="${fn:escapeXml(code)}"
                   data-expiry="${fn:escapeXml(exp)}"
                   data-inst="${fn:toLowerCase(inst)}"
                   data-last4="${last4}">
                <!-- head -->
                <div class="card-head">
                  <div class="card-id">
                    <span class="label">ID</span>
                    <a class="id-pill" href="<c:url value='/personal/cardOne?paymentMethodNo=${pmNo}'/>">
                      <i class="bi bi-credit-card-2-front" aria-hidden="true"></i>
                      <span class="mono">#${pmNo}</span>
                    </a>
                    <button class="copy-btn" type="button" data-copy="${pmNo}" aria-label="ID 복사">
                      <i class="bi bi-clipboard"></i>
                    </button>
                  </div>
                  <div class="badges">
                    <c:if test="${isDef}">
                      <span class="badge default"><i class="bi bi-star-fill"></i> 기본</span>
                    </c:if>
                    <c:choose>
                      <c:when test="${status eq 'ACTIVE'}"><span class="badge active js-status-badge">사용중</span></c:when>
                      <c:otherwise><span class="badge inactive js-status-badge">비활성</span></c:otherwise>
                    </c:choose>
                  </div>
                </div>

                <!-- body -->
                <div class="card-body">
                  <div class="rowline">
                    <div class="brand">
                      <i class="bi bi-bank"></i>
                      <span>
                        <c:out value="${empty inst ? '금융기관 미지정' : inst}"/>
                        <span class="muted"> • <c:out value="${empty code ? '코드없음' : code}"/></span>
                      </span>
                    </div>
                    <div class="mask mono"><c:out value="${masked}"/></div>
                  </div>
                  <div class="rowline muted">
                    <span>유효기간</span>
                    <span class="mono"><c:out value="${empty exp ? '-' : exp}"/></span>
                  </div>
                  <div class="rowline muted">
                    <span>등록일</span>
                    <span class="mono">
                      <c:choose>
                        <c:when test="${not empty createdTs}">${fn:substring(createdTs,0,16)}</c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </span>
                  </div>
                </div>

                <!-- foot -->
                <div class="card-foot">
                  <div class="btn-group">
                    <button class="btn-sm js-collapse-toggle collapsed"
                            data-target="#details_${pmNo}" data-parent="#acc_${pmNo}"
                            aria-expanded="false" aria-controls="details_${pmNo}">
                      <i class="bi bi-card-list"></i> 상세
                    </button>

                    <form method="post" action="<c:url value='/personal/setDefault'/>" class="d-inline">
                      <input type="hidden" name="paymentMethodNo" value="${pmNo}"/>
                      <button class="btn-sm primary" type="submit" <c:if test="${isDef}">disabled</c:if>>
                        <i class="bi bi-star"></i> 기본으로
                      </button>
                    </form>

                    <button class="btn-sm danger" type="button"
                            data-bs-toggle="modal" data-bs-target="#deleteModal"
                            data-pm-no="${pmNo}" <c:if test="${isDef}">disabled</c:if>>
                      <i class="bi bi-trash3"></i> 삭제
                    </button>
                  </div>
                </div>

                <!-- collapse container -->
                <div id="acc_${pmNo}">
                  <div class="collapse details" id="details_${pmNo}" data-bs-parent="#acc_${pmNo}">
                    <div class="kv"><div>금융기관</div><div><c:out value="${inst}"/></div></div>
                    <div class="kv"><div>결제코드</div><div><c:out value="${code}"/></div></div>
                    <div class="kv"><div>계좌/카드</div><div class="mono"><c:out value="${masked}"/></div></div>
                    <div class="kv"><div>유효기간</div><div class="mono"><c:out value="${empty exp ? '-' : exp}"/></div></div>
                    <div class="kv"><div>사용여부</div><div><c:out value="${useStat eq 'Y' ? 'Y' : 'N'}"/></div></div>
                    <div class="kv"><div>기본여부</div><div><c:out value="${isDef ? 'Y' : 'N'}"/></div></div>
                    <div class="kv"><div>등록일</div><div class="mono">
                      <c:choose>
                        <c:when test="${not empty createdTs}">${fn:substring(createdTs,0,16)}</c:when>
                        <c:otherwise>-</c:otherwise>
                      </c:choose>
                    </div></div>
                  </div>
                </div>

              </div><!-- /card-item -->
            </c:forEach>
          </div>

          <!-- 빈 상태 & 페이지네이션 -->
          <div id="emptyState" class="text-center text-muted py-5 d-none">조건에 맞는 결제수단이 없습니다.</div>
          <div id="pagination" class="pagination-wrapper"></div>
        </div><!-- /col-lg-9 -->

      </div><!-- /row -->
    </div><!-- /container -->
  </section>
</main>

<%@ include file="/WEB-INF/common/footer/footer.jsp"%>
<script src="<c:url value='/assets/vendor/bootstrap/js/bootstrap.bundle.min.js'/>"></script>

<!-- 삭제 확인 Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
  <div class="modal-dialog"><div class="modal-content">
    <form method="post" action="<c:url value='/personal/paymentCardDelete'/>">
      <div class="modal-header">
        <h5 class="modal-title" id="deleteModalLabel">결제수단 삭제</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="닫기"></button>
      </div>
      <div class="modal-body">
        <input type="hidden" name="paymentMethodNo" id="deletePmNo"/>
        기본으로 설정된 결제수단은 삭제할 수 없습니다. 삭제하시겠습니까?
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-light" data-bs-dismiss="modal">취소</button>
        <button type="submit" class="btn btn-danger">삭제</button>
      </div>
    </form>
  </div></div>
</div>

<!-- 목록 스크립트(검색/필터/정렬/페이징/복사/Collapse, 만료보정) -->
<script>
(function(){
  const grid = document.getElementById('cardsGrid');
  if(!grid) return;

  const cards = Array.from(grid.querySelectorAll('.card-item'));
  const searchInput = document.getElementById('searchInput');
  const pagination = document.getElementById('pagination');
  const emptyState = document.getElementById('emptyState');
  const pageSizeMenu = document.getElementById('pageSizeMenu');
  const pageSizeLabel = document.getElementById('pageSizeLabel');
  const chips = Array.from(document.querySelectorAll('.filters .chip'));

  const state = { filter:'all', query:'', page:1, pageSize:6 };

  function parseYM(ym){
    if(!ym || !/^\d{4}-\d{2}$/.test(ym)) return null;
    const [y,m]=ym.split('-').map(Number);
    return {y,m};
  }
  function isExpired(exp){
    const d = new Date();
    const y = d.getFullYear(), m = d.getMonth()+1;
    const p = parseYM(exp);
    if(!p) return false;
    return (p.y < y) || (p.y === y && p.m < m);
  }
  function ensureExpiryStatus(){
    cards.forEach(card=>{
      const exp = card.dataset.expiry || '';
      const code = (card.dataset.code || '').toUpperCase();
      if(exp && (code.includes('CARD') || code==='CARD')){
        if(isExpired(exp)){
          card.dataset.status = 'EXPIRED';
          const badge = card.querySelector('.js-status-badge');
          if(badge){
            badge.className = 'badge expired js-status-badge';
            badge.textContent = '만료';
          }
        }
      }
    });
  }

  function tsOf(card){
    const raw = (card.dataset.createdTs||'').trim();
    if(!raw) return 0;
    const iso = raw.includes('T') ? raw : raw.replace(' ','T');
    const t = Date.parse(iso);
    return isNaN(t) ? 0 : t;
  }
  function matchesFilter(card){
    if(state.filter==='all') return true;
    if(state.filter==='default') return card.dataset.default === 'true';
    return (card.dataset.status||'').toUpperCase() === state.filter;
  }
  function matchesQuery(card){
    if(!state.query) return true;
    const q = state.query;
    const text = (card.textContent||'').toLowerCase();
    const inst = (card.dataset.inst||'');
    const last4 = (card.dataset.last4||'');
    const code = (card.dataset.code||'').toLowerCase();
    return text.indexOf(q)>-1 || inst.indexOf(q)>-1 || last4.indexOf(q)>-1 || code.indexOf(q)>-1;
  }
  function getSortedAll(){ return cards.slice().sort((a,b)=>tsOf(b)-tsOf(a)); }
  function getFiltered(sortedAll){ return sortedAll.filter(c=>matchesFilter(c)&&matchesQuery(c)); }

  function render(){
    ensureExpiryStatus();

    const sortedAll = getSortedAll();
    const frag = document.createDocumentFragment();
    sortedAll.forEach(c=>frag.appendChild(c));
    grid.appendChild(frag);

    const list = getFiltered(sortedAll);
    cards.forEach(c=>{ c.style.display='none'; });

    const total = list.length;
    const totalPages = Math.max(1, Math.ceil(total/state.pageSize));
    if(state.page>totalPages) state.page = 1;

    const start = (state.page-1)*state.pageSize;
    const end = start + state.pageSize;
    list.slice(start, end).forEach(c=>{ c.style.display=''; });

    emptyState.classList.toggle('d-none', total!==0);
    renderPagination(totalPages);
  }

  function renderPagination(totalPages){
    pagination.innerHTML='';
    const total = totalPages>0 ? totalPages : 1;

    const prev=document.createElement('button');
    prev.type='button'; prev.className='btn-prev';
    prev.innerHTML='<i class="bi bi-chevron-left"></i>';
    prev.disabled = state.page===1;
    prev.addEventListener('click', ()=>{ if(state.page>1){ state.page--; render(); }});
    pagination.appendChild(prev);

    const pagesWrap=document.createElement('div');
    pagesWrap.className='page-numbers';
    const win=2;
    let s=Math.max(1,state.page-win);
    let e=Math.min(total,state.page+win);
    if(state.page<=win) e=Math.min(total,1+2*win);
    if(state.page+win>total) s=Math.max(1,total-2*win);

    function addBtn(p){
      const b=document.createElement('button');
      b.type='button';
      if(p===state.page) b.classList.add('active');
      b.textContent=String(p);
      b.addEventListener('click', ()=>{ state.page=p; render(); });
      pagesWrap.appendChild(b);
    }
    if(s>1){ addBtn(1); if(s>2){ const gap1=document.createElement('span'); gap1.className='gap'; gap1.textContent='…'; pagesWrap.appendChild(gap1);} }
    for(let p=s; p<=e; p++) addBtn(p);
    if(e<total){ if(e<total-1){ const gap2=document.createElement('span'); gap2.className='gap'; gap2.textContent='…'; pagesWrap.appendChild(gap2);} addBtn(total); }

    pagination.appendChild(pagesWrap);

    const next=document.createElement('button');
    next.type='button'; next.className='btn-next';
    next.innerHTML='<i class="bi bi-chevron-right"></i>';
    next.disabled = state.page===total;
    next.addEventListener('click', ()=>{ if(state.page<total){ state.page++; render(); }});
    pagination.appendChild(next);
  }

  // 검색
  document.addEventListener('input', (e)=>{
    if(e.target===searchInput){
      state.query = (e.target.value||'').trim().toLowerCase();
      state.page = 1; render();
    }
  });

  // 필터 칩
  chips.forEach(chip=>{
    chip.addEventListener('click', ()=>{
      chips.forEach(c=>c.classList.remove('active'));
      chip.classList.add('active');
      state.filter = chip.dataset.filter;
      state.page = 1; render();
    });
  });

  // 페이지 크기
  document.addEventListener('click', function(e){
    const a = e.target.closest('#pageSizeMenu .js-pagesize');
    if(!a) return;
    e.preventDefault();
    const size = parseInt(a.dataset.size,10);
    if(!isNaN(size)&&size>0){
      state.pageSize = size;
      if(pageSizeLabel) pageSizeLabel.textContent = a.textContent.trim();
      state.page = 1; render();
    }
    const dropdown = a.closest('.dropdown');
    if (dropdown){
      const toggle = dropdown.previousElementSibling;
      if (toggle){ const inst = bootstrap.Dropdown.getOrCreateInstance(toggle); inst.hide(); }
    }
  });

  // 복사
  grid.addEventListener('click', function(e){
    const copyBtn = e.target.closest('.copy-btn');
    if(copyBtn && grid.contains(copyBtn)){
      const val = copyBtn.dataset.copy || '';
      if(val){
        navigator.clipboard?.writeText(val).then(()=>{
          const prev = copyBtn.innerHTML;
          copyBtn.innerHTML = '<i class="bi bi-check2"></i>';
          setTimeout(()=> copyBtn.innerHTML = prev, 1200);
        });
      }
    }
  });

  // Collapse(배타)
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

  render();
})();
</script>

<!-- 모달 주입 -->
<script>
(function(){
  const deleteModal = document.getElementById('deleteModal');
  deleteModal?.addEventListener('show.bs.modal', function (event) {
    const btn = event.relatedTarget;
    const pmNo = btn?.getAttribute('data-pm-no') || '';
    document.getElementById('deletePmNo').value = pmNo;
  });
})();
</script>

<!-- 헤더 드롭다운 안전장치(공통) -->
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
</script>

</body>
</html>
