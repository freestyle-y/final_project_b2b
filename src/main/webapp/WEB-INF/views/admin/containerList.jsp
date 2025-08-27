<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>컨테이너 목록</title>
<style>
    table {
        border-collapse: collapse;
        width: 80%;
        margin: 20px auto;
        text-align: center;
    }
    th, td {
        border: 1px solid #333;
        padding: 10px;
    }
    th {
        background-color: #f2f2f2;
    }
</style>
</head>
<body>
<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<h1 style="text-align:center;">컨테이너 목록</h1>
<form id="containerForm">
<table>
    <thead>
        <tr>
        	<th>선택</th>
            <th>컨테이너 번호</th>
            <th>위치</th>
            <th>계약서 주문번호</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="con" items="${containerList}">
            <tr>
            	<td>
            		<input type="checkbox">
					<input type="hidden" name="containerNo" value="${con.containerNo}">
            	</td>
                <td>${con.containerNo}</td>
                <td>${con.containerLocation}</td>
                <td>${con.contractOrderNo}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>
	<button type="button" onclick="modifyContainer()">수정</button>
	<button type="button" onclick="deleteContainer()">삭제</button>
</form>
<script>
	function modifyContainer(){
		const checked = document.querySelector("input[type='checkbox']:checked");
		if (!checked) {
			alert("수정할 컨테이너를 선택하세요.");
			return;
		}
		const containerNo = checked.closest("tr").querySelector("input[name='containerNo']").value;
		location.href = "/admin/modifyContainerForm?containerNo=" + containerNo;
	}

	function deleteContainer(){
		if (!confirm("정말 삭제하시겠습니까?")) return;

		const form = document.getElementById("containerForm");
		form.action = "/admin/deleteContainer";
		form.method = "post";
		form.submit();
	}
</script>
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>
</body>
</html>
