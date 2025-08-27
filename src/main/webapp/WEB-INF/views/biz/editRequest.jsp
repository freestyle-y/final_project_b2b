<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%@ include file="/WEB-INF/common/head.jsp"%>
    <title>상품 요청 수정</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        .product-group {
            border: 1px solid #ccc;
            padding: 10px;
            margin-bottom: 10px;
            width: 700px;
            max-width: 90%;
            background: #f9f9f9;
        }
    </style>
</head>
<body>

<main class="main">

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<h1>상품 요청 수정</h1>

<form method="post" action="/biz/editRequest" enctype="multipart/form-data">
    <div id="product-container">
        <c:forEach var="item" items="${productRequestOne}" varStatus="status">
            <div class="product-group">
                <div>상품명: 
                    <input type="text" name="productRequestList[${status.index}].productName" value="${item.productName}" required>
                </div>
                <div>옵션: 
                    <input type="text" name="productRequestList[${status.index}].productOption" value="${item.productOption}" required>
                </div>
                <div>수량: 
                    <input type="number" name="productRequestList[${status.index}].productQuantity" value="${item.productQuantity}" min="1" required>
                </div>
                
                <!-- 숨겨야 하는 필드 -->
                <input type="hidden" name="productRequestList[${status.index}].subProductRequestNo" value="${item.subProductRequestNo}" />
                <input type="hidden" name="productRequestList[${status.index}].productRequestNo" value="${item.productRequestNo}" />
                <input type="hidden" name="productRequestList[${status.index}].updateUser" value="${item.createUser}" />
                <input type="hidden" name="productRequestList[${status.index}].createUser" value="${item.createUser}" />
            </div>
        </c:forEach>
        
        <c:set var="firstItem" value="${productRequestOne[0]}" />
		<div style="margin-top: 20px;">
		    <strong>첨부파일 목록:</strong>
		    <c:choose>
		        <c:when test="${not empty firstItem.attachments}">
		            <ul style="list-style: none; padding-left: 0; margin-top: 5px;">
		                <c:forEach var="file" items="${firstItem.attachments}" varStatus="loop">
		                    <li class="attachment-item" style="margin-bottom: 5px;">
							    <a href="${file.filepath}" download>${file.filename}</a>
							    <!-- 삭제용 체크박스 -->
							    <label style="margin-left: 10px;">
							        <input type="checkbox"
								       class="delete-file-checkbox"
								       data-filepath="${file.filepath}"
								       data-attachment-no="${file.attachmentNo}" />
							        삭제
							    </label>
							</li>
		                </c:forEach>
		            </ul>
		        </c:when>
		        <c:otherwise>
		            <span>첨부파일 없음</span>
		        </c:otherwise>
		    </c:choose>
		</div>
    </div>

    <br/>

	<div style="margin-top: 15px;">
	    <label><strong>첨부파일 추가:</strong></label><br/>
	    <input type="file" name="newFiles" multiple />
	    <small style="color: gray;">※ 여러 개 선택 가능</small>
	</div>

    <div>
        <label for="requests">요청사항:</label><br/>
        <textarea id="requests" name="requests" rows="3" cols="40">${productRequestOne[0].requests}</textarea>
    </div>

    <br/>

    <div>
        <label><strong>배송지 선택:</strong></label><br/>
        <c:set var="selectedAddressNo" value="${productRequestOne[0].addressNo}" />
        <c:forEach var="addr" items="${bizAddressList}">
            <label>
                <input type="radio" name="addressNo"
                       value="${addr.addressNo}"
                       <c:if test="${addr.addressNo == selectedAddressNo}">checked</c:if> />
                [${addr.postal}] ${addr.address} ${addr.detailAddress}
            </label><br/>
        </c:forEach>
    </div>

    <br/>
    <button type="submit">수정 완료</button>
</form>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
$(function () {
    // 배송지 체크 유효성 검사
    $('form').on('submit', function (e) {
        const isAddressSelected = $('input[name="addressNo"]:checked').length > 0;
        if (!isAddressSelected) {
            alert("배송지를 선택해주세요.");
            e.preventDefault();
        }
    });

    // 첨부파일 삭제 이벤트
    $('.delete-file-checkbox').on('change', function () {
        const checkbox = $(this);
        const filepath = checkbox.data('filepath');
        const attachmentNo = checkbox.data('attachment-no');
        const listItem = checkbox.closest('.attachment-item');

        // 체크되었을 때만 처리
        if (checkbox.is(':checked')) {
            const confirmDelete = confirm("정말로 삭제하시겠습니까?");
            if (!confirmDelete) {
                checkbox.prop('checked', false);
                return;
            }

            // Ajax 요청
            $.ajax({
                url: '/biz/deleteAttachment',
                method: 'POST',
                data: { 
					filepath: filepath,
					attachmentNo: attachmentNo	 
                },
                success: function (res) {
                    if (res === 'success') {
                        listItem.remove(); // 성공 시 UI에서 제거
                    } else {
                        alert('삭제 실패: ' + res);
                        checkbox.prop('checked', false);
                    }
                },
                error: function () {
                    alert('서버 오류로 삭제에 실패했습니다.');
                    checkbox.prop('checked', false);
                }
            });
        }
    });
});
</script>

</body>
</html>