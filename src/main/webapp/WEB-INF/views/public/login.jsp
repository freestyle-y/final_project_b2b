<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>login page</title>
</head>
<body>
	<h1>login page</h1>
	<hr>
	<form action="/public/loginAction" method="post" name="loginForm">
	<input type="text" id="username" name="username" placeholder="id">
	<input type="password" id="password" name="password" placeholder="password">
	<button type="submit">login</button>
	</form>
</body>
</html>