<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>로그인</title>
<meta name="description" content="로그인 페이지입니다.">
<meta name="keywords" content="로그인, 회원가입, 계정, 비밀번호 찾기">

<link href="/assets/img/favicon.png" rel="icon">
<link href="/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Montserrat:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

<link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
<link href="/assets/vendor/aos/aos.css" rel="stylesheet">
<link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
<link href="/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
<link href="/assets/vendor/drift-zoom/drift-basic.css" rel="stylesheet">

<link href="/assets/css/main.css" rel="stylesheet">

<style>
/* 아래 스타일은 템플릿의 CSS 파일에 정의된 내용을 포함합니다. */
:root {
  --primary-color: #007bff;
  --secondary-color: #6c757d;
  --success-color: #28a745;
  --info-color: #17a2b8;
  --warning-color: #ffc107;
  --danger-color: #dc3545;
  --light-color: #f8f9fa;
  --dark-color: #343a40;
  --white: #fff;
  --gray-100: #f8f9fa;
  --gray-200: #e9ecef;
  --gray-300: #dee2e6;
  --gray-400: #ced4da;
  --gray-500: #adb5bd;
  --gray-600: #6c757d;
  --gray-700: #495057;
  --gray-800: #343a40;
  --gray-900: #212529;
}

body {
  font-family: 'Poppins', sans-serif;
  background-color: var(--gray-100);
  margin: 0;
  min-height: 100vh;
  display: flex;
  flex-direction: column;
}

.main-content {
  flex: 1;
  display: flex;
  justify-content: center;
  align-items: center;
  padding: 40px 0;
}

.auth-container {
  width: 100%;
  max-width: 400px;
  background: var(--white);
  border-radius: 12px;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.05);
  overflow: hidden;
  display: flex;
  flex-direction: column;
}

.auth-form {
  padding: 40px;
  display: none;
  animation: fadeIn 0.5s ease-in-out;
}

.auth-form.active {
  display: block;
}

@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.form-header {
  text-align: center;
  margin-bottom: 30px;
}

.form-header h3 {
  font-size: 24px;
  font-weight: 600;
  color: var(--gray-800);
  margin-bottom: 8px;
}

.form-header p {
  font-size: 14px;
  color: var(--gray-600);
  margin: 0;
}

.input-group {
  position: relative;
  margin-bottom: 20px;
}

.input-icon {
  position: absolute;
  left: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--gray-500);
  font-size: 18px;
  pointer-events: none;
}

.input-group .form-control {
  width: 100%;
  padding: 12px 12px 12px 45px;
  border: 1px solid var(--gray-300);
  border-radius: 8px;
  font-size: 15px;
  transition: all 0.3s ease;
}

.input-group .form-control:focus {
  outline: none;
  border-color: var(--primary-color);
  box-shadow: 0 0 0 3px rgba(0, 123, 255, 0.1);
}

.password-toggle {
  position: absolute;
  right: 15px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--gray-500);
  cursor: pointer;
  font-size: 18px;
}

.form-options {
  display: flex;
  justify-content: space-between;
  align-items: center;
  font-size: 14px;
  margin-bottom: 25px;
}

.remember-me {
  display: flex;
  align-items: center;
}

.remember-me input[type="checkbox"] {
  width: auto;
  margin-right: 8px;
  cursor: pointer;
}

.remember-me label {
  color: var(--gray-700);
  margin: 0;
}

.forgot-password {
  color: var(--primary-color);
  text-decoration: none;
  transition: color 0.3s ease;
}

.forgot-password:hover {
  text-decoration: underline;
}

.auth-btn {
  width: 100%;
  padding: 14px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  transition: all 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
  text-decoration: none;
}

.primary-btn {
  background-color: var(--primary-color);
  color: var(--white);
}

.primary-btn:hover {
  background-color: #0056b3;
}

.auth-btn i {
  margin-left: 8px;
}

.divider {
  text-align: center;
  margin: 25px 0;
  position: relative;
  font-size: 14px;
  color: var(--gray-500);
}

.divider::before,
.divider::after {
  content: '';
  position: absolute;
  top: 50%;
  width: 40%;
  height: 1px;
  background-color: var(--gray-300);
}

.divider::before {
  left: 0;
}

.divider::after {
  right: 0;
}

.social-btn {
  background-color: var(--white);
  color: var(--gray-700);
  border: 1px solid var(--gray-300);
}

.social-btn:hover {
  background-color: var(--gray-100);
}

