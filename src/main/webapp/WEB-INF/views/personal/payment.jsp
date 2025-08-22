<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>결제 페이지</title>
<style>
table {
	border-collapse: collapse;
	width: 60%;
}

table, td {
	border: 1px solid #ddd;
	padding: 10px;
}

h1, h3 {
	margin-top: 20px;
}

.note {
	font-size: small;
	color: gray;
}

.btn {
	padding: 6px 12px;
	margin: 3px;
	border: 1px solid #444;
	background-color: #f4f4f4;
	cursor: pointer;
}

.btn:hover {
	background-color: #ddd;
}

.error {
	color: red;
	font-size: 14px;
	margin-top: 5px;
}
</style>
</head>

<jsp:include page="/WEB-INF/common/header/personalHeader.jsp" />
<body>
	<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />
	<h1>결제하기</h1>
	<form id="paymentForm">
		<h3>상품 정보</h3>
		<table border="1">
			<tr>
				<th>상품명</th>
				<th>옵션</th>
				<th>수량</th>
				<th>가격</th>
			</tr>
			<c:forEach var="order" items="${orderList}">
				<tr>
					<td>${order.productName}</td>
					<td>${order.optionName}:${order.optionNameValue}</td>
					<td>${order.orderQuantity}</td>
					<td>${order.price}원</td>
				</tr>
			</c:forEach>
		</table>

		<h3>결제수단</h3>
			<label><input type="radio" name="paymentMethod" value="kakaopay" checked> 카카오페이</label> 
			<label><input type="radio" name="paymentMethod" value="bank"> 계좌이체</label>
			<label><input type="radio" name="paymentMethod" value="card"> 카드결제</label>

		<div id="bankInfo" style="display: none; margin-top: 5px;">
			<p>기업 계좌번호: <strong>기업은행 977-000803-01-011 (예금주: 노민혁)</strong></p>
		</div>

		<div id="cardInfo" style="display: none; margin-top: 10px;">
			<c:choose>
				<c:when test="${not empty cardList}">
					<p><strong>등록된 카드 선택</strong></p>
					<c:forEach var="card" items="${cardList}">
						<label><input type="radio" name="cardNo" value="${card.paymentMethodNo}"
							<c:if test="${card.isDefault == 'Y'}">checked</c:if>>
								${card.financialInstitution} - ****-****-****-${fn:substring(card.accountNumber, card.accountNumber.length()-4, card.accountNumber.length())}
								(유효기간: ${card.cardExpiration})
						</label>
						<br>
					</c:forEach>
					<br>
					<button type="button" class="btn" onclick="document.getElementById('newCardForm').style.display='block'">+ 새 카드 등록</button>
					<div id="newCardForm" style="display: none;">
						<label>카드사: <input type="text" name="financialInstitution"></label><br>
						<label>카드번호: <input type="text" name="accountNumber"></label><br>
						<label>유효기간(YYYY-MM): <input type="month" name="cardExpiration"></label><br> 
						<label>CVC: <input type="text" name="cardCvc" maxlength="4"></label><br>
						<label>비밀번호 앞 2자리: <input type="password" name="cardPassword" maxlength="2"></label><br>
						<label><input type="checkbox" name="isDefault" value="Y"> 기본 결제수단으로 등록</label>
						<button type="button" class="btn" onclick="addCard()">카드 등록</button>
					</div>
				</c:when>
				<c:otherwise>
					<p><strong>등록된 카드가 없습니다. 새 카드 정보를 입력하세요.</strong></p>
						<div id="newCardForm">
							<label>카드사: <input type="text" name="financialInstitution"></label><br>
							<label>카드번호: <input type="text" name="accountNumber"></label><br>
							<label>유효기간(YYYY-MM): <input type="month" name="cardExpiration"></label><br>
							<label>CVC: <input type="text" name="cardCvc" maxlength="4"></label><br>
							<label>비밀번호 앞 2자리: <input type="password" name="cardPassword" maxlength="2"></label><br>
							<label><input type="checkbox" name="isDefault" value="Y"> 기본 결제수단으로 등록</label>
						</div>
				</c:otherwise>
			</c:choose>
		</div>

		<h3>결제 금액</h3>
		<p>상품 총 금액:
			<c:set var="total" value="0" />
			<c:forEach var="order" items="${orderList}">
				<c:set var="total" value="${total + (order.price * order.orderQuantity)}" />
			</c:forEach>
			<span id="totalAmount">${total}</span> 원
		</p>

		<p>사용 가능 적립금: <input type="text" id="availablePoints" value="${reward}" readonly> 원</p>

		<p>사용할 적립금: <input type="number" id="usePoints" name="usePoints" min="0" step="100"> 원
			<button type="button" id="useAllBtn" class="btn" onclick="useAllPoints()">전액 사용</button>
			<div id="pointError" class="error"></div>
				<div class="note" id="pointRuleNote">
					적립금 사용 규칙: ① 주문금액 10,000원 이상 ② 최소 1,000원 ③ 100원 단위 ④ 주문금액의 10% 이내
				</div>
			<div class="note" id="pointMaxNote"></div>
		</p>

		<p><strong>최종 결제 금액: <span id="finalAmount">${total}</span> 원</strong></p>

		<h3>배송지</h3>
		<c:forEach var="add" items="${mainAddress}">
			<p>기본 배송지: <strong id="selectedAddress">${add.address} 	${add.detailAddress }</strong></p>
			<p>별칭 : <strong id="selectedAddressNickname">${add.nickname}</strong></p>
		</c:forEach>
		<input type="hidden" id="selectedAddressId" name="addressNo" value="${orderList[0].addressNo}">
		<button type="button" class="btn" onclick="openAddressPopup()">배송지 변경</button>

		<h3>배송 요청사항</h3>
		<textarea name="deliveryRequest" rows="3" cols="60"	placeholder="예: 부재 시 경비실에 맡겨주세요.">${orderList[0].deliveryRequest}</textarea>
		<br><br> 
		<input type="button" id="payBtn" class="btn" value="결제하기" onclick="showPasswordPopup()"> 
		<input type="reset"	class="btn" value="취소">
	</form>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
