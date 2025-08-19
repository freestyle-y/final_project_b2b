<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>문의 내역</title>
<style>
    table {
        width: 50%;
        border-collapse: collapse;
        text-align: center;
        margin: auto;
    }
    th, td {
        border: 1px solid #ccc;
        padding: 8px;
    }
</style>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	
	<h1>문의 내역</h1>
	<table border="1">
		<tr>
			<th>제목</th>
		</tr>
		
		<c:forEach var="qna" items="${QNAList}">
			<tr>
				<td>${qna.boardTitle}</td>
			</tr>
		</c:forEach>
	</table>
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>