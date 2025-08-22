<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 상세 정보</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<h1>주문 상세 페이지</h1>

<table border="1" style="border-collapse:collapse; text-align:left; width:100%; margin-bottom:20px;">
    <tr><th colspan="2">받는 사람 정보</th></tr>
    <tr><td>받는 사람</td><td>${orderDetailList[0].name}</td></tr>
    <tr><td>연락처</td><td>${orderDetailList[0].phone}</td></tr>
    <tr><td>주소</td><td>${orderDetailList[0].address}</td></tr>
    <tr><td>상세주소</td><td>${orderDetailList[0].detailAddress}</td></tr>
    <tr><td>배송 요청사항</td><td>${orderDetailList[0].deliveryRequest}</td></tr>
    <tr><th colspan="2">결제 정보</th></tr>
    <tr><td>결제 수단</td><td>${orderDetailList[0].paymentType}</td></tr>
    <tr><td>결제 금액</td><td>${orderDetailList[0].totalPrice}원</td></tr>
</table>

<table border="1" style="border-collapse:collapse; text-align:center; width:100%;">
    <thead>
        <tr>
            <th>상품명</th>
            <th>옵션</th>
            <th>상세 옵션</th>
            <th>수량</th>
            <th>가격</th>
            <th>배송상태</th>
            <th>구매상태</th>
            <th>기능</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="order" items="${orderDetailList}" varStatus="status">
            <tr>
                <td>${order.productName}</td>
                <td>${order.optionName}</td>
                <td>${order.optionNameValue}</td>
                <td>${order.orderQuantity}</td>
                <td>${order.price}</td>
                <td>
                    <c:choose>
                        <c:when test="${order.deliveryStatus == 'DS008'}">교환완료</c:when>
                        <c:when test="${order.deliveryStatus == 'DS007'}">교환중</c:when>
                        <c:when test="${order.deliveryStatus == 'DS006'}">교환대기</c:when>
                        <c:when test="${order.deliveryStatus == 'DS005'}">반품완료</c:when>
                        <c:when test="${order.deliveryStatus == 'DS004'}">반품대기</c:when>
                        <c:when test="${order.deliveryStatus == 'DS003'}">배송완료</c:when>
                        <c:when test="${order.deliveryStatus == 'DS002'}">배송중</c:when>
                        <c:when test="${order.deliveryStatus == 'DS001'}">배송대기</c:when>
                    </c:choose>
                </td>
                <td>
                	<c:choose>
                		<c:when test="${order.orderStatus == 'OS001'}">결제대기</c:when>
                		<c:when test="${order.orderStatus == 'OS002'}">결제완료</c:when>
                		<c:when test="${order.orderStatus == 'OS003'}">구매확정</c:when>
                	</c:choose>
                </td>
                <td>
                    <button onclick="location.href='/personal/deliveryOne?subOrderNo=${order.subOrderNo}'">배송조회</button>
                    <button onclick="location.href='/personal/exchangeReturn?orderDetailNo=${order.orderNo}'">교환/반품</button>
                    <button onclick="toggleReviewForm(${status.index})">리뷰작성</button>
                    <button onclick="location.href='/public/QNAPage'">상품문의</button>
                    <button type="button" class="btn-confirm" onclick="confirmProduct('${order.orderNo}', '${order.subOrderNo}')">구매확정</button>
                    <span style="font-size:12px; color:gray;">(1% 적립 예정)</span>
                </td>
            </tr>

            <!-- 리뷰 작성 폼 -->
            <tr id="review-form-${status.index}" style="display:none;">
                <td colspan="8" style="text-align:left;">
                    <form method="post" action="/personal/addReview">
						<input type="hidden" name="orderNo" value="${order.orderNo}" />
						<input type="hidden" name="subOrderNo" value="${order.subOrderNo}" />
                        <label for="rating-${status.index}">별점 선택: </label>
                        <select name="grade" id="grade-${status.index}">
                            <option value="5.0">★★★★★ (5.0점)</option>
                            <option value="4.5">★★★★☆ (4.5점)</option>
                            <option value="4.0">★★★★ (4.0점)</option>
                            <option value="3.5">★★★☆ (3.5점)</option>
                            <option value="3.0">★★★ (3.0점)</option>
                            <option value="2.5">★★☆ (2.5점)</option>
                            <option value="2.0">★★ (2.0점)</option>
                            <option value="1.5">★☆ (1.5점)</option>
                            <option value="1.0">★ (1.0점)</option>
                            <option value="0.5">☆ (0.5점)</option>
                        </select><br/><br/>

                        <textarea name="review" rows="3" style="width:100%;" placeholder="리뷰를 입력하세요"></textarea><br/>
                        <button type="submit">등록하기</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
<script>
function toggleReviewForm(index) {
    const form = document.getElementById("review-form-" + index);
    form.style.display = (form.style.display === "none") ? "block" : "none";
}

function confirmProduct(orderNo, subOrderNo) {

	$.ajax({
		type: "POST"
		,url: "/personal/order/confirmProduct"
		,data: { orderNo: orderNo, subOrderNo: subOrderNo }
		,success: function(){
			alert("구매 확정이 되었습니다.")
			location.reload();
		},
		error: function(xhr){
			alert("구매확정 처리 중 오류가 발생했습니다.")
		}
	})
}
</script>

</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>