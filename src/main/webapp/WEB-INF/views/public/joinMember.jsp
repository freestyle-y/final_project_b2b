<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>회원가입</title>
<style>
    .hidden { display: none; }
    .error { color: red; font-size: 12px; }
    .success { color: green; font-size: 12px; }
    label { display: block; margin-top: 8px; }
    input[readonly] { background-color: #f0f0f0; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    // 회원 유형 선택
    function toggleMemberForm(type){
        $("#personalForm").toggle(type==='personal');
        $("#companyForm").toggle(type==='company');
    }

    // 카카오 우편번호 API
    function execDaumPostcode(postalId, addressId){
        new daum.Postcode({
            oncomplete: function(data){
                $("#" + postalId).val(data.zonecode);
                $("#" + addressId).val(data.roadAddress);
            }
        }).open();
    }

    // 비밀번호 유효성 체크
    function validatePassword(pw){
        const re = /^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
        return re.test(pw);
    }

    // 이메일 유효성
    function validateEmail(email){
        const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return re.test(email);
    }
	
 	// 주민등록번호 체크
    function validateSn(front, back){
        return front.length === 6 && back.length === 7;
    }
 	
 	// 휴대폰 체크
    function validatePhone(p1,p2,p3){
        return p1.length === 3 && p2.length >= 3 && p3.length === 4;
    }
 	
 	// 주소 체크
    function validateAddress(postal, address, detail){
        return postal.trim()!=="" && address.trim()!=="" && detail.trim()!=="";
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

        // 비밀번호 유효성
        if(pw === "") {
            $("#" + pwMsgId).text("");
        } else if(validatePassword(pw)){
            $("#" + pwMsgId).text("사용 가능한 비밀번호입니다.").removeClass("error").addClass("success");
        } else {
            $("#" + pwMsgId).text("8자 이상, 대문자 1개, 특수문자 1개 필요").removeClass("success").addClass("error");
        }

        // 비밀번호 확인 일치
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
    

    // 아이디 중복 체크
    function setupIdCheck(inputId, msgId){
        $("#" + inputId).on("input blur", function(){
            const userId = $(this).val().trim();
            const msgSpan = $("#" + msgId);
            if(userId === ""){ msgSpan.text(""); return; }

            $.get("/public/checkId", {id:userId}, function(data){
                if(data === "OK"){
                    msgSpan.text("사용 가능한 아이디입니다.").removeClass("error").addClass("success");
                } else {
                    msgSpan.text("중복된 아이디입니다.").removeClass("success").addClass("error");
                }
            });
        });
    }

    // 폼 제출 전 데이터 포맷
    function formatData(formId){
        if(formId==='personalForm'){
            $("#personalSnFull").val($("#personalSn1").val() + "-" + $("#personalSn2").val());
            $("#personalPhoneFull").val($("#personalPhone1").val() + "-" + $("#personalPhone2").val() + "-" + $("#personalPhone3").val());
        } else {
            $("#bizSnFull").val($("#bizSn1").val() + "-" + $("#bizSn2").val());
            $("#bizPhoneFull").val($("#bizPhone1").val() + "-" + $("#bizPhone2").val() + "-" + $("#bizPhone3").val());
            $("#companyBussFull").val($("#companyBuss1").val() + "-" + $("#companyBuss2").val() + "-" + $("#companyBuss3").val());
        }
    }

    // AJAX 제출
    function submitForm(formId, url){
        formatData(formId);
        if(!validateBeforeSubmit(formId)) return false;
        
        const form = $("#" + formId);
        $.post(url, form.serialize())
        .done(function(res){
            if(res==="SUCCESS"){
                alert("회원가입 완료!");
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
        if(formId === 'personalForm'){
            valid = $("#personalId").val().trim() !== "" &&
                    $("#personalPassword").val().trim() !== "" &&
                    $("#personalConfirm").val().trim() !== "" &&
                    $("#personalName").val().trim() !== "" &&
                    validatePhone($("#personalPhone1").val(), $("#personalPhone2").val(), $("#personalPhone3").val()) &&
                    validateSn($("#personalSn1").val(), $("#personalSn2").val()) &&
                    validateEmail($("#personalEmail").val()) &&
                    validateAddress($("#personalPostal").val(), $("#personalAddress").val(), $("input[name='detailAddress']").val());
        } else { // companyForm
            valid = $("#bizId").val().trim() !== "" &&
                    $("#bizPassword").val().trim() !== "" &&
                    $("#bizConfirm").val().trim() !== "" &&
                    $("#bizName").val().trim() !== "" &&
                    validatePhone($("#bizPhone1").val(), $("#bizPhone2").val(), $("#bizPhone3").val()) &&
                    validateSn($("#bizSn1").val(), $("#bizSn2").val()) &&
                    validateEmail($("#bizEmail").val()) &&
                    $("input[name='companyName']").val().trim() !== "" &&
                    $("#companyBuss1").val().trim() !== "" &&
                    $("#companyBuss2").val().trim() !== "" &&
                    $("#companyBuss3").val().trim() !== "" &&
                    validateAddress($("#bizPostal").val(), $("#bizAddress").val(), $("#companyForm input[name='detailAddress']").val());
        }

        if(!valid){
            alert("입력되지 않은 항목이 있습니다");
            return false;
        }

        return true;
    }

    $(function(){
        // 아이디 체크
        setupIdCheck("personalId","personalIdMsg");
        setupIdCheck("bizId","bizIdMsg");

        // 실시간 비밀번호 & 확인
        $("#personalPassword, #personalConfirm").on("input", function(){
            checkPassword("personalPassword","personalConfirm","personalPwMsg","personalConfirmMsg");
        });
        $("#bizPassword, #bizConfirm").on("input", function(){
            checkPassword("bizPassword","bizConfirm","bizPwMsg","bizConfirmMsg");
        });

        // 실시간 이메일
        $("#personalEmail").on("input", function(){ checkEmail("personalEmail","personalEmailMsg"); });
        $("#bizEmail").on("input", function(){ checkEmail("bizEmail","bizEmailMsg"); });

        // 이름 체크
        $("#personalName").on("input", function(){ checkName("personalName","personalNameMsg"); });
        $("#bizName").on("input", function(){ checkName("bizName","bizNameMsg"); });
        
    	// 주민등록번호 체크
        $("#personalSn1, #personalSn2").on("input", function(){ checkSn("personalSn1","personalSn2","personalSnMsg"); });
        $("#bizSn1, #bizSn2").on("input", function(){ checkSn("bizSn1","bizSn2","bizSnMsg"); });

        // 휴대폰 번호 체크
        $("#personalPhone1, #personalPhone2, #personalPhone3").on("input", function(){ checkPhone("personalPhone1","personalPhone2","personalPhone3","personalPhoneMsg"); });
        $("#bizPhone1, #bizPhone2, #bizPhone3").on("input", function(){ checkPhone("bizPhone1","bizPhone2","bizPhone3","bizPhoneMsg"); });
    });
</script>
</head>
<body>
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<h1>회원가입</h1>

<div>
    <label><input type="radio" name="customerCategory" value="CC003" onclick="toggleMemberForm('personal')" checked> 개인회원</label>
    <label><input type="radio" name="customerCategory" value="CC002" onclick="toggleMemberForm('company')"> 기업회원</label>
</div>

<!-- 개인회원 폼 -->
<form id="personalForm" onsubmit="return submitForm('personalForm','/public/joinPersonal');">
    <label>아이디: <input type="text" id="personalId" name="id" required> <span id="personalIdMsg"></span></label>
    <label>비밀번호: <input type="password" id="personalPassword" name="password" required> <span id="personalPwMsg"></span></label>
    <label>비밀번호 확인: <input type="password" id="personalConfirm" name="passwordConfirm" required> <span id="personalConfirmMsg"></span></label>
    <label>이름: <input type="text" id="personalName" name="name" required onkeypress="allowOnlyNameChar(event)"> <span id="personalNameMsg"></span></label>
    <label>휴대폰: 
        <input type="text" id="personalPhone1" maxlength="3" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'personalPhone2',3)"> -
        <input type="text" id="personalPhone2" maxlength="4" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'personalPhone3',4)"> -
        <input type="text" id="personalPhone3" maxlength="4" required onkeypress="allowOnlyNumber(event)"> <span id="personalPhoneMsg"></span>
    </label>
    <input type="hidden" id="personalPhoneFull" name="phone">
    <label>이메일: <input type="text" id="personalEmail" name="email" required> <span id="personalEmailMsg"></span></label>
    <label>주민등록번호: <input type="text" id="personalSn1" maxlength="6" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'personalSn2',6)"> -
        <input type="password" id="personalSn2" maxlength="7" required onkeypress="allowOnlyNumber(event)"> <span id="personalSnMsg"></span>
    </label>
    <input type="hidden" id="personalSnFull" name="sn">
    <label>우편번호: <input type="text" id="personalPostal" name="postal" readonly> 
        <button type="button" onclick="execDaumPostcode('personalPostal','personalAddress')">검색</button>
    </label>
    <label>주소: <input type="text" id="personalAddress" name="address" readonly></label>
    <label>상세주소: <input type="text" name="detailAddress"></label>
    <button type="submit">가입하기</button>
</form>

<!-- 기업회원 폼 -->
<form id="companyForm" class="hidden" onsubmit="return submitForm('companyForm','/public/joinBiz');">
    <label>아이디: <input type="text" id="bizId" name="id" required> <span id="bizIdMsg"></span></label>
    <label>비밀번호: <input type="password" id="bizPassword" name="password" required> <span id="bizPwMsg"></span></label>
    <label>비밀번호 확인: <input type="password" id="bizConfirm" name="passwordConfirm" required> <span id="bizConfirmMsg"></span></label>
    <label>이름: <input type="text" id="bizName" name="name" required onkeypress="allowOnlyNameChar(event)"> <span id="bizNameMsg"></span></label>
    <label>휴대폰: 
        <input type="text" id="bizPhone1" maxlength="3" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'bizPhone2',3)"> -
        <input type="text" id="bizPhone2" maxlength="4" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'bizPhone3',4)"> -
        <input type="text" id="bizPhone3" maxlength="4" required onkeypress="allowOnlyNumber(event)"> <span id="bizPhoneMsg"></span>
    </label>
    <input type="hidden" id="bizPhoneFull" name="phone">
    <label>이메일: <input type="text" id="bizEmail" name="email" required> <span id="bizEmailMsg"></span></label>
    <label>기업명: <input type="text" name="companyName" required></label>
    <label>사업자등록번호: 
        <input type="text" id="companyBuss1" maxlength="3" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'companyBuss2',3)"> -
        <input type="text" id="companyBuss2" maxlength="2" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'companyBuss3',2)"> -
        <input type="text" id="companyBuss3" maxlength="5" required onkeypress="allowOnlyNumber(event)">
    </label>
    <input type="hidden" id="companyBussFull" name="businessNo">
    <label>우편번호: <input type="text" id="bizPostal" name="postal" readonly> 
        <button type="button" onclick="execDaumPostcode('bizPostal','bizAddress')">검색</button>
    </label>
    <label>주소: <input type="text" id="bizAddress" name="address" readonly></label>
    <label>상세주소: <input type="text" name="detailAddress"></label>
    <button type="submit">가입하기</button>
</form>

</main>

<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>
