<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>휴면 계정 해제</title>
<meta name="description" content="휴면 계정 해제 페이지입니다.">
<meta name="keywords" content="휴면, 계정, 해제, 로그인, 활성화">

<link href="/assets/img/apple-touch-icon.png" rel="apple-touch-icon">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link href="https://fonts.googleapis.com" rel="preconnect">
<link href="https://fonts.gstatic.com" rel="preconnect" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@0,100;0,300;0,400;0,500;0,700;0,900;1,100;1,300;1,400;1,500;1,700;1,900&family=Montserrat:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&family=Poppins:ital,wght@0,100;0,200;0,300;0,400;0,500;0,600;0,700;0,800;0,900;1,100;1,200;1,300;1,400;1,500;1,600;1,700;1,800;1,900&display=swap" rel="stylesheet">

<link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/assets/vendor/aos/aos.css" rel="stylesheet">
<link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
<link href="/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
<link href="/assets/vendor/drift-zoom/drift-basic.css" rel="stylesheet">

<link href="/assets/css/main.css" rel="stylesheet">
<style>
/* 템플릿의 CSS는 그대로 유지합니다. */
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
  display: block; /* 이 페이지는 항상 폼이 보이도록 'block'으로 설정 */
  animation: fadeIn 0.5s ease-in-out;
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
</style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">
    <section id="active" class="active section">
        <div class="main-content" data-aos="fade-up" data-aos-delay="100">
            <div class="auth-container" data-aos="fade-in" data-aos-delay="200">
                <div class="auth-form">
                    <div class="form-header">
                        <h3>휴면 계정 해제</h3>
                        <p>계정 활성화를 위해 본인 인증 정보를 입력해주세요.</p>
                    </div>

                    <c:if test="${not empty errorMsg}">
                        <div class="alert alert-danger text-center" role="alert">
                            ${errorMsg}
                        </div>
                    </c:if>

                    <form action="/member/activateAccount" method="post" class="auth-form-content">
                        <input type="hidden" name="userId" value="${userId}" />

                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-person"></i></span>
                            <input type="text" id="userIdDisplay" class="form-control" value="${userId}" readonly>
                        </div>

                        <c:if test="${userRole eq 'ROLE_PERSONAL'}">
                            <div class="input-group">
                                <span class="input-icon"><i class="bi bi-credit-card"></i></span>
                                <input type="password" name="personalNumber" class="form-control" placeholder="주민등록번호 (123456-7890123)" maxlength="14" required/>
                            </div>
                        </c:if>
                        
                        <c:if test="${userRole eq 'ROLE_BIZ'}">
                            <div class="input-group">
                                <span class="input-icon"><i class="bi bi-credit-card-2-front"></i></span>
                                <input type="text" name="bizNumber" class="form-control" placeholder="사업자 등록 번호 (123-45-67890)" maxlength="12" required/>
                            </div>
                        </c:if>

                        <button type="submit" class="auth-btn primary-btn mb-3">
                            계정 활성화
                            <i class="bi bi-arrow-right"></i>
                        </button>

                        <div class="switch-form">
                            <span>로그인 페이지로 돌아가기</span>
                            <a href="/public/login" class="switch-btn">로그인</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </section>
</main>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true,
        mirror: false
    });
    
    // 에러 메시지가 있을 경우 alert 창을 띄웁니다.
    $(document).ready(function() {
        <c:if test="${not empty errorMsg}">
            alert('${errorMsg}');
        </c:if>
        
        // 🟢 추가: 성공 메시지가 있을 경우 alert 창을 띄웁니다.
        <c:if test="${not empty successMsg}">
            alert('${successMsg}');
            window.location.href = "/public/logout"
        </c:if>
    });
</script>
</body>
</html>