const reward = document.getElementById("availablePoints").value
console.log(reward);
	function getPointRuleError(usePoint, total, available) {
		// 포인트 사용 안 하면 통과
		if (!usePoint || usePoint <= 0) return "";
		
		if (total < 10000) return "물품 가격이 10,000원 이상이어야 적립금을 사용할 수 있습니다.";
		if (usePoint < 1000) return "적립금은 최소 1,000원 이상 사용 가능합니다.";
		if (usePoint % 100 !== 0) return "적립금은 100원 단위로만 사용 가능합니다.";
		
		const maxPoint = Math.floor((total * 0.1) / 100) * 100; // 구매가 10%를 100원 단위로 내림
		if (usePoint > maxPoint) return `적립금은 구매 가격의 10%(${maxPoint}원)를 넘을 수 없습니다.`;
		if (usePoint > available) return "보유 적립금을 초과했습니다.";
		
		return "";
	}
	function updateFinalAmount() {
		const total     = parseInt(document.getElementById("totalAmount").innerText);
		const available = parseInt(document.getElementById("availablePoints").value);
		let usePoint    = parseInt(document.getElementById("usePoints").value || 0);
		
		if (usePoint < 0) usePoint = 0;
		
		const err = getPointRuleError(usePoint, total, available);
		const errorDiv = document.getElementById("pointError");
		const payBtn = document.getElementById("payBtn");

		if (err) {
			errorDiv.textContent = err;
			document.getElementById("finalAmount").innerText = total; // 차감 금지
			payBtn.disabled = true;                                   // 버튼 막기
		} else {
			errorDiv.textContent = "";
			// 클램핑(보유 한도 내, 10% 내, 100원 단위 유지)
			const maxPoint = Math.floor((total * 0.1) / 100) * 100;
			usePoint = Math.min(usePoint, available, maxPoint);
			usePoint = Math.floor(usePoint / 100) * 100;
			document.getElementById("usePoints").value = usePoint;
			document.getElementById("finalAmount").innerText = total - usePoint;
			
			payBtn.disabled = false;
		}
		refreshPointControls();
	}
	console.log("totalAmount.innerText =", document.getElementById("totalAmount").innerText);

	function refreshPointControls() {
		const total = parseInt(document.getElementById("totalAmount").innerText);
		const available  = parseInt(document.getElementById("availablePoints").value);
		const useInput   = document.getElementById("usePoints");
		const allBtn     = document.getElementById("useAllBtn");
		const maxNote    = document.getElementById("pointMaxNote");
		
		const maxByRate  = Math.floor((total * 0.1) / 100) * 100; // 10%를 100원 단위 내림
		const maxUsable  = Math.min(available, maxByRate);
		const eligible   = (total >= 10000) && (maxUsable >= 1000);
		
		maxNote.textContent = `최대 사용 가능: ${maxUsable}원 (보유 ${available}원, 한도 ${maxByRate}원)`;
		
		useInput.disabled = !eligible;
		allBtn.disabled   = !eligible;
		if (!eligible) {
			useInput.value = 0;
			document.getElementById("finalAmount").innerText = total;
		}
	}
	
	function useAllPoints() {
		const total     = parseInt(document.getElementById("totalAmount").innerText);
		const available = parseInt(document.getElementById("availablePoints").value);
		
		// ❌ 1만원 미만이면 사용 불가: 0으로 고정하고 종료
		if (total < 10000) {
			document.getElementById("usePoints").value = 0;
			updateFinalAmount();
			return;
		}
		
		// 총액의 10% 한도(100원 단위 내림)와 보유 포인트 중 작은 값
		const tenPctCap = Math.floor((total * 0.1) / 100) * 100;
		let usePoint    = Math.min(available, tenPctCap);
		
		// 100원 단위로 내림
		usePoint = Math.floor(usePoint / 100) * 100;
		
		// ❌ 최소 1,000원 미만이면 사용하지 않음
		if (usePoint < 1000) {
			document.getElementById("usePoints").value = 0;
			updateFinalAmount();
			return;
		}
		
		document.getElementById("usePoints").value = usePoint;
		updateFinalAmount();
	}
	
	window.onload = function() {
	    document.querySelectorAll("input[name='paymentMethod']").forEach(radio => {
	        radio.addEventListener("change", function() {
	            const bankInfo = document.getElementById("bankInfo");
	            const cardInfo = document.getElementById("cardInfo");
	
	            bankInfo.style.display = (this.value === "bank") ? "block" : "none";
	            cardInfo.style.display = (this.value === "card") ? "block" : "none";
	        });
	    });
	
	    document.getElementById("usePoints").addEventListener("input", updateFinalAmount);
	    updateFinalAmount();
	    refreshPointControls(); 
	};
	
	function openAddressPopup() {
	    let userId = "${orderList[0].userId}";
	    window.open("/personal/addressPopup?user_id=" + userId, "addressPopup", "width=800,height=600,scrollbars=yes");
	}
	
	function showPasswordPopup() {
		const method = document.querySelector("input[name='paymentMethod']:checked").value;
		if (method === "bank") {
			  updateDeliveryRequest()
			    .done(function () {
			      const total     = parseInt(document.getElementById("totalAmount").innerText);
			      const available = parseInt(document.getElementById("availablePoints").value);
			      let usePoint    = parseInt(document.getElementById("usePoints").value || 0);

			      const err = getPointRuleError(usePoint, total, available);
			      if (err) { alert(err); return; }

			      // 규칙에 맞춰 클램프
			      const maxPoint = Math.floor((total * 0.1) / 100) * 100;
			      usePoint = Math.max(0, Math.min(usePoint, available, maxPoint));
			      usePoint = Math.floor(usePoint / 100) * 100;

			      $.ajax({
			        type: "POST",
			        url: "/personal/payment/saveMethodAndPoints",
			        contentType: "application/json",
			        data: JSON.stringify({
			          orderNo: "${orderList[0].orderNo}",
			          paymentMethod: "bank",
			          usePoint: usePoint
			        }),
			        success: function () {
			          alert("계좌이체가 선택되었습니다. 기업 계좌로 입금 후 주문이 완료됩니다.");
			          location.href = "/personal/orderList";
			        },
			        error: function () { alert("결제수단/적립금 저장 실패"); }
			      });
			    })
			    .fail(function () { alert("배송요청 저장 실패"); });
			  return;
			}

		
		// ✅ 포인트 규칙 검사
		const total     = parseInt(document.getElementById("totalAmount").innerText);
		const available = parseInt(document.getElementById("availablePoints").value);
		const usePoint  = parseInt(document.getElementById("usePoints").value || 0);
		const err = getPointRuleError(usePoint, total, available);
		if (err) { alert(err); return; }
		
		const userId = "${orderList[0].userId}";
			$.ajax({
				type: "GET"
				,url: "/personal/payment/simplePassword"
				,data: { userId }
				,dataType: "json"
				,success: function(hasPassword) {
					window.open("/personal/passwordPopup?userId=" + userId, "passwordPopup", "width=400, height=300");
				},
			error: function() { alert("비밀번호 등록 유무 확인 중 오류 발생"); }
			});
	}
	
	function updateDeliveryRequest() {
		const orderNo = "${orderList[0].orderNo}";
		const deliveryRequest = document.querySelector("textarea[name='deliveryRequest']").value.trim();
		
		return $.ajax({
			type: "POST"
			,url: "/personal/payment/deliveryRequest"
			,data: JSON.stringify({ orderNo: orderNo, deliveryRequest: deliveryRequest })
			,contentType: "application/json"
		});
	}
	
	// 팝업에서 호출할 결제 완료 함수
