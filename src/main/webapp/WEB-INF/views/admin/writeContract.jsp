<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<script src="https://cdn.jsdelivr.net/npm/signature_pad@4.1.7/dist/signature_pad.umd.min.js"></script>
<head>
  <meta charset="UTF-8">
  <title>계약서 작성 - 관리자</title>
  <style>
    /* 기본 스타일 */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }
    
    body {
      font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
      font-size: 14px;
      line-height: 1.6;
      color: #333;
      background: #fff;
      padding: 20px;
    }
    
    /* 계약서 컨테이너 */
    .contract-container {
      max-width: 800px;
      margin: 0 auto;
      background: #fff;
      border: 1px solid #ddd;
      padding: 40px;
      box-shadow: 0 2px 10px rgba(0,0,0,0.1);
    }
    
    /* 헤더 영역 */
    .contract-header {
      text-align: center;
      margin-bottom: 40px;
      border-bottom: 2px solid #333;
      padding-bottom: 20px;
    }
    
    .company-logo {
      display: flex;
      align-items: center;
      justify-content: center;
      margin-bottom: 20px;
    }
    
    .logo-box {
      width: 50px;
      height: 50px;
      border: 3px solid #333;
      border-radius: 8px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 24px;
      font-weight: bold;
      color: #333;
      margin-right: 15px;
    }
    
    .company-name {
      font-size: 28px;
      font-weight: bold;
      color: #333;
    }
    
    .contract-title {
      font-size: 32px;
      font-weight: bold;
      margin: 20px 0;
      color: #333;
    }
    
    /* 문서 정보 */
    .document-info {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      margin-bottom: 30px;
    }
    
    .info-left {
      flex: 1;
    }
    
    .info-right {
      text-align: right;
      min-width: 200px;
    }
    
    .info-item {
      margin-bottom: 8px;
      font-size: 14px;
      color: #666;
    }
    
    /* 서명 영역 */
    .signature-section {
      margin: 40px 0;
      padding: 20px;
      border: 1px solid #ddd;
      border-radius: 8px;
      background: #f9f9f9;
    }
    
    .signature-title {
      text-align: center;
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 20px;
      color: #333;
    }
    
    .signature-boxes {
      display: flex;
      gap: 20px;
      justify-content: center;
    }
    
    .signature-box {
      flex: 1;
      max-width: 250px;
      text-align: center;
    }
    
    .signature-label {
      font-size: 14px;
      font-weight: bold;
      margin-bottom: 10px;
      color: #333;
    }
    
    .signature-field {
      width: 100%;
      height: 60px;
      border: 2px dashed #999;
      border-radius: 6px;
      display: flex;
      align-items: center;
      justify-content: center;
      background: #fff;
      color: #999;
      font-size: 12px;
    }
    
    /* 테이블 스타일 */
    .contract-table {
      width: 100%;
      border-collapse: collapse;
      margin: 20px 0;
    }
    
    .contract-table th,
    .contract-table td {
      border: 1px solid #ddd;
      padding: 12px;
      text-align: center;
      vertical-align: middle;
    }
    
    .contract-table th {
      background: #f5f5f5;
      font-weight: bold;
      color: #333;
    }
    
    .contract-table td {
      background: #fff;
    }
    
    /* 섹션 제목 */
    .section-title {
      font-size: 18px;
      font-weight: bold;
      margin: 30px 0 15px 0;
      color: #333;
      border-left: 4px solid #333;
      padding-left: 15px;
    }
    
    /* 하단 문구 */
    .contract-footer {
      text-align: center;
      margin-top: 40px;
      padding-top: 20px;
      border-top: 1px solid #ddd;
      color: #666;
      font-size: 14px;
    }
    
    /* 계약 조건 조항 */
    .contract-terms {
      margin: 15px 0;
      page-break-inside: avoid;
      break-inside: avoid;
    }
    
    .term-item {
      margin-bottom: 8px;
      padding: 6px 10px;
      border: 1px solid #eee;
      border-radius: 4px;
      background: #fafafa;
      page-break-inside: avoid;
      break-inside: avoid;
    }
    
    .term-item h4 {
      color: #333;
      font-size: 13px;
      font-weight: bold;
      margin-bottom: 3px;
      border-bottom: 1px solid #007bff;
      padding-bottom: 2px;
    }
    
    .term-item p {
      color: #555;
      font-size: 12px;
      line-height: 1.2;
      margin: 0;
      text-align: justify;
    }
    
    /* 계약 당사자 섹션 */
    .contract-parties-section {
      page-break-inside: avoid;
      break-inside: avoid;
      margin: 20px 0;
      page-break-before: auto;
      page-break-after: auto;
    }
    
    .contract-parties-section .section-title {
      page-break-after: avoid;
      break-after: avoid;
      margin-bottom: 15px;
    }
    
    .contract-parties-section .contract-table {
      page-break-inside: avoid;
      break-inside: avoid;
      margin-bottom: 30px;
    }
    
    /* 계약 조건 조항 섹션 */
    .contract-terms-section {
      page-break-inside: avoid;
      break-inside: avoid;
      margin: 20px 0;
      page-break-before: auto;
      page-break-after: auto;
    }
    
    .contract-terms-section .section-title {
      page-break-after: avoid;
      break-after: avoid;
      margin-bottom: 15px;
    }
    
    .contract-terms-section .contract-terms {
      page-break-inside: avoid;
      break-inside: avoid;
      margin-bottom: 0;
    }
    
    /* 툴바 */
    .toolbar {
      position: sticky;
      top: 0;
      background: #fff;
      border-bottom: 1px solid #ddd;
      padding: 15px 0;
      margin-bottom: 20px;
      z-index: 1000;
      text-align: center;
    }
    
    .btn {
      display: inline-block;
      padding: 10px 20px;
      margin: 0 5px;
      border: 1px solid #ddd;
      border-radius: 5px;
      text-decoration: none;
      color: #333;
      background: #fff;
      cursor: pointer;
      transition: all 0.3s ease;
    }
    
    .btn:hover {
      background: #f5f5f5;
      border-color: #999;
    }
    
    .btn-primary {
      background: #007bff;
      color: #fff;
      border-color: #007bff;
    }
    
    .btn-primary:hover {
      background: #0056b3;
      border-color: #0056b3;
    }
    
    /* 인쇄 스타일 */
    @media print {
      body {
        padding: 0;
        background: #fff;
      }
      
      .no-print {
        display: none !important;
      }
      
      .contract-container {
        max-width: none;
        margin: 0;
        border: none;
        box-shadow: none;
        padding: 20px;
      }
      
      .toolbar {
        display: none !important;
      }
      
      .signature-boxes {
        display: flex !important;
        gap: 20px !important;
        justify-content: center !important;
      }
      
      .signature-box {
        flex: 1 !important;
        max-width: 250px !important;
      }
      
      .signature-field {
        border: 2px dashed #999 !important;
        height: 60px !important;
      }
      
      .contract-table th,
      .contract-table td {
        border: 1px solid #ddd !important;
        padding: 12px !important;
      }
      
      .contract-table th {
        background: #f5f5f5 !important;
      }
      
      .contract-table td {
        background: #fff !important;
      }
      
      .section-title {
        border-left: 4px solid #333 !important;
      }
      
      .contract-footer {
        border-top: 1px solid #ddd !important;
      }
      
      .contract-terms {
        margin: 15px 0 !important;
        page-break-inside: avoid !important;
        break-inside: avoid !important;
      }
      
      .term-item {
        margin-bottom: 8px !important;
        padding: 6px 10px !important;
        border: 1px solid #eee !important;
        border-radius: 4px !important;
        background: #fafafa !important;
        page-break-inside: avoid !important;
        break-inside: avoid !important;
      }
      
      .term-item h4 {
        color: #333 !important;
        font-size: 13px !important;
        font-weight: bold !important;
        margin-bottom: 3px !important;
        border-bottom: 1px solid #007bff !important;
        padding-bottom: 2px !important;
      }
      
      .term-item p {
        color: #555 !important;
        font-size: 12px !important;
        line-height: 1.2 !important;
        margin: 0 !important;
        text-align: justify !important;
      }
      
      .contract-parties-section {
         page-break-inside: avoid !important;
         break-inside: avoid !important;
         margin: 20px 0 !important;
         page-break-before: auto !important;
         page-break-after: auto !important;
       }
       
       .contract-terms-section {
         page-break-inside: avoid !important;
         break-inside: avoid !important;
         margin: 20px 0 !important;
         page-break-before: auto !important;
         page-break-after: auto !important;
       }
       
       .contract-terms-section .section-title {
         page-break-after: avoid !important;
         break-after: avoid !important;
         margin-bottom: 15px !important;
       }
       
       .contract-terms-section .contract-terms {
         page-break-inside: avoid !important;
         break-inside: avoid !important;
         margin-bottom: 0 !important;
       }
     }
  </style>
