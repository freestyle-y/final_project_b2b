<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입 - NiceShop</title>

<!-- Bootstrap and Custom CSS Files -->
<link href="/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link href="/assets/vendor/aos/aos.css" rel="stylesheet">
<link href="/assets/vendor/glightbox/css/glightbox.min.css" rel="stylesheet">
<link href="/assets/css/main.css" rel="stylesheet">

<!-- Custom CSS for form handling -->
<style>
    /* 폼의 유효성 검증 메시지 스타일 */
    .error { color: red; font-size: 12px; }
    .success { color: green; font-size: 12px; }

    /* 메인 폼 컨테이너가 다른 요소에 의해 가려지지 않도록 z-index 설정 */
    #main-content-container {
      z-index: 10;
      position: relative;
    }
    
    /* 우편번호 검색 부분을 위한 새로운 flexbox 스타일 */
    .address-input-group {
      display: flex;
      gap: 5px; /* 입력창과 버튼 사이의 간격을 줍니다 */
      align-items: center; /* 수직 정렬 */
      margin-bottom: 1.5rem; /* 아래쪽 여백 추가 */
    }

    /* 우편번호 입력란과 버튼을 감싸는 div */
    .address-input-group > div {
        flex-grow: 1; /* 남은 공간을 차지하도록 함 */
    }

    /* 버튼 높이와 정렬을 위해 padding-top과 bottom을 줍니다 */
    .address-input-group input,
    .address-input-group .btn {
      height: calc(1.5em + .75rem + 2px); /* Bootstrap의 기본 input 높이 계산식 */
    }
</style>


