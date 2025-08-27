<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <meta content="width=device-width, initial-scale=1.0" name="viewport">
  <title>Index - NiceShop Bootstrap Template</title>
  <meta name="description" content="">
  <meta name="keywords" content="">

  <!-- Favicons -->
  <link href="/assets/img/favicon.png" rel="icon">
  <link href="/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

  <!-- Fonts -->
  <link href="https://fonts.googleapis.com" rel="preconnect">
  <link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Montserrat:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

  <!-- Vendor CSS Files -->
  <link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
  <link href="/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
  <link href="/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
  <link href="/assets/vendor/aos/aos.css" rel="stylesheet">
  <link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
  <link href="/assets/vendor/drift-zoom/drift-basic.css" rel="stylesheet">

  <!-- Main CSS File -->
  <link href="/assets/css/main.css" rel="stylesheet">

  <!-- =======================================================
  * Template Name: NiceShop
  * Template URL: https://bootstrapmade.com/niceshop-bootstrap-ecommerce-template/
  * Updated: Jul 25 2025 with Bootstrap v5.3.7
  * Author: BootstrapMade.com
  * License: https://bootstrapmade.com/license/
  ======================================================== -->
</head>

<body class="index-page">

  <header id="header" class="header sticky-top">
    <!-- Main Header -->
    <div class="main-header">
      <div class="container-fluid container-xl">
        <div class="d-flex py-3 align-items-center justify-content-between">

          <!-- Logo -->
          <a href="index.html" class="logo d-flex align-items-center">
            <!-- Uncomment the line below if you also wish to use an image logo -->
            <!-- <img src="assets/img/logo.webp" alt=""> -->
            <h1 class="sitename">NiceShop</h1>
          </a>


          <!-- Actions -->
          <div class="header-actions d-flex align-items-center justify-content-end">

            <!-- Mobile Search Toggle -->
            <button class="header-action-btn mobile-search-toggle d-xl-none" type="button" data-bs-toggle="collapse" data-bs-target="#mobileSearch" aria-expanded="false" aria-controls="mobileSearch">
              <i class="bi bi-search"></i>
            </button>
			<a href="#" class="dropdown-toggle" data-bs-toggle="dropdown">
              <i class="bi bi-translate me-2"></i>EN
            </a>
            <ul class="dropdown-menu">
              <li><a class="dropdown-item" href="#"><i class="bi bi-check2 me-2 selected-icon"></i>English</a></li>
              <li><a class="dropdown-item" href="#">Español</a></li>
              <li><a class="dropdown-item" href="#">Français</a></li>
              <li><a class="dropdown-item" href="#">Deutsch</a></li>
            </ul>
            <!-- Account -->
            <div class="dropdown account-dropdown">
              <button class="header-action-btn" data-bs-toggle="dropdown">
                <i class="bi bi-person"></i>
              </button>
              <div class="dropdown-menu">
                <div class="dropdown-header">
                  <h6>Welcome to <span class="sitename">FashionStore</span></h6>
                  <p class="mb-0">Access account &amp; manage orders</p>
                </div>
                <div class="dropdown-body">
                  <a class="dropdown-item d-flex align-items-center" href="account.html">
                    <i class="bi bi-person-circle me-2"></i>
                    <span>My Profile</span>
                  </a>
                  <a class="dropdown-item d-flex align-items-center" href="account.html">
                    <i class="bi bi-bag-check me-2"></i>
                    <span>My Orders</span>
                  </a>
                  <a class="dropdown-item d-flex align-items-center" href="account.html">
                    <i class="bi bi-heart me-2"></i>
                    <span>My Wishlist</span>
                  </a>
                  <a class="dropdown-item d-flex align-items-center" href="account.html">
                    <i class="bi bi-gear me-2"></i>
                    <span>Settings</span>
                  </a>
                </div>
                <div class="dropdown-footer">
                  <a href="register.html" class="btn btn-primary w-100 mb-2">Sign In</a>
                  <a href="login.html" class="btn btn-outline-primary w-100">Register</a>
                </div>
              </div>
            </div>

            <!-- Wishlist -->
            <a href="account.html" class="header-action-btn d-none d-md-block">
              <i class="bi bi-heart"></i>
              <span class="badge">0</span>
            </a>

            <!-- Cart -->
            <a href="cart.html" class="header-action-btn">
              <i class="bi bi-cart3"></i>
              <span class="badge">3</span>
            </a>

            <!-- Mobile Navigation Toggle -->
            <i class="mobile-nav-toggle d-xl-none bi bi-list me-0"></i>

          </div>
        </div>
      </div>
    </div>

    <!-- Navigation -->
    <div class="header-nav">
      <div class="container-fluid container-xl position-relative">
        <nav id="navmenu" class="navmenu">
          <ul>
            <li><a href="index.html" class="active">Home</a></li>
            <li><a href="about.html">About</a></li>
            <li><a href="category.html">Category</a></li>
            <li><a href="product-details.html">Product Details</a></li>
            <li><a href="cart.html">Cart</a></li>
            <li><a href="checkout.html">Checkout</a></li>

          </ul>
        </nav>
      </div>
    </div>

    <!-- Mobile Search Form -->
    <div class="collapse" id="mobileSearch">
      <div class="container">
        <form class="search-form">
          <div class="input-group">
            <input type="text" class="form-control" placeholder="Search for products">
            <button class="btn" type="submit">
              <i class="bi bi-search"></i>
            </button>
          </div>
        </form>
      </div>
    </div>

  </header>
  
