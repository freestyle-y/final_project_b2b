<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회원 가입</title>
<style>
    .hidden { display: none; }
    .error { color: red; font-size: 0.9em; }
    .success { color: green; font-size: 0.9em; }
    label { display: block; margin-top: 8px; }
    input[readonly] { background-color: #f0f0f0; }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
let verifiedId = ""; // 실제 사용할 중복 확인된 아이디

// 회원 유형 선택
function toggleMemberForm(type){
    document.getElementById("personalForm").classList.toggle("hidden", type!=='personal');
    document.getElementById("companyForm").classList.toggle("hidden", type!=='company');
}

// 카카오 우편번호 API
function execDaumPostcode(postalId, addressId){
    new daum.Postcode({
        oncomplete: function(data){
            document.getElementById(postalId).value = data.zonecode;
            document.getElementById(addressId).value = data.roadAddress;
        }
    }).open();
}

// 이메일 유효성
function validateEmail(email){
    const re = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    return re.test(email);
}

// 비밀번호 유효성
function validatePassword(pw){
    const re = /^(?=.*[A-Z])(?=.*[!@#$%^&*])[A-Za-z\d!@#$%^&*]{8,}$/;
    return re.test(pw);
}

// 비밀번호 실시간 확인
function checkPasswordMatch(passwordId, confirmId, msgId){
    const pw = document.getElementById(passwordId).value;
    const confirm = document.getElementById(confirmId).value;
    const msg = document.getElementById(msgId);
    if(confirm === "") { msg.innerText=""; return; }
    if(pw === confirm){ msg.innerText="비밀번호가 일치합니다."; msg.className="success"; }
    else { msg.innerText="비밀번호가 일치하지 않습니다."; msg.className="error"; }
}

// 아이디 중복 확인 후 readonly input에 표시
function checkId(inputId, msgId, displayId){
    const userId = document.getElementById(inputId).value.trim();
    const displayInput = document.getElementById(displayId);

    if(userId === ""){
        document.getElementById(msgId).innerText = "아이디를 입력해주세요";
        document.getElementById(msgId).className = "error";
        displayInput.value = "";
        return;
    }

    $.ajax({
        url: "/public/checkId",
        type: "get",
        data: { id: userId },
        success: function(data){
            if(data === "OK"){
                document.getElementById(msgId).innerText = "사용 가능한 아이디입니다.";
                document.getElementById(msgId).className = "success";
                displayInput.value = userId;
            } else {
                document.getElementById(msgId).innerText = "이미 사용중인 아이디입니다.";
                document.getElementById(msgId).className = "error";
                displayInput.value = "";
            }
        },
        error: function(){ alert("서버 오류가 발생했습니다."); }
    });
}

// 자동 포커스 이동
function autoMoveNext(current, nextId, maxLength){
    if(current.value.length >= maxLength){
        document.getElementById(nextId).focus();
    }
}

// 숫자만 입력 가능
function allowOnlyNumber(event){
    const key = event.key;
    if(!/[\d]|Backspace|ArrowLeft|ArrowRight|Tab/.test(key)){
        event.preventDefault();
    }
}


</script>
</head>

<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h1>회원 가입</h1>

<div>
    <label><input type="radio" name="customerCategory" value="CC003" onclick="toggleMemberForm('personal')" checked> 개인회원</label>
    <label><input type="radio" name="customerCategory" value="CC002" onclick="toggleMemberForm('company')"> 기업회원</label>
</div>

<!-- 개인회원 폼 -->
<form id="personalForm" action="/public/joinPersonal" method="post" onsubmit="return submitPersonalForm('personalForm','/public/joinPersonal')">
    <label>아이디: 
        <input type="text" id="personalId" name="id" required>
        <button type="button" onclick="checkId('personalId','personalIdMsg','personalFormId')">중복확인</button>
        <span id="personalIdMsg"></span>
    </label>
    <label>중복확인 ID: <input type="text" id="personalFormId" name="idVerified" readonly></label>
    <label>비밀번호: <input type="password" id="personalPassword" name="password" required oninput="checkPasswordMatch('personalPassword','personalConfirm','personalPwMsg')"></label>
    <label>비밀번호 확인: <input type="password" id="personalConfirm" name="passwordConfirm" required oninput="checkPasswordMatch('personalPassword','personalConfirm','personalPwMsg')">
        <span id="personalPwMsg"></span>
    </label>
    <label>주민등록번호: 
        <input type="text" id="personalSn1" maxlength="6" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'personalSn2',6)"> -
        <input type="password" id="personalSn2" maxlength="7" required onkeypress="allowOnlyNumber(event)">
    </label>
    <input type="hidden" name="sn" id="personalSnFull">

    <label>이름: <input type="text" name="name" required></label>

    <label>휴대폰: 
        <input type="text" id="personalPhone1" maxlength="3" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'personalPhone2',3)"> -
        <input type="text" id="personalPhone2" maxlength="4" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'personalPhone3',4)"> -
        <input type="text" id="personalPhone3" maxlength="4" required onkeypress="allowOnlyNumber(event)">
    </label>
    <input type="hidden" name="phone" id="personalPhoneFull">

    <label>이메일: <input type="email" name="email" required></label>
    <label>우편번호: <input type="text" id="personalPostal" name="postal" readonly>
        <button type="button" onclick="execDaumPostcode('personalPostal','personalAddress')">검색</button>
    </label>
    <label>주소: <input type="text" id="personalAddress" name="address" readonly></label>
    <label>상세주소: <input type="text" name="detailAddress"></label>
    <button type="submit">가입하기</button>
</form>

