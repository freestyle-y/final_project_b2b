<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<header id="header" class="header sticky-top">
	<!-- Main Header -->
	<div class="main-header">
		<div class="container-fluid container-xl">
			<div class="d-flex py-3 align-items-center justify-content-between">

				<!-- Logo -->
				<a href="/admin/mainPage" class="logo d-flex align-items-center"> <!-- Uncomment the line below if you also wish to use an image logo -->
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
								<a class="dropdown-item d-flex align-items-center" href="account.html">
									<i class="bi bi-person-circle me-2"></i>
									<span>My Profile</span>
								</a>
								<a class="dropdown-item d-flex align-items-center" href="account.html">
									<i class="bi bi-gear me-2"></i>
									<span>Settings</span>
								</a>
							</div>
						</div>
					</div>

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
					<li><a href="/admin/mainPage" class="active">Home</a></li>
					<li><a href="/admin/insertProduct">상품 등록</a></li>
					<li><a href="/admin/productList">상품 조회</a></li>
					<li><a href="/admin/inventoryList">재고 관리</a></li>
					<li><a href="/public/reviewList">상품 후기</a></li>
					<li class="dropdown"><a href="#"><span>고객센터 관리</span><i class="bi bi-chevron-down toggle-dropdown"></i></a>
						<ul>
							<li><a href="/admin/noticeList">공지사항 관리</a></li>
							<li><a href="/admin/FAQList">자주 묻는 질문 관리</a></li>
							<li><a href="/admin/QNAList">문의 내역 관리</a></li>
						</ul>
					</li>
					<li><a href="/admin/updateCategory">카테고리 수정</a></li>
					<li><a href="/admin/updateOption">옵션 수정</a></li>
					<li><a href="/public/logout">로그아웃</a></li>
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