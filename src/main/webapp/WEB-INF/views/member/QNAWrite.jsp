<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>1:1 문의 등록</title>
<style>
    body {
        font-family: Arial, sans-serif;
        text-align: center;
        margin: 0;
        padding: 0;
    }
    h1 {
        margin-top: 30px;
    }
    form {
        width: 400px;
        margin: 30px auto;
        text-align: left;
        padding: 20px;
        border: 1px solid #ddd;
        border-radius: 6px;
        background-color: #f9f9f9;
    }
    label {
        font-weight: bold;
    }
    input[type="text"], textarea {
        width: 100%;
        padding: 6px;
        margin: 8px 0 15px 0;
        box-sizing: border-box;
    }
    button {
        width: 100%;
        padding: 10px;
        background-color: #4CAF50;
        color: white;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    button:hover {
        background-color: #45a049;
    }
</style>
</head>

<!-- 헤더 : 권한별 분기 -->
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <jsp:include page="/WEB-INF/common/header/adminHeader.jsp"/>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_BIZ')">
    <jsp:include page="/WEB-INF/common/header/bizHeader.jsp"/>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_PERSONAL')">
    <jsp:include page="/WEB-INF/common/header/personalHeader.jsp"/>
</sec:authorize>
<sec:authorize access="isAnonymous()">
    <jsp:include page="/WEB-INF/common/header/publicHeader.jsp"/>
</sec:authorize>

<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	
    <h1>1:1 문의 등록</h1>

    <!-- 문의 등록 폼 -->
    <form action="/member/QNAWrite" method="post">
        <label for="boardTitle">제목</label><br/>
        <input type="text" id="boardTitle" name="boardTitle" required /><br/><br/>

        <label for="boardContent">내용</label><br/>
        <textarea id="boardContent" name="boardContent" rows="6" required></textarea><br/><br/>

        <!-- hidden 값 : 구분 코드(BC002), 작성자 -->
        <input type="hidden" name="boardCode" value="BC002" />
        <sec:authentication property="name" var="loginId"/>
        <input type="hidden" name="createUser" value="${loginId}" />

        <button type="submit">등록하기</button>
    </form>
</body>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>