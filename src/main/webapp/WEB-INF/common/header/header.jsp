<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!-- 헤더 : 로그인 사용자 권한별 분기 -->
<sec:authorize access="hasRole('ROLE_ADMIN')">
    <jsp:include page="/WEB-INF/common/header_new/adminHeader.jsp"/>
</sec:authorize>

<sec:authorize access="hasRole('ROLE_BIZ')">
    <jsp:include page="/WEB-INF/common/header_new/bizHeader.jsp"/>
</sec:authorize>

<sec:authorize access="hasRole('ROLE_PERSONAL')">
    <jsp:include page="/WEB-INF/common/header_new/personalHeader.jsp"/>
</sec:authorize>

<sec:authorize access="isAnonymous()">
    <jsp:include page="/WEB-INF/common/header_new/publicHeader.jsp"/>
</sec:authorize>