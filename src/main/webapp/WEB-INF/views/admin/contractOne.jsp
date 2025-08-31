<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<%@ include file="/WEB-INF/common/head.jsp"%>
<title>계약서 상세 - 관리자</title>
<style>
/* 기본 스타일 */
* { margin: 0; padding: 0; box-sizing: border-box; }
body {
  font-family: "Malgun Gothic", "Apple SD Gothic Neo", sans-serif;
  font-size: 14px; line-height: 1.6; color: #333; background: #fff; padding: 20px;
}

/* 계약서 컨테이너 */
.contract-container {
  max-width: 800px; margin: 0 auto; background: #fff; border: 1px solid #ddd;
  padding: 40px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);
}

/* 헤더 영역 */
.contract-header { text-align: center; margin-bottom: 40px; border-bottom: 2px solid #333; padding-bottom: 20px; }
.company-logo { display: flex; align-items: center; justify-content: center; margin-bottom: 20px; }
.logo-box {
  width: 50px; height: 50px; border: 3px solid #333; border-radius: 8px;
  display: flex; align-items: center; justify-content: center; font-size: 24px; font-weight: bold; color: #333; margin-right: 15px;
}
.company-name { font-size: 28px; font-weight: bold; color: #333; }
.contract-title { font-size: 32px; font-weight: bold; margin: 20px 0; color: #333; }

/* 문서 정보 */
.document-info { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px; }
.info-left { flex: 1; }
.info-right { text-align: right; min-width: 200px; }
.info-item { margin-bottom: 8px; font-size: 14px; color: #666; }

/* 서명 영역 */
.signature-section { margin: 40px 0; padding: 20px; border: 1px solid #ddd; border-radius: 8px; background: #f9f9f9; }
.signature-title { text-align: center; font-size: 18px; font-weight: bold; margin-bottom: 20px; color: #333; }
.signature-boxes { display: flex; gap: 20px; justify-content: center; }
.signature-box { flex: 1; max-width: 250px; text-align: center; }
.signature-label { font-size: 14px; font-weight: bold; margin-bottom: 10px; color: #333; }
.signature-field {
  width: 100%; height: 60px; border: 2px dashed #999; border-radius: 6px; display: flex; align-items: center; justify-content: center;
  background: #fff; color: #999; font-size: 12px; padding: 6px; overflow: hidden; box-sizing: border-box;
}
.signature-field img { display: block; width: 100%; height: 100%; object-fit: contain; }

/* 테이블 스타일 */
.contract-table { width: 100%; border-collapse: collapse; margin: 20px 0; }
.contract-table th, .contract-table td { border: 1px solid #ddd; padding: 12px; text-align: center; vertical-align: middle; }
.contract-table th { background: #f5f5f5; font-weight: bold; color: #333; }
.contract-table td { background: #fff; }

/* 섹션 제목 */
.section-title {
  font-size: 18px; font-weight: bold; margin: 30px 0 15px 0; color: #333; border-left: 4px solid #333; padding-left: 15px;
}

/* 하단 문구 */
.contract-footer { text-align: center; margin-top: 40px; padding-top: 20px; border-top: 1px solid #ddd; color: #666; font-size: 14px; }

/* 툴바 */
.toolbar {
  position: sticky; top: 0; background: #fff; border-bottom: 1px solid #ddd; padding: 15px 0; margin-bottom: 20px; z-index: 1000; text-align: center;
}
.btn {
  display: inline-block; padding: 10px 20px; margin: 0 5px; border: 1px solid #ddd; border-radius: 5px; text-decoration: none;
  color: #333; background: #fff; cursor: pointer; transition: all 0.3s ease;
}
.btn:hover { background: #f5f5f5; border-color: #999; }
.btn-primary { background: #007bff; color: #fff; border-color: #007bff; }
.btn-primary:hover { background: #0056b3; border-color: #0056b3; }

/* ===== [수정] 업로드 줄에만 relative 부여해 절대배치 기준 제공 ===== */
.toolbar-upload { position: relative; } /* [수정] */

/* ===== [수정] 첨부파일 트리거: 오른쪽 끝 고정(버튼들은 가운데 유지) ===== */
.attachment-trigger {
  border:none; background:none; cursor:pointer; color:#374151; font-weight:600;
  margin-left:6px; vertical-align:middle;
  /* 아래 4줄이 핵심 */
  position:absolute; right:0; top:50%; transform:translateY(-50%); /* [수정] */
}
.attachment-trigger:hover { text-decoration:underline; color:#111827; }

/* 드롭다운 */
#attachmentDropdown {
  display: none;
  max-width: 1000px;
  margin: 10px auto 0;
  background: #fff;
  border: 1px solid #e5e7eb;
  border-radius: 8px;
  box-shadow: 0 6px 20px rgba(0,0,0,.08);
  padding: 12px;
}
#attachmentDropdown.open { display: block; }
#attachmentDropdown table { width: 100%; border-collapse: collapse; font-size: 13px; }
#attachmentDropdown th, #attachmentDropdown td { border: 1px solid #e5e7eb; padding: 8px; text-align: center; }
#attachmentDropdown th { background: #f9fafb; font-weight: 700; }

/* 인쇄 시 숨김 */
@media print {
  .no-print { display: none !important; }
  #attachmentDropdown, .attachment-trigger { display: none !important; }
  body { padding: 0; background: #fff; }
  .contract-container { max-width: none; margin: 0; border: none; box-shadow: none; padding: 20px; }
  .toolbar { display: none !important; }
}
</style>
</head>
<body>
<div class="no-print">
  <!-- 공통 헤더 -->
  <%@include file="/WEB-INF/common/header/header.jsp"%>
</div>

<div class="toolbar no-print">
  <button class="btn btn-primary" onclick="window.print()">PDF/인쇄</button>
  <a class="btn" href="${pageContext.request.contextPath}/admin/contractList">목록</a>
</div>

<form action="${pageContext.request.contextPath}/admin/attachmentUpload" method="post" enctype="multipart/form-data" onsubmit="return uploadFiles(this)">
  <!-- [수정] 이 줄만 클래스 추가 -->
  <div class="toolbar no-print toolbar-upload"> <!-- [수정] -->
    <c:if test="${not empty contractOne}">
      <input type="file" name="files" multiple>
      <input type="hidden" name="attachmentCode" value="CONTRACT">
      <input type="hidden" name="contractNo" value="${contractOne[0].contractNo}">
      <button class="btn btn-primary" type="submit">업로드</button>

      <!-- 📎 첨부파일 토글 트리거 -->
      <button type="button" id="attachmentTrigger" class="attachment-trigger" aria-expanded="false" title="첨부파일 보기/숨기기">
        첨부파일
      </button>
    </c:if>
  </div>
</form>

<!-- ▼ 드롭다운 영역 -->
<div id="attachmentDropdown" class="no-print" aria-hidden="true">
  <div id="attachmentList" data-contract-no="${contractOne[0].contractNo}">
    <!-- 첨부파일 목록이 동적으로 로드됩니다 -->
  </div>
</div>

<div class="contract-container">
  <div class="contract-header">
    <div class="company-logo">
      <div class="logo-box">y</div>
      <div class="company-name">freeStyle</div>
    </div>
    <div class="contract-title">계약서</div>
  </div>

  <div class="document-info">
    <div class="info-left">
      <div class="info-item">계약서 번호:
        <c:if test="${not empty contractOne}">${contractOne[0].contractNo}</c:if>
      </div>
      <div class="info-item">계약일자:
        <c:choose>
          <c:when test="${not empty contractOne[0].formattedQuotationCreateDate}">
            ${contractOne[0].formattedQuotationCreateDate}
          </c:when>
        </c:choose>
      </div>
    </div>
    <div class="info-right">
      <div class="info-item">발행일:
        <c:choose>
          <c:when test="${not empty contractOne[0].formattedCreateDate}">
            ${contractOne[0].formattedCreateDate}
          </c:when>
        </c:choose>
      </div>
    </div>
  </div>

  <div class="signature-section">
    <div class="signature-title">서명</div>
    <div class="signature-boxes">
      <!-- 갑 서명 -->
      <div class="signature-box">
        <div class="signature-label">갑 (공급자) 서명</div>
        <div class="signature-field">
          <c:choose>
            <c:when test="${not empty supplierSign}">
              <img src="${supplierSign.filepath}/${supplierSign.filename}" alt="supplier signature" />
            </c:when>
            <c:otherwise>서명 없음</c:otherwise>
          </c:choose>
        </div>
      </div>
      <!-- 을 서명 -->
      <div class="signature-box">
        <div class="signature-label">을 (수요자) 서명</div>
        <div class="signature-field">
          <c:choose>
            <c:when test="${not empty buyerSign}">
              <img src="${buyerSign.filepath}/${buyerSign.filename}" alt="buyer signature" style="max-width: 100%; max-height: 60px; object-fit: contain;" />
            </c:when>
            <c:otherwise>서명 없음</c:otherwise>
          </c:choose>
        </div>
      </div>
    </div>
  </div>

  <c:if test="${not empty contractOne}">
    <c:set var="first" value="${contractOne[0]}" />
    <div class="section-title">계약 개요</div>
    <table class="contract-table">
      <thead>
        <tr>
          <th>문서번호</th><th>계약금</th><th>잔금</th><th>계약 총액</th><th>계약서 작성 일자</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>
            <c:choose>
              <c:when test="${not empty contractOne and not empty contractOne[0].contractNo}">${contractOne[0].contractNo}</c:when>
              <c:otherwise>미발급</c:otherwise>
            </c:choose>
          </td>
          <td>₩<fmt:formatNumber value="${first.downPayment}" type="number" groupingUsed="true" /></td>
          <td>₩<fmt:formatNumber value="${first.finalPayment}" type="number" groupingUsed="true" /></td>
          <td>₩<fmt:formatNumber value="${first.downPayment + first.finalPayment}" type="number" groupingUsed="true" /></td>
          <td>${first.formattedCreateDate}</td>
        </tr>
      </tbody>
    </table>

    <div class="section-title">품목 내역</div>
    <table class="contract-table">
      <thead><tr><th>상품명</th><th>옵션</th><th>수량</th></tr></thead>
      <tbody>
        <c:forEach var="con" items="${contractOne}">
          <tr>
            <td style="text-align: left">${con.productName}</td>
            <td>${con.productOption}</td>
            <td>${con.productQuantity}</td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </c:if>

  <div class="contract-parties-section">
    <div class="section-title">계약 당사자</div>
    <table class="contract-table">
      <thead><tr><th>구분</th><th>회사명/성명</th><th>대표자</th><th>연락처</th><th>주소</th></tr></thead>
      <tbody>
        <tr>
          <td>갑 (공급자)</td>
          <td>freeStyle</td>
          <td>${contractSupplier[0].name}</td>
          <td>${contractSupplier[0].phone}</td>
          <td>${contractSupplier[0].address} ${contractSupplier[0].detailAddress}</td>
        </tr>
        <c:if test="${not empty contractUser}">
          <tr>
            <td>을 (수요자)</td>
            <td>${contractUser[0].companyName}</td>
            <td>${contractUser[0].name}</td>
            <td>${contractUser[0].phone}</td>
            <td>${contractUser[0].address} ${contractUser[0].detailAddress}</td>
          </tr>
        </c:if>
      </tbody>
    </table>

    <div class="section-title">계약 조건</div>
    <table class="contract-table">
      <thead><tr><th>구분</th><th>내용</th><th>비고</th></tr></thead>
      <tbody>
        <tr><td>계약 기간</td><td>계약 체결일로부터 1년</td><td>자동 갱신</td></tr>
        <tr><td>납기</td><td>주문 후 15일 이내</td><td>부득이 시 연기 가능</td></tr>
        <tr><td>결제 조건</td><td>계약금 30%, 납품 후 70%</td><td>계약서 명시</td></tr>
        <tr><td>품질 보증</td><td>그런 거 없음</td><td>하자 시 유감</td></tr>
      </tbody>
    </table>
  </div>

  <div class="contract-terms-section">
    <div class="section-title">계약 조건 조항</div>
    <div class="contract-terms">
      <div class="term-item"><h4>제1조 (계약의 목적)</h4><p>본 계약은 갑(공급자)과 을(수요자) 간에 상품의 공급 및 판매에 관한 권리와 의무를 정함을 목적으로 한다.</p></div>
      <div class="term-item"><h4>제2조 (계약 기간)</h4><p>본 계약의 유효기간은 계약 체결일로부터 1년간으로 하며, 계약 기간 만료 1개월 전까지 서면으로 통지한 경우에 한하여 갱신할 수 있다.</p></div>
      <div class="term-item"><h4>제3조 (상품의 품질 및 규격)</h4><p>갑은 계약서에 명시된 상품의 품질 및 규격에 맞는 상품을 공급할 의무가 있으며, 을은 계약서에 명시된 조건에 따라 상품을 검수할 권리를 가진다.</p></div>
      <div class="term-item"><h4>제4조 (납기 및 납품)</h4><p>갑은 계약서에 정한 납기 내에 상품을 납품하여야 하며, 부득이한 사유로 납기를 연기할 경우 사전에 을에게 통지하고 동의를 받아야 한다.</p></div>
      <div class="term-item"><h4>제5조 (대금 지급)</h4><p>을은 계약서에 정한 조건에 따라 대금을 지급하여야 하며, 지급 지연 시 연체 이자를 부담한다.</p></div>
      <div class="term-item"><h4>제6조 (하자 보수)</h4><p>상품에 하자가 발견된 경우, 을은 수령 후 30일 이내에 갑에게 통지하여야 하며, 갑은 즉시 하자 보수 또는 교환을 실시하여야 한다.</p></div>
      <div class="term-item"><h4>제7조 (계약 위반)</h4><p>당사자 일방이 본 계약을 위반한 경우, 상대방은 서면으로 시정을 요구할 수 있으며, 30일 이내에 시정되지 않을 경우 계약을 해지할 수 있다.</p></div>
      <div class="term-item"><h4>제8조 (분쟁 해결)</h4><p>본 계약과 관련하여 분쟁이 발생할 경우, 당사자 간의 협의로 해결하고, 협의가 이루어지지 않을 경우 갑의 주소지 관할 법원에 소를 제기한다.</p></div>
      <div class="term-item"><h4>제9조 (준거법)</h4><p>본 계약에 명시되지 않은 사항은 대한민국 법령 및 상관례에 따른다.</p></div>
    </div>
  </div>

  <div class="contract-footer">본 문서는 거래 조건 및 품목에 관한 계약 내용을 명시합니다.</div>
</div>

<script>
const ctx = '${pageContext.request.contextPath}';
const CONTRACT_NO = '<c:out value="${contractOne[0].contractNo}" default=""/>';

/* 📎 드롭다운 토글 */
function toggleAttachmentDropdown(force) {
  const dropdown = document.getElementById('attachmentDropdown');
  const trigger  = document.getElementById('attachmentTrigger');
  const willOpen = (typeof force === 'boolean') ? force : !dropdown.classList.contains('open');

  dropdown.classList.toggle('open', willOpen);
  dropdown.setAttribute('aria-hidden', !willOpen);
  if (trigger) trigger.setAttribute('aria-expanded', willOpen);

  if (willOpen) { loadAttachments(); } // 열릴 때마다 최신화
}

/* 트리거 클릭 바인딩 */
document.getElementById('attachmentTrigger')?.addEventListener('click', () => toggleAttachmentDropdown());

/* 업로드 */
function uploadFiles(form) {
  const formData = new FormData(form);
  fetch(ctx + '/admin/attachmentUpload', { method: 'POST', body: formData })
    .then(r => r.text())
    .then(result => {
      alert(result);
      if (result.includes('완료되었습니다')) {
        form.reset();
        toggleAttachmentDropdown(true); // 업로드 후 자동 펼침
      }
    })
    .catch(err => {
      console.error('업로드 실패:', err);
      alert('첨부파일 업로드 중 오류가 발생했습니다.');
    });
  return false;
}

/* 목록 로드 */
function loadAttachments() {
  const contractNo = CONTRACT_NO;
  if (!contractNo) return;

  fetch(ctx + '/api/attachments/' + encodeURIComponent(contractNo) + '?attachmentCode=CONTRACT')
    .then(r => { if(!r.ok) throw new Error('HTTP ' + r.status); return r.json(); })
    .then(attachments => {
      const box = document.getElementById('attachmentList');
      if (!attachments || attachments.length === 0) {
        box.innerHTML = '<p>첨부된 파일이 없습니다.</p>';
        return;
      }
      let html = '<table>';
      html += '<thead><tr><th>파일명</th><th>업로드일</th><th>작성자</th><th>관리</th></tr></thead><tbody>';
      attachments.forEach(att => {
        const uploadDate = att.createDate ? new Date(att.createDate).toLocaleDateString('ko-KR') : '날짜 없음';
        html += '<tr>'
          + '<td>' + (att.filename || '파일명 없음') + '</td>'
          + '<td>' + uploadDate + '</td>'
          + '<td>' + (att.createUser || '사용자 없음') + '</td>'
          + '<td><button class="btn btn-primary" onclick="deleteAttachment(' + att.attachmentNo + ')">삭제</button></td>'
          + '</tr>';
      });
      html += '</tbody></table>';
      box.innerHTML = html;
    })
    .catch(err => {
      const box = document.getElementById('attachmentList');
      box.innerHTML = '<p>첨부파일 목록을 불러올 수 없습니다. 오류: ' + err.message + '</p>';
    });
}

/* 삭제 */
function deleteAttachment(attachmentNo) {
  if (!confirm('정말로 이 첨부파일을 삭제하시겠습니까?')) return;
  const fd = new FormData();
  fd.append('attachmentNo', attachmentNo);
  fetch(ctx + '/api/attachments/delete', { method: 'POST', body: fd })
    .then(r => r.text())
    .then(result => {
      alert(result);
      if (result.includes('삭제되었습니다')) loadAttachments();
    })
    .catch(err => {
      console.error('삭제 실패:', err);
      alert('첨부파일 삭제에 실패했습니다.');
    });
}
</script>

<div class="no-print">
  <!-- 공통 풋터 -->
  <%@include file="/WEB-INF/common/footer/footer.jsp"%>
</div>
</body>
</html>