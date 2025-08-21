<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Page</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
.modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.5); }
.modal-content { background:#fff; padding:20px; margin:100px auto; width:400px; border-radius:10px; }
</style>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

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
            <tr><th>비밀번호 변경</th><td colspan="2"><button type="button" onclick="location.href='/public/changeMemberPw?id=${user.id}'">변경</button></td></tr>
            <tr><th>회원구분</th><td><input type="text" id="customerCategory" readonly value="${user.customerCategory}"></td></tr>
            <tr><th>이름</th><td><input type="text" id="name" readonly value="${user.name}"></td><td><button type="button" onclick="openChangeModal('name')">변경</button></td></tr>
            <tr><th>휴대폰 번호</th><td><input type="text" id="phone" readonly value="${user.phone}"></td><td><button type="button" onclick="openChangeModal('phone')">변경</button></td></tr>
            <tr><th>이메일</th><td><input type="text" id="email" readonly value="${user.email}"></td><td><button type="button" onclick="openChangeModal('email')">변경</button></td></tr>
            <tr><th>우편번호</th><td><input type="text" id="postal" readonly value="${user.postal}"></td><td><button type="button" onclick="openChangeModal('postal')">변경</button></td></tr>
            <tr><th>주소</th><td><input type="text" id="address" readonly value="${user.address}"></td></tr>
            <tr><th>상세주소</th><td><input type="text" id="detailAddress" readonly value="${user.detailAddress}"></td></tr>

            <!-- 개인회원 -->
            <c:if test="${user.customerCategory == 'CC003'}">
                <tr>
                    <th>간편 비밀번호</th>
                    <td>
                        <input type="password" id="simplePassword" readonly value="<c:out value='${user.simplePassword != null ? "설정됨" : "미설정"}'/>">
                        <button type="button" id="simplePasswordBtn" onclick="openChangeModal('simplePassword')">
                            <c:out value="${user.simplePassword != null ? '변경' : '생성'}"/>
                        </button>
                    </td>
                </tr>
                <tr><th>보유 적립금</th><td><input type="text" id="totalReward" readonly value="${user.totalReward}"></td></tr>
            </c:if>

            <!-- 기업회원 -->
            <c:if test="${user.customerCategory == 'CC002'}">
                <tr><th>기업명</th><td><input type="text" id="companyName" readonly value="${user.companyName}"></td><td><button type="button" onclick="openChangeModal('companyName')">변경</button></td></tr>
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
        <input type="text" id="changeValue">
        <button id="saveChangeBtn">저장</button>
        <button onclick="$('#changeModal').hide()">취소</button>
    </div>
</div>

<script>
let currentField = '';

// 페이지 로드 시 비밀번호 확인 모달 바로 표시
$(document).ready(function() {
    $("#passwordCheckModal").show();
    
 	// 뒤로가기 버튼
    $("#goBackBtn").click(function() {
        window.history.back();
    });

    // 비밀번호 확인
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

// 모달 오픈 함수
function openChangeModal(field){
    currentField = field;
    $("#changeTitle").text(field + " 변경");
    $("#changeValue").val($("#"+field).val());
    $("#changeModal").show();
}

// 정보 저장
$("#saveChangeBtn").click(function(){
    let value = $("#changeValue").val();
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
});
</script>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
