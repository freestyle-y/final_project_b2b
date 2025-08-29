<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<title>비밀번호 찾기</title>
<link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/assets/vendor/bootstrap-icons/bootstrap-icons.css" rel="stylesheet">
<link href="/assets/vendor/aos/aos.css" rel="stylesheet">
<link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
<link href="/assets/vendor/swiper/swiper-bundle.min.css" rel="stylesheet">
<link href="/assets/vendor/drift-zoom/drift-basic.css" rel="stylesheet">
<link href="/assets/css/main.css" rel="stylesheet">
<style>
:root {
  --primary-color: #007bff;
  --white: #fff;
  --gray-100: #f8f9fa;
  --gray-300: #dee2e6;
  --gray-500: #adb5bd;
  --gray-600: #6c757d;
  --gray-700: #495057;
  --gray-800: #343a40;
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

.auth-btn {
  width: 100%;
  padding: 14px;
  border: none;
  border-radius: 8px;
  font-size: 16px;
  font-weight: 600;
  cursor: pointer;
  background-color: var(--primary-color);
  color: var(--white);
  transition: background-color 0.3s ease;
  display: flex;
  align-items: center;
  justify-content: center;
}

.auth-btn:hover {
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

.radio-group {
    display: flex;
    justify-content: space-around;
    margin-bottom: 20px;
}
.radio-group label {
    display: flex;
    align-items: center;
    cursor: pointer;
    color: var(--gray-700);
}
.radio-group input[type="radio"] {
    margin-right: 8px;
    cursor: pointer;
}

.hidden { display: none; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
$(function(){
    // 회원 구분에 따라 폼 토글
    $("input[name='customerCategory']").change(function(){
        if($(this).val() === 'CC003'){ // 개인회원
            $("#personalForm").show();
            $("#companyForm").hide();
        }else{ // 기업회원
            $("#personalForm").hide();
            $("#companyForm").show();
        }
    });

    // 임시 비밀번호 발급 버튼
    $("#findPwBtn").click(function(){
        let category = $("input[name='customerCategory']:checked").val();
        let data = { customerCategory: category };

        if(category === 'CC003'){ // 개인회원
            data.id = $("#id").val().trim();
            data.name = $("#name").val().trim();
            data.sn = $("#sn").val().trim();
        }else{ // 기업회원
            data.id = $("#companyId").val().trim();
            data.companyName = $("#companyName").val().trim();
            data.businessNo = $("#businessNo").val().trim();
        }

        // 필수값 체크
        for (let key in data) {
            if (!data[key]) {
                alert("모든 입력란을 채워주세요.");
                return;
            }
        }

        // Ajax 요청
        $.ajax({
            url: "/public/findPw",
            type: "POST",
            contentType: "application/json",
            data: JSON.stringify(data),
            success: function(res){
                alert(res.message);
                if(res.success){
                    window.location.href = "/public/mainPage"; // 메인으로 이동
                }
            },
            error: function(xhr){
                alert("비밀번호 찾기 요청 중 오류가 발생했습니다.\n" + xhr.responseText);
            }
        });
    });
});
</script>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">
    <section id="login" class="login section">
        <div class="main-content" data-aos="fade-up" data-aos-delay="100">
            <div class="auth-container">
                <div class="auth-form login-form active">
                    <div class="form-header">
                        <h3>비밀번호 찾기</h3>
                        <p>정보를 입력하시면 임시 비밀번호가 발급됩니다</p>
                    </div>

                    <div class="radio-group">
                        <label>
                            <input type="radio" name="customerCategory" value="CC003" checked> 개인회원
                        </label>
                        <label>
                            <input type="radio" name="customerCategory" value="CC002"> 기업회원
                        </label>
                    </div>

                    <div id="personalForm">
                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-person"></i></span>
                            <input type="text" id="id" class="form-control" placeholder="아이디">
                        </div>
                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-person"></i></span>
                            <input type="text" id="name" class="form-control" placeholder="이름">
                        </div>
                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-credit-card"></i></span>
                            <input type="text" id="sn" class="form-control" placeholder="주민등록번호">
                        </div>
                    </div>

                    <div id="companyForm" style="display:none;">
                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-person"></i></span>
                            <input type="text" id="companyId" class="form-control" placeholder="아이디">
                        </div>
                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-building"></i></span>
                            <input type="text" id="companyName" class="form-control" placeholder="기업명">
                        </div>
                        <div class="input-group">
                            <span class="input-icon"><i class="bi bi-credit-card-2-front"></i></span>
                            <input type="text" id="businessNo" class="form-control" placeholder="사업자등록번호">
                        </div>
                    </div>

                    <button type="button" id="findPwBtn" class="auth-btn primary-btn mb-3">
                        임시 비밀번호 발급
                        <i class="bi bi-arrow-right"></i>
                    </button>
                    
                    <div class="switch-form">
                        <a href="/public/login" class="switch-btn">로그인 페이지로 돌아가기</a>
                    </div>
                </div>
            </div>
        </div>
    </section>
</main>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/assets/vendor/aos/aos.js"></script>
<script src="/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="/assets/js/main.js"></script>
<script>
    AOS.init({
        duration: 800,
        easing: 'ease-in-out',
        once: true,
        mirror: false
    });
</script>
</body>
</html>