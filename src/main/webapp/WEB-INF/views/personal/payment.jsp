<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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
                if (this.value === "bank") {
                    bankInfo.style.display = "block";
                } else {
                    bankInfo.style.display = "none";
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
        <label>
            <input type="radio" name="paymentMethod" value="kakaopay" checked> 카카오페이
        </label>
        <label>
            <input type="radio" name="paymentMethod" value="bank"> 계좌이체
        </label>
        <div id="bankInfo" style="display: none; margin-top: 5px;">
            <p>기업 계좌번호: <strong>기업은행 977-000803-01-011 (예금주: 노민혁)</strong></p>
        </div>
        <br>

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

        <p>
            사용 가능 적립금:
            <input type="text" id="availablePoints" value="${orderList[0].orderReward}" readonly> 원
        </p>
        <p>
            사용할 적립금:
            <input type="number" id="usePoints" name="usePoints" min="0" step="100"> 원
            <button type="button" class="btn" onclick="useAllPoints()">전액 사용</button>
        </p>

        <p class="note">
            ※ 적립금 사용 기준 <br>
            1. 적립금은 최소 1,000원 이상 사용 가능하다. <br>
            2. 단위는 100원 단위로 가능하다. <br>
            3. 물품 가격이 최소 10,000원 이상부터 적립금을 사용 가능하다. <br>
            4. 적립금은 구매 금액의 10%를 넘을 수 없다. <br>
            5. 적립금은 적립된 후 90일이 지나면 소멸된다. <br>
            6. 적립금은 남은 기간이 짧은 적립금부터 사용된다. <br>
        </p>

        <!-- 배송지 -->
        <h3>배송지</h3>
        <p>
            기본 배송지: <strong>${orderList[0].address} ${orderList[0].detailAddress}</strong>
        </p>
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

    if (method === "kakaopay") {
        // 카카오페이 Ajax 요청
        let data = {
            orderNo: "${orderList[0].orderNo}",    // 주문번호
            name: "${orderList[0].productName}",   // 상품명
            totalPrice: ${orderList[0].price}      // 총 결제금액
        };

        $.ajax({
            type: "POST",
            url: "/personal/payment/ready",
            data: JSON.stringify(data),
            contentType: "application/json",
            success: function(response) {
                if (response.next_redirect_pc_url) {
                	window.open(response.next_redirect_pc_url, "kakaoPayPopup", "width=500,height=700,scrollbars=yes");
                } else {
                    alert("카카오페이 결제 요청 실패");
                    console.log(response);
                }
            },
            error: function(xhr, status, error) {
                console.error("카카오페이 요청 에러:", error);
                alert("결제 중 오류 발생");
            }
        });
        return false; // 기본 form submit 막기
    } else {
        // 계좌이체 선택 시 일반 submit
        document.getElementById("paymentForm").action = "/payment/submit";
        return true;
    }
}
</script>

</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>
