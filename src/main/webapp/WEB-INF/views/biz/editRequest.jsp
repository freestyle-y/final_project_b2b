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
        /* Google Fonts - Noto Sans KR */
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');

        /* Basic Body and Main Styling */
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f0f2f5;
            color: #333;
            line-height: 1.6;
        }

        main.main {
            max-width: 800px;
            margin: 40px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 30px;
        }

        /* Form and Input Styling */
        form {
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .product-group {
            border: 1px solid #e0e0e0;
            padding: 20px;
            border-radius: 8px;
            background: #fdfdfd;
            transition: box-shadow 0.3s ease-in-out;
            margin-bottom: 10px;
        }

        .product-group:hover {
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        .product-group div {
            margin-bottom: 15px;
        }
        
        .product-group label {
            width: 70px;
            display: inline-block;
        }

        input[type="text"],
        input[type="number"],
        textarea {
            width: 300px;
            padding: 10px 12px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease-in-out;
        }
        
        input[type="text"]:focus,
        input[type="number"]:focus,
        textarea:focus {
            border-color: #3498db;
            outline: none;
        }

        label strong {
            color: #555;
            font-weight: 500;
        }

        textarea {
            width: calc(100% - 24px); /* 전체 너비에서 패딩 제외 */
            resize: vertical;
        }

        /* Buttons & Checkboxes */
        button {
            padding: 12px 20px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: 500;
            transition: background-color 0.3s ease-in-out, transform 0.2s;
        }

        button:active {
            transform: scale(0.98);
        }

        /* File & Radio Styling */
        #requests {
            width: 100%;
        }
        
        input[type="file"] {
            display: block;
            margin-top: 5px;
        }

        input[type="radio"] {
            margin-right: 8px;
        }

        /* Submit Button */
        button[type="submit"] {
            background-color: #2ecc71;
            color: white;
            align-self: flex-end;
        }

        button[type="submit"]:hover {
            background-color: #27ae60;
        }

        .attachment-item a {
            color: #3498db;
            text-decoration: none;
        }
        
        .attachment-item a:hover {
            text-decoration: underline;
        }
        
        .delete-file-checkbox {
            margin-left: 10px;
        }
    </style>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<h1>상품 요청 수정</h1>

<form method="post" action="/biz/editRequest" enctype="multipart/form-data">
    <div id="product-container">
        <c:forEach var="item" items="${productRequestOne}" varStatus="status">
            <div class="product-group">
                <div><label>상품명:</label> 
                    <input type="text" name="productRequestList[${status.index}].productName" value="${item.productName}" required>
                </div>
                <div><label>옵션:</label> 
                    <input type="text" name="productRequestList[${status.index}].productOption" value="${item.productOption}" required>
                </div>
                <div><label>수량:</label> 
                    <input type="number" name="productRequestList[${status.index}].productQuantity" value="${item.productQuantity}" min="1" required>
                </div>
                
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