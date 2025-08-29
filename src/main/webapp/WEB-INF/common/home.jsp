<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!-- 홈 : 로그인 사용자 권한별 분기 -->
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <a href="/admin/mainPage">Home</a>
</sec:authorize>

<sec:authorize access="hasRole('ROLE_BIZ')">
    <a href="/biz/mainPage">Home</a>
</sec:authorize>

<sec:authorize access="hasRole('ROLE_PERSONAL')">
    <a href="/personal/mainPage">Home</a>
</sec:authorize>

<sec:authorize access="isAnonymous()">
    <a href="/public/mainPage">Home</a>
</sec:authorize>