function completePayment() {
  updateDeliveryRequest()
    .done(function () {
      const method    = document.querySelector("input[name='paymentMethod']:checked").value;
      const total     = parseInt(document.getElementById("totalAmount").innerText);
      const available = parseInt(document.getElementById("availablePoints").value);
      let usePoint    = parseInt(document.getElementById("usePoints").value || 0);

      // 1) 규칙 검사
      const err = getPointRuleError(usePoint, total, available);
      if (err) { alert(err); return; }

      // 2) 클램프(보유/10%/100원 단위)
      const maxPoint = Math.floor((total * 0.1) / 100) * 100;
      usePoint = Math.max(0, Math.min(usePoint, available, maxPoint));
      usePoint = Math.floor(usePoint / 100) * 100;

      // 3) 결제 데이터
      const data = {
        orderNo: "${orderList[0].orderNo}",
        name: "${orderList[0].productName}",
        totalPrice: Math.max(0, total - usePoint),
        usePoint: usePoint,
        userId: "${orderList[0].userId}",
        paymentMethod: method
      };

      // 카드결제: 저장만 하고 끝
      if (method === "card") {
        $.ajax({
          type: "POST",
          url: "/personal/payment/saveMethodAndPoints",
          contentType: "application/json",
          data: JSON.stringify({
            orderNo: data.orderNo,
            paymentMethod: "card",
            usePoint: data.usePoint
          }),
          success: function () {
            alert("카드결제가 완료되었습니다.");
            location.href = "/personal/orderList";
          },
          error: function () { alert("결제수단/적립금 저장 실패"); }
        });
        return;
      }

      // 카카오페이: 먼저 저장 → 저장 성공 시 ready 호출
      if (method === "kakaopay") {
        $.ajax({
          type: "POST",
          url: "/personal/payment/saveMethodAndPoints",
          contentType: "application/json",
          data: JSON.stringify({
            orderNo: data.orderNo,
            paymentMethod: "kakaopay",
            usePoint: data.usePoint
          }),
          success: function () {
            $.ajax({
              type: "POST",
              url: "/personal/payment/ready",
              contentType: "application/json",
              data: JSON.stringify({
                orderNo: data.orderNo,
                name: data.name,
                totalPrice: data.totalPrice
              }),
              success: function(response) {
                if (response.next_redirect_pc_url) {
                  const win = window.open(
                    response.next_redirect_pc_url,
                    "kakaoPayPopup",
                    "width=500,height=700"
                  );
                  const timer = setInterval(function () {
                    if (win.closed) { clearInterval(timer); location.href = "/personal/orderList"; }
                  }, 1000);
                } else {
                  alert("카카오페이 결제 요청 실패");
                }
              },
              error: function(xhr) {
                alert(
                  (xhr.responseJSON && xhr.responseJSON.message)
                  ? xhr.responseJSON.message
                  : "카카오페이 결제 중 오류 발생"
                );
              }
            });
          },
          error: function () {
            alert("결제수단/적립금 저장 실패");
          }
        });
        return;
      }

      // (참고) 계좌이체는 showPasswordPopup() 쪽에서 이미 저장 후 안내 처리됨
    })
    .fail(function () {
      alert("배송요청 저장 실패");
    });
}
	
	function addCard() {
		const formData = {
			userId: "${orderList[0].userId}",
			financialInstitution: document.querySelector("input[name='financialInstitution']").value,
			accountNumber: document.querySelector("input[name='accountNumber']").value,
			cardExpiration: document.querySelector("input[name='cardExpiration']").value,
			cardCvc: document.querySelector("input[name='cardCvc']").value,
			cardPassword: document.querySelector("input[name='cardPassword']").value,
			isDefault: document.querySelector("input[name='isDefault']").checked ? "Y" : "N"
		};
	
		$.ajax({
			type: "POST",
			url: "/personal/payment/addCard"
			,data: JSON.stringify(formData)
			,contentType: "application/json"
			,success: function() {
				alert("카드가 등록되었습니다.");
				location.reload();
			},
			error: function(xhr, status, error) {
				console.error("카드 등록 실패:", error);
				alert("카드 등록 중 오류가 발생했습니다.");
			}
		});
	 }
</script>
</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>