<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>재고 관리</title>
    <style>
        .inventory-item {
            border: 1px solid #ddd;
            padding: 15px;
            margin-bottom: 10px;
        }
        .inventory-item div {
            margin: 5px 0;
        }
        .status-msg {
            color: green;
            margin-top: 5px;
        }
        .error-msg {
            color: red;
        }

        /* 검색창 스타일 */
        #search-input {
            display: block;
            margin: 20px auto;
            padding: 10px;
            width: 300px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 1em;
        }

        /* 페이징 버튼 스타일 */
        .pagination {
            text-align: center;
            margin-top: 20px;
            user-select: none;
        }
        .pagination button {
            margin: 0 4px;
            padding: 6px 12px;
            border-radius: 5px;
            border: 1px solid #ccc;
            background: #fff;
            cursor: pointer;
            font-size: 1em;
        }
        .pagination button.active {
            background-color: #333;
            color: white;
            border-color: #333;
        }

        /* 재고 추가 버튼 위치 */
        .add-button-container {
            text-align: center;
            margin-bottom: 20px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function updateQuantity(inventoryId) {
            const $input = $('#qty-' + inventoryId);
            const quantity = $input.val();

            if (quantity < 0) {
                alert("수량은 0 이상이어야 합니다.");
                return;
            }

            $.ajax({
                url: '/updateInventoryQuantity',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    inventoryId: inventoryId,
                    quantity: quantity
                }),
                success: function(response) {
                    $('#status-' + inventoryId).text("✔ 수량이 수정되었습니다.").removeClass('error-msg').addClass('status-msg');
                },
                error: function(xhr) {
                    $('#status-' + inventoryId).text("✖ 수량 수정 실패").removeClass('status-msg').addClass('error-msg');
                }
            });
        }

        $(document).ready(function () {
            const itemsPerPage = 4;
            let currentPage = 1;

            const container = $('.inventory-list-container');
            const items = container.find('.inventory-item').toArray();
            let filteredItems = items;

            function renderPage(page) {
                container.find('.inventory-item').hide();
                const start = (page - 1) * itemsPerPage;
                const end = start + itemsPerPage;

                $(filteredItems).slice(start, end).show();
                renderPagination();
            }

            function renderPagination() {
                $('#pagination').remove();
                const totalPages = Math.ceil(filteredItems.length / itemsPerPage);
                if (totalPages <= 0) return; // 페이지가 0페이지면 페이징 표시 x

                const $pagination = $('<div id="pagination" class="pagination"></div>');
                for (let i = 1; i <= totalPages; i++) {
                    const $btn = $('<button>').text(i);
                    if (i === currentPage) $btn.addClass('active');
                    $btn.on('click', function () {
                        currentPage = i;
                        renderPage(currentPage);
                    });
                    $pagination.append($btn);
                }
                container.after($pagination);
            }

            function filterItems(keyword) {
                filteredItems = items.filter(item => {
                    const name = $(item).find('.product-name').text().toLowerCase();
                    return name.includes(keyword.toLowerCase());
                });
                currentPage = 1;
                renderPage(currentPage);
            }

            // 검색 input 생성 및 이벤트 바인딩
            const $search = $('<input type="text" id="search-input" placeholder="상품명 검색...">').on('input', function () {
                filterItems($(this).val());
            });

            $('.add-button-container').after($search);

            // 초기 렌더링
            renderPage(currentPage);
        });
    </script>
</head>

<jsp:include page="/WEB-INF/common/header/adminHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<h1>재고 관리</h1>

<!-- ✅ 재고 추가 버튼 -->
<div class="add-button-container">
    <button onclick="">+ 재고 추가</button>
</div>

<!-- 재고 리스트 전체를 감싸는 컨테이너 추가 -->
<div class="inventory-list-container">
    <c:forEach var="item" items="${inventoryList}">
        <div class="inventory-item">
            <div><strong>상품명:</strong> <span class="product-name">${item.productName}</span></div>
            <div><strong>옵션값:</strong> ${item.optionNameValue}</div>
            <div><strong>가격:</strong> ${item.price}</div>
            <div><strong>주소:</strong> [${item.postal}] ${item.address} ${item.detailAddress}</div>

            <div>
                <label>수량:</label>
                <input type="number" id="qty-${item.inventoryId}" value="${item.quantity}" min="0" />
                <button type="button" onclick="updateQuantity(${item.inventoryId})">재고 수정</button>
            </div>

            <div id="status-${item.inventoryId}" class="status-msg"></div>
        </div>
    </c:forEach>
</div>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
