<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>찜</title>

<style>
    .product-name a {
        text-decoration: none;
        color: black;
    }

    .disabled {
        color: gray;
        opacity: 0.5;
    }

    .wishlist-container {
        margin: 20px;
    }

    .wishlist-item {
        display: flex;
        align-items: center;
        margin-bottom: 10px;
    }

    .wishlist-item input[type="checkbox"] {
        margin-right: 10px;
    }

    #deleteBtn {
        margin-top: 20px;
    }
</style>

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

        const form = document.getElementById("deleteForm");
        form.submit();
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
<jsp:include page="/WEB-INF/common/header/personalHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<div class="wishlist-container">
    <h1>찜 목록</h1>

    <form id="deleteForm" method="post" action="${pageContext.request.contextPath}/personal/wish/delete">
        <!-- 전체 선택 체크박스 -->
        <div>
            <input type="checkbox" id="checkAll" onclick="toggleAll(this)"> 전체 선택
        </div>

        <c:forEach var="item" items="${wishList}">
            <div class="wishlist-item">
                <input type="checkbox" class="item-checkbox" name="productNoList" value="${item.productNo}">
                <div class="product-name">
                    <a href=""
                       class="${item.productUseStatus == 'N' ? 'disabled' : ''}">
                       ${item.productName}
                    </a>
                </div>
            </div>
        </c:forEach>

        <!-- 삭제 버튼 -->
        <button type="button" id="deleteBtn" onclick="deleteSelected()">삭제</button>
    </form>
</div>

</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>
