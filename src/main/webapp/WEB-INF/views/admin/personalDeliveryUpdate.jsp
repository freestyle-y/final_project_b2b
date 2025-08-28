<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>배송 처리</title>
<style>
    body {
        font-family: Arial, sans-serif;
        text-align: left;
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
        margin: 10px auto;
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
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
	
    <h1>배송 처리</h1>

	<form action="/admin/personalDeliveryUpdate" method="post">
		<input type="hidden" name="orderNo" value="${orderNo}">
		<input type="hidden" name="subOrderNo" value="${subOrderNo}">
		
		<label for="deliveryCompany">배송사</label>
		<input type="text" name="deliveryCompany" id="deliveryCompany" placeholder="택배사 입력" required>
		
		<label for="trackingNo">운송장 번호</label>
		<input type="text" name="trackingNo" id="trackingNo" placeholder="운송장 번호 입력" required>

		<button type="submit">배송 처리</button>
	</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
   
</body>
</html>