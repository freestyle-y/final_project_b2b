<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <%@ include file="/WEB-INF/common/head.jsp"%>
  <title>회원 관리</title>

  <!-- 폰트 / 라이브러리 -->
  <link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

  <style>
  /* 조회 폼 (필터 박스) 스타일 */
.filter-box {
  background: var(--tbl-head);
  border: 1px solid var(--tbl-border);
  border-radius: 10px;
  padding: 1rem;
  margin-bottom: 2rem;
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 1rem;
}

.filter-box label,
.filter-box select,
.filter-box input[type="text"] {
  font-size: 0.92rem;
  font-family: "SUIT", sans-serif;
  color: #111827;
}

.filter-box select,
.filter-box input[type="text"] {
  border: 1px solid var(--tbl-border);
  border-radius: 6px;
  padding: 0.5rem 0.75rem;
  background: #fff;
  transition: border-color 0.2s;
}

.filter-box select:focus,
.filter-box input[type="text"]:focus {
  outline: none;
  border-color: #F3F4F6;
  box-shadow: 0 0 0 3px rgba(76, 89, 255, 0.1);
}

.filter-box button {
  padding: 0.5rem 1rem;
  font-size: 0.92rem;
  font-weight: 600;
  color: #111827; /* 글자색을 검정으로 변경 */
  background-color: var(--tbl-hover); /* 마우스 호버 색상으로 변경 */
  border: 1px solid var(--tbl-hover); /* 테두리 색상을 동일하게 변경 */
  border-radius: 6px;
  cursor: pointer;
  transition: background-color 0.2s, border-color 0.2s;
}

.filter-box button:hover {
  background-color: #e9ecef; /* 약간 더 어두운 회색으로 변경 */
  border-color: #e9ecef;
}
    :root{
      --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0;
    }
    body{
      font-family:"SUIT",-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,"Apple SD Gothic Neo","Noto Sans KR","Malgun Gothic",Arial,sans-serif;
      background:#f5f5f5;
    }
    a{ color:#4c59ff; text-decoration:none; }

    .container-xl{ max-width:1400px; }
    .table-wrap{ max-width:1400px; margin:0 auto; }

    /* DataTables 박스 */
    #userTable_wrapper .dataTables_scroll, #userTable{
      border:1px solid var(--tbl-border); border-radius:10px; overflow:auto; background:#fff; font-size:.92rem;
    }
    

    /* [수정] 폭/보더 계산 안정화 */
    #userTable{
      table-layout: fixed;
      border-collapse: collapse;
    }

    /* 그룹행(멀티헤더 1행) */
    #userTable thead tr.dt-group-header th,
    #userTable_wrapper .dataTables_scrollHead thead tr.dt-group-header th{
      background:#ffffff !important;
      border-top:none !important; border-bottom:1px solid var(--tbl-border) !important;
      text-align:center !important; vertical-align:middle !important;
      font-weight:700; color:#111827; padding:.45rem .75rem;
      pointer-events:none;
      box-sizing: border-box;
      white-space: nowrap;    /* [수정] 줄바꿈 방지 */
      line-height: 1.2;       /* [수정] 높이 안정화 */
    }

    /* 실제 헤더(2행) */
    #userTable thead tr:nth-child(2) th{
      background:var(--tbl-head) !important; font-weight:700; color:#111827;
      border-bottom:1px solid var(--tbl-border) !important; vertical-align:middle;
      padding:.55rem .75rem; white-space:nowrap; text-align:center;
      box-sizing: border-box;
    }

    /* 본문 */
    #userTable tbody td{
      border-top:1px solid var(--tbl-border); color:#111827; vertical-align:middle;
      height:40px; padding:.45rem .75rem; text-align:center;
      white-space:normal; word-break:keep-all; overflow-wrap:anywhere;
    }
    #userTable tbody tr:nth-child(even){ background:var(--tbl-zebra); }
    #userTable tbody tr:hover{ background:var(--tbl-hover); }

    /* 빈 셀 강조 */
    td.cell-empty{ background:var(--tbl-empty) !important; }

    /* ===== 정렬 아이콘 영역/위치 고정 + 상하 위치 교체 ===== */
    #userTable thead th { position: relative; padding-right: 2rem !important; } /* 아이콘 자리 확보 */

    table.dataTable thead .sorting:before,
    table.dataTable thead .sorting_asc:before,
    table.dataTable thead .sorting_desc:before,
    table.dataTable thead .sorting:after,
    table.dataTable thead .sorting_asc:after,
    table.dataTable thead .sorting_desc:after {
      position: absolute;
      right: .6rem;
      margin: 0;
      opacity: .25;  /* 기본 옅게 */
    }
    /* [수정] 위치 교체: 위쪽 = after(↓), 아래쪽 = before(↑) */
    table.dataTable thead .sorting:before,
