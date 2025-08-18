<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>배송지 관리</title>
<style>
    table { border-collapse: collapse; width: 100%; }
    table, td, th { border: 1px solid #ddd; padding: 8px; text-align: center; }
    th { background: #f2f2f2; }
    .btn { padding: 5px 10px; margin: 3px; border: 1px solid #444; cursor: pointer; }
    .form-row { margin-bottom: 8px; }
</style>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
function selectAddress(addressId, address, detail) {
    opener.document.querySelector("strong#selectedAddress").innerText = address + " " + detail;
    opener.document.getElementById("selectedAddressId").value = addressId;
    window.close();
}

function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {
            document.getElementById("postal").value = data.zonecode; // 우편번호
            document.getElementById("address").value = data.roadAddress || data.jibunAddress; // 기본 주소
            document.getElementById("detailAddress").focus(); // 상세주소로 포커스
        }
    }).open();
}

function addAddress() {
	console.log("postal 값:", document.getElementById("postal").value);
    const data = {
        userId: "${sessionScope.userId}", 
        address: document.getElementById("address").value,
        detailAddress: document.getElementById("detailAddress").value,
        postal: document.getElementById("postal").value,
        nickname: document.getElementById("nickname").value,
        ownerType: document.getElementById("newOwnerType").value,   // 수정
        mainAddress: document.getElementById("newMainAddress").value, // 수정
        useStatus: "Y"
    };

    console.log("등록 데이터:", data); // 🔎 값 확인용

    fetch("/personal/address/add", {
        method: "POST",
        headers: {"Content-Type": "application/json"},
        body: JSON.stringify(data)
    })
    .then(res => res.json())
    .then(result => {
        if (result.status === "success") {
            alert("새 배송지가 등록되었습니다.");
            location.reload();
        } else {
            alert("등록 실패: " + (result.message || ""));
        }
    })
    .catch(err => alert("배송지 등록 실패: " + err));
}

</script>
</head>
<body>
<h2>내 배송지 목록</h2>
<table>
    <tr>
        <th>주소</th>
        <th>상세</th>
        <th>우편번호</th>
        <th>별칭</th>
        <th>받는 분</th>
        <th>기본배송지</th>
        <th>선택</th>
    </tr>
    <c:forEach var="address" items="${addressList}">
        <tr>
            <td>${address.address}</td>
            <td>${address.detailAddress}</td>
            <td>${address.postal}</td>
            <td>${address.nickname}</td>
            <td>${address.managerName}</td>
            <td>
                <c:choose>
                    <c:when test="${address.mainAddress eq 'Y'}">✔</c:when>
                    <c:otherwise>-</c:otherwise>
                </c:choose>
            </td>
            <td>
                <button class="btn" onclick="selectAddress('${address.addressNo}','${address.address}','${address.detailAddress}')">선택</button>
            </td>
        </tr>
    </c:forEach>
</table>

<h3>새 배송지 추가</h3>
<div class="form-row">
    우편번호: 
    <input type="text" id="postal" name="postal" readonly>
    <button type="button" class="btn" onclick="execDaumPostcode()">주소 검색</button>
</div>
<div class="form-row">주소: <input type="text" id="address" name="address" readonly></div>
<div class="form-row">상세: <input type="text" id="detailAddress" name="detailAddress"></div>
<div class="form-row">별칭: <input type="text" id="nickname" name="nickname"></div>
<div class="form-row">소유자 유형:
    <select id="newOwnerType" name="ownerType">
        <option value="USER">개인</option>
        <option value="COMPANY">기업</option>
    </select>
</div>
<div class="form-row">기본배송지 여부:
    <select id="newMainAddress" name="mainAddress">
        <option value="N">아니오</option>
        <option value="Y">예</option>
    </select>
</div>
<button class="btn" onclick="addAddress()">등록</button>
</body>
</html>
