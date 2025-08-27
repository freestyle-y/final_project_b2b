<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>회원 관리</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background: #f5f5f5;
            margin: 0;
            padding: 20px;
        }
        h1 { margin-bottom: 20px; color:#333; }
        .filter-box {
            background: #fff;
            padding: 15px;
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        select, button {
            padding: 6px 10px;
            margin-right: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
        }
        #btnSearch {
            background: #444;
            color:#fff;
            cursor: pointer;
        }
        #btnSearch:hover {
            background:#222;
        }
        table {
            width: 100%;
            max-width: 1100px;
            margin: 0 auto;
            border-collapse: collapse;
            background: #fff;
            border-radius: 8px;
            overflow: hidden;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        th, td {
            padding: 12px;
            border-bottom: 1px solid #eee;
            text-align: center;
            font-size: 14px;
        }
        th {
            background: #f8f8f8;
            font-weight: 600;
        }
        .btn-approve {
            background: #28a745;
            color: #fff;
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }
        .btn-approve:hover {
            background: #218838;
        }
        .btn-reject {
            background: #dc3545;
            color: #fff;
            padding: 6px 12px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            margin-left:5px;
        }
        .btn-reject:hover {
            background: #c82333;
        }
    </style>
</head>
<body class="index-page">

<!-- 공통 헤더 -->
<%@include file="/WEB-INF/common/header/header.jsp"%>
<!-- 공통 사이드바 -->
<%@include file="/WEB-INF/common/sidebar/sidebar.jsp"%>
<main class="main">
<section id="best-sellers" class="best-sellers section">

      <!-- Section Title -->
      <div class="container section-title" data-aos="fade-up">
        <h2>Best Sellers</h2>
        <p>Necessitatibus eius consequatur ex aliquid fuga eum quidem sint consectetur velit</p>
      </div><!-- End Section Title -->

      <div class="container" data-aos="fade-up" data-aos-delay="100">

        <div class="row g-5">

          <!-- Product 1 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-item">
              <div class="product-image">
                <div class="product-badge">Limited</div>
                <img src="assets/img/product/product-1.webp" alt="Product Image" class="img-fluid" loading="lazy">
                <div class="product-actions">
                  <button class="action-btn wishlist-btn">
                    <i class="bi bi-heart"></i>
                  </button>
                  <button class="action-btn compare-btn">
                    <i class="bi bi-arrow-left-right"></i>
                  </button>
                  <button class="action-btn quickview-btn">
                    <i class="bi bi-zoom-in"></i>
                  </button>
                </div>
                <button class="cart-btn">Select Options</button>
              </div>
              <div class="product-info">
                <div class="product-category">Premium Collection</div>
                <h4 class="product-name"><a href="product-details.html">Mauris blandit aliquet elit</a></h4>
                <div class="product-rating">
                  <div class="stars">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star"></i>
                  </div>
                  <span class="rating-count">(24)</span>
                </div>
                <div class="product-price">$189.00</div>
                <div class="color-swatches">
                  <span class="swatch active" style="background-color: #2563eb;"></span>
                  <span class="swatch" style="background-color: #059669;"></span>
                  <span class="swatch" style="background-color: #dc2626;"></span>
                </div>
              </div>
            </div>
          </div>
          <!-- End Product 1 -->

          <!-- Product 2 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-item">
              <div class="product-image">
                <div class="product-badge sale-badge">25% Off</div>
                <img src="assets/img/product/product-4.webp" alt="Product Image" class="img-fluid" loading="lazy">
                <div class="product-actions">
                  <button class="action-btn wishlist-btn">
                    <i class="bi bi-heart"></i>
                  </button>
                  <button class="action-btn compare-btn">
                    <i class="bi bi-arrow-left-right"></i>
                  </button>
                  <button class="action-btn quickview-btn">
                    <i class="bi bi-zoom-in"></i>
                  </button>
                </div>
                <button class="cart-btn">Add to Cart</button>
              </div>
              <div class="product-info">
                <div class="product-category">Best Sellers</div>
                <h4 class="product-name"><a href="product-details.html">Sed do eiusmod tempor incididunt</a></h4>
                <div class="product-rating">
                  <div class="stars">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-half"></i>
                  </div>
                  <span class="rating-count">(38)</span>
                </div>
                <div class="product-price">
                  <span class="old-price">$240.00</span>
                  <span class="current-price">$180.00</span>
                </div>
                <div class="color-swatches">
                  <span class="swatch active" style="background-color: #1f2937;"></span>
                  <span class="swatch" style="background-color: #f59e0b;"></span>
                  <span class="swatch" style="background-color: #8b5cf6;"></span>
                </div>
              </div>
            </div>
          </div>
          <!-- End Product 2 -->

          <!-- Product 3 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-item">
              <div class="product-image">
                <img src="assets/img/product/product-7.webp" alt="Product Image" class="img-fluid" loading="lazy">
                <div class="product-actions">
                  <button class="action-btn wishlist-btn">
                    <i class="bi bi-heart"></i>
                  </button>
                  <button class="action-btn compare-btn">
                    <i class="bi bi-arrow-left-right"></i>
                  </button>
                  <button class="action-btn quickview-btn">
                    <i class="bi bi-zoom-in"></i>
                  </button>
                </div>
                <button class="cart-btn">Add to Cart</button>
              </div>
              <div class="product-info">
                <div class="product-category">New Arrivals</div>
                <h4 class="product-name"><a href="product-details.html">Lorem ipsum dolor sit amet consectetur</a></h4>
                <div class="product-rating">
                  <div class="stars">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star"></i>
                    <i class="bi bi-star"></i>
                  </div>
                  <span class="rating-count">(12)</span>
                </div>
                <div class="product-price">$95.00</div>
                <div class="color-swatches">
                  <span class="swatch active" style="background-color: #ef4444;"></span>
                  <span class="swatch" style="background-color: #06b6d4;"></span>
                  <span class="swatch" style="background-color: #10b981;"></span>
                </div>
              </div>
            </div>
          </div>
          <!-- End Product 3 -->

          <!-- Product 4 -->
          <div class="col-lg-3 col-md-6">
            <div class="product-item">
              <div class="product-image">
                <div class="product-badge trending-badge">Trending</div>
                <img src="assets/img/product/product-10.webp" alt="Product Image" class="img-fluid" loading="lazy">
                <div class="product-actions">
                  <button class="action-btn wishlist-btn active">
                    <i class="bi bi-heart-fill"></i>
                  </button>
                  <button class="action-btn compare-btn">
                    <i class="bi bi-arrow-left-right"></i>
                  </button>
                  <button class="action-btn quickview-btn">
                    <i class="bi bi-zoom-in"></i>
                  </button>
                </div>
                <button class="cart-btn">Add to Cart</button>
              </div>
              <div class="product-info">
                <div class="product-category">Designer Series</div>
                <h4 class="product-name"><a href="product-details.html">Ut enim ad minim veniam quis</a></h4>
                <div class="product-rating">
                  <div class="stars">
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                    <i class="bi bi-star-fill"></i>
                  </div>
                  <span class="rating-count">(56)</span>
                </div>
                <div class="product-price">$165.00</div>
                <div class="color-swatches">
                  <span class="swatch" style="background-color: #64748b;"></span>
                  <span class="swatch active" style="background-color: #7c3aed;"></span>
                  <span class="swatch" style="background-color: #f59e0b;"></span>
                </div>
              </div>
            </div>
          </div>
          <!-- End Product 4 -->

        </div>

      </div>

    </section><!-- /Best Sellers Section -->
    
    <h1>회원 관리</h1>

    <form method="get" action="/admin/manageUser" class="filter-box">
    <label>회원 구분:
        <select name="type">
            <option value="" ${empty type ? 'selected':''}>전체</option>
            <option value="CC001" ${type=='CC001'?'selected':''}>관리자</option>
            <option value="CC002" ${type=='CC002'?'selected':''}>기업회원</option>
            <option value="CC003" ${type=='CC003'?'selected':''}>개인회원</option>
        </select>
    </label>
    <label>상태:
        <select name="status">
            <option value="" ${empty status ? 'selected':''}>전체</option>
            <option value="CS001" ${status=='CS001'?'selected':''}>활성화</option>
            <option value="CS002" ${status=='CS002'?'selected':''}>휴면</option>
            <option value="CS003" ${status=='CS003'?'selected':''}>탈퇴</option>
            <option value="CS004" ${status=='CS004'?'selected':''}>가입대기</option>
        </select>
    </label>
    <input type="text" name="keyword" placeholder="아이디/이름/이메일 검색"
		value="${keyword}" style="padding:6px; border:1px solid #ccc; border-radius:5px;">
    <button type="submit">조회</button>
</form>

<table>
    <thead>
        <tr>
            <th>아이디</th>
            <th>이름</th>
            <th>회원 구분</th>
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
            <tr id="row-${u.id}">
                <td>${u.id}</td>
                <td>${u.name}</td>
                <td>
                    <c:choose>
                        <c:when test="${u.customerCategory eq 'CC001'}">관리자</c:when>
                        <c:when test="${u.customerCategory eq 'CC002'}">기업회원</c:when>
                        <c:when test="${u.customerCategory eq 'CC003'}">개인회원</c:when>
                    </c:choose>
                </td>
                <td>${u.email}</td>
                <td>${u.phone}</td>
                <td>${u.companyName}</td>
                <td>${u.businessNo}</td>
                <td id="status-${u.id}">
                    <c:choose>
                        <c:when test="${u.customerStatus eq 'CS001'}">활성화</c:when>
                        <c:when test="${u.customerStatus eq 'CS002'}">휴면</c:when>
                        <c:when test="${u.customerStatus eq 'CS003'}">탈퇴</c:when>
                        <c:when test="${u.customerStatus eq 'CS004'}">가입대기</c:when>
                    </c:choose>
                </td>
                <td>${u.createDate}</td>
                <td>
                    <c:if test="${u.customerCategory eq 'CC002' and u.customerStatus eq 'CS004'}">
                        <button class="btn-approve" onclick="approveUser('${u.id}')">승인</button>
                    </c:if>
                    <c:if test="${!(u.customerCategory eq 'CC002' and u.customerStatus eq 'CS004')}">
                        -
                    </c:if>
                </td>
            </tr>
        </c:forEach>
    </tbody>
</table>
	<!-- 페이징 -->
	<div style="text-align:center; margin-top:20px;">
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
</main>
    <!-- 공통 풋터 -->
	<%@include file="/WEB-INF/common/footer/footer.jsp"%>

    <script>
    function approveUser(id) {
        if (!confirm("해당 회원을 승인하시겠습니까?")) return;

        $.ajax({
            url: "/public/" + id + "/approve",
            type: "PUT",
            success: function() {
                alert("승인 완료되었습니다.");
                // 버튼 제거 & 상태 변경
                $("#row-" + id + " .btn-approve").remove();
                $("#status-" + id).text("활성화");
            },
            error: function() {
                alert("승인 처리 중 오류가 발생했습니다.");
            }
        });
    }
    </script>

</body>
</html>