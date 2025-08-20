<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head><title>결제 성공</title></head>
<body>
	<h2>결제가 성공적으로 완료되었습니다 🎉</h2>
	<p>구매자 : ${name}</p>
	<p>상품명 : ${productName}</p>
	<p>사용한 포인트: <fmt:formatNumber value="${usedPoint}" type="number"/> P</p>
	<p>카카오페이 포인트 사용: <fmt:formatNumber value="${usedKakaoPoint}" type="number"/> P</p>
	<p>실 결제 금액: <fmt:formatNumber value="${realPaidAmount - usedKakaoPoint}" type="number"/> 원</p>
</body>
</html>
