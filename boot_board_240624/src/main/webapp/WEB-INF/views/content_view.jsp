<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
	function modify(actions) {
		document.contentfrm.action = actions;
		document.contentfrm.submit();
	}
	
	function del(actions) {
		document.contentfrm.action = actions;
		document.contentfrm.submit();
	}
</script>
<body>
	<table width="500" border=1>
		<form name="contentfrm" method="post" action="modify">
			<tr>
				<td>순번</td>
				<td>
					${content_view.boardNo }
					<input type="hidden" name="boardNo" value="${content_view.boardNo }">
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.boardHit }
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>
					<input type="text" name="boardName" value="${content_view.boardName }">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="boardTitle" value="${content_view.boardTitle }">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<input type="text" name="boardContent" value="${content_view.boardContent }">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="button" onclick="modify('modify')">수정</button>
					<button type="button" onclick="del('delete')"><font color="red">삭제</font></button>
					<%-- 
					<input type="submit" value="수정">
					&nbsp;&nbsp;<button type="button" onclick="location.href='delete?boardNo=${content_view.boardNo }'"><font color=red>삭제</font></button>
					--%>
					&nbsp;&nbsp;<button type="button" onclick="location.href='list'">목록보기</button>
					<%-- <a href="list">목록보기</a> --%>
				</td>
			</tr>
		</form>
	</table>
</body>
</html>