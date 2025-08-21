<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>간편 비밀번호</title>
	<style>
		body {
			font-family: sans-serif;
			padding: 20px;
			background-color: #f5f5f5;
		}
		.container {
			background: white;
			padding: 20px;
			border-radius: 8px;
			box-shadow: 0 2px 10px rgba(0,0,0,0.1);
			max-width: 300px;
			margin: 0 auto;
		}
		.section {
			text-align: center;
		}
		.section h3 {
			color: #333;
			margin-bottom: 20px;
		}
		.section input {
			width: 100%;
			padding: 10px;
			border: 2px solid #ddd;
			border-radius: 4px;
			font-size: 16px;
			margin-bottom: 15px;
			text-align: center;
			letter-spacing: 2px;
		}
		.section input:focus {
			border-color: #007bff;
			outline: none;
		}
		.btn {
			padding: 10px 20px;
			margin: 5px;
			cursor: pointer;
			border: none;
			border-radius: 4px;
			font-size: 14px;
		}
		.btn-primary {
			background-color: #007bff;
			color: white;
		}
		.btn-secondary {
			background-color: #6c757d;
			color: white;
		}
		.btn:hover {
			opacity: 0.8;
		}
		.info-text {
			color: #666;
			font-size: 12px;
			margin-top: 10px;
		}
	</style>
</head>
<body>
	<div class="container">
		<div id="inputSection" class="section" style="display: none;">
			<h3>🔐 간편 결제 비밀번호 입력</h3>
			<input type="password" id="easyPassword" maxlength="4" placeholder="4자리 입력" autocomplete="off">
			<br>
			<button class="btn btn-primary" onclick="submitPassword()">확인</button>
			<button class="btn btn-secondary" onclick="window.close()">취소</button>
			<div class="info-text">등록된 4자리 비밀번호를 입력해주세요</div>
		</div>

		<div id="registerSection" class="section" style="display: none;">
			<h3>📝 간편 결제 비밀번호 등록</h3>
			<input type="password" id="newPassword" maxlength="4" placeholder="4자리 입력" autocomplete="off">
			<br>
			<button class="btn btn-primary" onclick="registerPassword()">등록</button>
			<button class="btn btn-secondary" onclick="window.close()">취소</button>
			<div class="info-text">새로운 4자리 비밀번호를 설정해주세요</div>
		</div>
	</div>

	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		const userId = new URLSearchParams(window.location.search).get('userId');

		$(document).ready(function() {
			$.ajax({
				type: "GET",
				url: "/personal/payment/simplePassword",
				data: { userId: userId },
				success: function(hasPassword) {
					if (hasPassword === true) {
						$("#inputSection").show();
					} else {
						$("#registerSection").show();
					}
				},
				error: function() {
					alert("비밀번호 상태 확인 실패");
					window.close();
				}
			});
		});


		function submitPassword() {
			const pw = $("#easyPassword").val().trim();
			if (pw.length !== 4) {
				alert("4자리 비밀번호를 입력해주세요.");
				return;
			}

			$.ajax({
				type : "POST",
				url : "/personal/payment/validate-password",
				data : {userId : userId, pw : pw},
				dataType : "json",
				success : function(valid) {
					if (!valid) {
						alert("비밀번호가 일치하지 않습니다.");
						return;
					}
					// 검증 성공 -> 부모창에서 결제 로직 수행
					if (window.opener && typeof window.opener.completePayment === "function") {
						window.opener.completePayment();
						window.close();
					} else {
						alert("결제 처리 중 오류가 발생했습니다.");
						window.close();
					}
				},
				error : function() {
					alert("비밀번호 검증 실패");
				}
			});
		}

		function registerPassword() {
			const newPw = $("#newPassword").val().trim();
			if (newPw.length !== 4) {
				alert("4자리 비밀번호를 입력해주세요.");
				return;
			}

			$.ajax({
				type : "POST",
				url : "/personal/payment/registerSimplePassword",
				data : JSON.stringify({
					userId : userId,
					password : newPw
				}),
				contentType : "application/json",
				success : function() {
					alert("비밀번호가 등록되었습니다. 이제 등록한 비밀번호를 입력해주세요.");
					// 등록 성공 후 입력 섹션으로 전환
					$("#registerSection").hide();
					$("#inputSection").show();
					// 입력 필드 초기화
					$("#easyPassword").val("");
					$("#easyPassword").focus();
				},
				error : function() {
					alert("비밀번호 등록 실패");
				}
			});
		}
	</script>
</body>
</html>