<header style="border-bottom:1px solid #e5e7eb; background:#ffffff;">
  <!-- 전체 헤더 컨테이너 -->
  <div style="max-width:1200px; margin:0 auto; padding:8px 12px; display:flex; align-items:flex-end; justify-content:space-between;">
<!-- 좌측: 로고 + 텍스트 로고 -->
<div style="display:flex; align-items:center; gap:5px; flex:1.5;">
  <a href="/admin/mainPage" style="display:flex; align-items:center;">
    <img src="${pageContext.request.contextPath}/images/freestyle.jpg"
         alt="FreeStyle 이미지 로고"
         style="height:130px; width:auto; object-fit:contain;">
  </a>
  <p>(admin header)</p>
  <a href="/admin/mainPage" style="display:flex; align-items:center; flex:1;">
    <img src="${pageContext.request.contextPath}/images/freestyle_text.png"
         alt="FreeStyle 텍스트 로고"
         style="height:110px; width:100%; object-fit:contain; padding-right:10px;">
  </a>
</div>
    <!-- 우측: 유틸 메뉴 + 메인 메뉴 -->
    <div style="display:flex; flex-direction:column; justify-content:flex-end; height:130px;">
      <!-- 유틸 메뉴 -->
      <div style="display:flex; gap:12px; font-size:14px; justify-content:flex-end;">
        <a href="/admin/insertProduct"     style="text-decoration:none; color:#374151;">상품 등록</a>
        <a href="/admin/productList" style="text-decoration:none; color:#374151;">상품 조회</a>
        <a href="/admin/inventoryList"     style="text-decoration:none; color:#374151;">재고 관리</a>
        <a href="#" style="text-decoration:none; color:#374151;">주문배송조회</a>
        <a href="/public/helpDesk"       style="text-decoration:none; color:#374151;">고객센터</a>
        <a href="/public/logout"       style="text-decoration:none; color:#111827;">로그아웃</a>
      </div>

      <!-- 메인 메뉴 -->
      <nav aria-label="Main Navigation" style="display:flex; gap:18px; font-size:15px; margin-top:auto;">
        <a href=""         style="text-decoration:none; color:#111827;">상품 카테고리</a>
        <a href="/biz/productRequest" style="text-decoration:none; color:#111827;">구매 견적 요청</a>
        <a href="/public/reviewList"  style="text-decoration:none; color:#111827;">상품 후기</a>
      </nav>
    </div>

  </div>
</header>
