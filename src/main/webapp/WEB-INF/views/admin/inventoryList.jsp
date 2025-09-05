<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%@ include file="/WEB-INF/common/head.jsp"%>
    <title>재고 관리</title>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Noto+Sans+KR:wght@400;500;700&display=swap');

        body {
            background-color: #f4f7f6;
            font-family: 'Noto Sans KR', sans-serif;
            color: #333;
            line-height: 1.6;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 900px;
            margin: 40px auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }

        h1 {
            text-align: center;
            color: #2c3e50;
            margin-bottom: 20px;
            font-weight: 700;
        }

        .inventory-list-container {
            padding: 0 20px;
        }

        .inventory-item {
            background-color: #fdfdfd;
            border: 1px solid #e0e0e0;
            padding: 20px;
            margin-bottom: 15px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
            transition: box-shadow 0.3s ease-in-out;
        }
        
        .inventory-item:hover {
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .inventory-item div {
            display: flex;
            align-items: center;
            margin-bottom: 10px;
            font-size: 15px;
        }

        .inventory-item strong {
            flex-basis: 80px;
            color: #555;
            font-weight: 500;
        }

        .inventory-item input[type="number"] {
            width: 80px;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
            text-align: center;
        }

        .inventory-item button {
            margin-left: 10px;
            padding: 8px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            color: #fff;
            transition: background-color 0.3s;
        }

        .inventory-item button.update-btn {
            background-color: #3498db;
        }
        .inventory-item button.update-btn:hover {
            background-color: #2980b9;
        }

        .inventory-item button.assign-btn {
            background-color: #2ecc71;
        }
        .inventory-item button.assign-btn:hover {
            background-color: #27ae60;
        }

        .status-msg {
            margin-top: 5px;
            font-size: 14px;
            font-weight: 500;
        }
        .status-msg.success {
            color: #2ecc71;
        }
        .status-msg.error {
            color: #e74c3c;
        }


        /* 모달 스타일 */
        .modal {
            display: none;
            position: fixed;
            z-index: 1000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0,0,0,0.4);
        }
        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
            max-width: 500px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
            text-align: center;
        }
        .modal-content button {
            margin: 10px 5px;
            padding: 10px 20px;
        }
        .modal-content select {
            width: 100%;
            padding: 10px;
            margin-bottom: 15px;
        }
    </style>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script>
        function updateQuantity(inventoryId, productNo, optionNo) {
            const $input = $('#qty-' + inventoryId);
            const quantity = $input.val();
            const $status = $('#status-' + inventoryId);

            if (quantity < 0) {
                $status.text("✖ 수량은 0 이상이어야 합니다.").removeClass('success').addClass('error');
                return;
            }

            $.ajax({
                url: '/updateInventoryQuantity',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    inventoryId: inventoryId,
                    productNo: productNo,
                    optionNo: optionNo,
                    quantity: quantity
                }),
                success: function(response) {
                    $status.text("✔ 수량이 수정되었습니다.").removeClass('error').addClass('success');
                },
                error: function(xhr) {
                    $status.text("✖ 수량 수정 실패").removeClass('success').addClass('error');
                }
            });
        }

        function assignWarehouse(inventoryId) {
            $.ajax({
                url: '/admin/warehouses',
                type: 'GET',
                success: function(warehouses) {
                    let selectHtml = '<select id="warehouseSelect">';
                    selectHtml += '<option value="">-- 창고 선택 --</option>';
                    for (let i = 0; i < warehouses.length; i++) {
                        const w = warehouses[i];
                        selectHtml += '<option value="' + w.addressNo + '">' +
                                      '[' + w.postal + '] ' + w.address + ' ' + w.detailAddress +
                                      '</option>';
                    }
                    selectHtml += '</select>';

                    const confirmHtml = selectHtml + '<br><button class="update-btn" onclick="confirmAssign(' + inventoryId + ')">선택 완료</button>';

                    $('#warehouseModalBody').html(confirmHtml);
                    $('#warehouseModal').css('display', 'flex').hide().fadeIn(300);
                },
                error: function() {
                    alert('창고 목록을 불러오는 데 실패했습니다.');
                }
            });
        }
        
        function confirmAssign(inventoryId) {
            const $select = $('#warehouseSelect');
            const selectedAddressNo = $select.val();
            const selectedText = $select.find('option:selected').text();
            
            if (!selectedAddressNo) {
                alert('창고를 선택해주세요.');
                return;
            }

            $.ajax({
                url: '/admin/updateInventoryAddress',
                type: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    inventoryId: parseInt(inventoryId),
                    addressNo: parseInt(selectedAddressNo)
                }),
                success: function() {
                    alert('창고가 지정되었습니다.');
                    
                    const updatedHtml = selectedText + ' <button type="button" class="assign-btn" onclick="assignWarehouse(' + inventoryId + ')">변경</button>';
                    $('#warehouse-btn-' + inventoryId).html(updatedHtml);

                    $('#warehouseModal').fadeOut(300);
                },
                error: function() {
                    alert('창고 지정 실패');
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
                $(filteredItems).slice(start, end).fadeIn(500);
                renderPagination();
            }

            function renderPagination() {
            	const totalPages = Math.ceil(filteredItems.length  / itemsPerPage);
                const pagination = $('#pagination');
                pagination.empty();
                

             // <ul> 생성
                const ul = $('<ul>').addClass('justify-content-center');

                const maxVisible = 3;
                let start = Math.max(1, currentPage - Math.floor(maxVisible / 2));
                let end = start + maxVisible - 1;

                if (end > totalPages) {
                    end = totalPages;
                    start = Math.max(1, end - maxVisible + 1);
                }

                // ◀ 이전 버튼
                if (currentPage > 1) {
                    const li = $('<li>').append(
                        $('<a href="#">').html('<i class="bi bi-chevron-left"></i>').on('click', function (e) {
                            e.preventDefault();
                            currentPage--;
                            renderPage(currentPage);
                        })
                    );
                    ul.append(li);
                }

                // 1페이지 버튼
                if (start > 1) {
                    const li = $('<li>').append(
                        $('<a href="#">').text(1).on('click', function (e) {
                            e.preventDefault();
                            currentPage = 1;
                            renderPage(currentPage);
                        })
                    );
                    ul.append(li);
                    if (start > 2) {
                        ul.append($('<li>').html('<span>...</span>'));
                    }
                }

                // 중간 페이지 버튼들
                for (let i = start; i <= end; i++) {
                    const a = $('<a href="#">').text(i).on('click', function (e) {
                        e.preventDefault();
                        currentPage = i;
                        renderPage(currentPage);
                    });
                    if (i === currentPage) a.addClass('active');
                    ul.append($('<li>').append(a));
                }

                // 마지막 페이지 버튼
                if (end < totalPages) {
                    if (end < totalPages - 1) {
                        ul.append($('<li>').html('<span>...</span>'));
                    }
                    const li = $('<li>').append(
                        $('<a href="#">').text(totalPages).on('click', function (e) {
                            e.preventDefault();
                            currentPage = totalPages;
                            renderPage(currentPage);
                        })
                    );
                    ul.append(li);
                }

                // ▶ 다음 버튼
                if (currentPage < totalPages) {
                    const li = $('<li>').append(
                        $('<a href="#">').html('<i class="bi bi-chevron-right"></i>').on('click', function (e) {
                            e.preventDefault();
                            currentPage++;
                            renderPage(currentPage);
                        })
                    );
                    ul.append(li);
                }

                pagination.append($('<nav>').append(ul));
            }

            function filterItems(keyword) {
                filteredItems = items.filter(item => {
                    const name = $(item).find('.product-name').text().toLowerCase();
                    return name.includes(keyword.toLowerCase());
                });
                currentPage = 1;
                renderPage(currentPage);
            }

            $('#search-input').on('input', function() {
                filterItems($(this).val());
            });

            renderPage(currentPage);
        });
    </script>
