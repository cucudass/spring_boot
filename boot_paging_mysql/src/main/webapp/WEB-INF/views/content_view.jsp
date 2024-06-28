<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<style>
	.uploadResult {
		width: 100%;
		background-color: gray;
	}
	.uploadResult ul {
		display: flex;
		flex-flow: row;
	}
	.uploadResult ul li {
		list-style: none;
		padding: 10px;
	}
	.uploadResult ul li img {
		width: 100px;
	}
</style>
</head>
<body>
	<table width="500" border=1>
		<form name="contentfrm" method="post" action="modify">
			<tr>
				<td>순번</td>
				<td>
					${content_view.boardNo }
					<input type="hidden" id="boardNo" name="boardNo" value="${content_view.boardNo }">
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
					<input type="submit" value="수정">
					&nbsp;&nbsp;<button type="button" onclick="location.href='delete?boardNo=${content_view.boardNo }'"><font color=red>삭제</font></button>
					&nbsp;&nbsp;<a href="list">목록보기</a>
				</td>
			</tr>
		</form>
	</table>
	Files
	<div class="bigPicture">
		<div class="bigPic">
			<!-- 클릭된 이미지 출력 공간 -->
		</div>
	</div>
	<!-- 업로드된 파일 출력(화면 레이아웃-->
	<div class="uploadResult">
		<ul>
			<!-- 업로드된 파일 출력 공간-->
		</ul>
	</div>
	<div>
		<input type="text" id="commentWriter" placeholder="작성자">
		<input type="text" id="commentContent" placeholder="내용">
		<button type="button" onclick="commentWrite();">댓글작성</button>
	</div>
	<div id="comment-list">
		<table>
			<tr>
				<th>댓글번호</th>
				<th>작성자</th>
				<th>내용</th>
				<th>작성시간</th>
			</tr>
			<c:forEach items="${commentList }" var="comm">
				<tr>
					<td>${comm.commentNo }</td>
					<td>${comm.commentWriter }</td>
					<td>${comm.commentContent }</td>
					<td>
						<fmt:formatDate value="${comm.commentCreatedTime }" pattern="yyyy-MM-dd HH:mm" />
					</td>
				</tr>
			</c:forEach>
		</table>
	</div>
</body>
<script>
	const commentWrite = () => {
		const writer = document.getElementById("commentWriter").value;
		const content = document.getElementById("commentContent").value;
		const no = "${content_view.boardNo }";

		$.ajax({
			type: "post",
			data: {commentWriter : writer, commentContent: content, boardNo: no},
			url: "/comment/save",
			success: function(commentList) {
				console.log("작성성공");
				console.log(commentList);
				
				let output = "<table>";
					output+= "<tr>";
					output+= "<th>댓글번호</th>";
					output+= "<th>작성자</th>";
					output+= "<th>내용</th>";
					output+= "<th>작성시간</th>";
					output+= "</tr>";
					for(let i in commentList) {
						output+= "<tr>";
						output+= "<td>"+commentList[i].commentNo+"</td>";
						output+= "<td>"+commentList[i].commentWriter+"</td>";
						output+= "<td>"+commentList[i].commentContent+"</td>";
						//output+= "<td>"+commentList[i].commentCreatedTime+"</td>";
						let commentCreatedTime = commentList[i].commentCreatedTime.substring(0, 10)+" ";
							commentCreatedTime += (parseInt(commentList[i].commentCreatedTime.substring(12, 13))+9);
							commentCreatedTime += commentList[i].commentCreatedTime.substring(13, 16);
						output+= "<td>"+commentCreatedTime+"</td>";
						output+= "</tr>";
					}
					output+= "</table>";
					console.log("@# output=>"+output);
				//document.getElementById("comment-list").innerHTML(output);
				$("#comment-list").html(output);
				$("#commentWriter").val("");
				$("#commentContent").val("");

			},
			error: function() {
				console.log("작성실패");
			}
		});
	}
</script>
<script>
	$(document).ready(function(){
		//즉시 실행 함수
		(function(){
			console.log("@# document.ready");
			var boardNo = "<c:out value='${content_view.boardNo }'/>";
			console.log("@# boardNo=>"+boardNo);
			
			$.getJSON("/getFileList", {boardNo:boardNo}, function(arr){
				console.log("@# arr=>"+arr);
				var str = "";
				$(arr).each(function(i, attach){
					if(attach.image) {
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/s_"+attach.uuid+"_"+attach.fileName);
						str += "<li data-filename='"+attach.fileName+"' data-uuid='"+attach.uuid+"' data-path='"+attach.uploadPath+"' data-type='"+attach.image+"'><div>";
						str += "<span>"+attach.fileName+"</span>";
						str += "<img src='/display?fileName="+fileCallPath+"'>" //이미지 출력 처리(컨트롤러단)
						//str += "<span data-file=\'"+fileCallPath+"\'data-type='image'> X </span>"; // 삭제 처리
						str += "</div></li>";
					} else {
						var fileCallPath = encodeURIComponent(attach.uploadPath+"/"+attach.uuid+"_"+attach.fileName);
						str += "<li data-filename='"+attach.fileName+"' data-uuid='"+attach.uuid+"' data-path='"+attach.uploadPath+"' data-type='"+attach.image+"'><div>";
						str += "<span>"+attach.fileName+"</span>";
						str += "<img src='./resources/img/attach.png'>" //고정 이미지(attach.png) 출력 처리(컨트롤러단)
						//str += "<span data-file=\'"+fileCallPath+"\'data-type='file'> X </span>";
						str += "</div></li>";
					}
				}); // and $(arr)
				$(".uploadResult ul").html(str);
			}); //end getJSON
			
			$(".uploadResult").on("click", "li", function(e){
				console.log('click');
				var liObj = $(this);
				console.log("@# liObj.data =>"+JSON.stringify(liObj.data(), null, 2));
				var path = encodeURIComponent(liObj.data("path")+"/"+liObj.data("uuid")+"_"+liObj.data("filename"));
				console.log('@# path=>'+path);
				if(liObj.data("type")) {
					console.log("@# 01");
					console.log("@# view");

					showImage(path);
				} else {
					console.log("@# 02");
					console.log("@# download");
					//컨트롤러 download 호출
					self.location="/download?filename="+path;
				}
			});//end $(".uploadResult").on
			
			function showImage(fileCallPath) {
				$(".bigPicture").css("display","flex").show();
				$(".bigPic").html("<img src='/display?fileName="+fileCallPath+"'>").animate({
					width: "100%",
					height: "100%"
				}, 1000);
			}
			$(".bigPicture").on('click', function(e) {
				$(".bigPic").animate({width: "0%", height: "0%"}, 0);
				setTimeout(() => {
					$(".bigPicture").hide();
				}, 1);// end setTimeout
			});// end $(".bigPicture").on('click' 
		})();
	});// end ready
</script>
</html>