<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 메인 페이지</title>
<style>
    .main-container {
        max-width: 1200px;
        margin: 30px auto;
        padding: 0 16px;
    }
    .card-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(250px, 1fr));
        gap: 20px;
    }
    .card {
        border: 1px solid #e5e7eb;
        border-radius: 12px;
        overflow: hidden;
        background: #fff;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        transition: transform 0.15s ease;
    }
    .card:hover {
        transform: translateY(-4px);
    }
    .card img {
        width: 100%;
        height: auto;
        display: block;
    }
    .card-body {
        padding: 12px;
    }
    .card-body h3 {
        margin: 0 0 8px;
        font-size: 18px;
    }
    .card-body p {
        margin: 0 0 8px;
        color: #6b7280;
        font-size: 14px;
    }
    .card-body strong {
        color: #111827;
        font-size: 16px;
    }
</style>
</head>

<jsp:include page="/WEB-INF/common/header/adminHeader.jsp" />
<body>
    <jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

    <div class="main-container">
        <h1>admin mainPage</h1>
		<a href="/biz/quotationList?userId=biz001">견적서</a> / 
		<a href="/admin/loginHistory">로그인 이력</a> /
		<a href="/admin/alarmList">알림 목록</a> /
		<a href="/admin/alarmWrite">알림 등록</a> /
		<a href="/admin/manageUser">회원관리</a>
    </div>
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>
