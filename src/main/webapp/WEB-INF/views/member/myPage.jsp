<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>My Page</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<style>
.modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); }
.modal-content { background:#fff; padding:20px; margin:100px auto; width:400px; border-radius:10px; }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<h1>마이페이지</h1>

<!-- 1. 비밀번호 확인 모달 -->
<div id="passwordCheckModal" class="modal">
    <div class="modal-content">
        <h3>비밀번호 확인</h3>
        <input type="password" id="checkPassword" placeholder="비밀번호 입력">
        <button id="checkPasswordBtn">확인</button>
        <button id="goBackBtn">뒤로가기</button>
    </div>
</div>

<!-- 2. 사용자 정보 영역 -->
<div id="userInfo" style="display:none;">
    <form id="myPageForm">
        <table>
            <tr><th>아이디</th><td><input type="text" id="userId" readonly value="${user.id}"></td></tr>
            <tr><th>비밀번호 변경</th><td colspan="2"><button type="button" onclick="location.href='/member/changeMemberPw'">변경</button></td></tr>
            <tr><th>회원구분</th><td><input type="text" id="customerCategory" readonly value="${user.customerCategory}"></td></tr>
            <tr><th>이름</th><td><input type="text" id="name" readonly value="${user.name}"> <button type="button" onclick="openChangeModal('name')">변경</button></td></tr>
            <tr><th>휴대폰 번호</th><td><input type="text" id="phone" readonly value="${user.phone}"> <button type="button" onclick="openChangeModal('phone')">변경</button></td></tr>
            <tr><th>이메일</th><td><input type="text" id="email" readonly value="${user.email}"> <button type="button" onclick="openChangeModal('email')">변경</button></td></tr>
            <tr><th>우편번호</th><td><input type="text" id="postal" readonly value="${user.postal}"> <button type="button" onclick="openChangeModal('postal')">변경</button></td></tr>
            <tr><th>주소</th><td><input type="text" id="address" readonly value="${user.address}"></td></tr>
            <tr><th>상세주소</th><td><input type="text" id="detailAddress" readonly value="${user.detailAddress}"></td></tr>

            <!-- 개인회원 -->
            <c:if test="${user.customerCategory == 'CC003'}">
                <tr>
                    <th>간편 비밀번호</th>
                    <td>
                        <input type="text" id="simplePassword" readonly value="<c:out value='${user.simplePassword != null ? "설정됨" : "미설정"}'/>">
                        <button type="button" id="simplePasswordBtn" onclick="openChangeModal('simplePassword')">
                            <c:out value="${user.simplePassword != null ? '변경' : '생성'}"/>
                        </button>
                    </td>
                </tr>
                <tr><th>보유 적립금</th><td><input type="text" id="totalReward" readonly value="${user.totalReward}"></td></tr>
				<tr>
				    <th>소셜 계정 연동</th>
				    <td>
				        <c:forEach var="s" items="${socialList}">
							${s.socialType}
							<button type="button" onclick="unlinkSocial('${s.socialType}')">해제</button><br/>
						</c:forEach>
						<button type="button" onclick="openSocialModal()">소셜 계정 추가 연동</button>
				    </td>
				</tr>
           	</c:if>

            <!-- 기업회원 -->
            <c:if test="${user.customerCategory == 'CC002'}">
                <tr><th>기업명</th><td><input type="text" id="companyName" readonly value="${user.companyName}"> <button type="button" onclick="openChangeModal('companyName')">변경</button></td></tr>
                <tr><th>사업자등록번호</th><td><input type="text" id="businessNo" readonly value="${user.businessNo}"></td></tr>
            </c:if>

            <tr><th>생성일</th><td><input type="text" id="createDate" readonly value="${user.createDate}"></td></tr>
        </table>
    </form>
</div>

<!-- 정보 수정 모달 -->
<div id="changeModal" class="modal">
    <div class="modal-content">
        <h3 id="changeTitle">정보 변경</h3>

        <!-- 일반 필드용 -->
        <input type="text" id="changeValue">

        <!-- 주소 변경용 -->
        <div id="addressChangeFields" style="display:none;">
            <label>우편번호: <input type="text" id="modalPostal" readonly>
                <button type="button" id="searchPostalBtn">주소 검색</button>
            </label><br>
            <label>주소: <input type="text" id="modalAddress" readonly></label><br>
            <label>상세주소: <input type="text" id="modalDetailAddress"></label>
        </div>

        <button id="saveChangeBtn">저장</button>
        <button onclick="$('#changeModal').hide()">취소</button>
    </div>
</div>

<!-- 소셜 연동 모달 -->
<div id="socialModal" class="modal">
  <div class="modal-content">
    <h3>소셜 로그인 연동</h3>
    <button onclick="linkSocial('kakao')">카카오 연동</button>
    <button onclick="linkSocial('naver')">네이버 연동</button>
    <button onclick="$('#socialModal').hide()">취소</button>
  </div>
</div>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
let currentField = '';

// 페이지 로드 시 비밀번호 확인 모달
$(document).ready(function() {
    $("#passwordCheckModal").show();

    $("#goBackBtn").click(function() { window.history.back(); });

    $("#checkPasswordBtn").click(function() {
        let password = $("#checkPassword").val();
        $.post("/public/checkPassword", { password: password }, function(result) {
            if(result){
                $("#passwordCheckModal").hide();
                $("#userInfo").show();
            } else {
                alert("비밀번호가 일치하지 않습니다.");
            }
        });
    });
});

// 모달 열기 함수
function openChangeModal(field){
    currentField = field;
    $("#changeValue").val('');
    $("#modalPostal").val('');
    $("#modalAddress").val('');
    $("#modalDetailAddress").val('');
    
    if(field === "postal"){
        $("#changeValue").hide();
        $("#addressChangeFields").show();
        $("#changeTitle").text("주소 변경");

        $("#modalPostal").val($("#postal").val());
        $("#modalAddress").val($("#address").val());
        $("#modalDetailAddress").val($("#detailAddress").val());
    } else {
        $("#changeValue").show();
        $("#addressChangeFields").hide();
        $("#changeTitle").text(field + " 변경");
        $("#changeValue").val($("#"+field).val());
    }
    $("#changeModal").show();
}

// 주소 검색 버튼
$("#searchPostalBtn").click(function(){
    new daum.Postcode({
        oncomplete: function(data){
            $("#modalPostal").val(data.zonecode);
            $("#modalAddress").val(data.roadAddress);
            $("#modalDetailAddress").focus();
        }
    }).open();
});

// 소셜 연동
function openSocialModal() { $("#socialModal").show(); }
function linkSocial(provider) { location.href = "/api/social/link/" + provider; }
function unlinkSocial(provider) {
    $.ajax({
        url: "/api/social/unlink/" + provider,
        type: "DELETE",
        success: function(res){ alert(res); location.reload(); },
        error: function(){ alert("연동 해제 실패"); }
    });
}

// 이메일 체크
function validateEmail(email) {
    const re = /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/;
    return re.test(email);
}
// 전화번호 체크
function validatePhone(phone) {
    const re = /^01[016789]-\d{3,4}-\d{4}$/;
    return re.test(phone);
}

// 저장 버튼
// 저장 버튼 클릭 이벤트 (한 번만)
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
                $("#postal").val(postal);
                $("#address").val(address);
                $("#detailAddress").val(detail);
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
        if(currentField === "email" && !validateEmail(value)){
            alert("올바른 이메일 형식을 입력해주세요.");
            return;
        }
        if(currentField === "phone" && !validatePhone(value)){
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

</script>

</body>
</html>
