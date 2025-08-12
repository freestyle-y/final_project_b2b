<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	<h1>mainPage</h1>
	<form>
		<table border="1">
		<%
			for(int i=0; i<25; i++) {
		%>
			<tr>
			
				<td>1</td>
				<td>2</td>
				<td>3</td>
				<td>4</td>
				<td>5</td>
				<td>6</td>
				<td>7</td>
			</tr>
				
		<%
			}
		%>
		</table>
	</form>
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>