</head>
<body>

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

  <div class="no-print">
	<!-- 공통 사이드바 -->
	<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
  </div>
  
	<div class="toolbar no-print">
	  <button class="btn btn-primary" type="submit" form="contractForm">작성 완료</button>
	  <a class="btn" href="${pageContext.request.contextPath}/admin/contractList">목록</a>
	</div>
  
  <form id="contractForm" method="post" action="${pageContext.request.contextPath}/biz/contract/write">
    <c:if test="${not empty contractOne}">
      <c:set var="first" value="${contractOne[0]}" />
    </c:if>
    <div class="contract-container">
      <div class="contract-header">
        <div class="company-logo">
          <div class="logo-box">y</div>
          <div class="company-name">freeStyle</div>
        </div>
        <div class="contract-title">계약서 작성</div>
      </div>
      
      <div class="document-info">
        <div class="info-left">
          <div class="info-item">계약서 번호: 
            <input type="text" name="contractNo" value="${contractNo}" required 
            <c:if test="${not empty contractNo}">readonly</c:if> />
          </div>
          <div class="info-item">계약일자: <span id="today"></span></div>
        </div>
        <div class="info-right">
          <div class="info-item">발행일: <span id="today2"></span></div>
          <div class="info-item">문서번호: <input type="text" name="documentNo" required /></div>
        </div>
      </div>
      
		<div class="signature-section">
		  <div class="signature-title">서명</div>
		  <div class="signature-boxes">
		    <!-- 갑 서명 -->
		<div class="signature-box" id="sig-supplier">
		  <div class="signature-label">갑 (공급자) 서명</div>
		  <div class="signature-field" style="padding:0">
		<canvas style="width:100%; height:60px;"></canvas>
		</div>
		<div class="no-print" style="margin-top:8px">
		  <button type="button" class="btn" data-action="clear">지우기</button>
		</div>
		<!-- 제출용 hidden -->
		<input type="hidden" name="supplierSignature" />
		<!-- 인쇄 시 이미지로 교체 표시 (선택) -->
		<img alt="supplier signature" style="display:none; max-width:100%; height:60px;" />
		</div>
		
		<!-- 을 서명 -->
		<div class="signature-box" id="sig-buyer">
		  <div class="signature-label">을 (수요자) 서명</div>
		  <div class="signature-field" style="padding:0">
		<canvas style="width:100%; height:60px;"></canvas>
		</div>
		<div class="no-print" style="margin-top:8px">
		  <button type="button" class="btn" data-action="clear">지우기</button>
		</div>
		<!-- 제출용 hidden -->
		<input type="hidden" name="buyerSignature" />
		<!-- 인쇄 시 이미지로 교체 표시 (선택) -->
		<img alt="buyer signature" style="display:none; max-width:100%; height:60px;" />
		    </div>
		  </div>
		</div>


      <div class="section-title">계약 개요</div>
      <table class="contract-table">
        <thead>
          <tr>
            <th>계약금</th>
            <th>잔금</th>
            <th>계약 총액</th>
            <th>계약서 작성 일자</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td><input type="number" name="downPayment" value="${first.downPayment}" required /></td>
            <td><input type="number" name="finalPayment" value="${first.finalPayment}" required /></td>
            <td>
              <span id="totalAmountDisplay">
                <c:choose>
                  <c:when test="${not empty contractOne}">
                    ₩<fmt:formatNumber value="${first.downPayment + first.finalPayment}" type="number" groupingUsed="true" />
                  </c:when>
                  <c:otherwise>-</c:otherwise>
                </c:choose>
              </span>
              <input type="hidden" name="totalAmount" id="totalAmount" />
            </td>
            <td><input type="date" name="createDate" required /></td>
          </tr>
        </tbody>
      </table>
      
      <div class="section-title">품목 내역</div>
      <table class="contract-table">
        <thead>
          <tr>
            <th>상품명</th>
            <th>옵션</th>
            <th>수량</th>
          </tr>
        </thead>
        <tbody>
          <c:choose>
            <c:when test="${not empty contractOne}">
              <c:forEach var="item" items="${contractOne}">
                <tr>
                  <td style="text-align:left">${item.productName}
                    <input type="hidden" name="productName" value="${item.productName}" />
                  </td>
                  <td>${item.productOption}
                    <input type="hidden" name="productOption" value="${item.productOption}" />
                  </td>
                  <td>${item.productQuantity}
                    <input type="hidden" name="productQuantity" value="${item.productQuantity}" />
                  </td>
                </tr>
              </c:forEach>
            </c:when>
            <c:otherwise>
              <tr>
                <td><input type="text" name="productName" required /></td>
                <td><input type="text" name="productOption" /></td>
                <td><input type="number" name="productQuantity" required /></td>
              </tr>
            </c:otherwise>
          </c:choose>
        </tbody>
      </table>
      
      <div class="section-title">계약 당사자</div>
      <table class="contract-table">
        <thead>
          <tr>
            <th>구분</th>
            <th>회사명/성명</th>
            <th>대표자</th>
            <th>연락처</th>
            <th>주소</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>갑 (공급자)</td>
            <td>
              <span>freeStyle</span>
              <input type="hidden" name="supplierCompanyName" value="freeStyle" />
            </td>
            <td>
              <span>${not empty contractSupplier ? contractSupplier[0].name : ''}</span>
              <input type="hidden" name="supplierName" value="${not empty contractSupplier ? contractSupplier[0].name : ''}" />
            </td>
            <td>
              <span>${not empty contractSupplier ? contractSupplier[0].phone : ''}</span>
              <input type="hidden" name="supplierPhone" value="${not empty contractSupplier ? contractSupplier[0].phone : ''}" />
            </td>
            <td>
              <span>${not empty contractSupplier ? contractSupplier[0].address : ''} ${not empty contractSupplier ? contractSupplier[0].detailAddress : ''}</span>
              <input type="hidden" name="supplierAddress" value="${not empty contractSupplier ? contractSupplier[0].address : ''} ${not empty contractSupplier ? contractSupplier[0].detailAddress : ''}" />
            </td>
          </tr>
          <tr>
            <td>을 (수요자)</td>
            <td>
              <span>${not empty contractUser ? contractUser[0].companyName : ''}</span>
              <input type="hidden" name="userCompanyName" value="${not empty contractUser ? contractUser[0].companyName : ''}" />
            </td>
            <td>
              <span>${not empty contractUser ? contractUser[0].name : ''}</span>
              <input type="hidden" name="userName" value="${not empty contractUser ? contractUser[0].name : ''}" />
            </td>
            <td>
              <span>${not empty contractUser ? contractUser[0].phone : ''}</span>
              <input type="hidden" name="userPhone" value="${not empty contractUser ? contractUser[0].phone : ''}" />
            </td>
            <td>
              <span>${not empty contractUser ? contractUser[0].address : ''} ${not empty contractUser ? contractUser[0].detailAddress : ''}</span>
              <input type="hidden" name="userAddress" value="${not empty contractUser ? contractUser[0].address : ''} ${not empty contractUser ? contractUser[0].detailAddress : ''}" />
            </td>
          </tr>
        </tbody>
      </table>

      <div class="section-title">계약 조건</div>
      <table class="contract-table">
        <thead>
          <tr>
            <th>구분</th>
            <th>내용</th>
            <th>비고</th>
          </tr>
        </thead>
        <tbody>
          <tr>
            <td>계약 기간</td>
            <td><input type="text" name="term" value="계약 체결일로부터 1년" readonly/></td>
            <td><input type="text" name="termEtc" value="자동 갱신" readonly /></td>
          </tr>
          <tr>
            <td>납기</td>
            <td><input type="text" name="delivery" value="주문 후 15일 이내" readonly /></td>
            <td><input type="text" name="deliveryEtc" value="부득이 시 연기 가능" readonly /></td>
          </tr>
          <tr>
            <td>결제 조건</td>
            <td><input type="text" name="payment" value="계약금 30%, 납품 후 70%" readonly /></td>
            <td><input type="text" name="paymentEtc" value="계약서 명시" readonly /></td>
          </tr>
          <tr>
            <td>품질 보증</td>
            <td><input type="text" name="warranty" value="그런 거 없음" readonly /></td>
            <td><input type="text" name="warrantyEtc" value="하자 시 유감" readonly /></td>
          </tr>
        </tbody>
      </table>
      
      <div class="contract-footer">
        본 문서는 거래 조건 및 품목에 관한 계약 내용을 명시합니다.
      </div>
    </div>
  </form>

  <script>
    (function () {
      const d = new Date();
      const z = n => String(n).padStart(2, '0');
      const today = d.getFullYear() + '-' + z(d.getMonth() + 1) + '-' + z(d.getDate());
      document.getElementById('today').textContent = today;
      document.getElementById('today2').textContent = today;
      document.querySelector('input[name=createDate]').value = today;

      // 총액 실시간 업데이트
      const downEl = document.querySelector('input[name=downPayment]');
      const finalEl = document.querySelector('input[name=finalPayment]');
      const totalHidden = document.getElementById('totalAmount');
      const totalDisplay = document.getElementById('totalAmountDisplay');

      function formatCurrency(n) {
        if (isNaN(n)) return '-';
        return '₩' + n.toLocaleString();
      }

      function updateTotal() {
        const down = Number(downEl.value || 0);
        const fin = Number(finalEl.value || 0);
        const total = down + fin;
        totalHidden.value = total;
        totalDisplay.textContent = formatCurrency(total);
      }

      if (downEl && finalEl) {
        downEl.addEventListener('input', updateTotal);
        finalEl.addEventListener('input', updateTotal);
        updateTotal();
      }
    })();
    (function() {
    	  // 공통 유틸: 캔버스 리사이즈(레티나 대응)
    	  function fitCanvas(canvas) {
    	    const ratio = Math.max(window.devicePixelRatio || 1, 1);
    	    const rect = canvas.getBoundingClientRect();
    	    canvas.width  = Math.max(1, Math.round(rect.width  * ratio));
    	    canvas.height = Math.max(1, Math.round(rect.height * ratio));
    	    const ctx = canvas.getContext('2d');
    	    ctx.setTransform(ratio, 0, 0, ratio, 0, 0);
    	  }

    	  function makePad(rootId) {
    	    const root   = document.getElementById(rootId);
    	    const canvas = root.querySelector('canvas');
    	    const pad    = new SignaturePad(canvas, { backgroundColor: 'rgb(255,255,255)' });
    	    const btnClr = root.querySelector('[data-action="clear"]');
    	    const hidden = root.querySelector('input[type="hidden"]');
    	    const imgOut = root.querySelector('img');

    	    function resize() {
    	      // 리사이즈 시 기존 선 유지
    	      const data = pad.toData();
    	      fitCanvas(canvas);
    	      pad.clear();
    	      if (data && data.length) pad.fromData(data);
    	    }
    	    resize();
    	    window.addEventListener('resize', resize);

    	    btnClr.addEventListener('click', () => {
    	      pad.clear();
    	      if (hidden) hidden.value = '';
    	      if (imgOut) { imgOut.src = ''; imgOut.style.display = 'none'; }
    	    });

    	    // 제출 전 dataURL로 저장
    	    function persist() {
    	      if (!hidden) return;
    	      hidden.value = pad.isEmpty() ? '' : pad.toDataURL('image/png');
    	      if (imgOut) {
    	        if (hidden.value) { imgOut.src = hidden.value; imgOut.style.display = 'block'; }
    	        else { imgOut.src = ''; imgOut.style.display = 'none'; }
    	      }
    	    }

    	    // 인쇄 전/후 캔버스 대신 이미지로 표시(선택)
    	    function beforePrint() {
    	      persist();               // 최신 값 저장
    	      if (imgOut && hidden.value) {
    	        imgOut.src = hidden.value;
    	        imgOut.style.display = 'block';
    	      }
    	    }
    	    function afterPrint() {
    	      // 인쇄 후 캔버스 계속 보이게 유지 (이미지는 둬도 무방)
    	    }
    	    window.addEventListener('beforeprint', beforePrint);
    	    window.addEventListener('afterprint',  afterPrint);

    	    return { pad, persist };
    	  }

    	  const supplier = makePad('sig-supplier');
    	  const buyer    = makePad('sig-buyer');

    	  // 폼 제출 시 두 서명 확정 저장
    	  const form = document.getElementById('contractForm');
    	  form.addEventListener('submit', function() {
    	    supplier.persist();
    	    buyer.persist();
    	    // 서명 필수라면 아래 검증 추가
    	    // if (!form.supplierSignature.value || !form.buyerSignature.value) {
    	    //   alert('서명이 필요합니다.');
    	    //   event.preventDefault();
    	    // }
    	  });
    	})();
  </script>

  <div class="no-print">
    <!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>
  </div>
</body>
</html>
