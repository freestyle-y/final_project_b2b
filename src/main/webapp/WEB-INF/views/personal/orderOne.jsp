<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 상세 정보</title>
<script>
function toggleReviewForm(index) {
    const form = document.getElementById("review-form-" + index);
    form.style.display = (form.style.display === "none") ? "block" : "none";
}
</script>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

<h1>주문 상세 페이지</h1>

<!-- 받는 사람 & 결제 정보 -->
<table border="1" style="border-collapse:collapse; text-align:left; width:100%; margin-bottom:20px;">
    <tr>
    	<th colspan="2">받는 사람 정보</th>
    </tr>
    <tr>
    	<td>받는 사람</td><td>${orderDetailList[0].name}</td>
    </tr>
    <tr>
    	<td>연락처</td><td>${orderDetailList[0].phone}</td>
    </tr>
    <tr>
    	<td>주소</td><td>${orderDetailList[0].address}</td>
    </tr>
    <tr>
    	<td>상세주소</td><td>${orderDetailList[0].detailAddress}</td>
    </tr>
    <tr>
    	<td>배송 요청사항</td><td>${orderDetailList[0].deliveryRequest}</td>
    </tr>
    <tr>
    	<th colspan="2">결제 정보</th>
    </tr>
    <tr>
    	<td>결제 수단</td><td>${orderDetailList[0].paymentType}</td>
    </tr>
    <tr>
    	<td>결제 금액</td><td>${orderDetailList[0].totalPrice}원</td>
    </tr>
</table>

<!-- 주문 상품 목록 -->
<table border="1" style="border-collapse:collapse; text-align:center; width:100%;">
    <thead>
        <tr>
            <th>상품명</th>
            <th>옵션</th>
            <th>상세 옵션</th>
            <th>수량</th>
            <th>가격</th>
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
                    <button onclick="location.href='/personal/deliveryOne?subOrderNo=${order.subOrderNo}'">배송조회</button>
                    <button onclick="location.href='/personal/exchangeReturn?orderDetailNo=${order.orderNo}'">교환/반품</button>
                    <button onclick="toggleReviewForm(${status.index})">리뷰작성</button>
                    <button onclick="location.href='/personal/confirm?orderDetailNo=${order.orderNo}'">구매확정</button>
                    <button onclick="location.href='/public/QNAPage'">상품문의</button>
                </td>
            </tr>
            <!-- 리뷰 작성 폼 -->
            <tr id="review-form-${status.index}" style="display:none;">
                <td colspan="6" style="text-align:left;">
                    <form method="post" action="/personal/review/add">
                        <input type="hidden" name="orderDetailNo" value="${order.orderNo}" />
                        <label>별점:
                            <select name="rating">
                                <c:forEach begin="1" end="5" var="i">
                                    <option value="${i}">${i}점</option>
                                </c:forEach>
                            </select>
                        </label><br/>
                        <textarea name="content" rows="3" style="width:100%;" placeholder="리뷰를 입력하세요"></textarea><br/>
                        <button type="submit">등록하기</button>
                    </form>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>

</body>
<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</html>
