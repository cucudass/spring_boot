<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<form name="listfrm" method="post">
		<table width="500" border="1">
			<tr>
				<td>번호</td>
				<td>이름</td>
				<td>제목</td>
				<td>날짜</td>
				<td>히트</td>
			</tr>
			<%-- list : 모델 객체에서 보낸 이름 --%>
			<c:forEach items="${list }" var="dto">
				<tr>
					<td>${dto.boardNo }</td>
					<td>${dto.boardName }</td>
					<td>
						<%-- content_view: 컨트롤러단 호출 --%>
						<a href="content_view?boardNo=${dto.boardNo }">
							${dto.boardTitle }
						</a>
					</td>
					<td><fmt:formatDate value="${dto.boardDate }" pattern="yyyy-MM-dd"/></td>
					<td>${dto.boardHit }</td>
				</tr>					
			</c:forEach>
			<tr>
				<td colspan="5">
					<!-- 컨트롤러단에서 호출 -->
					<a href="write_view">글 작성</a>
				</td>
			</tr>
		</table>
	</form>
</body>
</html>