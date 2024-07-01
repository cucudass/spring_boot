<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<style type="text/css">
	.div_page ul {
		display: flex;
		list-style: none;
	}
</style>
</head>
<body>
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
					<a class="move_link" href="${dto.boardNo }">
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
	<h3>${pageMaker}</h3>
	<div class="div_page">
		<ul>
			<c:if test="${pageMaker.prev }">
				<li class="paginate_button">
					<a href="${pageMaker.startpage - 1}">[Prev]</a>
				</li>
			</c:if>
			<c:forEach var="num" begin="${pageMaker.startpage }" end="${pageMaker.endpage }">
				<%-- <li>[${num }]</li> --%>
				<li class="paginate_button " ${pageMaker.cri.pageNum == num?"style='background-color: yellow'":""}>
					<a href="${num }">[${num }]</a>
				</li>
			</c:forEach>
			<c:if test="${pageMaker.next }">
				<li class="paginate_button">
					<a href="${pageMaker.endpage + 1}">[Next]</a>
				</li>
			</c:if>
		</ul>
	</div>
	<form id="actionForm" method="get">
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum }">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount }">
	</form>
</body>
</html>
<script type="text/javascript">
	var actionForm = $("#actionForm");
	
	$(".paginate_button a").on("click", function(e) {
		e.preventDefault();
		console.log("click~");
		console.log("href=>"+$(this).attr("href"));
		
		//게시글 클릭 후 뒤로가기 버튼 클릭 후, 다른 게시글 클릭 할 때 &boardNo=번호 누적 방지
		var bno = actionForm.find("input[name='boardNo']").val;
		if(bno != '') {
			actionForm.find("input[name='boardNo']").remove();
		}
		
		actionForm.find("input[name='pageNum']").val($(this).attr("href"));
		actionForm.attr("action", "list").submit();
	}); //end paginate_button
	
	$(".move_link").on("click", function(e) {
		e.preventDefault();
		console.log("@# move_link");
		console.log("@# href=> "+$(this).attr("href"));
		var targetBno = $(this).attr("href");
		
		//게시글 클릭 후 뒤로가기 버튼 클릭 시, &boardNo=번호 누적 방지
		var bno = actionForm.find("input[name='boardNo']").val;
		if(bno != '') {
			actionForm.find("input[name='boardNo']").remove();
		}
			
		actionForm.append("<input type='hidden' name='boardNo' value='"+targetBno+"'>");
		actionForm.attr("action", "content_view").submit(); //컨트롤러 단의 content_view를 찾아감
	}); // end move_link
</script>