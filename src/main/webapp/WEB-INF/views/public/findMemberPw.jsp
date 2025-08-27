<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>비밀번호 찾기</title>
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

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<h1>비밀번호 찾기</h1>

<!-- 회원 구분 -->
<div>
    <label><input type="radio" name="customerCategory" value="CC003" checked> 개인회원</label>
    <label><input type="radio" name="customerCategory" value="CC002"> 기업회원</label>
</div>

<!-- 개인회원 폼 -->
<div id="personalForm">
    <p><input type="text" id="id" placeholder="아이디"></p>
    <p><input type="text" id="name" placeholder="이름"></p>
    <p><input type="text" id="sn" placeholder="주민등록번호"></p>
</div>

<!-- 기업회원 폼 -->
<div id="companyForm" style="display:none;">
    <p><input type="text" id="companyId" placeholder="아이디"></p>
    <p><input type="text" id="companyName" placeholder="기업명"></p>
    <p><input type="text" id="businessNo" placeholder="사업자등록번호"></p>
</div>

<button type="button" id="findPwBtn">임시 비밀번호 발급</button>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>