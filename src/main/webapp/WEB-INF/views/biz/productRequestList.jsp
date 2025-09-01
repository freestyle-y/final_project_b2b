<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <%@ include file="/WEB-INF/common/head.jsp" %>
    <title>상품 요청 목록</title>

    <!-- SUIT Font -->
    <link href="https://cdn.jsdelivr.net/gh/sunn-us/SUIT/fonts/static/woff2/SUIT.css" rel="stylesheet">
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- DataTables -->
    <link rel="stylesheet" href="https://cdn.datatables.net/1.13.8/css/dataTables.bootstrap5.min.css">

    <style>
        :root {
            --tbl-border:#E5E7EB; --tbl-head:#F9FAFB; --tbl-hover:#F3F4F6; --tbl-zebra:#FAFAFA; --tbl-empty:#FFF0F0;
        }

        body {
            font-family: "SUIT", sans-serif;
        }

        .table-wrap {
            max-width: 1000px;
            margin: 0 auto;
        }

        #productRequestTable_wrapper .dataTables_scroll,
        #productRequestTable {
            border: 1px solid var(--tbl-border);
            border-radius: 10px;
            overflow: hidden;
            background: #fff;
            font-size: 0.92rem;

            /* 테이블 넓이 100% 유지 */
            width: 100% !important;
        }

        #productRequestTable thead th {
            background: var(--tbl-head) !important;
            font-weight: 700;
            color: #111827;
            border-bottom: 1px solid var(--tbl-border) !important;
            vertical-align: middle;
            padding: 0.55rem 0.75rem;
        }

        #productRequestTable tbody td {
            text-align: left;
        }

        #productRequestTable tbody td.dt-center,
        #productRequestTable tbody td.text-center {
            text-align: center !important;
        }

        #productRequestTable tbody td.dt-left,
        #productRequestTable tbody td.text-start {
            text-align: left !important;
        }

        #productRequestTable tbody tr:nth-child(even) {
            background: var(--tbl-zebra);
        }

        #productRequestTable tbody tr:hover {
            background: var(--tbl-hover);
        }

        td.cell-empty {
            background: var(--tbl-empty) !important;
        }

        /* 텍스트만 투명하게 하여 묶인 셀 시각화 (숨기지 않음) */
        td.group-col.visually-merged {
            color: transparent !important;
            text-shadow: none !important;
            pointer-events: none !important;
            user-select: none !important;
            background-color: transparent !important;
            border-top-color: transparent !important;
        }

        a {
            color: #4c59ff;
            text-decoration: none;
        }
    </style>
</head>
<body>

<!-- 공통 헤더 -->
<%@ include file="/WEB-INF/common/header/header.jsp" %>

<div class="container-xl py-4">
    <div class="table-wrap">
        <h2 class="mb-4 text-center">상품 요청 목록</h2>

        <table id="productRequestTable" class="table table-striped table-hover table-bordered align-middle nowrap w-100">
            <thead class="table-light">
                <tr>
                    <th>요청번호</th>
                    <th>상품명</th>
                    <th>옵션</th>
                    <th>수량</th>
                </tr>
            </thead>
            <tbody>
              <c:forEach var="productList" items="${groupedRequests.values()}">
                <c:forEach var="p" items="${productList}" varStatus="status">
                  <tr>
                    <td class="group-col">
                      <c:choose>
                        <c:when test="${status.first}">
                          <a href="${pageContext.request.contextPath}/biz/requestDetail?requestNo=${p.productRequestNo}">
                            ${p.productRequestNo}
                          </a>
                        </c:when>
                        <c:otherwise>
                          ${p.productRequestNo}
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td>${p.productName}</td>
                    <td>${p.productOption}</td>
                    <td>${p.productQuantity}</td>
                  </tr>
                </c:forEach>
              </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<!-- 공통 풋터 -->
<%@ include file="/WEB-INF/common/footer/footer.jsp" %>

<!-- JS Scripts -->
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/jquery.dataTables.min.js"></script>
<script src="https://cdn.datatables.net/1.13.8/js/dataTables.bootstrap5.min.js"></script>

<script>
    // 첫번째 요청번호를 제외한 동일 값들은 텍스트만 투명하게 처리 (숨기지 않음)
    function visuallyGroupFirstColumn(dtApi) {
        let lastVal = null;
        dtApi.column(0, { page: 'current' }).nodes().each(function (cell) {
            const $cell = $(cell);
            const raw = $cell.text().trim();
            $cell.removeClass('visually-merged').removeAttr('aria-hidden');

            if (lastVal !== null && raw === lastVal) {
                $cell.addClass('visually-merged').attr('aria-hidden', 'true');
            } else {
                lastVal = raw;
            }
        });
    }

    function highlightEmptyCells(dtApi) {
        const rows = dtApi.rows({ page: 'current' }).nodes();
        $(rows).find('td').each(function () {
            const $td = $(this);
            if ($td.hasClass('group-col') && $td.hasClass('visually-merged')) {
                $td.removeClass('cell-empty').removeAttr('title');
                return;
            }
            const text = ($td.text() || '').trim().toLowerCase();
            if (text === '' || text === 'null' || text === 'undefined') {
                $td.addClass('cell-empty').attr('title', '데이터 없음');
            } else {
                $td.removeClass('cell-empty').removeAttr('title');
            }
        });
    }

    $(function () {
        $('#productRequestTable').DataTable({
            ordering: true,
            searching: true,
            paging: true,
            pageLength: 10,
            lengthMenu: [10, 25, 50, 100],
            info: true,
            autoWidth: false,
            scrollX: true,
            scrollY: '50vh',
            scrollCollapse: true,
            columnDefs: [
                { targets: 0, width: "80px", className: 'dt-center' },
                { targets: 1, width: "250px", className: 'dt-left' },
                { targets: 2, width: "150px", className: 'dt-left' },
                { targets: 3, width: "100px", className: 'dt-center' }
            ],
            dom: '<"row mb-2"<"col-md-6"l><"col-md-6 text-end"f>>' +
                 'rt' +
                 '<"row mt-2"<"col-md-5"i><"col-md-7"p>>',
            order: [[0, 'desc']],
            language: {
                lengthMenu: '_MENU_ 개씩 보기',
                search: '검색:',
                info: '총 _TOTAL_건 중 _START_–_END_',
                infoEmpty: '0건',
                infoFiltered: '(전체 _MAX_건 중 필터링됨)',
                zeroRecords: '일치하는 데이터가 없습니다.',
                paginate: {
                    first: '처음',
                    last: '마지막',
                    next: '다음',
                    previous: '이전'
                },
                loadingRecords: '불러오는 중...',
                processing: '처리 중...'
            },
            drawCallback: function () {
                const api = this.api();
                visuallyGroupFirstColumn(api);
                highlightEmptyCells(api);
            },
            initComplete: function () {
                const api = this.api();
                visuallyGroupFirstColumn(api);
                highlightEmptyCells(api);
            }
        });
    });
</script>

</body>
</html>
