<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header id="header" class="header sticky-top">
	<!-- Main Header -->
	<div class="main-header">
		<div class="container-fluid container-xl">
			<div class="d-flex py-3 align-items-center justify-content-between">

				<!-- Logo -->
				<a href="/public/mainPage" class="logo d-flex align-items-center"> <!-- Uncomment the line below if you also wish to use an image logo -->
					<!-- <img src="assets/img/logo.webp" alt=""> -->
					<h1 class="sitename">FreeStyle</h1>
				</a>


				<!-- Actions -->
				<div class="header-actions d-flex align-items-center justify-content-end">

					<!-- Mobile Search Toggle -->
					<button class="header-action-btn mobile-search-toggle d-xl-none" type="button" data-bs-toggle="collapse" data-bs-target="#mobileSearch" aria-expanded="false" aria-controls="mobileSearch">
						<i class="bi bi-search"></i>
					</button>
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
								<a class="dropdown-item d-flex align-items-center" href="/member/myPage">
									<i class="bi bi-person-circle me-2"></i>
									<span>My Profile</span>
								</a>
								<a class="dropdown-item d-flex align-items-center" href="/personal/deliveryList">
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
								<a href="/public/login" class="btn btn-primary w-100 mb-2">Log In</a>
								<a href="/public/joinMember" class="btn btn-outline-primary w-100">Register</a>
							</div>
						</div>
					</div>

					<!-- Wishlist -->
					<a href="/personal/wishList" class="header-action-btn d-none d-md-block">
						<i class="bi bi-heart"></i>
						<span class="badge">0</span>
					</a>

					<!-- Cart -->
					<a href="/personal/shoppingCart" class="header-action-btn">
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
					<li><a href="/public/mainPage" class="active">Home</a></li>
					<li><a href="/categories">상품 카테고리</a></li>
					<li><a href="/biz/productRequest">구매 견적 요청</a></li>
					<li><a href="/public/reviewList">상품 후기</a></li>
					<li><a href="/personal/deliveryList">회원가입</a></li>
					<li><a href="/personal/deliveryList">주문배송조회</a></li>
					<li><a href="/public/helpDesk">고객센터</a></li>
					<li><a href="/public/login">로그인</a></li>
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