<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<style>
  /* 컨테이너: 우측 고정 + 세로 중앙 */
  .fs-sidebar {
    position: fixed;
    right: 16px;
    top: 50%;
    transform: translateY(-50%);
    display: flex;
    flex-direction: column;
    gap: 10px;
    z-index: 9999;
  }

  /* 버튼 공통 스타일 */
  .fs-btn {
    min-width: 120px;
    padding: 10px 14px;
    border-radius: 12px;
    border: none;
    text-decoration: none;
    text-align: center;
    font-size: 14px;
    line-height: 1;
    color: #fff;
    cursor: pointer;
    box-shadow: 0 4px 14px rgba(0,0,0,.12);
    transition: transform .12s ease, box-shadow .12s ease, opacity .12s ease;
    user-select: none;
  }
  .fs-btn:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(0,0,0,.16); }
  .fs-btn:active { transform: translateY(0); box-shadow: 0 2px 8px rgba(0,0,0,.10); }
  .fs-btn:focus { outline: 2px solid rgba(16,185,129,.6); outline-offset: 2px; }

  /* 컬러 시스템 */
  .fs-dark-900 { background: #111827; } /* 고객센터 */
  .fs-dark-800 { background: #1f2937; } /* 마이페이지 */
  .fs-green    { background: linear-gradient(180deg, #10b981 0%, #0ea371 100%); } /* 최상단 */

  /* 모바일(<=768px): 우측 하단 바 형태 */
  @media (max-width: 768px) {
    .fs-sidebar {
      right: 10px;
      bottom: 14px;
      top: auto;
      transform: none;
      flex-direction: row;
      gap: 8px;
    }
    .fs-btn { min-width: auto; padding: 10px 12px; font-size: 13px; border-radius: 10px; }
    .fs-hide-sm { display: none; } /* 필요 시 감출 요소에 사용 */
  }
</style>

<aside aria-label="Quick Actions" class="fs-sidebar">
  <a href="/public/helpDesk" class="fs-btn fs-dark-900" title="고객센터">고객센터</a>
  <a href="/member/myPage" class="fs-btn fs-dark-800" title="마이페이지">마이페이지</a>
  <button type="button" id="goTopBtn" class="fs-btn fs-green" title="최상단 이동">↑ 최상단</button>
</aside>

<script>
  (function () {
    var btn = document.getElementById('goTopBtn');
    if (btn) btn.addEventListener('click', function () {
      window.scrollTo({ top: 0, behavior: 'smooth' });
    });
  })();
</script>
