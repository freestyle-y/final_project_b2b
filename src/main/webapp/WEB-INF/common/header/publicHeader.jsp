<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header style="border-bottom:1px solid #e5e7eb; background:#ffffff;">
  <!-- 전체 헤더 컨테이너 -->
  <div style="max-width:1200px; margin:0 auto; padding:8px 12px; display:flex; align-items:flex-end; justify-content:space-between;">
<!-- 좌측: 로고 + 텍스트 로고 -->
<div style="display:flex; align-items:center; gap:5px; flex:1.5;">
  <a href="/public/mainPage" style="display:flex; align-items:center;">
    <img src="${pageContext.request.contextPath}/images/freestyle.jpg"
         alt="FreeStyle 이미지 로고"
         style="height:130px; width:auto; object-fit:contain;">
  </a>
  <a href="/public/mainPage" style="display:flex; align-items:center; flex:1;">
    <img src="${pageContext.request.contextPath}/images/freestyle_text.png"
         alt="FreeStyle 텍스트 로고"
         style="height:110px; width:100%; object-fit:contain; padding-right:10px;">
  </a>
</div>
    <!-- 우측: 유틸 메뉴 + 메인 메뉴 -->
    <div style="display:flex; flex-direction:column; justify-content:flex-end; height:130px;">
      <!-- 유틸 메뉴 -->
      <div style="display:flex; gap:12px; font-size:14px; justify-content:flex-end;">
        <a href="/public/joinMember"     style="text-decoration:none; color:#374151;">회원가입</a>
        <a href="/personal/shoppingCart" style="text-decoration:none; color:#374151;">장바구니</a>
        <a href="/personal/wishList"     style="text-decoration:none; color:#374151;">찜 목록</a>
        <a href="/personal/deliveryList" style="text-decoration:none; color:#374151;">주문배송조회</a>
        <a href="/public/helpDesk"       style="text-decoration:none; color:#374151;">고객센터</a>
      </div>

      <!-- 메인 메뉴 -->
      <nav aria-label="Main Navigation" style="display:flex; gap:18px; font-size:15px; margin-top:auto;">
        <a href="/categories"         style="text-decoration:none; color:#111827;">상품 카테고리</a>
        <a href="/biz/productRequest" style="text-decoration:none; color:#111827;">구매 견적 요청</a>
        <a href="/public/reviewList"  style="text-decoration:none; color:#111827;">상품 후기</a>
        <a href="/public/login"       style="text-decoration:none; color:#111827;">로그인</a>
      </nav>
    </div>

  </div>
</header>
