<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객센터</title>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	<h1>help desk page</h1>
	<a href="/public/FAQList">자주 묻는 질문</a> /
	<a href="/member/QNAList">문의 내역</a> /
	<a href="/member/QNAWrite">1:1 문의</a> /
	<a href="/public/noticeList">공지사항</a>
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>