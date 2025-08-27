<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>비밀번호 변경</title>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<style>
    .error-msg { color: red; font-size: 0.9em; margin-left: 8px; }
    .success-msg { color: green; font-size: 0.9em; margin-left: 8px; }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

    <h1>비밀번호 변경</h1>
	
	<c:if test="${not empty error}">
	<script>
		alert("${error}");
	</script>
	</c:if>
	<c:if test="${not empty success}">
	<script>
		alert("${success}");
		window.location.href = "/public/logout";  // 확인 누르면 자동 로그아웃
	</script>
	</c:if>
	
    <form id="pwForm" action="/member/changeMemberPw" method="post">
    	<input type="hidden" name="id" value="${id}">
        <div>
            현재 비밀번호 : 
            <input type="password" id="nowPw" name="nowPw">
        </div>
        <br>
        <div>
            변경 비밀번호 : 
            <input type="password" id="newPw" name="newPw">
            <span id="newPwMsg" class="error-msg"></span>
        </div>
        <br>
        <div>
            비밀번호 확인 : 
            <input type="password" id="password" name="password">
            <span id="confirmMsg" class="error-msg"></span>
        </div>
        <br>
        <button type="submit">변경하기</button>
    </form>
    
    <!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>

    <script>
    $(function() {
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