<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
	function ck(actions){
		document.loginfrm.action = actions;
		document.loginfrm.submit();
	}
	function regis(actions){
		document.loginfrm.action = actions;
		document.loginfrm.submit();
	}
</script>
</head>
<body>
	<form name="loginfrm" method="post" action="login_ck">
	<div align="center">
		<table style="width: 300px;" border="1">
			<tr>
				<td width="40%">사용자 ID</td>
				<td width="60%">
					<input type="text" name="mem_uid">
				</td>
			</tr>
			<tr>
				<td>비밀번호</td>
				<td>
					<input type="password" name="mem_pwd">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="button" onclick="ck('login_ck')">로그인</button>
					&nbsp;&nbsp;&nbsp;
					<a href="register"">회원가입</a>
					<%-- <button type="button" onclick="regis('register')">회원가입</button> --%>
				</td>
			</tr>
		</table>
	</div>
	</form>
</body>
</html>