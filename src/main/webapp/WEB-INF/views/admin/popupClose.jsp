<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>제출 완료</title>
  <script>
    window.onload = function () {
      // 부모창 새로고침 (선택사항)
      if (window.opener && !window.opener.closed) {
        window.opener.location.reload();
      }

      // 팝업창 닫기
      window.close();
    }
  </script>
</head>
<body>
  <p>처리 완료. 창이 곧 닫힙니다.</p>
</body>
</html>
