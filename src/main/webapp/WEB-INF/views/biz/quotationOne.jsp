<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>기업회원 견적서 상세</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<h1>견적서 상세</h1>

<!-- 승인 Form -->
<form action="${pageContext.request.contextPath}/biz/quotationApprove" method="post">
    <c:if test="${not empty _csrf}">
        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
    </c:if>
    <!-- ✅ 승인 시에는 quotationNo만 전송 -->
    <input type="hidden" name="quotationNo" value="${quotationOne.quotationNo}"/>

<table border="1">
    <tr>
        <th>견적서 번호</th>
        <th>상태</th>
        <th>작성자</th>
        <th>작성일자</th>
        <th>상품명</th>
        <th>옵션</th>
        <th>수량</th>
        <th>가격</th>
    </tr>
    <c:set var="rowCount" value="${fn:length(quotationOne.items)}"/>
    <c:forEach var="item" items="${quotationOne.items}" varStatus="status">
        <tr>
            <c:if test="${status.first}">
                <!-- ✅ 첫 번째 행에서만 공통 정보 출력 + rowspan 적용 -->
                <td rowspan="${rowCount}">${quotationOne.quotationNo}</td>
                <td rowspan="${rowCount}">${quotationOne.status}</td>
                <td rowspan="${rowCount}">${quotationOne.createUser}</td>
                <td rowspan="${rowCount}">${quotationOne.createDate}</td>
            </c:if>
            <!-- ✅ 상품별 정보는 매 행 출력 -->
            <td>${item.productName}</td>
            <td>${item.productOption}</td>
            <td>${item.productQuantity}</td>
            <td>₩<fmt:formatNumber value="${item.price}" type="number" groupingUsed="true"/></td>
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
    <!-- ✅ 거절 시에도 quotationNo만 전송 -->
    <input type="hidden" name="quotationNo" value="${quotationOne.quotationNo}"/>

    <!-- 거절 버튼 / 사유 입력 -->
    <button type="button" onclick="showRejectionBox()">거절</button>

    <div id="rejectionBox" style="display:none; margin-top:10px;">
        <label for="rejectionReason">거절 사유 입력:</label><br>
        <textarea name="rejectionReason" id="rejectionReason" rows="4" cols="60" placeholder="사유를 입력해주세요" required></textarea><br>
        <button type="submit">제출</button>
    </div>
</form>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
    function showRejectionBox() {
        document.getElementById("rejectionBox").style.display = "block";
        event.target.style.display = "none"; // 처음 거절 버튼 숨기기
    }
</script>

</body>
</html>
