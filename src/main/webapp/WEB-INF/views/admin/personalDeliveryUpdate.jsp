<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>배송 상태 변경</title>
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
	
    <h1>배송 상태 변경</h1>

	<form action="/admin/personalDeliveryUpdate" method="post">
		<input type="hidden" name="orderNo" value="${orderNo}">
		<input type="hidden" name="subOrderNo" value="${subOrderNo}">

		<label for="deliveryStatus">변경할 배송 상태</label>
		<select name="deliveryStatus" id="deliveryStatus" required>
			<option value="">-- 선택 --</option>
			<option value="DS001">배송대기</option>
			<option value="DS002">배송중</option>
			<option value="DS003">배송완료</option>
			<option value="DS004">반품대기</option>
			<option value="DS005">반품완료</option>
			<option value="DS006">교환대기</option>
			<option value="DS007">교환중</option>
			<option value="DS008">교환완료</option>
			<option value="DS009">상품회수</option>
		</select>

		<button type="submit">변경</button>
	</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
   
</body>
</html>