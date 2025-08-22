<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>

<!-- 사이드바 : 로그인 사용자 권한별 분기 -->
<sec:authorize access="hasRole('ROLE_BIZ')">
    <jsp:include page="/WEB-INF/common/sidebar/bizSidebar.jsp"/>
</sec:authorize>

<sec:authorize access="isAnonymous() or hasAnyRole('ROLE_ADMIN','ROLE_PERSONAL')">
    <jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp"/>
</sec:authorize>