<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>비밀번호 변경</title>
<meta name="description" content="회원 비밀번호를 변경하는 페이지입니다.">
<meta name="keywords" content="비밀번호, 변경, 회원, 로그인">

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

.validation-msg {
    font-size: 13px;
    margin-top: 5px;
    padding-left: 45px;
}
.validation-msg.error-msg {
    color: var(--danger-color);
}
.validation-msg.success-msg {
    color: var(--success-color);
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
                        <h3>비밀번호 변경</h3>
                        <p>새로운 비밀번호를 입력해주세요</p>
                    </div>

                    <c:if test="${not empty error}">
                        <div style="color: red; text-align: center; margin-bottom: 15px; font-size: 14px;">
                            ${error}
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty success}">
                        <div style="color: green; text-align: center; margin-bottom: 15px; font-size: 14px;">
                            ${success}
                        </div>
                    </c:if>

                    <form id="pwForm" action="/member/changeMemberPw" method="post" class="auth-form-content">
                        <input type="hidden" name="id" value="${id}" />
                        
                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-lock-fill"></i></span>
                            <input type="password" id="nowPw" name="nowPw" class="form-control" placeholder="현재 비밀번호" required/>
                        </div>

                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                            <input type="password" id="newPw" name="newPw" class="form-control" placeholder="새 비밀번호" required/>
                        </div>
                        <div id="newPwMsg" class="validation-msg"></div>

                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-key-fill"></i></span>
                            <input type="password" id="password" name="password" class="form-control" placeholder="새 비밀번호 확인" required/>
                        </div>
                        <div id="confirmMsg" class="validation-msg"></div>

                        <button type="submit" class="auth-btn primary-btn mb-3">
                            변경하기
                            <i class="bi bi-arrow-right"></i>
                        </button>
                    </form>
                    
                    <div class="switch-form">
                        <a href="/member/myPage" class="switch-btn"><span>마이 페이지로 돌아가기</span></a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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

    $(document).ready(function() {
        // 기존 알림창 및 리다이렉션 로직
        <c:if test="${not empty error}">
            alert("${error}");
        </c:if>
        <c:if test="${not empty success}">
            alert("${success}");
            window.location.href = "/public/logout";
        </c:if>

        function validateNewPw() {
            const nowPw = $("#nowPw").val();
            const newPw = $("#newPw").val();
            const regex = /^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
			if(newPw === "") {
				$("#newPwMsg").text("").removeClass("error-msg success-msg");
				return false;
			}	else if (newPw === nowPw) {
				$("#newPwMsg").text("현재 비밀번호와 동일합니다.").removeClass("success-msg").addClass("error-msg");
				return false;
			}	else if (!regex.test(newPw)) {
				$("#newPwMsg").text("8자 이상, 대문자 1개, 특수문자 1개 포함해야 합니다.").removeClass("success-msg").addClass("error-msg");
				return false;
			} else {
				$("#newPwMsg").text("사용 가능한 비밀번호입니다.").removeClass("error-msg").addClass("success-msg");
				return true;
			}
		}

        function validateConfirmPw() {
            const newPw = $("#newPw").val();
            const confirmPw = $("#password").val();
			
            if (newPw === "" || confirmPw === "") {
				$("#confirmMsg").text("").removeClass("error-msg success-msg");
				return false;
            }	else if (newPw !== confirmPw) {
				$("#confirmMsg").text("비밀번호가 일치하지 않습니다.").removeClass("success-msg").addClass("error-msg");
				return false;
			}	else {
				$("#confirmMsg").text("비밀번호가 일치합니다.").removeClass("error-msg").addClass("success-msg");
				return true;
			}
        }

        $("#newPw, #nowPw").on("keyup blur", validateNewPw);
        $("#password, #newPw").on("keyup blur", validateConfirmPw);

        $("#pwForm").on("submit", function(e) {
            if (!validateNewPw() || !validateConfirmPw()) {
                e.preventDefault(); // 유효성 검사 실패 시 제출 막음
                alert("비밀번호 조건을 확인해주세요.");
            }	else if ($("#nowPw").val().trim() === "") {
            	e.preventDefault();
            	alert("현재 비밀번호를 입력해주세요.")
            }
        });
    });
</script>
</body>
</html>
