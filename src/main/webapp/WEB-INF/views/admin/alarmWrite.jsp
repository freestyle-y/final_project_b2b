<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림 등록</title>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 0;
    }
    h1 {
        margin: 30px 0;
        text-align: center;
    }
    form {
        width: 500px;
        margin: 20px auto 40px auto;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 8px;
        background-color: #fff;
        box-shadow: 0 2px 5px rgba(0,0,0,0.1);
    }
    label {
        font-weight: bold;
        margin-top: 10px;
        display: block;
    }
    input[type="text"], select, textarea {
        width: 100%;
        padding: 8px;
        margin-top: 6px;
        margin-bottom: 15px;
        border: 1px solid #ccc;
        border-radius: 4px;
        box-sizing: border-box;
    }
    textarea {
        resize: vertical;
    }
    button {
        width: 100%;
        padding: 12px;
        background-color: #4CAF50;
        color: white;
        font-size: 16px;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    button:hover {
        background-color: #45a049;
    }
</style>
</head>

<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

    <h1>알림 작성</h1>

    <form action="/admin/notification/write" method="post">
        <label for="targetType">대상 유형</label>
        <select name="targetType" id="targetType" required onchange="updateTargetField()">
            <option value="">-- 선택 --</option>
            <option value="USER">개별 사용자</option>
            <option value="ROLE">회원 유형</option>
            <option value="ALL">전체 회원</option>
        </select>

        <label for="targetValue">대상 값</label>
        <div id="targetValueWrapper">
            <input type="text" name="targetValue" placeholder="대상 유형을 선택하세요.">
        </div>

        <label for="notificationType">알림 유형</label>
        <select name="notificationType" id="notificationType" required>
            <option value="">-- 선택 --</option>
            <option value="NC001">주문</option>
            <option value="NC002">배송</option>
            <option value="NC003">결제</option>
            <option value="NC004">이벤트</option>
            <option value="NC005">시스템</option>
            <option value="NC006">기타</option>
        </select>

        <label for="notificationTitle">알림 제목</label>
        <input type="text" name="notificationTitle" id="notificationTitle" required>

        <label for="notificationContent">알림 내용</label>
        <textarea name="notificationContent" id="notificationContent" rows="5"></textarea>

        <button type="submit">등록하기</button>
    </form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
<script>
    // 대상 유형 선택에 따라 targetValue 필드 변경
    function updateTargetField() {
        const type = document.getElementById("targetType").value;
        const wrapper = document.getElementById("targetValueWrapper");

        if (type === "USER") {
            wrapper.innerHTML = '<input type="text" name="targetValue" placeholder="알림을 받을 사용자 ID 입력 (예: personal001)">';
        } else if (type === "ROLE") {
            wrapper.innerHTML = `
                <select name="targetValue" required>
                    <option value="">-- 회원 유형 선택 --</option>
                    <option value="CC002">기업회원</option>
                    <option value="CC003">개인회원</option>
                </select>
            `;
        } else if (type === "ALL") {
            wrapper.innerHTML = '<input type="text" name="targetValue" value="" placeholder="전체 회원 선택 시 입력 불필요" disabled>';
        } else {
            wrapper.innerHTML = '<input type="text" name="targetValue" placeholder="대상 유형을 선택하세요.">';
        }
    }
</script>
</html>