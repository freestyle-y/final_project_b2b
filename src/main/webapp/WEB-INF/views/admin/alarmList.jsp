<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>알림 목록</title>
<style>
    table {
        width: 90%;
        border-collapse: collapse;
        text-align: center;
        margin: auto;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
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
	
	<h1>알림 목록</h1>
	<table>
		<tr>
			<th>번호</th>
			<th>알림 대상</th>
			<th>알림 종류</th>
			<th>제목</th>
			<th>내용</th>
			<th>target URL</th>
			<th>image URL</th>
			<th>확인 유무</th>
			<th>확인 일시</th>
			<th>작성자</th>
			<th>작성 일시</th>
			<th>수정자</th>
			<th>수정 일시</th>
			<th>사용 유무</th>
		</tr>
		
		<c:forEach var="alarmList" items="${alarmList}">
			<tr>
				<td>${alarmList.notificationNo}</td>
				<td>${alarmList.targetDisplay}</td>
				<td>${alarmList.notificationType}</td>
				<td>${alarmList.notificationTitle}</td>
				<td>${alarmList.notificationContent}</td>
				<td>${alarmList.targetUrl}</td>
				<td>${alarmList.imageUrl}</td>
				<td>${alarmList.readStatus}</td>
				<td>${alarmList.readDate}</td>
				<td>${alarmList.createUser}</td>
				<td>${alarmList.createDate}</td>
				<td>${alarmList.updateUser}</td>
				<td>${alarmList.updateDate}</td>
				<td>${alarmList.useStatus}</td>
			</tr>
		</c:forEach>
	</table>
</body>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>