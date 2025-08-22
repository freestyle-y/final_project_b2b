<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>견적서 작성</title>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

	<h1>견적서 작성</h1>

	<table border="1">
	    <thead>
	        <tr>
	            <th>견적번호</th>
	            <th>상품명</th>
	            <th>수량</th>
	            <th>옵션</th>
	            <th>견적 작성하기</th>
	        </tr>
	    </thead>
	    <tbody>
	        <c:forEach var="entry" items="${groupList}">
	            <c:set var="quotationList" value="${entry.value}" />
	            <c:set var="first" value="${quotationList[0]}" />
	            <c:forEach var="q" items="${quotationList}" varStatus="status">
	                <tr>
	                    <c:if test="${status.first}">
	                        <td rowspan="${fn:length(quotationList)}">
	                            ${first.quotationNo} - ${first.subProductRequestNo}
	                        </td>
	                    </c:if>
	                    <td>${q.productName}</td>
	                    <td>${q.productQuantity}</td>
	                    <td>${q.productOption}</td>
	                    <c:if test="${status.first}">
	                        <td rowspan="${fn:length(quotationList)}">
	                            <button type="button"
	                                onclick="submitQuotationPopup('${first.quotationNo}', '${first.subProductRequestNo}')">
	                                견적 작성하기
	                            </button>
	                        </td>
	                    </c:if>
	                </tr>
	            </c:forEach>
	        </c:forEach>
	    </tbody>
	</table>

	<!-- 숨겨진 폼 (팝업으로 제출용) -->
	<form id="quotationForm" method="get" target="quotationPopup" style="display: none;">
	    <input type="hidden" name="quotationNo" />
	    <input type="hidden" name="subProductRequestNo" />
	</form>
	
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>

<script>
function submitQuotationPopup(quotationNo, subProductRequestNo) {
    const form = document.getElementById('quotationForm');
    form.action = '/admin/writeQuotationForm';
    form.quotationNo.value = quotationNo;
    form.subProductRequestNo.value = subProductRequestNo;

    // 팝업 창 열기
    window.open('', 'quotationPopup', 'width=700,height=600,scrollbars=yes');

    // 팝업 창에 폼 제출
    form.submit();
}
</script>

</html>