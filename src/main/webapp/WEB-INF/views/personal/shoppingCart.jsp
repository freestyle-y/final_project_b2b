<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>장바구니</title>
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
    
    $(function() {
    	$('.item-checkbox:not(:disabled)').on('change', updateTotal);
    	
        // 수량 감소 (-) 버튼
        $('.quantity-btn.decrease').on('click', function() {
            const $item = $(this).closest('.cart-item');
            const $input = $item.find('input[type="text"]');
            const currentQty = parseInt($input.val());
            const newQty = currentQty;

            if (newQty < 1) {
                alert("수량은 1개 이상이어야 합니다.");
                return;
            }

            const maxQty = parseInt($item.data('inventory-quantity'));
            if (newQty > maxQty) {
                alert("수량은 최대 " + maxQty + "개까지 가능합니다.");
                return;
            }

            // UI 즉시 업데이트
            $input.val(newQty);
            const pricePerUnit = parseInt($item.find('.item-total').data('price-per-unit'));
            const newTotalPrice = pricePerUnit * newQty;
            $item.find('.item-total > span').text(newTotalPrice.toLocaleString('ko-KR') + "원");
            $item.find('.reward-point').text("적립금: " + Math.floor(newTotalPrice * 0.01).toLocaleString('ko-KR') + "원");
            $item.find('.item-checkbox').attr('data-total-price', newTotalPrice);

            // 총합 재계산
            updateTotal();

            // 서버로 수량 변경 전송
            $.ajax({
                url: '/shoppingCart/updateQuantity',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    cartId: $item.data('cart-id'),
                    quantity: newQty
                }),
                success(data) {
                    if (!data.success) {
                        alert('수량 변경에 실패했습니다. 다시 시도해주세요.');
                        restoreOldQty($item, currentQty, pricePerUnit);
                    }
                },
                error() {
                    alert('서버와 통신 중 오류가 발생했습니다.');
                    restoreOldQty($item, currentQty, pricePerUnit);
                }
            });
        });

        // 수량 증가 (+) 버튼
        $('.quantity-btn.increase').on('click', function() {
            const $item = $(this).closest('.cart-item');
            const $input = $item.find('input[type="text"]');
            const currentQty = parseInt($input.val());
            const newQty = currentQty;

            const maxQty = parseInt($item.data('inventory-quantity'));
            if (newQty > maxQty) {
                alert("수량은 최대 " + maxQty + "개까지 가능합니다.");
                return;
            }

            // UI 즉시 업데이트
            $input.val(newQty);
            const pricePerUnit = parseInt($item.find('.item-total').data('price-per-unit'));
            const newTotalPrice = pricePerUnit * newQty;
            $item.find('.item-total > span').text(newTotalPrice.toLocaleString('ko-KR') + "원");
            $item.find('.reward-point').text("적립금: " + Math.floor(newTotalPrice * 0.01).toLocaleString('ko-KR') + "원");
            $item.find('.item-checkbox').attr('data-total-price', newTotalPrice);

            // 총합 재계산
            updateTotal();

            // 서버로 수량 변경 전송
            $.ajax({
                url: '/shoppingCart/updateQuantity',
                method: 'POST',
                contentType: 'application/json',
                data: JSON.stringify({
                    cartId: $item.data('cart-id'),
                    quantity: newQty
                }),
                success(data) {
                    if (!data.success) {
                        alert('수량 변경에 실패했습니다. 다시 시도해주세요.');
                        restoreOldQty($item, currentQty, pricePerUnit);
                    }
                },
                error() {
                    alert('서버와 통신 중 오류가 발생했습니다.');
                    restoreOldQty($item, currentQty, pricePerUnit);
                }
            });
        });

        // 총합 초기 계산
        updateTotal();
    });

    function toggleAllCheckboxes(source) {
        const checkboxes = document.querySelectorAll(".item-checkbox:not(:disabled)");
        checkboxes.forEach(cb => {
            cb.checked = source.checked;
        });
        updateTotal();
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
                    updateCartCount();
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
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

	<!-- Page Title -->
    <div class="page-title light-background">
      <div class="container d-lg-flex justify-content-between align-items-center">
        <h1 class="mb-2 mb-lg-0">장바구니</h1>
        <nav class="breadcrumbs">
          <ol>
            <li><a href="index.html">Home</a></li>
            <li class="current">장바구니</li>
          </ol>
        </nav>
      </div>
    </div><!-- End Page Title -->

	<!-- Cart Section -->
    <section id="cart" class="cart section">

      <div class="container" data-aos="fade-up" data-aos-delay="100">

        <div class="row">
          <div class="col-lg-8" data-aos="fade-up" data-aos-delay="200">
          
            <div class="cart-items">
            
            <!-- ✅ 에러 메시지 영역 -->
		    <c:if test="${not empty errorMessage}">
		        <div style="background-color: #ffdddd; border: 1px solid #ff4d4f; padding: 10px; margin-bottom: 20px; border-radius: 5px; color: #a94442;">
		            <strong>알림:</strong> ${errorMessage}
		        </div>
		    </c:if>
		    
              <div class="cart-header d-none d-lg-block">
                <div class="row align-items-center">
                  <div class="col-lg-1 d-flex justify-content-center">
			        <input type="checkbox" id="selectAll" onclick="toggleAllCheckboxes(this)" />
			      </div>
                  <div class="col-lg-5">
                    <h5>상품</h5>
                  </div>
                  <div class="col-lg-2 text-center">
                    <h5>가격</h5>
                  </div>
                  <div class="col-lg-2 text-center">
                    <h5>수량</h5>
                  </div>
                  <div class="col-lg-2 text-center">
                    <h5>금액</h5>
                  </div>
                </div>
              </div>

                <!-- Cart Item -->
				<c:forEach var="item" items="${shoppingCartList}">
				    <c:set var="itemTotal" value="${item.quantity * item.price}" />
				    <c:set var="isSoldOut" value="${item.productStatus == '일시품절'}" />
				
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
				         
				        <div class="row align-items-center">
				            
				            <!-- 🧾 Product Info -->
				            <div class="col-lg-6 col-12 mt-3 mt-lg-0 mb-lg-0 mb-3">
				                <div class="product-info d-flex align-items-center">
				                    <div class="product-checkbox me-3">
								      <input type="checkbox" class="item-checkbox" data-total-price="${item.quantity * item.price}" 
								      	<c:if test="${isSoldOut}"> disabled </c:if>/>
								    </div>
				                    <!-- ✅ 이미지 -->
				                    <div class="product-image">
				                        <c:choose>
				                            <c:when test="${not empty item.imagePath}">
				                                <img src="${pageContext.request.contextPath}${item.imagePath}" alt="${item.productName}" class="img-fluid" loading="lazy">
				                            </c:when>
				                            <c:otherwise>
				                                <span style="color: #ccc; font-size: 12px;">이미지 없음</span>
				                            </c:otherwise>
				                        </c:choose>
				                    </div>
				
				                    <!-- ✅ 상품명, 옵션, 삭제 버튼 -->
				                    <div class="product-details">
				                        <h6 class="product-title">
				                        	<a href="/personal/productOne?productNo=${item.productNo}">${item.productName}</a>
				                        </h6>
				                        <div class="product-meta">
				                            <span>옵션: ${item.optionNameValue}</span>
				                        </div>
				
				                        <button class="remove-item" type="button" onclick="deleteItem('${item.cartId}', this)">
				                            <i class="bi bi-trash"></i> 삭제
				                        </button>
				
				                        <!-- 🔔 수량 조정 안내 -->
				                        <c:if test="${item.quantityAdjusted}">
				                            <div style="color: red; font-size: 13px; margin-top: 5px;">
				                                ※ 재고 부족으로 수량이 ${item.inventoryQuantity}개로 조정되었습니다.
				                            </div>
				                        </c:if>
				                        <c:if test="${isSoldOut}">
						                	<div class="text-danger small mt-1">※ 품절 상품입니다.</div>
						                </c:if>
				                    </div>
				                </div>
				            </div>
				
				            <!-- 💰 Price -->
				            <div class="col-lg-2 col-12 mt-3 mt-lg-0 text-center">
				                <div class="price-tag">
				                    <span class="current-price">
				                        <fmt:formatNumber value="${item.price}" type="number" />원
				                    </span>
				                </div>
				            </div>
				
				            <!-- 🔢 Quantity -->
				            <div class="col-lg-2 col-12 mt-3 mt-lg-0 text-center">
				                <div class="quantity-selector">
				                    <button class="quantity-btn decrease" <c:if test="${isSoldOut}">disabled</c:if> > 
				                        <i class="bi bi-dash"></i>
				                    </button>
				                    <input type="text" class="quantity-input" value="${item.quantity}" min="1" max="${item.inventoryQuantity}" readonly>
				                    <button class="quantity-btn increase" <c:if test="${isSoldOut}">disabled</c:if> >
				                        <i class="bi bi-plus"></i>
				                    </button>
				                </div>
				            </div>
				
				            <!-- 🧮 Total Price + 적립금 -->
				            <div class="col-lg-2 col-12 mt-3 mt-lg-0 text-center">
				                <div class="item-total" data-price-per-unit="${item.price}">
				                	<span style="font-size: 16px; font-weight: 600;">
				                    	<fmt:formatNumber value="${itemTotal}" type="number" />원
				                    </span>
				
				                    <c:if test="${isSoldOut}">
				                        <div class="sold-out-text" style="font-size: 13px; color: red; margin-top: 4px;">품절</div>
				                    </c:if>
				
				                    <div class="reward-point" style="font-size: 13px; color: #666; margin-top: 4px;">
				                        적립금: <fmt:formatNumber value="${itemTotal * 0.01}" type="number" />원
				                    </div>
				                </div>
				            </div>
				
				        </div>
				    </div>
				</c:forEach>
			
            </div>
          </div>

          <div class="col-lg-4 mt-4 mt-lg-0" data-aos="fade-up" data-aos-delay="300">
            <div class="cart-summary">
              <h4 class="summary-title">주문 요약</h4>
			  
			  <div class="summary-item reward">
                <span class="summary-label">적립금</span>
                <span class="summary-value" id="totalRewardPoint">0원</span>
              </div>
              
              <div class="summary-total">
                <span class="summary-label">총액</span>
                <span class="summary-value" id="totalPrice">0원</span>
              </div>

			  <div class="checkout-button">
			    <a href="javascript:void(0);" class="btn btn-accent w-100" onclick="handleBuyClick()">
			      결제하기 <i class="bi bi-arrow-right"></i>
			    </a>
			  </div>

              <div class="continue-shopping">
                <a href="/personal/productList" class="btn btn-link w-100">
                  <i class="bi bi-arrow-left"></i> 계속 쇼핑하기
                </a>
              </div>

              <div class="payment-methods">
                <p class="payment-title">We Accept</p>
                <div class="payment-icons">
                  <i class="bi bi-credit-card"></i>
                  <i class="bi bi-paypal"></i>
                  <i class="bi bi-wallet2"></i>
                  <i class="bi bi-bank"></i>
                </div>
              </div>
            </div>
          </div>
        </div>

      </div>

    </section><!-- /Cart Section -->

	<!-- Scroll Top -->
  	<a href="#" id="scroll-top" class="scroll-top d-flex align-items-center justify-content-center"><i class="bi bi-arrow-up-short"></i></a>
	
</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>