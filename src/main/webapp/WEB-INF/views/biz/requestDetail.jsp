<%@ page contentType="text/html; charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>요청 상세</title>
    <style>
        .detail-container {
            max-width: 800px;
            margin: 30px auto;
            background: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.1);
        }
        .detail-table {
            width: 100%;
            border-collapse: collapse;
        }
        .detail-table th, .detail-table td {
            border-bottom: 1px solid #ddd;
            padding: 10px;
        }
        .detail-table th {
            background-color: #f0f0f0;
        }
        .button-area {
            text-align: right;
            margin-top: 20px;
        }
        .btn {
            padding: 8px 16px;
            margin-left: 10px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-edit { background: #4CAF50; color: white; }
        .btn-delete { background: #f44336; color: white; }
    </style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<div class="detail-container">
    <h2>요청 상세 정보</h2>

    <table class="detail-table">
        <tr>
            <th>상품명</th>
            <th>옵션</th>
            <th>수량</th>
            <th>주소</th>
        </tr>
        <c:forEach var="item" items="${productRequestOne}">
            <tr>
                <td>${item.productName}</td>
                <td>${item.productOption}</td>
                <td>${item.productQuantity}</td>
                <td>
                    ${item.address} ${item.detail_address} (${item.postal})
                </td>
            </tr>
        </c:forEach>
    </table>

    <!-- 첨부파일 목록 (수정/삭제 버튼 위에 위치) -->
    <c:set var="firstItem" value="${productRequestOne[0]}" />
    <div style="margin-top: 20px; margin-bottom: 15px;">
	    <strong>첨부파일:</strong>
	    <c:choose>
	        <c:when test="${not empty firstItem.attachments}">
	            <ul style="list-style: none; padding-left: 0; margin-top: 5px;">
	                <c:forEach var="file" items="${firstItem.attachments}">
	                    <li style="margin-bottom: 5px;">
	                        <a href="${file.filepath}" download>
	                            ${file.filename}
	                        </a>
	                    </li>
	                </c:forEach>
	            </ul>
	        </c:when>
	        <c:otherwise>
	            <span>첨부파일 없음</span>
	        </c:otherwise>
	    </c:choose>
	</div>


    <c:set var="status" value="${productRequestOne[0].status}" />
    
    <div class="button-area">
        <c:if test="${status eq '확인전'}">
            <button class="btn btn-edit" onclick="location.href='/biz/editRequest?requestNo=${param.requestNo}'">수정</button>
            <button class="btn btn-delete" onclick="confirmDelete(${param.requestNo})">삭제</button>
        </c:if>
    </div>
</div>


<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
    function confirmDelete(requestNo) {
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = '/biz/deleteRequest?requestNo=' + requestNo;
        }
    }
</script>

</body>
</html>