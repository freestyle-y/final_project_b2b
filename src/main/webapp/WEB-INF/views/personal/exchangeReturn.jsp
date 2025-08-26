<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>교환/반품 신청</title>
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
    #exchangeBox, #returnBox {
    margin-top: 15px;
	}
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
	
    <h1>교환/반품 신청</h1>
    
    <!-- 교환/반품 신청 폼 -->
    <form action="/personal/exchangeReturn" method="post">
    	<input type="hidden" name="orderNo" value="${orderNo}">
    	<input type="hidden" name="subOrderNo" value="${subOrderNo}">
    	
		<label for="type">구분</label>
		<select id="type" name="type" required onchange="toggleReason()">
			<option value="DS006" selected>교환</option>
			<option value="DS004">반품</option>
		</select>
		
		<div id="exchangeBox">
			<label for="exchangeReason">교환 사유</label>
			<textarea id="exchangeReason" name="exchangeReason" rows="6" required></textarea>
		</div>
		
		<div id="returnBox" style="display:none;">
			<label for="returnReason">반품 사유</label>
			<textarea id="returnReason" name="returnReason" rows="6" disabled required></textarea>
		</div>

		<button type="submit">신청</button>
    </form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
	function toggleReason() {
		const type = document.getElementById("type").value;
		const exchangeBox = document.getElementById("exchangeBox");
		const returnBox = document.getElementById("returnBox");
		const exchangeReason = document.getElementById("exchangeReason");
		const returnReason = document.getElementById("returnReason");

		if (type === "DS006") { // 교환
			exchangeBox.style.display = "block";
			exchangeReason.disabled = false;
			returnBox.style.display = "none";
			returnReason.disabled = true;
		} else { // 반품
			returnBox.style.display = "block";
			returnReason.disabled = false;
			exchangeBox.style.display = "none";
			exchangeReason.disabled = true;
		}
	}
</script>

</body>
</html>