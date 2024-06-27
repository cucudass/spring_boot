<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
		width: 20px;
	}
</style>
<script type="text/javascript" src="${pageContext.request.contextPath}/js/jquery.min.js"></script>
<script>
	function fn_submit() {
		//form 요소 자체
		var formData = $("#frm").serialize();
		$.ajax({
			type: "post",
			data: formData,
			url: "write",
			success: function(data) {
				alert("저장완료");
				location.href="list";
			}, error: function() {
				alert("오류발생");
			}
		});
	}
</script>
</head>
<body>
	<table width="500" border=1>
		<form id="frm" method="post" action="write">
			<tr>
				<td>이름</td>
				<td>
					<input type="text" name="boardName">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
					<input type="text" name="boardTitle">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
					<textarea rows="10" name="boardContent" style="width: 98%"></textarea>
				</td>
			</tr>
			<tr>
				<td colspan="2">
 					<!-- <input type="submit" value="입력"> -->
					<!-- <input type="button" onclick="fn_submit();" value="입력"> -->
					<button type="submit">입력</button>
					&nbsp;&nbsp;
					<a href="list">목록보기</a>
				</td>
			</tr>
		</form>
	</table>
	File Attach
	<!-- 업로드된 파일 출력(화면 레이아웃-->
	<div class="uploadDiv">
		<!-- 업로드 버튼 -->
		<input type="file" name="uploadFile" multiple="multiple">
	</div>
	<div class="uploadResult">
		<ul>
			<!-- 업로드된 파일 출력 공간-->
		</ul>
	</div>
</body>
<script>
	$(document).ready(function(e) { //자바스크립 그룹
		$("button[type='submit']").on('click', function(e) {
			e.preventDefault();
			var formObj = $("form[id='frm']");
			var str = "";
			
			console.log("submit clicked");
			$(".uploadResult ul li").each(function (i, obj) {
				console.log("@# i => " + i);
				console.log("@# obj => "+$(obj));
				console.log("@# obj.data => "+$(obj).data());
				console.log("@# obj.data(file) => "+$(obj).data("filename"));
				console.log("@# obj.data(uuid) => "+$(obj).data("uuid"));
				console.log("@# obj.data(path) => "+$(obj).data("path"));
				console.log("@# obj.data(type) => "+$(obj).data("type"));
				
				var jobj = $(obj);
				//console.dir(): javascript개체의 속성에 대한 목록을 표시
				console.dir(jobj);
				console.log("======================");
				console.log(jobj.data("filename"));
				
				str += "<input type='hidden' name='attachList["+i+"].fileName' value='"+jobj.data("filename")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uuid' value='"+jobj.data("uuid")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].uploadPath' value='"+jobj.data("path")+"'>";
				str += "<input type='hidden' name='attachList["+i+"].image' value='"+jobj.data("type")+"'>";	
				
				console.log("@# str=>"+str);
			}); //end .uploadResult ul li
			formObj.append(str);
			formObj.submit();
		}); // end button submit
		//확장자(exe, sh, alz), 파일크기 조건(5MB 미만)
		//확장자가 exe|sh|alz 인 파일 금지하기 위한 정규식
		var regex = new RegExp("(.*?)\.(exe|sh|alz)$");
		var maxSize = 5242880; //5MB
		//유효성 체크 -> 파일 이름, 파일 크기
		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}

		$("input[type='file']").change(function (e) { //파일이 추가될 때 실행
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files; //파일 정보
			
			for (var i=0; i<files.length; i++) {
				console.log("@# files=>"+files[i].name);

				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}

				formData.append("uploadFile", files[i]);
			}

			$.ajax({
				type: "post",
				data: formData, //파일 정보
				url: "uploadAjaxAction", //컨트롤러단 호출
				processData: false, //기본은 key-value를 Query String으로 전송하는게 true (파일은 false)
				contentType: false, //기본은 application / x-www-from-urlencoded; charset=UTF-8 (파일은 false -> multipart/form-data로 정송)
				success: function(result) { //result->처리결과
					alert("Uploaded");
					console.log(result);
					//파일 정보를 함수로 보냄
					showUploadResult(result);
				}
			}); //end ajax

			function showUploadResult(uploadREsultArr){ //이미지 T/F 따라서 처리
				if(!uploadREsultArr || uploadREsultArr.length == 0) {
					return;
				}

				var uploadUL = $(".uploadResult ul");
				var str = "";

				$(uploadREsultArr).each(function (i, obj) {
					if(obj.image) { //이미지일때
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
						str += "<li data-filename='"+obj.fileName+"' data-uuid='"+obj.uuid+"' data-path='"+obj.uploadPath+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'><div>";
						str += "<span>"+obj.fileName+"</span>";
						str += "<img src='/display?fileName="+fileCallPath+"'>" //이미지 출력 처리(컨트롤러단)
						str += "<span data-file=\'"+fileCallPath+"\'data-type='image'> X </span>"; // 삭제 처리
						str += "</div></li>";
					} else { //이미지 아닐때
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/"+obj.uuid+"_"+obj.fileName);
						str += "<li data-filename='"+obj.fileName+"' data-uuid='"+obj.uuid+"' data-path='"+obj.uploadPath+"' data-filename='"+obj.fileName+"' data-type='"+obj.image+"'<div>";
						str += "<span>"+obj.fileName+"</span>";
						str += "<img src='./resources/img/attach.png'>" //고정 이미지(attach.png) 출력 처리(컨트롤러단)
						str += "<span data-file=\'"+fileCallPath+"\'data-type='file'> X </span>";
						str += "</div></li>";
					}
				}); // end each
				uploadUL.append(str); //파일 목록 출력
			}

			//파일 삭제 ajax 방식으로 컨트롤러단 호출
			$(".uploadResult").on("click", "span", function(){ 
				var targetFile = $(this).data("file");
				var type = $(this).data("type");
				var uploadResultItem = $(this).closest("li");

				console.log("@# targetFile=> "+targetFile);
				console.log("@# type=> "+type);
				console.log("@# uploadResultItem=> "+uploadResultItem);
				
				$.ajax({
					type: "post",
					data: {fileName: targetFile, type: type},
					url: "deleteFile",
					success: function(result) {
						alert(result);
						uploadResultItem.remove();
					}
				}); //end ajax
			}); //end click
		}); // end change
	}); // end ready
	/*
	$(document).ready(function(e) {
		//확장자(exe, sh, alz), 파일크기 조건(5MB 미만)
		//확장자가 exe|sh|alz 인 파일 금지하기 위한 정규식
		var regex = new RegExp("(.*?)\.(exe|sh|alz)$");
		var maxSize = 5242880; //5MB

		function checkExtension(fileName, fileSize) {
			if(fileSize >= maxSize) {
				alert("파일 사이즈 초과");
				return false;
			}
			if(regex.test(fileName)) {
				alert("해당 종류의 파일은 업로드 할 수 없습니다.");
				return false;
			}
			return true;
		}

		$("input[type='file']").change(function (e) {
			var formData = new FormData();
			var inputFile = $("input[name='uploadFile']");
			var files = inputFile[0].files; //파일 정보
			
			for (var i=0; i<files.length; i++) {
				console.log("@# files=>"+files[i].name);

				if(!checkExtension(files[i].name, files[i].size)) {
					return false;
				}

				formData.append("uploadFile", files[i]);
			}

			$.ajax({
				type: "post",
				data: formData,
				url: "uploadAjaxAction", //컨트롤러단 호출
				processData: false, //기본은 key-value를 Query String으로 전송하는게 true (파일은 false)
				contentType: false, //기본은 application / x-www-from-urlencoded; charset=UTF-8 (파일은 false -> multipart/form-data로 정송)
				success: function(result) {
					alert("Uploaded");
					console.log(result);
					//파일 정보를 함수로 보냄
					showUploadResult(result);
				}
			}); //end ajax

			function showUploadResult(uploadREsultArr){
				if(!uploadREsultArr || uploadREsultArr.length == 0) {
					return;
				}

				var uploadUL = $(".uploadResult ul");
				var str = "";

				$(uploadREsultArr).each(function (i, obj) {
					if(obj.image) {
						var fileCallPath = encodeURIComponent(obj.uploadPath+"/s_"+obj.uuid+"_"+obj.fileName);
						str += "<li><div>";
						str += "<span>"+obj.fileName+"</span>";
						str += "<img src='/display?fileName="+fileCallPath.trim()+"'>" //이미지 출력 처리(컨트롤러단)
						str += "</div></li>";
					} else {
						var fileCallPath = obj.uploadPath+obj.uuid+"_"+obj.fileName;
						str += "<li><div>";
						str += "<span>"+obj.fileName+"</span>";
						str += "<img src='./resources/img/attach.png'>" //이미지 출력 처리(컨트롤러단)
						str += "</div></li>";
					}
				}); // end each
				uploadUL.append(str);
			}
		}); // end change
	}); // end ready
	*/
</script>
</html>
