<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜</title>

<style>
    body {
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background-color: #f9f9f9;
        color: #333;
        margin: 0;
        padding: 0;
    }

    .wishlist-container {
        max-width: 800px;
        margin: 40px auto;
        background-color: #fff;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }

    .wishlist-item {
        display: flex;
        align-items: center;
        padding: 15px;
        border-bottom: 1px solid #e0e0e0;
    }

    .wishlist-item:last-child {
        border-bottom: none;
    }

    .wishlist-item input[type="checkbox"] {
        margin-right: 15px;
        transform: scale(1.2);
        cursor: pointer;
    }

    .product-name {
        flex: 1;
        font-size: 16px;
    }

    .product-name a {
        text-decoration: none;
        color: #333;
        transition: color 0.2s;
    }

    .product-name a:hover {
        color: #007bff;
    }

    .disabled {
        color: #999;
        opacity: 0.6;
        pointer-events: none;
    }

    #deleteBtn {
        margin-top: 25px;
        padding: 10px 20px;
        background-color: #dc3545;
        color: white;
        border: none;
        border-radius: 4px;
        font-size: 15px;
        cursor: pointer;
        transition: background-color 0.2s;
    }

    #deleteBtn:hover {
        background-color: #c82333;
    }

    #checkAll {
        margin-bottom: 20px;
        transform: scale(1.2);
        cursor: pointer;
    }

    .wishlist-container div:first-child {
        font-size: 16px;
        font-weight: bold;
    }
</style>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 전체 선택/해제 기능
    function toggleAll(source) {
        const checkboxes = document.querySelectorAll('.item-checkbox');
        checkboxes.forEach(cb => cb.checked = source.checked);
    }
    
 	// 선택된 상품 삭제
    function deleteSelected() {
        const selected = document.querySelectorAll('.item-checkbox:checked');
        if (selected.length === 0) {
            alert("삭제할 상품을 선택하세요.");
            return;
        }

        const confirmed = confirm("선택한 상품을 찜 목록에서 삭제하시겠습니까?");
        if (!confirmed) return;

        // 배열로 변환 후 value 수집
        const productNoList = Array.from(selected).map(function(el) {
            return el.value;
        });

        const loginUserName = '${loginUserName}';

        $.ajax({
            url: '${pageContext.request.contextPath}/personal/wish/delete',
            type: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                productNoList: productNoList,
                userId: loginUserName
            }),
            success: function (response) {
                if (response.success) {
                    alert("삭제가 완료되었습니다.");
                    location.reload();
                } else {
                    alert("삭제 실패: " + (response.message || "알 수 없는 오류"));
                }
            },
            error: function () {
                alert("요청 중 오류가 발생했습니다.");
            }
        });
    }


    // 개별 체크박스 변경 시 전체 선택 상태 업데이트
    document.addEventListener('DOMContentLoaded', () => {
        const checkAll = document.getElementById('checkAll');
        const itemCheckboxes = document.querySelectorAll('.item-checkbox');

        itemCheckboxes.forEach(cb => {
            cb.addEventListener('change', () => {
                const allChecked = Array.from(itemCheckboxes).every(c => c.checked);
                checkAll.checked = allChecked;
            });
        });
    });
</script>

</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<div class="wishlist-container">

    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/personal/wish/delete">
        <!-- 전체 선택 체크박스 -->
        <div>
            <input type="checkbox" id="checkAll" onclick="toggleAll(this)"> 전체 선택
        </div>

        <c:forEach var="item" items="${wishList}">
		    <div class="wishlist-item" style="display: flex; align-items: center; gap: 10px; margin-bottom: 10px;">
		        
		        <!-- ✅ 체크박스 -->
		        <input type="checkbox" class="item-checkbox" name="productNoList" value="${item.productNo}">
		
		        <!-- ✅ 썸네일 이미지 -->
				<div class="product-image" style="width: 50px; height: 50px; flex-shrink: 0; display: flex; align-items: center; justify-content: center;">
				    <c:choose>
				        <c:when test="${not empty item.imagePath}">
				            <img src="${pageContext.request.contextPath}${item.imagePath}"
				                 alt="${item.productName}"
				                 style="width: 100%; height: 100%; object-fit: cover; border-radius: 5px;" />
				        </c:when>
				        <c:otherwise>
				            <span style="color: #ccc; font-size: 10px;">이미지 없음</span>
				        </c:otherwise>
				    </c:choose>
				</div>


		
		        <!-- ✅ 상품명 -->
		        <div class="product-name">
		            <c:choose>
		                <c:when test="${item.productStatus == 'GS002'}">
		                    <a href="/personal/productOne?productNo=${item.productNo}"
		                       style="color: black; text-decoration: none;">
		                        ${item.productName}
		                    </a>
		                </c:when>
		                <c:otherwise>
		                    <span style="color: gray;">
		                        ${item.productName}
		                        (
		                        <c:choose>
		                            <c:when test="${item.productStatus == 'GS001'}">판매대기</c:when>
		                            <c:when test="${item.productStatus == 'GS003'}">일시품절</c:when>
		                            <c:when test="${item.productStatus == 'GS004'}">영구중단</c:when>
		                            <c:otherwise>알수없음</c:otherwise>
		                        </c:choose>
		                        )
		                    </span>
		                </c:otherwise>
		            </c:choose>
		        </div>
		    </div>
		</c:forEach>


        <!-- 삭제 버튼 -->
        <button type="button" id="deleteBtn" onclick="deleteSelected()">삭제</button>
    </form>
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>