<!-- 기업회원 폼 -->
<form id="companyForm" class="hidden" action="/public/joinBiz" method="post" onsubmit="return submitCompanyForm('companyForm','/public/joinBiz')">
    <label>아이디: 
        <input type="text" id="bizId" name="id" required>
        <button type="button" onclick="checkId('bizId','bizIdMsg','companyFormId')">중복확인</button>
        <span id="bizIdMsg"></span>
    </label>
    <label>중복확인 ID: <input type="text" id="companyFormId" name="idVerified" readonly></label>
    <label>비밀번호: <input type="password" id="bizPassword" name="password" required oninput="checkPasswordMatch('bizPassword','bizConfirm','bizPwMsg')"></label>
    <label>비밀번호 확인: <input type="password" id="bizConfirm" name="passwordConfirm" required oninput="checkPasswordMatch('bizPassword','bizConfirm','bizPwMsg')">
        <span id="bizPwMsg"></span>
    </label>
    <label>주민등록번호: 
        <input type="text" id="bizSn1" maxlength="6" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'bizSn2',6)"> -
        <input type="password" id="bizSn2" maxlength="7" required onkeypress="allowOnlyNumber(event)">
    </label>
    <input type="hidden" name="sn" id="bizSnFull">

    <label>이름: <input type="text" name="name" required></label>

    <label>휴대폰:
        <input type="text" id="bizPhone1" maxlength="3" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'bizPhone2',3)"> -
        <input type="text" id="bizPhone2" maxlength="4" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'bizPhone3',4)"> -
        <input type="text" id="bizPhone3" maxlength="4" required onkeypress="allowOnlyNumber(event)">
    </label>
    <input type="hidden" name="phone" id="bizPhoneFull">

    <label>이메일: <input type="email" name="email" required></label>
    <label>기업명: <input type="text" name="companyName" required></label>
    <label>사업자등록번호:
        <input type="text" id="companyBuss1" maxlength="3" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'companyBuss2',3)"> -
        <input type="text" id="companyBuss2" maxlength="2" required onkeypress="allowOnlyNumber(event)" oninput="autoMoveNext(this,'companyBuss3',2)"> -
        <input type="text" id="companyBuss3" maxlength="5" required onkeypress="allowOnlyNumber(event)">
    </label>
    <input type="hidden" name="businessNo" id="companyBussFull">

    <label>우편번호: <input type="text" id="bizPostal" name="postal" readonly>
        <button type="button" onclick="execDaumPostcode('bizPostal','bizAddress')">검색</button>
    </label>
    <label>주소: <input type="text" id="bizAddress" name="address" readonly></label>
    <label>상세주소: <input type="text" name="detailAddress"></label>
    <button type="submit">가입하기</button>
</form>
<script>
//회원가입 전 유효성 체크
function validateForm(formId){
    const form = document.getElementById(formId);
    const idVerified = form.querySelector("[name='idVerified']").value;
    const pw = form.querySelector("[name='password']").value;
    const confirmPw = form.querySelector("[name='passwordConfirm']").value;
    const email = form.querySelector("[name='email']").value;

    if(!idVerified){ alert("아이디 중복 확인이 필요합니다."); return false; }
    if(!validatePassword(pw)){ alert("비밀번호는 8자 이상, 대문자 1개, 특수문자 1개를 포함해야 합니다."); return false; }
    if(pw !== confirmPw){ alert("비밀번호가 일치하지 않습니다."); return false; }
    if(!validateEmail(email)){ alert("유효한 이메일을 입력해주세요."); return false; }

    return true;
}

// 제출 직전에 - 추가 후 전송
function formatDataBeforeSubmit(formId){
	const form = document.getElementById(formId);

    // 개인회원
    if(formId==='personalForm'){
        document.getElementById("personalSnFull").value = 
            document.getElementById("personalSn1").value + "-" + document.getElementById("personalSn2").value;
        document.getElementById("personalPhoneFull").value = 
            document.getElementById("personalPhone1").value + "-" + document.getElementById("personalPhone2").value + "-" + document.getElementById("personalPhone3").value;
    }
    // 기업회원
    else if(formId==='companyForm'){
        document.getElementById("bizSnFull").value = 
            document.getElementById("bizSn1").value + "-" + document.getElementById("bizSn2").value;
        document.getElementById("bizPhoneFull").value = 
            document.getElementById("bizPhone1").value + "-" + document.getElementById("bizPhone2").value + "-" + document.getElementById("bizPhone3").value;
        document.getElementById("companyBussFull").value = 
            document.getElementById("companyBuss1").value + "-" + document.getElementById("companyBuss2").value + "-" + document.getElementById("companyBuss3").value;
    }

    return validateForm(formId);
}

//개인회원 Ajax 제출
function submitPersonalForm(){
    if(!formatDataBeforeSubmit('personalForm')) return false;

    $.post('/public/joinPersonal', $('#personalForm').serialize())
     .done(function(res){
         if(res === "SUCCESS"){
             alert("회원가입 완료!");
             window.location.href = "/public/mainPage"; // 메인페이지 이동
         } else {
             alert("오류: " + res);
         }
     })
     .fail(function(xhr){
         alert("회원가입 실패 : " + xhr.responseText);
     });

    return false; // 기본 submit 막기
}

// 기업회원 Ajax 제출
function submitCompanyForm(){
    if(!formatDataBeforeSubmit('companyForm')) return false;

    $.post('/public/joinBiz', $('#companyForm').serialize())
     .done(function(res){
         if(res === "SUCCESS"){
             alert("회원가입 완료!");
             window.location.href = "/public/mainPage"; // 메인페이지 이동
         } else {
             alert("오류: " + res);
         }
     })
     .fail(function(xhr){
         alert("회원가입 실패 : " + xhr.responseText);
     });

    return false; // 기본 submit 막기
}
</script>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>