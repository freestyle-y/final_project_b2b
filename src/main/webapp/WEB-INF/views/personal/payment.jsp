<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
</style>

<script>
    // 적립금 전액 사용 버튼
    function useAllPoints() {
        const available = document.getElementById("availablePoints").value;
        document.getElementById("usePoints").value = available;
    }

    // 페이지 로드 후 이벤트 등록
    window.onload = function() {
        // 결제수단 라디오 버튼 change 이벤트 등록
        document.querySelectorAll("input[name='paymentMethod']").forEach(radio => {
            radio.addEventListener("change", function() {
                const bankInfo = document.getElementById("bankInfo");
                const cardInfo = document.getElementById("cardInfo");

                if (this.value === "bank") {
                    bankInfo.style.display = "block";
                    cardInfo.style.display = "none";
                } else if (this.value === "card") {
                    cardInfo.style.display = "block";
                    bankInfo.style.display = "none";
                } else {
                    bankInfo.style.display = "none";
                    cardInfo.style.display = "none";
                }
            });
        });
    };
</script>
</head>

<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
    <jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

    <h1>결제하기</h1>

    <!-- form 시작 -->
    <form id="paymentForm" onsubmit="return handlePayment();">

        <!-- 상품 정보 -->
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
                    <td>${order.optionName}: ${order.optionNameValue}</td>
                    <td>${order.orderQuantity}</td>
                    <td>${order.price}원</td>
                </tr>
            </c:forEach>
        </table>

        <!-- 결제수단 -->
        <h3>결제수단</h3>
        <label><input type="radio" name="paymentMethod" value="kakaopay" checked> 카카오페이</label>
        <label><input type="radio" name="paymentMethod" value="bank"> 계좌이체</label>
        <label><input type="radio" name="paymentMethod" value="card"> 카드결제</label>

        <div id="bankInfo" style="display: none; margin-top: 5px;">
            <p>기업 계좌번호: <strong>기업은행 977-000803-01-011 (예금주: 노민혁)</strong></p>
        </div>

		<!-- 카드 결제 영역 -->
		<div id="cardInfo" style="display: none; margin-top: 10px;">
		    <c:choose>
		        <c:when test="${not empty cardList}">
		            <p><strong>등록된 카드 선택</strong></p>
						<c:forEach var="card" items="${cardList}">
						<label>
						    <input type="radio" name="cardNo" value="${card.paymentMethodNo}" 
						           <c:if test="${card.isDefault == 'Y'}">checked</c:if>>
						    ${card.financialInstitution} - ****-****-****-${fn:substring(card.accountNumber, card.accountNumber.length()-4, card.accountNumber.length())}
						    (유효기간: ${card.cardExpiration})
						</label>
						<br>
						</c:forEach>
		            <br>
		            <button type="button" class="btn" onclick="document.getElementById('newCardForm').style.display='block'">+ 새 카드 등록</button>
		            <div id="newCardForm" style="display:none;">
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

        <!-- 결제 금액 & 적립금 -->
        <h3>결제 금액</h3>
        <p>
            상품 총 금액: <strong>
            <c:set var="total" value="0" />
            <c:forEach var="order" items="${orderList}">
                <c:set var="total" value="${total + (order.price * order.orderQuantity)}" />
            </c:forEach>
            ${total} 원
            </strong>
        </p>

        <p>사용 가능 적립금:
            <input type="text" id="availablePoints" value="${orderList[0].orderReward}" readonly> 원
        </p>
        <p>사용할 적립금:
            <input type="number" id="usePoints" name="usePoints" min="0" step="100"> 원
            <button type="button" class="btn" onclick="useAllPoints()">전액 사용</button>
        </p>

        <!-- 배송지 -->
        <h3>배송지</h3>
        <p>기본 배송지: <strong>${orderList[0].address} ${orderList[0].detailAddress}</strong></p>
        <button type="button" class="btn" onclick="alert('배송지 변경 창')">배송지 변경</button>
        <br><br>

        <!-- 배송 요청사항 -->
        <h3>배송 요청사항</h3>
        <textarea name="deliveryRequest" rows="3" cols="60" placeholder="예: 부재 시 경비실에 맡겨주세요.">${orderList[0].deliveryRequest}</textarea>
        <br><br>

        <!-- 최종 버튼 -->
        <input type="submit" class="btn" value="결제하기">
        <input type="reset" class="btn" value="취소">
    </form>
    <!-- form 끝 -->

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script type="text/javascript">
	function handlePayment() {
	    const method = document.querySelector("input[name='paymentMethod']:checked").value;

	    if (method === "card") {
	        const hasRegisteredCards = document.querySelectorAll("input[name='cardNo']").length > 0;
	        if (hasRegisteredCards) {
	            const selectedCard = document.querySelector("input[name='cardNo']:checked");
	            if (!selectedCard) {
	                alert("결제할 카드를 선택해주세요.");
	                return false;
	            }
	            alert("선택한 카드(" + selectedCard.value + ")로 결제를 진행합니다.");
	            // TODO: Ajax로 카드 결제 처리
	            return false;
	        } else {
	            document.getElementById("newCardForm").style.display = "block";
	            alert("등록된 카드가 없습니다. 새 카드를 등록해주세요.");
	            return false;
	        }
	    }

	    if (method === "kakaopay") {
	        let data = {
	            orderNo: "${orderList[0].orderNo}",
	            name: "${orderList[0].productName}",
	            totalPrice: ${orderList[0].price}
	        };

	        $.ajax({
	            type: "POST",
	            url: "/personal/payment/ready",
	            data: JSON.stringify(data),
	            contentType: "application/json",
	            success: function(response) {
	                if (response.next_redirect_pc_url) {
	                    const kakaoWin = window.open(
	                        response.next_redirect_pc_url, 
	                        "kakaoPayPopup", 
	                        "width=500,height=700,scrollbars=yes"
	                    );
	                    const timer = setInterval(function() {
	                        if (kakaoWin.closed) {
	                            clearInterval(timer);
	                            location.href = "/personal/orderList";
	                        }
	                    }, 1000);
	                } else {
	                    alert("카카오페이 결제 요청 실패");
	                }
	            },
	            error: function(xhr, status, error) {
	                console.error("카카오페이 요청 에러:", error);
	                alert("결제 중 오류 발생");
	            }
	        });
	        return false;
	    }

	    if (method === "bank") {
	        document.getElementById("paymentForm").action = "/payment/submit";
	        return true;
	    }
	}
	
	function addCard() {
	    const formData = {
	        userId: "${orderList[0].userId}",  // 세션 사용자 id도 가능
	        financialInstitution: document.querySelector("input[name='financialInstitution']").value,
	        accountNumber: document.querySelector("input[name='accountNumber']").value,
	        cardExpiration: document.querySelector("input[name='cardExpiration']").value,
	        cardCvc: document.querySelector("input[name='cardCvc']").value,
	        cardPassword: document.querySelector("input[name='cardPassword']").value,
	        isDefault: document.querySelector("input[name='isDefault']").checked ? "Y" : "N"
	    };

	    $.ajax({
	        type: "POST",
	        url: "/personal/payment/addCard",
	        data: JSON.stringify(formData),
	        contentType: "application/json",
	        success: function(response) {
	            alert("카드가 등록되었습니다.");
	            location.reload(); // 새로고침해서 cardList 다시 불러오기
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