</head>
<body>

<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container">
    <h1>재고 관리</h1>
    
    <div class="header mb-4">
		<div class="row justify-content-center">
			<div class="col-md-3 col-lg-3">
				<div class="search-form">
					<div class="input-group">
						<input type="text" class="form-control" id="search-input" placeholder="상품 검색">
						<button class="btn" type="button">
							<i class="bi bi-search"></i>
						</button>
					</div>
				</div>
			</div>
		</div>
	</div>

    <div id="warehouseModal" class="modal">
        <div class="modal-content">
            <h3>창고 지정</h3>
            <div id="warehouseModalBody"></div>
            <button class="add-btn" onclick="$('#warehouseModal').fadeOut(300)">닫기</button>
        </div>
    </div>
                
    <div class="inventory-list-container">
        <c:forEach var="item" items="${inventoryList}">
            <div class="inventory-item">
                <div><strong>상품명:</strong> <span class="product-name">${item.productName}</span></div>
                <div><strong>옵션:</strong> <span class="product-option">${item.optionNameValue}</span></div>
                <div><strong>가격:</strong> <fmt:formatNumber value="${item.price}" type="number" groupingUsed="true" />원</div>
                <div><strong>주소:</strong>
                    <span id="warehouse-btn-${item.inventoryId}">
                        <c:choose>
                            <c:when test="${empty item.address}">
                                <button type="button" class="assign-btn" onclick="assignWarehouse(${item.inventoryId})">창고 지정</button>
                            </c:when>
                            <c:otherwise>
                                [${item.postal}] ${item.address} ${item.detailAddress}
                                <button type="button" class="assign-btn" onclick="assignWarehouse(${item.inventoryId})">변경</button>
                            </c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <div>
                    <strong>수량:</strong>
                    <input type="number" id="qty-${item.inventoryId}" value="${item.quantity}" min="0" />
                    <button type="button" class="update-btn" onclick="updateQuantity(${item.inventoryId}, ${item.productNo}, ${item.optionNo})">재고 수정</button>
                </div>
                <div id="status-${item.inventoryId}" class="status-msg"></div>
            </div>
        </c:forEach>
    </div>
</div>
<div id="pagination" class="category-pagination justify-content-center mt-4"></div>


<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>