<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>로그인</title>
<style>
	body {
		font-family: Arial, sans-serif;
		background-color: #f4f6f9;
		margin: 0;
		min-height: 100vh;
		display: flex;
		flex-direction: column;
	}

	/* 메인 컨텐츠 영역 */
	.main-content {
		flex: 1;
		display: flex;
		justify-content: center;
		align-items: center;
		padding: 40px 0;
	}

	.login-container {
		width: 350px;
		padding: 30px;
		background: #fff;
		border: 1px solid #ddd;
		border-radius: 8px;
		box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
		text-align: center;
	}

	h1 {
		margin-bottom: 20px;
		font-size: 22px;
		color: #333;
	}

	input[type="text"], input[type="password"] {
		width: 100%;
		padding: 10px;
		margin: 8px 0;
		border: 1px solid #ccc;
		border-radius: 4px;
		box-sizing: border-box;
	}

	button {
		width: 100%;
		padding: 12px;
		background-color: #4CAF50;
		color: white;
		border: none;
		border-radius: 4px;
		cursor: pointer;
		font-size: 16px;
		margin-top: 10px;
	}

	button:hover {
		background-color: #45a049;
	}

	/* 소셜 로그인 버튼 */
	.social-login {
		margin-top: 15px;
	}

	.naver-btn {
		background-color: #03C75A;
		color: white;
		margin-bottom: 8px;
	}

	.kakao-btn {
		background-color: #FEE500;
		color: #3C1E1E;
	}

	/* 하단 링크 */
	.extra-links {
		margin-top: 15px;
		display: flex;
		justify-content: space-between;
		font-size: 13px;
	}

	.extra-links a {
		color: #555;
		text-decoration: none;
	}

	.extra-links a:hover {
		text-decoration: underline;
	}
	.naver-btn, .kakao-btn {
    display: block;
    text-align: center;
    width: 100%;
    padding: 12px;
    border-radius: 4px;
    font-size: 16px;
    text-decoration: none;
    cursor: pointer;
	}
	
	/* 네이버 */
	.naver-btn {
	    background-color: #03C75A;
	    color: white;
	    margin-bottom: 8px;
	}
	
	/* 카카오 */
	.kakao-btn {
	    background-color: #FEE500;
	    color: #3C1E1E;
	}
		
</style>
</head>
<jsp:include page="/WEB-INF/common/header/publicHeader.jsp" />
<body>
<jsp:include page="/WEB-INF/common/sidebar/publicSidebar.jsp" />

	<div class="main-content">
		<div class="login-container">
			<h1>로그인</h1>
			<form action="/public/loginAction" method="post" name="loginForm">
				<input type="text" id="username" name="username" placeholder="아이디" required>
				<input type="password" id="password" name="password" placeholder="비밀번호" required>
				<button type="submit">로그인</button>
			</form>
			
			<div class="social-login">
			    <a href="/oauth2/authorization/naver" class="naver-btn">네이버로 로그인</a>
			    <a href="/oauth2/authorization/kakao" class="kakao-btn">카카오로 로그인</a>
			</div>

			<div class="extra-links">
				<a href="/public/joinMember">회원가입</a>
				<div>
					<a href="/public/findMemberId">계정찾기</a> | 
					<a href="/public/findMemberPw">비밀번호 찾기</a>
				</div>
			</div>
		</div>
	</div>

	<jsp:include page="/WEB-INF/common/footer/footer.jsp" />
</body>
</html>