<!-- 필수 스크립트: jQuery와 Daum Postcode를 템플릿 스크립트보다 먼저 로드 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
    // 회원 유형 선택
    function toggleMemberForm(type){
        if(type === 'personal'){
            $("#personalForm").removeClass('d-none');
            $("#companyForm").addClass('d-none');
        } else {
            $("#personalForm").addClass('d-none');
            $("#companyForm").removeClass('d-none');
        }
    }

    // 카카오 우편번호 API
    function execDaumPostcode(postalId, addressId){
        new daum.Postcode({
            oncomplete: function(data){
                $("#" + postalId).val(data.zonecode);
                $("#" + addressId).val(data.roadAddress);
                $("#" + addressId).focus();
            }
        }).open();
    }
    
    // 비밀번호 유효성 체크
    function validatePassword(pw){
        const re = /^(?=.*[A-Z])(?=.*[!@#$%^&*])(?=.*[0-9])[A-Za-z\d!@#$%^&*]{8,}$/;
        return re.test(pw);
    }

    // 이메일 유효성
    function validateEmail(email){
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
	}
	
 	// 주민등록번호 유효성
    function validateSn(front, back){
        return front.length === 6 && back.length === 7;
    }
 	
 	// 휴대폰 유효성
    function validatePhone(p1,p2,p3){
        return p1.length === 3 && p2.length >= 3 && p3.length === 4;
    }
 	
 	// 주소 유효성
    function validateAddress(postal, address, detail){
        return postal.trim() !== "" && address.trim() !== "" && detail.trim() !== "";
    }
    
    // 이름 유효성 (한글, 영어만)
    function validateName(name){
        const re = /^[가-힣a-zA-Z]+$/;
        return re.test(name);
    }

    // 숫자만 입력
    function allowOnlyNumber(event){
        if(!/[\d]|Backspace|ArrowLeft|ArrowRight|Tab/.test(event.key)){
            event.preventDefault();
        }
    }

    // 영어/한글만 입력
    function allowOnlyNameChar(event){
        if(!/[\uAC00-\uD7A3a-zA-Z]|Backspace|ArrowLeft|ArrowRight|Tab/.test(event.key)){
            event.preventDefault();
        }
    }

    // 자동 포커스 이동
    function autoMoveNext(current, nextId, maxLength){
        if(current.value.length >= maxLength){
            $("#" + nextId).focus();
        }
    }

    // 실시간 비밀번호 체크
    function checkPassword(passwordId, confirmId, pwMsgId, confirmMsgId){
        const pw = $("#" + passwordId).val();
        const confirm = $("#" + confirmId).val();
        
        if(pw === "") {
            $("#" + pwMsgId).text("");
        } else if(validatePassword(pw)){
            $("#" + pwMsgId).text("사용 가능한 비밀번호입니다.").removeClass("error").addClass("success");
        } else {
            $("#" + pwMsgId).text("8자 이상, 대문자/숫자/특수문자 각 1개 필요").removeClass("success").addClass("error");
        }
        
        if(confirm === "") {
            $("#" + confirmMsgId).text("");
        } else if(pw === confirm){
            $("#" + confirmMsgId).text("비밀번호가 일치합니다.").removeClass("error").addClass("success");
        } else {
            $("#" + confirmMsgId).text("비밀번호가 일치하지 않습니다.").removeClass("success").addClass("error");
        }
    }

    // 실시간 이메일 체크
    function checkEmail(emailId, msgId){
        const email = $("#" + emailId).val();
        if(email === "") { $("#" + msgId).text(""); return; }
        if(validateEmail(email)){
            $("#" + msgId).text("사용 가능한 이메일입니다.").removeClass("error").addClass("success");
        } else {
            $("#" + msgId).text("유효하지 않은 이메일입니다.").removeClass("success").addClass("error");
        }
    }

    // 실시간 이름 체크
    function checkName(nameId, msgId){
        const name = $("#" + nameId).val();
        if(name === "") { $("#" + msgId).text(""); return; }
        if(validateName(name)){
            $("#" + msgId).text("사용 가능한 이름입니다.").removeClass("error").addClass("success");
        } else {
            $("#" + msgId).text("영어/한글만 입력 가능합니다.").removeClass("success").addClass("error");
        }
    }
    
    // 주민등록번호 체크
    function checkSn(frontId, backId, msgId){
	    const front = $("#" + frontId).val();
	    const back = $("#" + backId).val();
	    if(front === "" && back === ""){
	        $("#" + msgId).text("");
	    } else if(validateSn(front, back)){
	        $("#" + msgId).text("유효한 주민등록번호입니다.").removeClass("error").addClass("success");
	    } else {
	        $("#" + msgId).text("주민등록번호를 올바르게 입력해주세요.").removeClass("success").addClass("error");
	    }
	}
    // 휴대폰 번호 체크
    function checkPhone(p1Id, p2Id, p3Id, msgId){
		const p1 = $("#" + p1Id).val();
		const p2 = $("#" + p2Id).val();
		const p3 = $("#" + p3Id).val();
		if(p1 === "" && p2 === "" && p3 === ""){
		    $("#" + msgId).text("");
		} else if(validatePhone(p1,p2,p3)){
		    $("#" + msgId).text("유효한 휴대폰 번호입니다.").removeClass("error").addClass("success");
		} else {
		    $("#" + msgId).text("휴대폰 번호를 올바르게 입력해주세요.").removeClass("success").addClass("error");
		}
	}
    
    // 아이디 중복 체크 (AJAX)
    function checkId(inputId, msgId){
        const userId = $("#" + inputId).val().trim();
        const msgSpan = $("#" + msgId);
        if(userId === ""){ msgSpan.text(""); return; }
        $.get("/public/checkId", {id:userId}, function(data){
            if(data === "OK"){
                msgSpan.text("사용 가능한 아이디입니다.").removeClass("error").addClass("success");
            } else {
                msgSpan.text("중복된 아이디입니다.").removeClass("success").addClass("error");
            }
        });
    }

    // 폼 제출 전 데이터 포맷
    function formatData(formId){
        if(formId==='personalForm'){
            $("#personalSnFull").val($("#personalSn1").val() + "-" + $("#personalSn2").val());
            $("#personalPhoneFull").val($("#personalPhone1").val() + "-" + $("#personalPhone2").val() + "-" + $("#personalPhone3").val());
        } else {
            $("#bizPhoneFull").val($("#bizPhone1").val() + "-" + $("#bizPhone2").val() + "-" + $("#bizPhone3").val());
            $("#companyBussFull").val($("#companyBuss1").val() + "-" + $("#companyBuss2").val() + "-" + $("#companyBuss3").val());
        }
    }

    // AJAX 제출
    function submitForm(formId, url){
        formatData(formId);
        if(!validateBeforeSubmit(formId)) {
            return false;
        }
        
        const form = $("#" + formId);
        $.post(url, form.serialize())
        .done(function(res){
            if(res==="SUCCESS"){
                alert("회원가입이 성공적으로 완료되었습니다!");
                window.location.href="/public/mainPage";
            } else {
                alert("오류: " + res);
            }
        })
        .fail(function(xhr){
            alert("회원가입 실패: " + xhr.responseText);
        });
        return false;
    }
    
 	// 필수 입력 체크
    function validateBeforeSubmit(formId){
        let valid = true;
        let form = $("#" + formId);
        
        form.find("input[required]").each(function(){
            if($(this).val().trim() === ""){
                valid = false;
                $(this).focus();
                return false; // each 루프 종료
            }
        });

        if(!valid){
            alert("필수 입력 항목을 모두 작성해주세요.");
            return false;
        }

        // 추가적인 유효성 검증
        if(formId === 'personalForm'){
            if(!validatePassword($("#personalPassword").val()) || $("#personalPassword").val() !== $("#personalConfirm").val()){
                alert("비밀번호를 올바르게 입력해주세요.");
                $("#personalPassword").focus();
                return false;
            }
            if(!validatePhone($("#personalPhone1").val(), $("#personalPhone2").val(), $("#personalPhone3").val())){
                alert("휴대폰 번호를 올바르게 입력해주세요.");
                $("#personalPhone1").focus();
                return false;
            }
             if(!validateEmail($("#personalEmail").val())){
                alert("이메일을 올바르게 입력해주세요.");
                $("#personalEmail").focus();
                return false;
            }
            if(!validateSn($("#personalSn1").val(), $("#personalSn2").val())){
                alert("주민등록번호를 올바르게 입력해주세요.");
                $("#personalSn1").focus();
                return false;
            }
             if(!validateAddress($("#personalPostal").val(), $("#personalAddress").val(), form.find("input[name='detailAddress']").val())){
                alert("주소를 올바르게 입력해주세요.");
                $("#personalPostal").focus();
                return false;
            }
        } else { // companyForm
            if(!validatePassword($("#bizPassword").val()) || $("#bizPassword").val() !== $("#bizConfirm").val()){
                alert("비밀번호를 올바르게 입력해주세요.");
                $("#bizPassword").focus();
                return false;
            }
            if(!validatePhone($("#bizPhone1").val(), $("#bizPhone2").val(), $("#bizPhone3").val())){
                alert("휴대폰 번호를 올바르게 입력해주세요.");
                $("#bizPhone1").focus();
                return false;
            }
            if(!validateEmail($("#bizEmail").val())){
                alert("이메일을 올바르게 입력해주세요.");
                $("#bizEmail").focus();
                return false;
            }
            if($("#companyBuss1").val().length + $("#companyBuss2").val().length + $("#companyBuss3").val().length !== 10){
                alert("사업자등록번호를 올바르게 입력해주세요.");
                $("#companyBuss1").focus();
                return false;
            }
            if(!validateAddress($("#bizPostal").val(), $("#bizAddress").val(), form.find("input[name='detailAddress']").val())){
                alert("주소를 올바르게 입력해주세요.");
                $("#bizPostal").focus();
                return false;
            }
        }
        return true;
    }

    // 모든 이벤트 리스너를 한곳에서 관리
    $(function(){
        // 회원 유형 라디오 버튼
        $("input[name='customerCategory']").on("click", function(){
            toggleMemberForm($(this).val() === 'CC003' ? 'personal' : 'company');
        });

        // 우편번호 검색 버튼
        $("#personalPostcodeSearch").on("click", function(){ execDaumPostcode('personalPostal', 'personalAddress'); });
        $("#bizPostcodeSearch").on("click", function(){ execDaumPostcode('bizPostal', 'bizAddress'); });

        // 실시간 유효성 체크
        $("#personalId").on("input", function(){ checkId("personalId","personalIdMsg"); });
        $("#bizId").on("input", function(){ checkId("bizId","bizIdMsg"); });

        $("#personalPassword, #personalConfirm").on("input", function(){ checkPassword("personalPassword","personalConfirm","personalPwMsg","personalConfirmMsg"); });
        $("#bizPassword, #bizConfirm").on("input", function(){ checkPassword("bizPassword","bizConfirm","bizPwMsg","bizConfirmMsg"); });

        $("#personalEmail").on("input", function(){ checkEmail("personalEmail","personalEmailMsg"); });
        $("#bizEmail").on("input", function(){ checkEmail("bizEmail","bizEmailMsg"); });

        $("#personalName").on("input", function(){ checkName("personalName","personalNameMsg"); });
        $("#bizName").on("input", function(){ checkName("bizName","bizNameMsg"); });
        
        $("#personalSn1, #personalSn2").on("input", function(){ checkSn("personalSn1","personalSn2","personalSnMsg"); });

        $("#personalPhone1, #personalPhone2, #personalPhone3").on("input", function(){ checkPhone("personalPhone1","personalPhone2","personalPhone3","personalPhoneMsg"); });
        $("#bizPhone1, #bizPhone2, #bizPhone3").on("input", function(){ checkPhone("bizPhone1","bizPhone2","bizPhone3","bizPhoneMsg"); });
        
        // 자동 포커스 이동
        $("#personalPhone1").on("input", function(){ autoMoveNext(this, 'personalPhone2', 3); });
        $("#personalPhone2").on("input", function(){ autoMoveNext(this, 'personalPhone3', 4); });
        $("#bizPhone1").on("input", function(){ autoMoveNext(this, 'bizPhone2', 3); });
        $("#bizPhone2").on("input", function(){ autoMoveNext(this, 'bizPhone3', 4); });
        
        $("#personalSn1").on("input", function(){ autoMoveNext(this, 'personalSn2', 6); });
        
        $("#companyBuss1").on("input", function(){ autoMoveNext(this, 'companyBuss2', 3); });
        $("#companyBuss2").on("input", function(){ autoMoveNext(this, 'companyBuss3', 2); });
        
        // 숫자만 입력/영어/한글만 입력 이벤트
        $("#personalPhone1, #personalPhone2, #personalPhone3, #personalSn1, #personalSn2, #companyBuss1, #companyBuss2, #companyBuss3").on("keypress", allowOnlyNumber);
        $("#personalName, #bizName").on("keypress", allowOnlyNameChar);
    });
</script>

<!-- 새로운 템플릿 스크립트들을 마지막에 로드 -->
<script src="/assets/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>
<script src="/assets/vendor/aos/aos.js"></script>
<script src="/assets/vendor/glightbox/js/glightbox.min.js"></script>
<script src="/assets/js/main.js"></script>

</head>
<body>
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main" id="main-content-container">
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">회원가입</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="/">Home</a></li>
            <li class="current">회원가입</li>
          </ol>
        </nav>
      </div>
    </div>

    <section id="register" class="register section">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-10">
            <div class="registration-form-wrapper">
              <div class="form-header text-center mb-4">
                <h2>회원가입</h2>
                <p>회원 유형을 선택하고, 계정을 만드세요</p>
                <div class="mb-4 text-center">
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="customerCategory" id="personalRadio" value="CC003" checked>
                        <label class="form-check-label" for="personalRadio">개인회원</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="customerCategory" id="companyRadio" value="CC002">
                        <label class="form-check-label" for="companyRadio">기업회원</label>
                    </div>
                </div>
              </div>

              <div class="row">
                <div class="col-lg-8 mx-auto">
                  <!-- 개인회원 폼 -->
                  <form id="personalForm" onsubmit="return submitForm('personalForm','/public/joinPersonal');">
                    <div class="form-floating mb-3">
                      <input type="text" class="form-control" id="personalId" name="id" placeholder="아이디" required>
                      <label for="personalId">아이디</label>
                      <span id="personalIdMsg" class="form-text"></span>
                    </div>

                    <div class="form-floating mb-3">
                      <input type="password" class="form-control" id="personalPassword" name="password" placeholder="비밀번호" required>
                      <label for="personalPassword">비밀번호</label>
                      <span id="personalPwMsg" class="form-text"></span>
                    </div>

                    <div class="form-floating mb-3">
                      <input type="password" class="form-control" id="personalConfirm" name="passwordConfirm" placeholder="비밀번호 확인" required>
                      <label for="personalConfirm">비밀번호 확인</label>
                      <span id="personalConfirmMsg" class="form-text"></span>
                    </div>
                    
                    <div class="form-floating mb-3">
                      <input type="text" class="form-control" id="personalName" name="name" placeholder="이름" required>
                      <label for="personalName">이름</label>
                      <span id="personalNameMsg" class="form-text"></span>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="personalPhone1" maxlength="3" placeholder="010" required>
                                <label for="personalPhone1">휴대폰</label>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="personalPhone2" maxlength="4" placeholder="1234" required>
                                <label for="personalPhone2"> </label>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="personalPhone3" maxlength="4" placeholder="5678" required>
                                <label for="personalPhone3"> </label>
                            </div>
                        </div>
                        <span id="personalPhoneMsg" class="form-text"></span>
                    </div>
                    <input type="hidden" id="personalPhoneFull" name="phone">
                    
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="personalEmail" name="email" placeholder="이메일" required>
                        <label for="personalEmail">이메일</label>
                        <span id="personalEmailMsg" class="form-text"></span>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-6">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="personalSn1" maxlength="6" placeholder="생년월일 6자리" required>
                                <label for="personalSn1">주민등록번호</label>
                            </div>
                        </div>
                        <div class="col-6">
                            <div class="form-floating">
                                <input type="password" class="form-control" id="personalSn2" maxlength="7" placeholder="주민등록번호 뒤 7자리" required>
                                <label for="personalSn2"> </label>
                            </div>
                        </div>
                        <span id="personalSnMsg" class="form-text"></span>
                    </div>
                    <input type="hidden" id="personalSnFull" name="sn">
                    
                    <!-- 우편번호 검색 부분을 input-group으로 재구성 -->
                    <div class="input-group mb-3 address-input-group">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="personalPostal" name="postal" placeholder="우편번호" readonly required>
                            <label for="personalPostal">우편번호</label>
                        </div>
                        <button class="btn btn-outline-secondary" type="button" id="personalPostcodeSearch">검색</button>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="personalAddress" name="address" placeholder="주소" readonly required>
                        <label for="personalAddress">주소</label>
                    </div>
                    <div class="form-floating mb-4">
                        <input type="text" class="form-control" name="detailAddress" placeholder="상세주소" required>
                        <label for="detailAddress">상세주소</label>
                    </div>

                    <div class="d-grid mb-4">
                      <button type="submit" class="btn btn-register">가입하기</button>
                    </div>
                  </form>

                  <!-- 기업회원 폼 -->
                  <form id="companyForm" class="d-none" onsubmit="return submitForm('companyForm','/public/joinBiz');">
                    <div class="form-floating mb-3">
                      <input type="text" class="form-control" id="bizId" name="id" placeholder="아이디" required>
                      <label for="bizId">아이디</label>
                      <span id="bizIdMsg" class="form-text"></span>
                    </div>

                    <div class="form-floating mb-3">
                      <input type="password" class="form-control" id="bizPassword" name="password" placeholder="비밀번호" required>
                      <label for="bizPassword">비밀번호</label>
                      <span id="bizPwMsg" class="form-text"></span>
                    </div>

                    <div class="form-floating mb-3">
                      <input type="password" class="form-control" id="bizConfirm" name="passwordConfirm" placeholder="비밀번호 확인" required>
                      <label for="bizConfirm">비밀번호 확인</label>
                      <span id="bizConfirmMsg" class="form-text"></span>
                    </div>
                    
                    <div class="form-floating mb-3">
                      <input type="text" class="form-control" id="bizName" name="name" placeholder="대표자 이름" required>
                      <label for="bizName">대표자 이름</label>
                      <span id="bizNameMsg" class="form-text"></span>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="bizPhone1" maxlength="3" placeholder="010" required>
                                <label for="bizPhone1">휴대폰</label>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="bizPhone2" maxlength="4" placeholder="1234" required>
                                <label for="bizPhone2"> </label>
                            </div>
                        </div>
                        <div class="col-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="bizPhone3" maxlength="4" placeholder="5678" required>
                                <label for="bizPhone3"> </label>
                            </div>
                        </div>
                        <span id="bizPhoneMsg" class="form-text"></span>
                    </div>
                    <input type="hidden" id="bizPhoneFull" name="phone">

                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="bizEmail" name="email" placeholder="이메일" required>
                        <label for="bizEmail">이메일</label>
                        <span id="bizEmailMsg" class="form-text"></span>
                    </div>

                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" name="companyName" placeholder="기업명" required>
                        <label for="companyName">기업명</label>
                    </div>
                    
                    <div class="row mb-3">
                        <div class="col-4">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="companyBuss1" maxlength="3" placeholder="123" required>
                                <label for="companyBuss1">사업자등록번호</label>
                            </div>
                        </div>
                        <div class="col-3">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="companyBuss2" maxlength="2" placeholder="45" required>
                                <label for="companyBuss2"> </label>
                            </div>
                        </div>
                        <div class="col-5">
                            <div class="form-floating">
                                <input type="text" class="form-control" id="companyBuss3" maxlength="5" placeholder="67890" required>
                                <label for="companyBuss3"> </label>
                            </div>
                        </div>
                    </div>
                    <input type="hidden" id="companyBussFull" name="businessNo">

                    <!-- 우편번호 검색 부분을 input-group으로 재구성 -->
                    <div class="input-group mb-3 address-input-group">
                        <div class="form-floating">
                            <input type="text" class="form-control" id="bizPostal" name="postal" placeholder="우편번호" readonly required>
                            <label for="bizPostal">우편번호</label>
                        </div>
                        <button class="btn btn-outline-secondary" type="button" id="bizPostcodeSearch">검색</button>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="bizAddress" name="address" placeholder="주소" readonly required>
                        <label for="bizAddress">주소</label>
                    </div>
                    <div class="form-floating mb-4">
                        <input type="text" class="form-control" name="detailAddress" placeholder="상세주소" required>
                        <label for="detailAddress">상세주소</label>
                    </div>

                    <div class="d-grid mb-4">
                      <button type="submit" class="btn btn-register">가입하기</button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
</main>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
