<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	<h1>quotationOne</h1>
	<form action="${pageContext.request.contextPath}/biz/quotationApprove" method="post">
    <!-- ✅ 수정: Spring Security 사용 시 CSRF 토큰 전송 -->
    <c:if test="${not empty _csrf}">
    	<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
	<table border="1">
	    <tr>
	        <th>견적서 번호</th>
	        <th>재견적서 번호</th>
	        <th>가격</th>
	        <th>승인상태</th>
	        <th>작성자</th>
	        <th>작성일자</th>
	        <th>상품명</th>
	        <th>수량</th>
	    </tr>
    <!-- quotationOne 리스트의 크기(상품 개수)를 rowCount 변수에 저장 -->
    <!-- 예: quotationOne 리스트에 4개의 상품이 있으면 rowCount = 4 -->
    <c:set var="rowCount" value="${fn:length(quotationOne)}" />
    <!-- quotationOne 리스트를 순회 시작 -->
    <!-- var="q" : 현재 반복에서 꺼낸 Quotation 객체 (상품 1개 정보) -->
    <!-- varStatus="status" : 반복 상태 정보를 담음 (예: status.first → 첫 번째인지 여부) -->
    <c:forEach var="q" items="${quotationOne}" varStatus="status">
        <tr>
            <!-- 첫 번째 상품일 때만 공통 정보 출력 -->
            <!-- status.first = true 일 때만 실행됨 -->
            <!-- rowspan="${rowCount}" → 공통 정보 셀을 rowCount 만큼 세로로 병합 -->
            <c:if test="${status.first}">
                <input type="hidden" name="quotationNo" value="${q.quotationNo}"/>
            	<input type="hidden" name="subProductRequestNo" value="${q.subProductRequestNo}"/>
                <!-- 견적서 번호 : 모든 상품에 동일한 값 → 1번만 찍고 세로 병합 -->
                <td rowspan="${rowCount}">${q.quotationNo}</td>
                <td rowspan="${rowCount}">${q.subProductRequestNo}</td>
                <td rowspan="${rowCount}">${q.price}</td>
                <td rowspan="${rowCount}">${q.status}</td>
                <td rowspan="${rowCount}">${q.createUser}</td>
                <td rowspan="${rowCount}">${q.createDate}</td>
            </c:if>
            <!-- 상품별 정보 (모든 행에서 출력됨) -->
            <!-- 상품명 : 각 상품마다 다르므로 무조건 출력 -->
            <td>${q.productName}</td>
            <!-- 수량 : 각 상품마다 다르므로 무조건 출력 -->
            <td>${q.productQuantity}</td>
        </tr>
    </c:forEach>
	</table>
	<button type="submit">승인</button>
	</form>
	<!-- 거절 Form -->
	<form action="${pageContext.request.contextPath}/biz/quotationReject" method="post" id="rejectForm" style="margin-top:20px;">
	    <c:if test="${not empty _csrf}">
	        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
	    </c:if>
	    <input type="hidden" name="quotationNo" value="${quotationOne[0].quotationNo}"/>
	    <input type="hidden" name="subProductRequestNo" value="${quotationOne[0].subProductRequestNo}"/>
	
	    <!-- ✅ 초기 상태에서 보이는 거절 버튼 -->
	    <button type="button" onclick="showRejectionBox()">거절</button>
	
	    <!-- ✅ 거절 사유 입력창과 제출 버튼 (초기에는 숨김 처리) -->
	    <div id="rejectionBox" style="display:none; margin-top:10px;">
	        <label for="rejectionReason">거절 사유 입력:</label><br>
	        <textarea name="rejectionReason" id="rejectionReason" rows="4" cols="60" placeholder="사유를 입력해주세요" required></textarea><br>
	        <!-- 실제 제출용 버튼 (거절 사유와 함께 전송) -->
	        <button type="submit">제출</button>
	    </div>
	</form>
<script>
    function showRejectionBox() {
        document.getElementById("rejectionBox").style.display = "block";
        // 버튼 숨기기 (처음 거절 버튼)
        event.target.style.display = "none";
    }
</script>

</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>