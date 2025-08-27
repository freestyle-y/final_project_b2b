<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/common/head.jsp"%>
	<title>공용 메인 페이지</title>
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
<body class="index-page">

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">
    <div class="container">
        <h1>mainPage</h1>

        <div class="card-grid">
            <% for (int i = 1; i <= 9; i++) { %>
                <div class="card">

                    <div class="card-body">
                        <h3>상품 이름 <%=i%></h3>
                        <p>간단한 상품 설명이 들어갑니다.</p>
                        <strong>₩<%= i * 10000 %></strong>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>