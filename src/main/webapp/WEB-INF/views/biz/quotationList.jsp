<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>견적서 목록</title>
<style>
    table {
        width: 100%;
        border-collapse: collapse;
        text-align: center;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
    }
</style>
</head>
<body>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
<h1>견적서 목록</h1>
<table>
    <thead>
        <tr>
            <th>견적서 번호</th>
            <th>price</th>
            <th>status</th>
            <th>createUser</th>
            <th>createDate</th>
        </tr>
    </thead>
	<tbody>
	<c:forEach var="entry" items="${quotationGroupedMap}">
	    <!-- entry.key : "subProductRequestNo_quotationNo_price" 문자열 -->
	    <!-- "_" 기준으로 나눠 배열로 저장 (예: ["1","2","3000000"]) -->
	    <c:set var="keyParts" value="${fn:split(entry.key, '_')}" />
	    <!-- entry.value : 같은 key를 가진 Quotation 객체들의 리스트 -->
	    <c:set var="quotationList" value="${entry.value}" />
	    <!-- 첫 번째 반복 여부를 체크하기 위한 flag -->
	    <c:set var="first" value="true" />
	    <c:forEach var="q" items="${quotationList}">
	        <!-- 첫 번째 아이템일 때만 행 출력 (중복 방지용) -->
	        <c:if test="${first}">
	        <tr>
	            <td>
		        	<a href="/biz/quotationOne?quotationNo=${q.quotationNo }&subProductRequestNo=${q.subProductRequestNo}">
		            	${keyParts[0]}-${keyParts[1]}
		        	</a>
            	</td>		            
	            <!-- 가격 (keyParts[2] : 그룹핑 key에서 가져온 price 값) -->
	            <td>${keyParts[2]}</td>
	            <td>${q.status}</td>
	            <td>${q.createUser}</td>
	            <td>${q.createDate}</td>
	        </tr>
	        </c:if>
	        <!-- 이후 반복부터는 first=false → 중복행 출력 안 함 -->
	        <c:set var="first" value="false" />
	    </c:forEach>
	</c:forEach>
	</tbody>
</table>

<!-- 공통 푸터 포함 -->
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
