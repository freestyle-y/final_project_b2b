<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>아이디 찾기</title>
<style>
    .form-container { max-width: 400px; margin: 50px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background: #fff; }
    input[type=text], input[type=radio] { width: 100%; padding: 10px; margin: 8px 0; box-sizing: border-box; }
    button { width: 100%; padding: 10px; background: #4CAF50; color: white; border: none; border-radius: 4px; cursor: pointer; }
    button:hover { background: #45a049; }
    .small-link { font-size: 12px; margin-top: 10px; display: inline-block; }
    .hidden { display: none; }
</style>
<script>
function toggleForm() {
    const personalForm = document.getElementById("personalForm");
    const bizForm = document.getElementById("bizForm");
    const selected = document.querySelector('input[name="memberType"]:checked').value;
    if(selected === 'PERSONAL') {
        personalForm.classList.remove("hidden");
        bizForm.classList.add("hidden");
    } else {
        personalForm.classList.add("hidden");
        bizForm.classList.remove("hidden");
    }
}

function showAlert(message) {
    alert(message);
}
</script>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<div class="form-container">
    <h2>아이디 찾기</h2>

    <!-- 회원 유형 선택 -->
    <label><input type="radio" name="memberType" value="PERSONAL" checked onclick="toggleForm()"> 개인회원</label>
    <label><input type="radio" name="memberType" value="BIZ" onclick="toggleForm()"> 기업회원</label>

    <!-- 개인회원 폼 -->
    <form id="personalForm" action="/public/findMemberIdAction" method="post">
        <input type="hidden" name="memberType" value="PERSONAL"/>
        <input type="text" name="name" placeholder="이름" required/>
        <input type="text" name="sn" placeholder="주민등록번호" required/>
        <button type="submit">아이디 찾기</button>
    </form>

    <!-- 기업회원 폼 -->
    <form id="bizForm" class="hidden" action="/public/findMemberIdAction" method="post">
        <input type="hidden" name="memberType" value="BIZ"/>
        <input type="text" name="companyName" placeholder="기업명" required/>
        <input type="text" name="businessNo" placeholder="사업자등록번호" required/>
        <button type="submit">아이디 찾기</button>
    </form>

    <!-- 아이디 출력 -->
    <c:if test="${not empty foundId}">
        <p>회원님의 아이디는: <strong>${foundId}</strong> 입니다.</p>
        <a href="/public/findMemberPw" class="small-link">비밀번호 찾기</a>
    </c:if>

    <!-- 일치하는 회원 없음 -->
    <c:if test="${not empty notFound}">
        <script>showAlert('일치하는 회원이 없습니다.');</script>
    </c:if>
</div>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
