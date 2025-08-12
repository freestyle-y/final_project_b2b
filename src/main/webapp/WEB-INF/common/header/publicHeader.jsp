<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header style="border-bottom:1px solid #e5e7eb; background:#ffffff;">
  <!-- 상단 유틸 헤더 -->
  <div style="max-width:1200px; margin:0 auto; padding:6px 12px; display:flex; gap:12px; justify-content:flex-end; font-size:14px;">
    <a href="/public/joinMember"        style="text-decoration:none; color:#374151;">회원가입</a>
    <a href="/personal/shoppingCart"          style="text-decoration:none; color:#374151;">장바구니</a>
    <a href="/personal/wishList"      style="text-decoration:none; color:#374151;">찜 목록</a>
    <a href="/personal/deliveryList"  style="text-decoration:none; color:#374151;">주문배송조회</a>
    <a href="/public/helpDesk"       style="text-decoration:none; color:#374151;">고객센터</a>
  </div>

   <!-- 메인 헤더 -->
  <div style="max-width:1200px; margin:0 auto; padding:10px 12px; display:flex; align-items:center; justify-content:space-between;">
    <!-- 로고 (이미지) -->
    <a href="/public/mainPage" style="display:flex; align-items:center;">
      <img src="<%=request.getContextPath()%>/resources/images/freestyle.jpg" 
           alt="FreeStyle 로고" 
           style="height:100px; width:auto; object-fit:contain;">
    </a>
    <!-- 메인 메뉴 -->
    <nav aria-label="Main Navigation" style="display:flex; gap:18px; font-size:15px;">
      <a href="/categories"     style="text-decoration:none; color:#111827;">상품 카테고리</a>
      <a href="/biz/productRequest"  style="text-decoration:none; color:#111827;">구매 견적 요청</a>
      <a href="/public/reviewList"        style="text-decoration:none; color:#111827;">상품 후기</a>
      <a href="/public/login"   style="text-decoration:none; color:#111827;">로그인</a>
    </nav>
  </div>
</header>
