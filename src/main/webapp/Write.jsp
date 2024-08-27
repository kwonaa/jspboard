<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script type="text/javascript">
	function validateForm(form) { // 필수 항목 입력 확인
		if(form.name.value == ""){
			alert("작성자를 입력하세요.");
			form.name.focus();
			return false;
		}
		if(form.title.value == ""){
			alert("제목을 입력하세요.");
			form.title.focus();
			return false;
		}
		if(form.content.value == ""){
			alert("내용을 입력하세요.");
			form.content.focus();
			return false;
		}
		if(form.pass.value == ""){
			alert("비밀번호를 입력하세요.");
			form.pass.focus();
			return false;
		}
		
		// 파일 크기 체크
		var inputFile = document.getElementById("file");
		var files = inputFile.files;
		if(files[0].size > 5*1024*1024){ // 첫번재 파일의 크기가 5MB가 초과되면
			alert("파일 크기는 5Mbyte를 초과할 수 없습니다.");
			return false;
		}
	}
</script>
</head>
<body>
	<div class="form-check form-switch" style="position: absolute; right: 10px">
		<input class="form-check-input" type="checkbox" id="mySwitch" name="darkmode" value="yes" /> 
		<label class="form-check-label" for="mySwitch">Dark Mode</label>
	</div>
	<div class = "container" style="margin-top: 20px"> <!-- 좌우 여백 생김 -->
		<h2>글쓰기</h2>
		<form name="writeFrm" method="post" action="/write.do" enctype="multipart/form-data" onsubmit="return validateForm(this);">
			<table border="1" width="90%" class="table table-striped">
				<tr>
					<td>작성자</td>
					<td>
						<input type="text" name="name" class="form-control" style="width:150px;" />
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td>
						<input type="text" name="title" class="form-control" style="width:90%;" />
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea name="content" class="form-control" rows="20" style="width:90%;"></textarea>
					</td>
				</tr>
				<tr>
					<td>첨부 파일</td>
					<td>
						<input type="file" name="ofile" class="form-control" id="file"/>
					</td>
				</tr>
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" name="pass" class="form-control" style="width:100px" />
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center"> <!-- 가로 방향으로 두 칸을 합쳐라 -->
						<button type="submit" class = "btn btn-primary btn-sm">등록</button>
						<button type="reset" class = "btn btn-primary btn-sm">취소</button>
						<button type="button" class = "btn btn-primary btn-sm" onclick="location.href='/list.do';">목록</button>
					</td>
				</tr>
			</table>
		</form>
	</div>
	<script>
		const darkSwitch = document.querySelector("#mySwitch");

		// 페이지 로드 시, darkMode 상태에 따라 초기 설정
		document.addEventListener('DOMContentLoaded', function() {
			const darkMode = getDarkModeCookie(); // 쿠키에서 darkMode 상태 가져오기
			if (darkMode === 'on') {
				enableDarkMode();
			} else {
				disableDarkMode();
			}
		});

		// Dark Mode 토글 처리
		darkSwitch.addEventListener('click', function() {
			if (isChecked()) {
				enableDarkMode();
				setDarkModeCookie('on');
			} else {
				disableDarkMode();
				setDarkModeCookie('off');
			}
		});

		// Dark Mode 상태를 쿠키에 설정하는 함수
		function setDarkModeCookie(mode) {
			$.ajax({
				url: "./DarkModeCookie.jsp",
				type: "post",
				data: { darkMode: mode },
				success: function() {
					console.log("Dark mode cookie set successfully.");
				},
				error: function() {
					console.error("Error setting dark mode cookie.");
				}
			});
		}

		// Dark Mode 상태를 쿠키에서 가져오는 함수
		function getDarkModeCookie() {
			const cookies = document.cookie.split('; ');
			for (let i = 0; i < cookies.length; i++) {
				const cookie = cookies[i].split('=');
				if (cookie[0] === 'DarkMode') {
					return cookie[1];
				}
			}
			return 'off'; // 기본값은 off
		}

		// Dark Mode를 활성화하는 함수
		function enableDarkMode() {
			document.querySelector("html").setAttribute("data-bs-theme", "dark");
		}

		// Dark Mode를 비활성화하는 함수
		function disableDarkMode() {
			document.querySelector("html").setAttribute("data-bs-theme", "");
		}

		// Dark Mode가 현재 활성화되어 있는지 확인하는 함수
		function isChecked() {
			return document.querySelector("#mySwitch").checked;
		}
	</script>
</body>
</html>