<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>공지사항 수정</title>
<!-- Froala CSS -->
<link href="https://cdn.jsdelivr.net/npm/froala-editor@4.0.15/css/froala_editor.pkgd.min.css" rel="stylesheet" type="text/css" />
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

	<!-- Page Title -->
	<div class="page-title light-background">
		<div class="container d-lg-flex justify-content-between align-items-center">
			<h1 class="mb-2 mb-lg-0">Notice</h1>
			<nav class="breadcrumbs">
				<ol>
					<li><%@include file="/WEB-INF/common/home.jsp"%></li>
					<li class="current">Notice</li>
				</ol>
			</nav>
		</div>
	</div>
	<!-- End Page Title -->

	<!-- Contact 2 Section -->
	<section id="contact-2" class="contact-2 section">

		<!-- Contact Form Section -->
		<div class="container">
			<div class="row justify-content-center" data-aos="fade-up" data-aos-delay="300">
				<div class="col-lg-10">
					<div class="contact-form-wrapper">
						<h2 class="text-center mb-4">공지사항 수정</h2>
							<!-- 공지사항 수정 폼 -->
							<form action="/admin/noticeUpdate" method="post">
							<!-- boardNo hidden -->
    						<input type="hidden" name="boardNo" value="${noticeOne.boardNo}">
							<div class="row g-3">
								<!-- 제목 -->
								<div class="col-md-12">
									<div class="form-group">
										<div class="input-with-icon">
											<i class="bi bi-text-left"></i>
											<input type="text" class="form-control" name="boardTitle" value="${noticeOne.boardTitle}" placeholder="제목" required>
										</div>
									</div>
								</div>
								<!-- 내용 -->
								<div class="col-12">
									<div class="form-group">
										<div class="input-with-icon">
											<textarea id="boardContent" name="boardContent">${noticeOne.boardContent}</textarea>
										</div>
									</div>
								</div>
								<!-- 사용 여부 -->
								<div class="col-md-12">
									<div class="form-group">
										<select id="useStatus" name="useStatus" class="form-select" required>
											<option value="Y" ${noticeOne.useStatus == 'Y' ? 'selected' : ''}>사용 여부 : 사용</option>
											<option value="N" ${noticeOne.useStatus == 'N' ? 'selected' : ''}>사용 여부 : 미사용</option>
										</select>
									</div>
								</div>
								<!-- 버튼 -->
								<section class="register py-1">
									<div class="d-grid">
										<button type="submit" class="btn btn-register">수정</button>
									</div>
								</section>
							</div>
						</form>
						
					</div>
				</div>
			</div>
		</div>

	</section>
	<!-- /Contact 2 Section -->
	
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- Froala JS -->
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/froala-editor@4.0.15/js/froala_editor.pkgd.min.js"></script>
<!-- Froala Language Pack (Korean) -->
<script src="https://cdn.jsdelivr.net/npm/froala-editor@4.0.15/js/languages/ko.js"></script>
<script>
	new FroalaEditor('#boardContent', {
		height : 500,
		language : 'ko',
		placeholderText : '공지사항 내용을 입력하세요.',
		toolbarSticky : true, // 툴바 고정
		quickInsertEnabled : true, // 빠른 삽입 기능
		imageUpload : false,

		// Enter → <br> / Shift + Enter → <p>
		enter: FroalaEditor.ENTER_BR,
		shiftEnter: FroalaEditor.ENTER_P
	});
</script>

</body>
</html>