table.dataTable thead .sorting:after,
table.dataTable thead .sorting_asc:before,
table.dataTable thead .sorting_asc:after,
table.dataTable thead .sorting_desc:before,
table.dataTable thead .sorting_desc:after {
  position: absolute;
  right: .6rem;
  margin: 0;
  opacity: .25;   /* 기본은 흐리게 */
  transform: none; /* translateY 제거 */
}

    /* [수정] 강조 규칙 유지: ASC=↓(위) 진함, DESC=↑(아래) 진함 */
    table.dataTable thead .sorting_asc:after { opacity: 1; }   /* ASC → 위쪽(↓) 진하게 */
    table.dataTable thead .sorting_desc:before { opacity: 1; } /* DESC → 아래쪽(↑) 진하게 */

    /* 날짜 셀 줄바꿈 방지 */
    .nowrap-cell { white-space: nowrap; }
    
    .status-cell {
  position: relative;
  cursor: pointer;
}
.status-dropdown {
  display: none;
  position: fixed;
  top: 100%;
  left: 50%;
  transform: translateX(-50%);
  z-index: 1000;
  min-width: 120px;
  background-color: #fff;
  border: 1px solid #ddd;
  border-radius: 6px;
  box-shadow: 0 4px 12px rgba(0,0,0,0.15);
  margin-top: 5px;
  white-space: nowrap;
}
.status-dropdown ul {
  list-style: none;
  padding: 0;
  margin: 0;
}
.status-dropdown ul li {
  padding: 8px 12px;
  font-size: 0.875rem;
  color: #333;
}
.status-dropdown ul li:hover {
  background-color: #f0f0f0;
}
.status-dropdown ul li.disabled {
  color: #aaa;
  cursor: not-allowed;
  background-color: #f7f7f7;
}
/* 상태 뱃지 스타일 */
.status-badge {
  display: inline-block;
  padding: 4px 8px;
  border-radius: 12px;
  font-size: 0.8rem;
  font-weight: bold;
  color: #fff;
}
.status-active { background-color: #1a73e8; }
.status-inactive { background-color: #757575; }
.status-suspended { background-color: #d9534f; }
.status-pending { background-color: #f0ad4e; }

.category-pagination li.disabled a,
.category-pagination li.disabled-link {
    /* 클릭을 방지 */
    pointer-events: none;
    cursor: default;
    /* 색상 변경 */
    color: #999;
    /* 밑줄 제거 */
    text-decoration: none;
}

.category-pagination li.active a {
  background-color: #e9ecef; /* 회색 배경 */
  border-radius: 6px;
  color: #495057; /* 짙은 회색 글자 */
  font-weight: bold;
  pointer-events: none; /* 클릭 비활성화 */
  cursor: default;
}

/* 현재 페이지 버튼의 hover 효과 제거 */
.category-pagination li.active a:hover {
  background-color: #e9ecef;
}
  </style>
</head>
<body class="index-page">

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>

<div class="container-xl py-3">
  <h1 class="h4 mb-3">회원 관리</h1>

  <!-- 조회 폼 -->
  <form method="get" action="/admin/manageUser" class="filter-box">
    <label class="me-2">회원 구분:
      <select name="type">
        <option value="" ${empty type ? 'selected' : ''}>전체</option>
        <option value="CC001" ${type=='CC001' ? 'selected' : ''}>관리자</option>
        <option value="CC002" ${type=='CC002' ? 'selected' : ''}>기업회원</option>
        <option value="CC003" ${type=='CC003' ? 'selected' : ''}>개인회원</option>
      </select>
    </label>
    <label class="me-2">상태:
      <select name="status">
        <option value="" ${empty status ? 'selected' : ''}>전체</option>
        <option value="CS001" ${status=='CS001' ? 'selected' : ''}>활성화</option>
        <option value="CS002" ${status=='CS002' ? 'selected' : ''}>탈퇴</option>
        <option value="CS003" ${status=='CS003' ? 'selected' : ''}>휴면</option>
        <option value="CS004" ${status=='CS004' ? 'selected' : ''}>가입대기</option>
      </select>
    </label>
    <input type="text" name="keyword" placeholder="아이디/이름/이메일 검색" value="${keyword}">
    <button type="submit">조회</button>
  </form>
</div>
  <div class="table-wrap">
    <table id="userTable" class="table table-striped table-hover table-bordered align-middle w-100">
      <thead class="table-light">
        <!-- 멀티헤더(그룹행) -->
        <tr class="dt-group-header">
          <th></th> <!-- 아이디 -->
          <th></th> <!-- 회원 구분 -->
          <th colspan="3" class="text-center">기본정보</th> <!-- 이름, 이메일, 전화번호 -->
          <th colspan="2" class="text-center">기업정보</th> <!-- 기업명, 사업자등록번호 -->
          <th></th> <!-- 상태 -->
          <th></th> <!-- 가입일 -->
          <th></th> <!-- 승인 -->
        </tr>
        <!-- 실제 헤더 -->
        <tr>
          <th>아이디</th>
          <th>회원 구분</th>
          <th>이름</th>
          <th>이메일</th>
          <th>전화번호</th>
          <th>기업명</th>
          <th>사업자 등록 번호</th>
          <th>상태</th>
          <th>가입일</th>
          <th>승인</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="u" items="${users}">
          <tr data-userid="${u.id}">
            <td>${u.id}</td>
            <td>
              <c:choose>
                <c:when test="${u.customerCategory eq 'CC001'}"><span class="user-type-badge type-admin">관리자</span></c:when>
                <c:when test="${u.customerCategory eq 'CC002'}"><span class="user-type-badge type-business">기업회원</span></c:when>
                <c:when test="${u.customerCategory eq 'CC003'}"><span class="user-type-badge type-personal">개인회원</span></c:when>
                <c:otherwise><span class="user-type-badge type-personal">${u.customerCategory}</span></c:otherwise>
              </c:choose>
            </td>
            <td class="text-start">${fn:escapeXml(u.name)}</td>
            <td class="text-start">${fn:escapeXml(u.email)}</td>
            <td class="text-start">${fn:escapeXml(u.phone)}</td>
            <td class="text-start">${fn:escapeXml(u.companyName)}</td>
            <td class="text-start">${fn:escapeXml(u.businessNo)}</td>
            <td id="status-cell-${u.id}" data-current-status="${u.customerStatus}" class="status-cell">
    <span class="status-badge status-${u.customerStatus eq 'CS001' ? 'active' : u.customerStatus eq 'CS002' ? 'inactive' : u.customerStatus eq 'CS003' ? 'suspended' : u.customerStatus eq 'CS004' ? 'pending' : 'inactive'}">
        <c:choose>
            <c:when test="${u.customerStatus eq 'CS001'}">활성화</c:when>
            <c:when test="${u.customerStatus eq 'CS002'}">탈퇴</c:when>
            <c:when test="${u.customerStatus eq 'CS003'}">휴면</c:when>
            <c:when test="${u.customerStatus eq 'CS004'}">가입대기</c:when>
            <c:otherwise>알 수 없음</c:otherwise>
        </c:choose>
    </span>
    
    <div class="status-dropdown">
        <ul>
            <li data-status="CS001" data-label="활성화" data-userid="${u.id}">활성화</li>
            <li data-status="CS002" data-label="탈퇴" data-userid="${u.id}">탈퇴</li>
            <li data-status="CS003" data-label="휴면" data-userid="${u.id}">휴면</li>
            <li data-status="CS004" data-label="가입대기" data-userid="${u.id}">가입대기</li>
        </ul>
    </div>
</td>
            <td class="nowrap-cell" data-order="${u.createDate}">
              <c:choose>
                <c:when test="${not empty u.createDate and fn:contains(u.createDate,'T')}">
                  ${fn:substringBefore(u.createDate,'T')}
                </c:when>
                <c:when test="${not empty u.createDate}">
                  ${fn:substringBefore(u.createDate,' ')}
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
            <td>
              <c:choose>
                <c:when test="${u.customerCategory eq 'CC002' and u.customerStatus eq 'CS004'}">
                  <button type="button" class="btn btn-user btn-approve" onclick="approveUser('${u.id}')">승인</button>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </td>
          </tr>
        </c:forEach>
      </tbody>
    </table>
  </div>
	
	<!-- 페이징 영역 -->
	<div class="category-pagination">
		<nav>
			<ul class="justify-content-center">
				<!-- 이전 버튼 -->
				<li class="${page == 1 ? 'disabled' : ''}">
				  <a href="?page=${page - 1}&type=${type}&status=${status}&keyword=${keyword}" 
				     class="${page == 1 ? 'disabled-link' : ''}">
				    <span class="d-none d-sm-inline">이전</span>
				  </a>
				</li>

				<!-- 페이지 번호 -->
				<c:forEach begin="${startPage}" end="${endPage}" var="i">
					<li class="${i == page ? 'active' : ''}">
						<a href="?page=${i}&type=${type}&status=${status}&keyword=${keyword}">${i}</a>
					</li>
				</c:forEach>

				<!-- 다음 버튼 -->
				<c:if test="${endPage < totalPage}">
					<li>
						<a href="?page=${endPage + 1}&type=${type}&status=${status}&keyword=${keyword}">
							<span class="d-none d-sm-inline">다음</span>
						</a>
					</li>
				</c:if>
			</ul>
		</nav>
	</div>
 <!--
  <div class="text-center mt-3">
    <c:if test="${page > 1}">
      <a href="?page=1&type=${type}&status=${status}&keyword=${keyword}">&lt;&lt;</a>
      <a href="?page=${startPage-1}&type=${type}&status=${status}&keyword=${keyword}">&lt;</a>
    </c:if>

    <c:forEach var="i" begin="${startPage}" end="${endPage}">
      <a href="?page=${i}&type=${type}&status=${status}&keyword=${keyword}"
         style="margin:0 5px; ${i==page?'font-weight:bold; color:red;':''}">
        ${i}
      </a>
    </c:forEach>

    <c:if test="${endPage < totalPage}">
      <a href="?page=${endPage+1}&type=${type}&status=${status}&keyword=${keyword}">&gt;</a>
      <a href="?page=${totalPage}&type=${type}&status=${status}&keyword=${keyword}">&gt;&gt;</a>
    </c:if>
  </div>
</div>
 -->
<!-- 공통 풋터 -->
<%@include file="/WEB-INF/common/footer/footer.jsp"%>

<!-- JS -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
  /* 승인 처리 (원본 AJAX 로직 유지) */
  function approveUser(id) {
    if (!confirm("해당 회원을 승인하시겠습니까?")) return;

    $.ajax({
      url: "/admin/" + id + "/approve",
      type: "PUT",
      success: function() {
        alert("승인 완료되었습니다.");
        window.location.reload();
      },
      error: function() {
        alert("승인 처리 중 오류가 발생했습니다.");
      }
    });
  }

  /* 빈 셀 강조 */
  function highlightEmptyCells(){
    $('#userTable tbody tr').each(function(){
      $(this).children('td').each(function(){
        const $td = $(this);
        const hasElem = $td.find('input,button,select,textarea,a,span.status-badge,span.user-type-badge').length > 0;
        const text = ($td.text() || '').replace(/\u00a0/g,' ').trim().toLowerCase();
        const emptyText = (text === '' || text === 'null' || text === 'undefined' || text === '-');
        if (!hasElem && emptyText) $td.addClass('cell-empty').attr('title','데이터 없음');
        else $td.removeClass('cell-empty').removeAttr('title');
      });
    });
  }

  /* 멀티헤더 폭 동기화(누적 증가 방지) */
  function syncGroupHeaderWidthsStable() {
    const $wrapperHead = $('#userTable_wrapper .dataTables_scrollHead thead');
    const $head = $wrapperHead.length ? $wrapperHead : $('#userTable thead');

    const $row2 = $head.find('tr').eq(1);            // 실제 헤더
    const $row1 = $head.find('tr.dt-group-header');  // 그룹행
    if ($row1.length === 0 || $row2.length === 0) return;

    // 초기화
    $row1.children('th').each(function(){
      this.style.width = '';
      this.style.minWidth = '';
      this.style.maxWidth = '';
    });

    // 실측
    const widths = Array.from($row2[0].children).map(th => Math.round(th.clientWidth));
    const total = widths.reduce((a,b)=>a+b,0);

    // 합산 + 마지막 셀 보정
    let idx = 0, used = 0;
    const gCells = Array.from($row1[0].children);
    gCells.forEach(function(th, gIdx){
      const span = parseInt(th.getAttribute('colspan') || '1', 10);
      let sum = 0;
      for (let i=0; i<span; i++) sum += (widths[idx + i] || 0);
      idx += span;
      used += sum;
      if (gIdx === gCells.length - 1) sum += (total - used);
      th.style.width    = sum + 'px';
      th.style.minWidth = sum + 'px';
      th.style.maxWidth = sum + 'px';
    });
  }

  $(function(){
    // DataTables: 정렬만 사용(서버 페이징 유지)
    const table = $('#userTable').DataTable({
      ordering:true,
      paging:false,
      searching:false,
      info:false,
      lengthChange:false,
      autoWidth:false,
      scrollX:false,
      scrollY:false,
      orderMulti:false,
      columnDefs: [
        { targets: 0, width: '10ch', className: 'text-center' },
        { targets: 1, width: '11ch', className: 'text-center' },
        { targets: 2, width: '16ch', className: 'text-start'  },
        { targets: 3, width: '26ch', className: 'text-start'  },
        { targets: 4, width: '16ch', className: 'text-start'  },
        { targets: 5, width: '20ch', className: 'text-start'  },
        { targets: 6, width: '20ch', className: 'text-start'  },
        { targets: 7, width: '12ch', className: 'text-center' },
        { targets: 8, width: '14ch', className: 'text-center' },
        { targets: 9, width: '10ch', className: 'text-center' }
      ],
      order: [[8, 'desc']],
      dom: 't'
    });

    // 초기 렌더 & 보정
    table.on('init', function(){
      table.columns.adjust();
      requestAnimationFrame(function(){
        syncGroupHeaderWidthsStable();
        highlightEmptyCells();
      });
    });

    // 정렬/그리기/사이징/가시성 변경 시 동기화
    table.on('order.dt draw.dt column-sizing.dt columns-visibility.dt', function(){
      requestAnimationFrame(function(){
        syncGroupHeaderWidthsStable();
        highlightEmptyCells();
      });
    });

    // 창 리사이즈 시 동기화
    $(window).on('resize', function(){
      requestAnimationFrame(syncGroupHeaderWidthsStable);
    });

    // 안전 보정
    setTimeout(syncGroupHeaderWidthsStable, 0);
    
    $(window).on("scroll", function() {
    	$('.status-dropdown').hide();
    });

    
 // 1. 상태 셀 클릭 이벤트
    $(document).on('click', '.status-cell', function(e) {
        e.stopPropagation(); // 이벤트 버블링 방지
        
        // 모든 드롭다운 닫기
        $('.status-dropdown').hide();

        const $cell = $(this);
        const $dropdown = $cell.find('.status-dropdown');
        const currentStatus = $cell.data('current-status');
        const top = $(this).offset().top + 30 - $(window).scrollTop();
        const left = $(this).offset().left + 50;
        $('.status-dropdown').css('top', top);
        $('.status-dropdown').css('left', left);

        // 드롭다운 메뉴 열기
        $dropdown.show();

        // 현재 상태와 동일한 옵션 비활성화
        $dropdown.find('li').each(function() {
            if ($(this).data('status') === currentStatus) {
                $(this).addClass('disabled');
            } else {
                $(this).removeClass('disabled');
            }
        });
    });

 // 2. 드롭다운 옵션 클릭 이벤트
    $(document).on('click', '.status-dropdown li:not(.disabled)', function(e) {
        e.stopPropagation();

        const $li = $(this);
        const newStatus = $li.data('status');
        const newLabel = $.trim($li.text());
        
        const userId = $li.data('userid');
        
        console.log("userId:", userId);
        console.log("newStatus:", newStatus);
        console.log("newLabel:", newLabel);
        
        // 사용자에게 확인 받기
        if (!confirm("회원(" + userId + ")의 상태를 '" + newLabel + "'(으)로 변경하시겠습니까?")) {
            $li.closest('.status-dropdown').hide();
            return;
        }
        
        console.log("AJAX 호출 직전 userId:", userId);
        console.log("최종 URL(3):","/admin/user/" + userId + "/status");

        // 3. AJAX 요청으로 서버 API 호출
        $.ajax({
            url: "/admin/user/" + userId + "/status",
            type: "PUT",
            contentType: "application/json",
            data: JSON.stringify({ customerStatus: newStatus }),
            success: function(response) {
                    alert("상태가 성공적으로 변경되었습니다.");
                    window.location.reload();
            },
            error: function(xhr) {
                alert("상태 변경 요청에 실패했습니다.");
                console.error("AJAX Error:", xhr.status, xhr.responseText);
            }
        });
    });

    // 4. 테이블 외부 클릭 시 모든 드롭다운 닫기
    $(document).on('click', function(e) {
        if (!$(e.target).closest('.status-cell').length) {
            $('.status-dropdown').hide();
        }
    });
  });
</script>
</body>
</html>