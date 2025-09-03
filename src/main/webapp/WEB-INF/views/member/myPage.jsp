<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 - NiceShop</title>

<!-- Bootstrap and Custom CSS Files -->
<link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/assets/vendor/aos/aos.css" rel="stylesheet">
<link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
<link href="/assets/css/main.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<!-- Custom CSS for unified form design -->
<style>
    /* 공통 스타일 */
    .register-container {
        max-width: 800px;
        margin: 2rem auto;
        padding: 2rem;
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    
    .register-form-wrapper h2 {
        font-weight: 700;
        color: #333;
    }

    .form-floating > .form-control:focus, .form-floating > .form-control:not(:placeholder-shown) {
        padding-top: 2rem;
        padding-bottom: 0.5rem;
    }
    
    .btn-custom {
        padding: 0.75rem 1.5rem;
        border-radius: 50px;
        background-color: #333;
        color: #fff;
        border: none;
        transition: background-color 0.3s;
    }

    .btn-custom:hover {
        background-color: #555;
    }
    
    .modal { 
        display:none; 
        position:fixed; 
        top:0; 
        left:0; 
        width:100%; 
        height:100%; 
        background:rgba(0,0,0,0.5); 
        z-index: 1050; 
        align-items: center; 
        justify-content: center;
    }
    .modal-content { 
        background:#fff; 
        padding:20px; 
        border-radius:10px; 
        width:90%; 
        max-width:400px;
        box-shadow: 0 4px 10px rgba(0,0,0,0.2);
    }
    .modal-content h3 {
        margin-bottom: 1rem;
    }
    .modal-content input {
        width: 100%;
        margin-bottom: 1rem;
        padding: 0.75rem;
        border: 1px solid #ddd;
        border-radius: 8px;
    }
    .modal-content .btn {
        width: 48%;
    }
    .modal-content button:first-of-type {
        margin-right: 4%;
    }
    
    /* 마이페이지 레이아웃 */
    .mypage-form .form-group {
        display: flex;
        align-items: center;
        margin-bottom: 1.5rem;
        flex-wrap: nowrap;
    }

    .mypage-form .form-group label {
        flex-basis: 150px;
        font-weight: 600;
        margin-right: 1rem;
        white-space: nowrap;
        min-width: 120px;
    }
    
    .mypage-form .form-group .input-wrapper {
        flex-grow: 1;
        display: flex;
        align-items: center;
    }
    
    .mypage-form .form-group .input-wrapper .form-control {
        flex-grow: 1;
        background-color: #f8f9fa;
        cursor: default;
    }
    
    .mypage-form .form-group .input-wrapper .btn-change {
        margin-left: 10px;
        background-color: #f0f0f0;
        color: #333;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 0.5rem 1rem;
        white-space: nowrap;
        transition: background-color 0.3s, border-color 0.3s;
    }

    .mypage-form .form-group .input-wrapper .btn-change:hover {
        background-color: #e2e6ea;
        border-color: #dae0e5;
    }
    
    /* 소셜 연동 부분 스타일 조정 */
    .social-links-wrapper {
        display: flex;
        align-items: center;
        flex-wrap: wrap;
        margin-bottom: 1rem;
    }
    .social-links-wrapper .social-item {
        display: flex;
        align-items: center;
        margin-right: 1.5rem;
        margin-bottom: 0.5rem;
    }
    .social-links-wrapper .social-item span {
        margin-right: 0.5rem;
    }
    .social-links-wrapper .btn {
        white-space: nowrap;
        padding: 0.25rem 0.75rem;
    }
    
    .social-links-wrapper .social-icon-btn {
        background: none;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 0.5rem;
        transition: all 0.3s;
    }
    
    .social-links-wrapper .social-icon-btn:hover {
        background-color: #f0f0f0;
    }
    
    .social-links-wrapper .fa-brands {
        font-size: 1.5rem;
    }
    
    .fa-brands {
	    font-family: "Font Awesome 6 Brands"; /* 폰트 패밀리 명시 */
	}
	
    .fa-brands.fa-kakao {
        color: #FEE500;
    }
    
    .fa-brands.fa-naver {
        color: #ffffff;
    }

    @media (max-width: 768px) {
        .mypage-form .form-group {
            flex-direction: column;
            align-items: flex-start;
        }
        .mypage-form .form-group label {
            width: 100%;
            margin-bottom: 0.5rem;
        }
        .mypage-form .form-group .input-wrapper {
            width: 100%;
        }
    }

</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main" id="main-content-container">
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">마이페이지</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="/">Home</a></li>
            <li class="current">마이페이지</li>
          </ol>
        </nav>
      </div>
    </div>
    
    <section id="mypage" class="mypage section">
        <div class="container">
            <div class="row justify-content-center">
                <div class="col-lg-10">
                    <div class="register-container">
                        <div class="registration-form-wrapper">
                            <div class="form-header text-center mb-4">
                                <h2>회원정보</h2>
                                <p>회원 정보를 확인하고 수정할 수 있습니다</p>
                            </div>
                            
                            <!-- 1. 비밀번호 확인 모달 -->
                            <div id="passwordCheckModal" class="modal">
                                <div class="modal-content text-center">
                                    <h3 class="mb-3">비밀번호 확인</h3>
                                    <input type="password" class="form-control mb-3" id="checkPassword" placeholder="비밀번호 입력">
                                    <div class="d-flex justify-content-between">
                                        <button id="checkPasswordBtn" class="btn btn-dark">확인</button>
                                        <button id="goBackBtn" class="btn btn-secondary">뒤로가기</button>
                                    </div>
                                </div>
                            </div>
                            
                            <!-- 2. 사용자 정보 영역 -->
                            <div id="userInfo" style="display:none;">
                                <form id="myPageForm" class="mypage-form">
                                    <div class="form-group">
                                        <label for="userId">아이디</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="userId" readonly value="${user.id}">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>비밀번호</label>
                                        <div class="input-wrapper">
                                            <button type="button" class="btn btn-change w-100" onclick="location.href='/member/changeMemberPw'">비밀번호 변경</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="customerCategory">회원구분</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="customerCategory" readonly value="">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="name">이름</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="name" readonly value="${user.name}">
                                            <button type="button" class="btn btn-change" onclick="openChangeModal('name')">변경</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="phone">휴대폰 번호</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="phone" readonly value="${user.phone}">
                                            <button type="button" class="btn btn-change" onclick="openChangeModal('phone')">변경</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="email">이메일</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="email" readonly value="${user.email}">
                                            <button type="button" class="btn btn-change" onclick="openChangeModal('email')">변경</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="postal">주소</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="address" readonly value="${user.address}">
                                            <button type="button" class="btn btn-change" onclick="openChangeModal('postal')">변경</button>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label for="detailAddress">상세주소</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="detailAddress" readonly value="${user.detailAddress}">
                                        </div>
                                    </div>
                                    
                                    <!-- 개인회원 -->
                                    <c:if test="${user.customerCategory == 'CC003'}">
                                        <div class="form-group">
                                            <label for="simplePassword">간편 비밀번호</label>
                                            <div class="input-wrapper">
                                                <c:choose>
										            <c:when test="${user.simplePassword != null}">
										                <span class="form-control" id="simplePassword" style="background-color: #f8f9fa; cursor: default;">
										                    설정됨
										                </span>
										            </c:when>
										            <c:otherwise>
										                <span class="form-control" id="simplePassword" style="background-color: #f8f9fa; cursor: default;">
										                    미설정
										                </span>
										            </c:otherwise>
										        </c:choose>
										        
										        <button type="button" class="btn btn-change" id="simplePasswordBtn" onclick="openChangeModal('simplePassword')">
										            <c:choose>
										                <c:when test="${user.simplePassword != null}">변경</c:when>
										                <c:otherwise>생성</c:otherwise>
										            </c:choose>
										        </button>
										        <c:if test="${user.simplePassword != null}">
										            <button type="button" class="btn btn-change" id="simplePasswordUnlinkBtn" onclick="unlinkSimplePassword()">해제</button>
										        </c:if>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="totalReward">보유 적립금</label>
                                            <div class="input-wrapper">
                                                <input type="text" class="form-control" id="totalReward" readonly value="${user.totalReward}">
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label>소셜 연동</label>
                                            <div class="social-links-wrapper">
                                                <!-- 카카오 연동 상태 -->
                                                <c:set var="isKakaoLinked" value="false" />
                                                <c:forEach var="s" items="${socialList}">
                                                    <c:if test="${s.socialType == 'kakao'}">
                                                        <c:set var="isKakaoLinked" value="true" />
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${isKakaoLinked}">
												    <div class="social-item">
												        <img src="/images/kakaotalk.png" alt="카카오" 
												             style="width:36px; height:36px; margin-right:8px; cursor:pointer;" 
												             onclick="confirmUnlink('kakao')">
												    </div>
												</c:if>
                                                
                                                <!-- 네이버 연동 상태 -->
                                                <c:set var="isNaverLinked" value="false" />
                                                <c:forEach var="s" items="${socialList}">
                                                    <c:if test="${s.socialType == 'naver'}">
                                                        <c:set var="isNaverLinked" value="true" />
                                                    </c:if>
                                                </c:forEach>
                                                <c:if test="${isNaverLinked}">
												    <div class="social-item">
												        <img src="/images/naver.png" alt="네이버" 
												             style="width:48px; height:48px; margin-right:8px; cursor:pointer;" 
												             onclick="confirmUnlink('naver')">
												    </div>
												</c:if>
                                                
                                                <c:if test="${socialList.size() < 2}">
                                                    <button type="button" class="btn btn-change" onclick="openSocialModal()">계정 추가</button>
                                                </c:if>
                                            </div>
                                        </div>
                                    </c:if>

                                    <!-- 기업회원 -->
                                    <c:if test="${user.customerCategory == 'CC002'}">
                                        <div class="form-group">
                                            <label for="companyName">기업명</label>
                                            <div class="input-wrapper">
                                                <input type="text" class="form-control" id="companyName" readonly value="${user.companyName}">
                                                <button type="button" class="btn btn-change" onclick="openChangeModal('companyName')">변경</button>
                                            </div>
                                        </div>
                                        <div class="form-group">
                                            <label for="businessNo">사업자등록번호</label>
                                            <div class="input-wrapper">
                                                <input type="text" class="form-control" id="businessNo" readonly value="${user.businessNo}">
                                            </div>
                                        </div>
                                    </c:if>
                                    
                                    <div class="form-group">
                                        <label for="createDate">생성일</label>
                                        <div class="input-wrapper">
                                            <input type="text" class="form-control" id="createDate" readonly value="${user.createDate}">
                                        </div>
                                    </div>

                                    <div class="text-center mt-4">
                                        <button type="button" class="btn btn-danger" onclick="openWithdrawalModal()">회원 탈퇴</button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
    
    <!-- 정보 수정 모달 -->
    <div id="changeModal" class="modal">
        <div class="modal-content">
            <h3 id="changeTitle">정보 변경</h3>
    
            <!-- 일반 필드용 -->
            <div id="defaultChangeFields">
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="changeValue">
                    <label for="changeValue">변경할 값 입력</label>
                </div>
            </div>

            <!-- 간편 비밀번호용 -->
            <div id="simplePwChangeFields">
                 <div class="form-floating mb-3">
                     <input type="password" class="form-control" id="changeSimplePw" placeholder="4자리 숫자" maxlength="4">
                     <label for="changeSimplePw">4자리 숫자 입력</label>
                 </div>
            </div>
    
            <!-- 주소 변경용 -->
            <div id="addressChangeFields">
                <div class="input-group mb-3">
                    <div class="form-floating">
                        <input type="text" class="form-control" id="modalPostal" readonly>
                        <label for="modalPostal">우편번호</label>
                    </div>
                    <button class="btn btn-change" type="button" id="searchPostalBtn">검색</button>
                </div>
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="modalAddress" readonly>
                    <label for="modalAddress">주소</label>
                </div>
                <div class="form-floating mb-3">
                    <input type="text" class="form-control" id="modalDetailAddress">
                    <label for="modalDetailAddress">상세주소</label>
                </div>
            </div>
    
            <div class="d-flex justify-content-between">
                <button id="saveChangeBtn" class="btn btn-dark">저장</button>
                <button onclick="$('#changeModal').hide()" class="btn btn-secondary">취소</button>
            </div>
        </div>
    </div>
    
    <!-- 소셜 연동 모달 -->
    <div id="socialModal" class="modal">
      <div class="modal-content text-center">
        <h3 class="mb-3">소셜 로그인 연동</h3>
        <c:if test="${!isKakaoLinked}">
            <button class="btn btn-custom mb-2 w-100 d-flex align-items-center justify-content-center"
	              onclick="linkSocial('kakao')"
	              style="background-color: #FEE500; color: #3C1E1E;">
	        <img src="/images/kakaotalk.png" alt="카카오" style="width:36px; height:36px; margin-right:8px;">
	        카카오 연동
	      </button>
        </c:if>
        <c:if test="${!isNaverLinked}">
            <button class="btn btn-custom mb-2 w-100 d-flex align-items-center justify-content-center"
	              onclick="linkSocial('naver')"
	              style="background-color: #03C75A; color: white;">
	        <img src="/images/naver.png" alt="네이버" style="width:36px; height:36px; margin-right:8px;">
	        네이버 연동
	      </button>
        </c:if>
        <button class="btn btn-secondary w-100" onclick="$('#socialModal').hide()">취소</button>
      </div>
    </div>
    
    <!-- 회원 탈퇴 모달 -->
    <div id="withdrawalModal" class="modal">
        <div class="modal-content text-center">
            <h3 class="mb-3">회원 탈퇴</h3>
            <p class="mb-3">정말로 탈퇴하시겠습니까?</p>
            <input type="password" class="form-control mb-3" id="withdrawalPassword" placeholder="탈퇴하시려면 비밀번호를 입력해주세요.">
            <div class="d-flex justify-content-between">
                <button id="confirmWithdrawalBtn" class="btn btn-danger">탈퇴하기</button>
                <button onclick="$('#withdrawalModal').hide()" class="btn btn-secondary">돌아가기</button>
            </div>
        </div>
    </div>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
let currentField = '';

$(document).ready(function() {
    console.log("jQuery ready 실행됨");
    
    // -------------------------------
    // 1️⃣ 쿠키 확인 및 비밀번호 모달
    // -------------------------------
    function getCookie(name) {
        const match = document.cookie.match(new RegExp('(?:^|; )' + name + '=([^;]*)'));
        return match ? decodeURIComponent(match[1]) : null;
    }

    const auth = getCookie("myPageAuth");
    console.log("auth 값:", auth);
    if(auth === "true"){
        $("#passwordCheckModal").hide();
        $("#userInfo").show();
    } else {
        $("#passwordCheckModal").css("display", "flex");
        $("#userInfo").hide();
        $("#checkPasswordBtn").click(function() {
            let password = $("#checkPassword").val();
            $.post("/public/checkPassword", { password: password }, function(result) {
                // 쿠키 콘솔 확인
                console.log("쿠키 전체:", document.cookie);
                console.log("myPageAuth 값:", getCookie("myPageAuth"));
                if(result){
                    $("#passwordCheckModal").hide();
                    $("#userInfo").show();
                    // 쿠키 생성 
                    document.cookie = "myPageAuth=true; path=/";
                    
                    // 회원구분과 생성일 데이터 변환 및 UI 업데이트
                    updateCategoryAndDate();
                } else {
                    alert("비밀번호가 일치하지 않습니다.");
                }
            });
        });
    }

    $("#goBackBtn").click(function() { window.history.back(); });
    
    function updateCategoryAndDate() {
        const categoryCode = "${user.customerCategory}";
        let categoryText = "";
        switch(categoryCode) {
            case 'CC001': categoryText = "관리자"; break;
            case 'CC002': categoryText = "기업회원"; break;
            case 'CC003': categoryText = "개인회원"; break;
            default: categoryText = categoryCode;
        }
        $("#customerCategory").val(categoryText);

        const createDate = "${user.createDate}";
        if(createDate && createDate.includes('T')) {
            $("#createDate").val(createDate.replace('T', ' '));
        }
    }

    // 초기 로드 시 실행 (이미 로그인 되어있을 경우)
    if(auth === "true"){
        updateCategoryAndDate();
    }

    // -------------------------------
    // 2️⃣ 소셜 연동 알람
    // -------------------------------
    const urlParams = new URLSearchParams(window.location.search);
    if(urlParams.get('linkResult') === 'success'){
        alert("연동이 완료되었습니다.");
        window.history.replaceState({}, document.title, "/member/myPage");
    } else if(urlParams.get('linkResult') === 'fail'){
        alert("연동에 실패했습니다.");
        window.history.replaceState({}, document.title, "/member/myPage");
    }

    // -------------------------------
    // 3️⃣ 정보 수정 모달
    // -------------------------------
    window.openChangeModal = function(field){
        currentField = field;
        
        // 필드 그룹을 먼저 모두 숨기고, 필요한 그룹만 보여줍니다.
        $("#defaultChangeFields").hide();
        $("#addressChangeFields").hide();
        $("#simplePwChangeFields").hide();
        
        if(field === "postal"){
            $("#changeTitle").text("주소 변경");
            $("#addressChangeFields").show();
            
            $("#modalPostal").val($("#address").val().split(' ')[0] || '');
            $("#modalAddress").val($("#address").val().substring($("#address").val().indexOf(' ') + 1) || '');
            $("#modalDetailAddress").val($("#detailAddress").val());
        } else if(field === "simplePassword") {
            $("#changeTitle").text("간편 비밀번호 변경");
            $("#simplePwChangeFields").css("display", "flex");
            $("#changeSimplePw").val('');
        } else {
            $("#changeTitle").text(field + " 변경");
            $("#defaultChangeFields").css("display", "flex");
            $("#changeValue").val($("#"+field).val());
        }
        $("#changeModal").css("display", "flex");
    }

    $("#searchPostalBtn").click(function(){
        new daum.Postcode({
            oncomplete: function(data){
                $("#modalPostal").val(data.zonecode);
                $("#modalAddress").val(data.roadAddress);
                $("#modalDetailAddress").focus();
            }
        }).open();
    });

    $("#saveChangeBtn").off('click').on('click', function(){
        if(currentField === "postal"){
            let postal = $("#modalPostal").val().trim();
            let address = $("#modalAddress").val().trim();
            let detail = $("#modalDetailAddress").val().trim();

            if(postal==="" || address==="" || detail===""){
                alert("모든 주소 항목을 입력해주세요.");
                return;
            }

            let data = { postal: postal, address: address, detailAddress: detail };
            $.ajax({
                url: '/public/updateUserInfo',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function(res){
                    alert('주소가 변경되었습니다.');
                    $("#simplePassword").text('설정됨'); 
                    $("#simplePasswordBtn").text('변경');
                    $("#changeModal").hide();
                    window.location.reload();
                },
                error: function(xhr){
                    alert('변경 실패: ' + xhr.responseText);
                }
            });
        } else if(currentField === "simplePassword") {
            const simplePw = $("#changeSimplePw").val();
            if (!/^\d{4}$/.test(simplePw)) {
                alert("간편 비밀번호는 4자리 숫자로 입력해주세요.");
                return;
            }
            $.ajax({
                url: '/public/updateUserInfo',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify({simplePassword: simplePw}),
                success: function(res){
                    alert('간편 비밀번호가 변경되었습니다.');
                    $("#simplePassword").val('****');
                    $("#simplePasswordBtn").text('변경');
                    $("#changeModal").hide();
                },
                error: function(xhr){
                    alert('변경 실패: ' + xhr.responseText);
                }
            });
        } else {
            let value = $("#changeValue").val().trim();
            if(value === ""){
                alert("값을 입력해주세요.");
                return;
            }
            if(currentField === "email" && !/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/.test(value)){
                alert("올바른 이메일 형식을 입력해주세요.");
                return;
            }
            if(currentField === "phone" && !/^01[016789]-\d{3,4}-\d{4}$/.test(value)){
                alert("전화번호는 010-1234-5678 형식으로 입력해주세요.");
                return;
            }

            let data = {};
            data[currentField] = value;

            $.ajax({
                url: '/public/updateUserInfo',
                type: 'PUT',
                contentType: 'application/json',
                data: JSON.stringify(data),
                success: function(res){
                    alert('정보가 변경되었습니다.');
                    $("#"+currentField).val(value);
                    $("#changeModal").hide();
                },
                error: function(xhr){
                    alert('변경 실패: ' + xhr.responseText);
                }
            });
        }
    });
    
	 // ✅ 간편 비밀번호 해제 함수 추가
	    window.unlinkSimplePassword = function() {
	        if (!confirm("간편 비밀번호를 해제하시겠습니까?")) {
	            return;
	        }
	
	        $.ajax({
	            url: '/public/updateUserInfo',
	            type: 'PUT',
	            contentType: 'application/json',
	            data: JSON.stringify({simplePassword: null}), // ✅ null 값을 전송하여 해제 요청
	            success: function(res) {
	                alert('간편 비밀번호가 해제되었습니다.');
	                // ✅ 해제 후 UI 업데이트
	                $("#simplePassword").text('미설정');
	                $("#simplePasswordBtn").text('생성');
	                $("#simplePasswordUnlinkBtn").hide(); // 해제 버튼 숨기기
	            },
	            error: function(xhr) {
	                alert('해제 실패: ' + xhr.responseText);
	            }
	        });
	    };

    // -------------------------------
    // 4️⃣ 소셜 연동
    // -------------------------------
    window.openSocialModal = function() {
        const isKakaoLinked = <c:out value="${isKakaoLinked}"/>;
        const isNaverLinked = <c:out value="${isNaverLinked}"/>;
        if (isKakaoLinked && isNaverLinked) {
            alert("이미 2개의 소셜 계정이 연동되어 있습니다.");
            return;
        }
        $("#socialModal").css("display", "flex"); 
    }
    window.linkSocial = function(provider) { location.href = "/api/social/link/" + provider; }
    
    window.confirmUnlink = function(provider) {
        if (confirm(provider + " 연동을 해제하시겠습니까?")) {
            unlinkSocial(provider);
        }
    }
    
    window.unlinkSocial = function(provider) {
        $.ajax({
            url: "/api/social/unlink/" + provider,
            type: "DELETE",
            success: function(res){ alert(res); location.reload(); },
            error: function(){ alert("연동 해제 실패"); }
        });
    }
    
    

    // -------------------------------
    // 5️⃣ 회원 탈퇴
    // -------------------------------
    window.openWithdrawalModal = function() {
        $("#withdrawalModal").css("display", "flex");
    }
    
    $("#confirmWithdrawalBtn").click(function() {
        const password = $("#withdrawalPassword").val();
        if(password === "") {
            alert("비밀번호를 입력해주세요.");
            return;
        }
        
        $.ajax({
            url: "/public/checkPassword",
            type: "POST",
            data: { password: password },
            success: function(isPasswordCorrect) {
            	if(isPasswordCorrect) {
                    // 서버에 탈퇴 요청을 POST 방식으로 보냅니다.
                    $.ajax({
                        url: "/member/memberWithdraw",
                        type: "POST",
                        success: function(res) {
                            alert("회원 탈퇴가 완료되었습니다.");
                            window.location.href = "/public/logout"; // 로그아웃 페이지로 이동
                        },
                        error: function(xhr) {
                            alert("회원 탈퇴에 실패했습니다.");
                        }
                    });
                } else {
                    alert("비밀번호가 일치하지 않습니다.");
                }
            },
            error: function() {
                alert("비밀번호 확인에 실패했습니다.");
            }
        });
    });
});
</script>

<!-- 필수 스크립트들을 마지막에 로드 -->
<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/assets/vendor/aos/aos.js"></script>
<script src="/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="/assets/js/main.js"></script>
</body>
</html>