.social-btn i {
  margin-right: 8px;
}

.switch-form {
  text-align: center;
  margin-top: 25px;
  font-size: 14px;
  color: var(--gray-700);
}

.switch-btn {
  background: none;
  border: none;
  color: var(--primary-color);
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  padding: 0;
  margin-left: 5px;
  text-decoration: underline;
}

.name-row {
  display: flex;
  gap: 10px;
  margin-bottom: 20px;
}

.name-row .input-group {
  margin-bottom: 0;
}

.terms-check {
  display: flex;
  align-items: flex-start;
  font-size: 13px;
  color: var(--gray-700);
  margin-bottom: 25px;
}

.terms-check input[type="checkbox"] {
  margin-right: 10px;
  margin-top: 2px;
}

.terms-check a {
  color: var(--primary-color);
  text-decoration: none;
  font-weight: 500;
}

.terms-check a:hover {
  text-decoration: underline;
}
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">
    <section id="login" class="login section">
        <div class="main-content" data-aos="fade-up" data-aos-delay="100">
            <div class="auth-container" data-aos="fade-in" data-aos-delay="200">
                <div class="auth-form login-form active">
                    <div class="form-header">
                        <h3>Welcome Back</h3>
                        <p>Sign in to your account</p>
                    </div>

                    <c:if test="${not empty param.errorMsg}">
                        <div style="color: red; text-align: center; margin-bottom: 15px; font-size: 14px;">
                            ${param.errorMsg}
                        </div>
                    </c:if>

                    <form action="/public/loginAction" method="post" class="auth-form-content">
                        <div class="input-group">
                            <span class="input-icon">
                                <i class="bi bi-person"></i>
                            </span>
                            <input type="text" id="username" name="username" class="form-control" placeholder="아이디" required="" autocomplete="username">
                        </div>

                        <div class="input-group mb-3">
                            <span class="input-icon">
                                <i class="bi bi-lock"></i>
                            </span>
                            <input type="password" id="password" name="password" class="form-control" placeholder="비밀번호" required="" autocomplete="current-password">
                            <span class="password-toggle">
                                <i class="bi bi-eye"></i>
                            </span>
                        </div>

                        <div class="form-options mb-4">
                        	<a href="/public/findMemberId" class="forgot-password">아이디 찾기</a>
                            <a href="/public/findMemberPw" class="forgot-password">비밀번호 찾기</a>
                        </div>

                        <button type="submit" class="auth-btn primary-btn mb-3">
                            Sign In
                            <i class="bi bi-arrow-right"></i>
                        </button>

                        <div class="divider">
                            <span>or</span>
                        </div>

                        <a href="/oauth2/authorization/naver" class="auth-btn social-btn mb-3" style="background-color: #03C75A; color: white;">
						    <i class="fa-solid fa-n"></i>
						    네이버로 로그인
						</a>
                        <a href="/oauth2/authorization/kakao" class="auth-btn social-btn" style="background-color: #FEE500; color: #3C1E1E;">
						    <i class="fa-solid fa-k"></i>
						    카카오로 로그인
						</a>

                        <div class="switch-form">
                            <span>Don't have an account?</span>
                            <a href="/public/joinMember" class="switch-btn">회원가입</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/assets/vendor/swiper/swiper-bundle.min.js"></script>
<script src="/assets/vendor/aos/aos.js"></script>
<script src="/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="/assets/vendor/isotope-layout/isotope.pkgd.min.js"></script>
<script src="/assets/vendor/imagesloaded/imagesloaded.pkgd.min.js"></script>
<script src="/assets/vendor/shufflejs/shuffle.min.js"></script>
<script src="/assets/vendor/purecounter/purecounter_vanilla.js"></script>
<script src="/assets/vendor/drift-zoom/Drift.min.js"></script>
<script src="/assets/js/main.js"></script>
<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true,
        mirror: false
    });

    const passwordToggles = document.querySelectorAll('.password-toggle');
    passwordToggles.forEach(toggle => {
        toggle.addEventListener('click', () => {
            const passwordInput = toggle.previousElementSibling;
            const icon = toggle.querySelector('i');
            if (passwordInput.type === 'password') {
                passwordInput.type = 'text';
                icon.classList.remove('bi-eye');
                icon.classList.add('bi-eye-slash');
            } else {
                passwordInput.type = 'password';
                icon.classList.remove('bi-eye-slash');
                icon.classList.add('bi-eye');
            }
        });
    });
</script>

</body>
</html>