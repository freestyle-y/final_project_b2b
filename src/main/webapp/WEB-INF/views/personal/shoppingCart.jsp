<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>장바구니</title>
<style>
    body {
        font-family: 'Arial', sans-serif;
        background-color: #f9f9f9;
        margin: 0; padding: 0;
    }

    .container {
        max-width: 1000px;
        margin: 30px auto;
        padding: 0 20px;
    }

    .cart-title {
        font-size: 26px;
        font-weight: bold;
        margin-bottom: 30px;
        border-bottom: 2px solid #333;
        padding-bottom: 10px;
    }

    .header-checkbox {
        display: flex;
        align-items: center;
        margin-bottom: 20px;
    }

    .header-checkbox input[type="checkbox"] {
        margin-right: 8px;
        width: 18px;
        height: 18px;
        cursor: pointer;
    }

    .cart-item {
        background-color: #fff;
        border: 1px solid #ddd;
        border-radius: 6px;
        padding: 20px;
        margin-bottom: 20px;
        display: flex;
        justify-content: space-between;
        align-items: center;
    }

    .cart-item.sold-out {
        background-color: #e0e0e0;
        color: #888;
    }

    .item-info {
        flex: 1;
        margin-left: 10px;
    }

    .item-name {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .item-option {
        font-size: 14px;
        color: #555;
    }

    .item-price {
        text-align: right;
        width: 140px;
        position: relative;
        white-space: nowrap;
        display: inline-block;
        vertical-align: middle;
    }

    .item-quantity {
        display: flex;
        align-items: center;
    }

    .qty-btn {
        padding: 2px 8px;
        margin: 0 4px;
        font-size: 16px;
        cursor: pointer;
        user-select: none;
    }

    .item-quantity input[type="text"] {
        width: 40px;
        text-align: center;
        border: none;
        background: transparent;
        font-size: 16px;
        pointer-events: none;
    }

    .item-quantity button.delete-btn {
        margin-left: 10px;
        background-color: #ff4d4f;
        border: none;
        color: white;
        padding: 5px 10px;
        border-radius: 4px;
        cursor: pointer;
        font-size: 14px;
    }

    .sold-out-text {
        color: #b00000;
        font-weight: bold;
        margin-top: 5px;
        font-size: 14px;
    }

    .reward-point {
        color: #28a745;
        font-size: 14px;
        margin-top: 4px;
        white-space: nowrap;
    }

    .summary-box {
        text-align: right;
        margin-top: 40px;
        font-size: 18px;
    }

    .total-price {
        font-weight: bold;
        font-size: 20px;
        margin-top: 10px;
    }

    .total-reward-point {
        color: #28a745;
        font-weight: bold;
        margin-top: 6px;
        font-size: 18px;
    }

    .buy-btn {
        margin-top: 20px;
        padding: 12px 30px;
        background-color: #007bff;
        border: none;
        color: white;
        font-size: 16px;
        cursor: pointer;
        border-radius: 4px;
    }
</style>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    function updateTotal() {
        let total = 0;
        const checkboxes = document.querySelectorAll(".item-checkbox");
        const allCheckbox = document.getElementById("selectAll");

        let checkedCount = 0;
        let enabledCount = 0;

        checkboxes.forEach(cb => {
            if (!cb.disabled) enabledCount++;
            if (cb.checked) {
                checkedCount++;
                const price = parseInt(cb.getAttribute("data-total-price"));
                total += price;
            }
        });

        allCheckbox.checked = (checkedCount === enabledCount && enabledCount > 0);

        const totalElement = document.getElementById("totalPrice");
        const formatted = total.toLocaleString('ko-KR');
        totalElement.innerText = formatted + "원";

        const rewardPoint = Math.floor(total * 0.01);
        const rewardElement = document.getElementById("totalRewardPoint");
        if (rewardElement) {
            rewardElement.innerText = rewardPoint.toLocaleString('ko-KR') + "원";
        }
    }

    function toggleAllCheckboxes(source) {
        const checkboxes = document.querySelectorAll(".item-checkbox:not(:disabled)");
        checkboxes.forEach(cb => {
            cb.checked = source.checked;
        });
        updateTotal();
    }

    // 변경: 버튼에서 this(버튼 자신)도 같이 넘겨받음
    function changeQuantity(delta, button) {
	    const itemDiv = button.closest('.cart-item');
	    const cartId = itemDiv.getAttribute('data-cart-id');
	    const qtyInput = itemDiv.querySelector('input[type="text"]');
        let currentQty = parseInt(qtyInput.value);
        let newQty = currentQty + delta;

        if (newQty < 1) {
            alert("수량은 1개 이상이어야 합니다.");
            return;
        }

        const maxQty = parseInt(itemDiv.getAttribute("data-inventory-quantity"));

        if (newQty > maxQty) {
        	alert('수량은 최대 ' + maxQty + '개까지 가능합니다.');
            return;
        }

     	// 수량 변경 반영
        qtyInput.value = newQty;

        // ✅ [추가] 가격도 실시간 반영
        const pricePerUnit = parseInt(itemDiv.querySelector('.item-price').getAttribute('data-price-per-unit'));
        const newTotalPrice = pricePerUnit * newQty;
        itemDiv.querySelector('.price-value').innerText = newTotalPrice.toLocaleString('ko-KR') + "원";

        // ✅ [추가] 적립금도 업데이트
        itemDiv.querySelector('.reward-point').innerText = "적립금: " + Math.floor(newTotalPrice * 0.01).toLocaleString('ko-KR') + "원";

        // 기존 총액 업데이트
        updateTotal();


        console.log('cartId:', cartId);
        console.log('newQty:' , newQty);
        $.ajax({
            url: '/shoppingCart/updateQuantity',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({
                cartId: cartId,
                quantity: newQty
            }),
            success: function(data) {
                if (!data.success) {
                    alert('수량 변경에 실패했습니다. 다시 시도해주세요.');
                    // 실패 시 원래 수량으로 복원
                    qtyInput.value = currentQty;
                    updateTotal();
                }
                // 성공 시 추가 처리 가능
            },
            error: function(xhr, status, error) {
                console.error('AJAX 오류:', error);
                alert('서버와 통신 중 오류가 발생했습니다.');
                // 오류 시 원래 수량으로 복원
                qtyInput.value = currentQty;
                updateTotal();
            }
        });

    }

    function deleteItem(cartId, button) {
        if (!confirm("정말 삭제하시겠습니까?")) return;

        $.ajax({
            url: '/shoppingCart/deleteItem',
            method: 'POST',
            contentType: 'application/json',
            data: JSON.stringify({ cartId: cartId }),
            success: function(response) {
                if (response.success) {
                    // 장바구니 항목 DOM에서 삭제
                    const itemDiv = button.closest('.cart-item');
                    itemDiv.remove();

                    updateTotal(); // 총액 재계산
                } else {
                    alert('삭제에 실패했습니다: ' + response.message);
                }
            },
            error: function(xhr, status, error) {
                console.error('삭제 AJAX 오류:', error);
                alert('서버와 통신 중 오류가 발생했습니다.');
            }
        });
        
    }
</script>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

<div class="container">
    <div class="cart-title">장바구니</div>

	<!-- ✅ 에러 메시지 영역 -->
    <c:if test="${not empty errorMessage}">
        <div style="background-color: #ffdddd; border: 1px solid #ff4d4f; padding: 10px; margin-bottom: 20px; border-radius: 5px; color: #a94442;">
            <strong>알림:</strong> ${errorMessage}
        </div>
    </c:if>
    
    <div class="header-checkbox">
        <input type="checkbox" id="selectAll" onclick="toggleAllCheckboxes(this)" />
        <label for="selectAll">전체 선택</label>
    </div>

    <c:forEach var="item" items="${shoppingCartList}">
        <c:set var="itemTotal" value="${item.quantity * item.price}" />
        <c:set var="isSoldOut" value="${item.productStatus == '일시품절'}" />

		<c:if test="${item.quantityAdjusted}">
		    <div style="color: red; font-size: 13px; margin-top: 5px;">
		        ※ 재고 부족으로 수량이 ${item.inventoryQuantity}개로 조정되었습니다.
		    </div>
		</c:if>
		
        <div class="cart-item ${isSoldOut ? 'sold-out' : ''}"
        	data-cart-id="${item.cartId}"
	     	data-user-id="${item.userId}"
		    data-product-no="${item.productNo}"
		    data-option-no="${item.optionNo}"
		    data-product-name="${item.productName}"
		    data-option-name="${item.optionName}"
		    data-option-name-value="${item.optionNameValue}"
		    data-quantity="${item.quantity}"
		    data-price="${item.price}"
		    data-inventory-quantity="${item.inventoryQuantity}">
            <input type="checkbox" class="item-checkbox"
                   data-total-price="${itemTotal}"
                   onchange="updateTotal()"
                   <c:if test="${isSoldOut}">disabled</c:if> />

			<!-- ✅ 썸네일 이미지 영역 추가 -->
	        <div class="item-thumbnail" style="margin-right: 10px;">
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
	        </div>
        
            <div class="item-info">
                <div class="item-name">${item.productName}</div>
                <div class="item-option">옵션: ${item.optionNameValue}</div>
            </div>

            <div class="item-quantity">
                수량:
                <button type="button" class="qty-btn" onclick="changeQuantity(-1, this)" <c:if test="${isSoldOut}">disabled</c:if> >-</button>
				<input type="text" value="${item.quantity}" readonly />
				<button type="button" class="qty-btn" onclick="changeQuantity(1, this)" <c:if test="${isSoldOut}">disabled</c:if> >+</button>

                <button type="button" class="delete-btn" onclick="deleteItem('${item.cartId}', this)">삭제</button>
            </div>

            <div class="item-price" data-price-per-unit="${item.price}">
                <span class="price-value"><fmt:formatNumber value="${itemTotal}" type="number" />원</span>
                <c:if test="${isSoldOut}">
                    <div class="sold-out-text">품절</div>
                </c:if>
                <div class="reward-point">
                    적립금: <fmt:formatNumber value="${itemTotal * 0.01}" type="number" />원
                </div>
            </div>
        </div>
    </c:forEach>

    <div class="summary-box">
        <div class="total-price">
            총 결제 금액: <span id="totalPrice">0원</span>
        </div>
        <div class="total-reward-point">
            적립금: <span id="totalRewardPoint">0원</span>
        </div>
        <button class="buy-btn" onclick="handleBuyClick()">구매하기</button>
    </div>
</div>

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<script>
    window.onload = function() {
        updateTotal();
    };
    
    function handleBuyClick() {
        // 체크된 체크박스 중 disabled가 아닌 것 확인
        const checkedBoxes = document.querySelectorAll('.item-checkbox:not(:disabled):checked');
        if (checkedBoxes.length === 0) {
            alert('구매할 상품을 선택해주세요.');
            return;
        }
        
        const form = document.createElement("form");
        form.method = "POST";
        form.action = "/personal/purchase";
        form.style.display = "none";

        checkedBoxes.forEach((checkbox, index) => {
            const item = checkbox.closest('.cart-item');

            const userId = item.getAttribute('data-user-id');
            const productNo = item.getAttribute('data-product-no');
            const optionNo = item.getAttribute('data-option-no');
            const productName = item.getAttribute('data-product-name');
            const optionName = item.getAttribute('data-option-name');
            const optionNameValue = item.getAttribute('data-option-name-value');
            const price = item.getAttribute('data-price');
            const quantity = item.querySelector('input[type="text"]').value;

            form.appendChild(createHiddenInput("purchaseList[" + index + "].userId", userId));
            form.appendChild(createHiddenInput("purchaseList[" + index + "].productNo", productNo));
            form.appendChild(createHiddenInput("purchaseList[" + index + "].optionNo", optionNo));
            form.appendChild(createHiddenInput("purchaseList[" + index + "].productName", productName));
            form.appendChild(createHiddenInput("purchaseList[" + index + "].optionName", optionName));
            form.appendChild(createHiddenInput("purchaseList[" + index + "].optionNameValue", optionNameValue));
            form.appendChild(createHiddenInput("purchaseList[" + index + "].orderQuantity", quantity));
            form.appendChild(createHiddenInput("purchaseList[" + index + "].price", price));
            form.appendChild(createHiddenInput("purchaseList[0].source", "cart"));
        });

        document.body.appendChild(form);
        form.submit();
    }
    
    function createHiddenInput(name, value) {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = name;
        input.value = value;
        return input;
    }
</script>

</body>
</html>