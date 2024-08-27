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
	function validateForm(form){
		if(form.name.value == ""){
			alert("이름을 입력하세요.");
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
	}
</script>
</head>
<body>
	<div class="form-check form-switch" style="position: absolute; right: 10px">
		<input class="form-check-input" type="checkbox" id="mySwitch" name="darkmode" value="yes" /> 
		<label class="form-check-label" for="mySwitch">Dark Mode</label>
	</div>
	<div class = "container" style="margin-top: 20px"> <!-- 좌우 여백 생김 -->
		<h2>수정하기</h2>
		<form name="writeFrm" method="post" enctype="multipart/form-data" action="/edit.do" onsubmit="return validateForm(this);">
			<input type = "hidden" name="idx" value="${dto.idx}"/>
			<input type = "hidden" name="prevOfile" value="${dto.ofile}"/>
			<input type = "hidden" name="prevSfile" value="${dto.sfile}"/>
			
			<table border="1" width="90%" class="table table-striped">
				<tr>
					<td>작성자</td>
					<td>
						<input type="text" name="name" class="form-control" style="width:150px;" value="${dto.name}" />
					</td>
				</tr>
				<tr>
					<td>제목</td>
					<td>
						<input type="text" name="title" class="form-control" style="width:90%;" value="${dto.title}" />
					</td>
				</tr>
				<tr>
					<td>내용</td>
					<td>
						<textarea name = "content" class="form-control" style="width:90%; height:100px;">${dto.content}</textarea>
					</td>
				</tr>
				<tr>
					<td>첨부 파일</td>
					<td>
						<input type="file" name="ofile" class="form-control" />
					</td>
				</tr>
				<tr>
					<td colspan="2" align="center">
						<button type = "submit" class = "btn btn-primary btn-sm">완료</button>
						<button type = "reset" class = "btn btn-primary btn-sm">취소</button>
						<button type = "button" class = "btn btn-primary btn-sm" onclick="location.href='/list.do';">목록</button>
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