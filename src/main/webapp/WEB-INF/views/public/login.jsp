<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>로그인</title>
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

                        <a href="/oauth2/authorization/naver"
						   class="auth-btn social-btn mb-3 d-flex align-items-center justify-content-center"
						   style="background-color: #03C75A; color: white; text-decoration: none;">
						    <img src="/images/naver.png" alt="네이버" style="width:36px; height:36px; margin-right:8px;">
						    네이버로 로그인
						</a>
                        <a href="/oauth2/authorization/kakao"
						   class="auth-btn social-btn d-flex align-items-center justify-content-center"
						   style="background-color: #FEE500; color: #3C1E1E; text-decoration: none;">
						    <img src="/images/kakaotalk.png" alt="카카오" style="width:36px; height:36px; margin-right:8px;">
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
    
    /* 1) 드롭다운 토글 버튼이면 type="button" 강제(폼 submit 방지) */
    (function ensureBtnType(){
      const sel = [
        'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
        '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"]',
        'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]',
        '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
      ].join(',');

      document.querySelectorAll(sel).forEach(btn => {
        if (!btn.hasAttribute('type')) btn.setAttribute('type','button');
      });
    })();

    /* 2) 캡처링 단계에서 좌표 기반 hit-test로 드롭다운 강제 토글 */
    (function forceDropdownToggle(){
      const getBtns = () => Array.from(document.querySelectorAll(
        'header#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
        '#header .account-dropdown > .header-action-btn[data-bs-toggle="dropdown"],' +
        'header#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"],' +
        '#header .alarm-dropdown   > .header-action-btn[data-bs-toggle="dropdown"]'
      ));

      function inside(rect, x, y){
        return x >= rect.left && x <= rect.right && y >= rect.top && y <= rect.bottom;
      }

      // 캡처링 단계(true)로 등록 → 위에 뭔가 덮여 있어도 좌표로 판별해 토글
      document.addEventListener('click', function(ev){
        const x = ev.clientX, y = ev.clientY;
        const btn = getBtns().find(b => inside(b.getBoundingClientRect(), x, y));
        if (!btn) return;

        // 기본 동작(폼 제출/포커스 등) 막고 Bootstrap 드롭다운을 직접 토글
        ev.preventDefault();
        // ev.stopPropagation(); // 필요시 주석 해제. 기본에선 버블링 유지.

        try {
          const dd = bootstrap.Dropdown.getOrCreateInstance(btn);
          dd.toggle();
        } catch (e) {
          // bootstrap이 아직 로드 전이면 다음 틱에 재시도
          setTimeout(() => {
            const dd = bootstrap.Dropdown.getOrCreateInstance(btn);
            dd.toggle();
          }, 0);
        }
      }, true);
    })();
</script>

</body>
</html>