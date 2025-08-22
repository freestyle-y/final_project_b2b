<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>상품 상세</title>
<style>
    .product-section {
        border: 1px solid #ccc;
        padding: 20px;
        margin: 20px;
    }
    .product-section h3 {
        margin-top: 0;
    }
    .option-table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }
    .option-table th, .option-table td {
        border: 1px solid #ddd;
        padding: 8px;
        text-align: center;
    }
</style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>

<!-- ✅ 상품 기본 정보 표시 (수정 X) -->
<div class="product-section">
    <h3>상품 정보</h3>
    <p><strong>상품명:</strong> ${product.productName}</p>
</div>

<!-- ✅ 옵션 가격만 수정 -->
<div class="product-section">
    <h3>옵션 가격 수정</h3>
    <form action="/admin/updateProductPrices" method="post">
        <input type="hidden" name="productNo" value="${product.productNo}" />
        <table class="option-table">
            <thead>
                <tr>
                    <th>옵션명</th>
                    <th>가격</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="option" items="${optionList}">
                    <tr>
                        <td>
                            ${option.optionNameValue}
                            <input type="hidden" name="optionNo" value="${option.optionNo}" />
                        </td>
                        <td>
                            <input type="number" name="price" value="${option.price}" required />
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <button type="submit">가격 수정</button>
    </form>
</div>

<!-- ✅ 이미지 업로드 -->
<div class="product-section">
    <h3>상품 이미지 등록</h3>
    <form action="/admin/uploadProductImage" method="post" enctype="multipart/form-data">
        <input type="hidden" name="productNo" value="${product.productNo}" />
        <input type="file" name="imageFile" accept="image/*" required />
        <button type="submit">이미지 업로드</button>
    </form>
</div>

<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

</body>
</html>