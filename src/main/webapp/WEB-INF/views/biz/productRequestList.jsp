<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>상품 요청 목록</title>
    <style>
        body {
            background-color: #f5f5f5;
            font-family: 'Noto Sans KR', sans-serif;
        }
        
        .request-card {
            background: white;
            border-radius: 10px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            padding: 20px;
            margin: 20px auto;
            width: 90%;
            max-width: 800px;
        }
        
        .request-header {
            font-weight: bold;
            margin-bottom: 15px;
            font-size: 16px;
        }
        
        .request-table {
            width: 100%;
            border-collapse: collapse;
            table-layout: fixed;
        }
        
        .request-table th,
        .request-table td {
            padding: 10px;
            text-align: left;
            border-bottom: 1px solid #ddd;
            word-wrap: break-word;
        }
        
        .request-table th {
            background-color: #f0f0f0;
        }
        
        .request-table tr:last-child td {
            border-bottom: none;
        }
        
        .request-table th:nth-child(1),
        .request-table td:nth-child(1) {
            width: 40%;
        }
        
        .request-table th:nth-child(2),
        .request-table td:nth-child(2) {
            width: 30%;
        }
        
        .request-table th:nth-child(3),
        .request-table td:nth-child(3) {
            width: 30%;
        }

        /* 검색창 스타일 */
        #search-input {
            display: block;
            margin: 20px auto;
            padding: 10px;
            width: 300px;
            border-radius: 6px;
            border: 1px solid #ccc;
            font-size: 1em;
        }

        /* 페이징 버튼 스타일 */
        .pagination {
            text-align: center;
            margin-top: 20px;
        }
        .pagination button {
            margin: 0 4px;
            padding: 6px 12px;
            border-radius: 5px;
            border: 1px solid #ccc;
            background: #fff;
            cursor: pointer;
            font-size: 1em;
        }
        .pagination button.active {
            background-color: #333;
            color: white;
            border-color: #333;
        }
    </style>

    <!-- jQuery CDN -->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

</head>

<jsp:include page="/WEB-INF/common/header/bizHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/bizSidebar.jsp" />

    <h2 style="text-align:center; margin-top: 30px;">상품 요청 목록</h2>

    <!-- 검색 입력창 -->
    <input type="text" id="search-input" placeholder="상품명 검색...">

    <div id="request-container">
        <c:forEach var="entry" items="${groupedRequests}">
            <c:set var="requestNo" value="${entry.key}" />
            <c:set var="items" value="${entry.value}" />
            <c:set var="firstItem" value="${items[0]}" />

            <div class="request-card" data-request-no="${requestNo}" style="cursor: pointer;">
                <div class="request-header">
                    요청번호: <span class="product">${requestNo}</span> / 요청시간: ${firstItem.formattedCreateDate}
                </div>

                <table class="request-table">
                    <tr>
                        <th>상품명</th>
                        <th>옵션</th>
                        <th>수량</th>
                    </tr>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td class="product">${item.productName}</td>
                            <td>${item.productOption}</td>
                            <td>${item.productQuantity}</td>
                        </tr>
                    </c:forEach>
                </table>
            </div>
        </c:forEach>
    </div>

    <script>
        $(document).ready(function () {
            const itemsPerPage = 4;
            let currentPage = 1;

            const container = $('#request-container');
            const cards = container.find('.request-card').toArray();
            let filteredCards = cards;

            function renderPage(page) {
                container.find('.request-card').hide();
                const start = (page - 1) * itemsPerPage;
                const end = start + itemsPerPage;

                $(filteredCards).slice(start, end).show();
                renderPagination();
            }

            function renderPagination() {
                $('#pagination').remove();
                const totalPages = Math.ceil(filteredCards.length / itemsPerPage);
                if(totalPages <= 0) return; // 페이지 0개면 페이징 숨김

                const $pagination = $('<div id="pagination" class="pagination"></div>');
                for (let i = 1; i <= totalPages; i++) {
                    const $btn = $('<button>').text(i);
                    if (i === currentPage) $btn.addClass('active');
                    $btn.on('click', function () {
                        currentPage = i;
                        renderPage(currentPage);
                    });
                    $pagination.append($btn);
                }
                container.after($pagination);
            }

            function filterCards(keyword) {
                filteredCards = cards.filter(card => {
                    // 카드 내 모든 .product 텍스트를 합쳐서 검색
                    let text = "";
                    $(card).find('.product').each(function(){
                        text += $(this).text().toLowerCase() + " ";
                    });
                    return text.includes(keyword.toLowerCase());
                });
                currentPage = 1;
                renderPage(currentPage);
            }

            $('#search-input').on('input', function () {
                filterCards($(this).val());
            });
            
            $('.request-card').on('click', function () {
                const requestNo = $(this).data('request-no');
                window.location.href = '/biz/requestDetail?requestNo=' + requestNo;
            });

            // 초기 페이지 렌더링
            renderPage(currentPage);
        });
    </script>

<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
