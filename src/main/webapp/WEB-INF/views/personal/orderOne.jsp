<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>주문 상세 정보</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<style>
/* ===== 테이블 톤(잔금 확인 페이지 느낌) ===== */
:root{
  /* 테이블 팔레트 */
  --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0;
  /* 포인트/텍스트 */
  --brand-500:#6366f1; --brand-600:#4f46e5;
  --ink-900:#0f172a; --ink-700:#334155; --ink-500:#64748b; --ink-300:#cbd5e1;
  --bg-50:#f8fafc; --bg-100:#f1f5f9;
  /* 라운드/그림자 */
  --radius-xl:16px; --radius-lg:12px; --radius-md:10px;
  --shadow-sm:0 1px 2px rgba(0,0,0,.06); --shadow-md:0 6px 18px rgba(15,23,42,.08);
}

body{
  font-family: "SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif;
}
.main{ background:#fff; padding:24px; }
.main > h1{ font-size:26px; font-weight:700; color:var(--ink-900); margin:0 0 18px; letter-spacing:-.2px; }

/* ===== 공통 테이블(카드형) ===== */
.main table{
  width:100%;
  background:#fff;
  border:1px solid var(--tbl-border) !important;
  border-radius:10px;
  border-collapse:separate !important; border-spacing:0 !important;
  box-shadow:var(--shadow-md);
  overflow:hidden;
  margin-bottom:20px !important;
  font-size:.95rem;
}

/* 헤더 */
.main table thead th,
.main table tr th[colspan]{
  background:var(--tbl-head) !important;
  color:#111827; font-weight:700;
  border-bottom:1px solid var(--tbl-border) !important;
  padding:.55rem .75rem; white-space:nowrap; text-align:center;
  vertical-align:middle;
}

/* 바디 셀 */
.main table tbody td{
  border-top:1px solid var(--tbl-border) !important;
  color:#111827; vertical-align:middle;
  padding:.55rem .75rem; text-align:left;
  white-space:normal; word-break:keep-all; overflow-wrap:anywhere;
}

/* 지브라/호버 */
.main table tbody tr:nth-child(even){ background:var(--tbl-zebra); }
.main table tbody tr:hover{ background:var(--tbl-hover); }

/* 첫 번째(요약) 테이블: 좌측 라벨 폭 */
.main > table:first-of-type td:first-child{
  width: 180px; color: var(--ink-500); white-space:nowrap;
}

/* 두 번째(상세) 테이블: 수량/가격 정렬 */
.main table + table td:nth-child(4){ text-align:center; }
.main table + table td:nth-child(5){ text-align:right; white-space:nowrap; }

/* 금액 강조 유틸(필요 시 td에 class="amount" 주면 더 굵게) */
.main table td.amount{ font-weight:700; color:var(--ink-900); }

/* 상태/구매상태 칼럼 시인성(6,7번째) – HTML 변경 없이 도트+굵기 */
.main table + table td:nth-child(6),
.main table + table td:nth-child(7){
  font-weight:600; color:var(--ink-900); position:relative; padding-left:16px;
}
.main table + table td:nth-child(6)::before,
.main table + table td:nth-child(7)::before{
  content:""; position:absolute; left:6px; top:50%;
  width:6px; height:6px; border-radius:50%; transform:translateY(-50%); background:#9ca3af;
}

/* 리뷰 폼(토글 tr) */
.main table tr[id^="review-form-"]{ background:var(--bg-100); }
.main table tr[id^="review-form-"] td{ padding:18px 16px; border-top:1px solid var(--tbl-border) !important; }
.main table tr[id^="review-form-"] form{
  background:#fff; border:1px solid var(--tbl-border);
  border-left:4px solid var(--brand-500);
  border-radius:var(--radius-lg); padding:14px; box-shadow:var(--shadow-sm);
}
.main table tr[id^="review-form-"] textarea,
.main table tr[id^="review-form-"] select{
  border:1px solid var(--ink-300); border-radius:var(--radius-md);
  padding:8px 10px; width:100%; outline:none;
}
.main table tr[id^="review-form-"] textarea:focus,
.main table tr[id^="review-form-"] select:focus{
  border-color:var(--brand-500);
  box-shadow:0 0 0 3px color-mix(in srgb, var(--brand-500) 20%, transparent);
}

/* 버튼 톤 (기본/비활성/호버) */
.main table button{
  appearance:none; border:1px solid var(--ink-300);
  background:#fff; color:#111827;
  padding:8px 12px; border-radius:10px;
  cursor:pointer; transition:all .16s ease; box-shadow:var(--shadow-sm);
  margin:2px 0;
}
.main table button:hover{ transform:translateY(-1px); box-shadow:var(--shadow-md); }
.main table button:active{ transform:translateY(0); box-shadow:var(--shadow-sm); }
.main table button[disabled],
.main table button[disabled]:hover{ opacity:.55; cursor:not-allowed; transform:none; box-shadow:var(--shadow-sm); }

/* 주요 액션: 구매확정 */
.main table .btn-confirm{
  background:linear-gradient(180deg, var(--brand-500), var(--brand-600));
  border-color:var(--brand-600); color:#fff;
}
.main table .btn-confirm:hover{ filter:brightness(1.02); }

/* 작은 화면: 가로 스크롤 허용 */
@media (max-width: 992px){
  .main{ padding:16px; }
  .main > h1{ font-size:22px; }
  .main table{ display:block; overflow-x:auto; -webkit-overflow-scrolling:touch; }
  .main > table:first-of-type td:first-child{ width:140px; }
}
</style>


<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<main class="main">

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
    <tr><td>적립금 사용 내역</td><td>${usedPoint}원</td></tr>
    <tr><td>결제 금액</td><td>${orderDetailList[0].totalPrice-usedPoint}원</td></tr>
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
                    <button onclick="location.href='/personal/deliveryOne?orderNo=${order.orderNo}&subOrderNo=${order.subOrderNo}'">배송조회</button>
						<c:choose>
							<c:when test="${order.deliveryStatus eq 'DS003' && order.orderStatus ne 'OS003'}">
								<!-- 배송완료이고 구매확정이 아닐 때만 활성 -->
								<button onclick="location.href='/personal/exchangeReturn?orderNo=${order.orderNo}&subOrderNo=${order.subOrderNo}&orderQuantity=${order.orderQuantity}'">교환/반품</button>
							</c:when>
							<c:otherwise>
								<button disabled>교환/반품</button>
							</c:otherwise>
						</c:choose>
					  <c:choose>
						<c:when test="${order.orderStatus == 'OS003'}">
							<button onclick="toggleReviewForm(${status.index})">리뷰작성</button>
						</c:when>
						<c:otherwise>
							<button disabled title="구매확정 후 작성 가능합니다.">리뷰작성</button>
						</c:otherwise>
					  </c:choose>

							<button onclick="location.href='/member/QNAWrite'">상품문의</button>
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

</main>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

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
</html>