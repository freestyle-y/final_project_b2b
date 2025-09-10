<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header id="header" class="header sticky-top">
	<!-- Main Header -->
	<div class="main-header">
		<div class="container-fluid container-xl">
			<div class="d-flex py-3 align-items-center justify-content-between">

				<!-- Logo -->
				<a href="/biz/mainPage" class="logo d-flex align-items-center"> <!-- Uncomment the line below if you also wish to use an image logo -->
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
							</div>
						</div>
					</div>
					
					<!-- Alarm -->
					<div class="dropdown account-dropdown">
						<button class="header-action-btn" data-bs-toggle="dropdown">
							<i class="bi bi-bell"></i>
							<span class="badge bg-danger" id="notiCount">0</span>
						</button>

						<div class="dropdown-menu dropdown-menu-end p-0" style="width: 360px;">
							<!-- Header -->
							<div class="dropdown-header border-bottom px-3 py-2">
								<h6 class="mb-0">알림 목록</h6>
							</div>

							<!-- 알림 리스트 -->
							<div class="dropdown-body px-0 py-0" id="notiList" style="max-height: 600px; overflow-y: auto;">
								<p class="text-center text-muted my-3">새로운 알림이 없습니다.</p>
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
					<li><a href="/biz/mainPage" class="active">Home</a></li>
					<li><a href="/biz/productList">상품 목록</a></li>
					<li><a href="/biz/productRequest">상품 요청</a></li>
					<li><a href="/biz/productRequestList">상품 요청 목록</a></li>
					<li><a href="/biz/quotationList?userId=biz001">견적서</a></li>
					<li><a href="/biz/contractList?userId=biz001">계약서</a></li>
					<li><a href="/biz/deliveryList">주문배송조회</a></li>
					<li><a href="/public/helpDesk">고객센터</a></li>
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

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script>
	// 알림 개수 갱신
	function updateNotificationCount() {
		$.ajax({
			url: "/member/notificationCount",
			type: "GET",
			success: function(count) {
				$("#notiCount").text(count);
			}
		});
	}

	function loadNotifications() {
		$.ajax({
			url: "/member/notificationList", // 알림 목록을 가져오는 API
			type: "GET",
			success: function(data) {
				// 알림 리스트 영역 초기화
				$("#notiList").empty();
	
				// 알림이 없을 경우
				if(data.length === 0) {
					// "새로운 알림이 없습니다" 문구 출력
					$("#notiList").append('<p class="text-center text-muted my-3">새로운 알림이 없습니다.</p>');
					// 뱃지 숫자 0으로 표시
					$("#notiCount").text(0);
				} else {
					// 알림 개수를 뱃지에 표시
					$("#notiCount").text(data.length);

					// 알림 목록 반복 출력
					data.forEach(function(n, idx) {
						// 마지막 항목 여부 확인 (마지막이면 border-bottom 제거)
						const isLast = (idx === data.length - 1);
						
						// 읽음 여부에 따라 클래스 적용
						const readClass = (n.readStatus === 'Y') ? ' bg-secondary-subtle' : '';

						// 알림 목록 HTML 생성 및 추가
						$("#notiList").append(
							'<a href="' + (n.targetUrl || '#') + '" ' +
							'class="notification-entry d-flex align-items-start px-3 py-2 text-decoration-none' + (isLast ? '' : ' border-bottom') + readClass + '"' +
							 // 알림 클릭 시 읽음 처리
							' onclick="markAsRead(' + n.notificationNo + ')">' +
								// 알림 아이콘(현재 기본 아이콘)
								'<i class="bi bi-info-circle text-primary me-2 fs-5"></i>' +
								'<div class="flex-grow-1">' +
									// 알림 제목 (알림 읽었을 경우 fw-normal, 안 읽었을 경우 fw-semibold)
									'<div class="' + (n.readStatus === 'Y' ? 'fw-normal text-muted' : 'fw-semibold') + ' small">' + n.notificationTitle + '</div>' +
									// 알림 내용
									'<div class="small ' + (n.readStatus === 'Y' ? 'text-muted' : '') + '">' + n.notificationContent + '</div>' +
									// 알림 생성일
									'<div class="text-muted small">' + n.createDate + '</div>' +
								'</div>' +
							'</a>'
						);
					});
				}
				// 리스트 갱신 후 개수도 다시 갱신
				updateNotificationCount();
			}
		});
	}

	// 알림 읽음 처리
	function markAsRead(notificationNo) {
		$.post("/member/notificationRead", { notificationNo: notificationNo }, function() {
			updateNotificationCount(); // 읽음 처리 후 뱃지 숫자 갱신
			
			// 클릭한 알림 항목에 즉시 회색 처리
			const $target = $("a[onclick*='" + notificationNo + "']");
			$target.addClass("bg-secondary-subtle");
			$target.find(".fw-semibold").removeClass("fw-semibold").addClass("fw-normal text-muted");
			$target.find(".small:not(.text-muted)").addClass("text-muted");
		});
	}
	
	// 페이지 로드 시 실행 + 60초마다 새로고침
	$(document).ready(function() {
		loadNotifications();
		updateNotificationCount();
		setInterval(function() {
			loadNotifications();
			updateNotificationCount();
		}, 60000);
	});
</script>