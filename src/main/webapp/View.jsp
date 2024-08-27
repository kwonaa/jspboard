<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c" %>
<jsp:useBean id="dto" class="model2.mvcboard.MVCBoardDTO" scope="request" />
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
	<div class="form-check form-switch" style="position: absolute; right: 10px">
		<input class="form-check-input" type="checkbox" id="mySwitch" name="darkmode" value="yes" /> 
		<label class="form-check-label" for="mySwitch">Dark Mode</label>
	</div>
	<div class = "container" style="margin-top: 20px; "> <!-- 좌우 여백 생김 -->
		<h2>상세보기</h2>
		
		<table border="1" width="90%" class="table table-striped">
			<colgroup>
				<col width="15%"/><col width="35%"/>
				<col width="15%"/><col width="*"/>
			</colgroup>
			
			<!-- 게시글 정보 -->
			<tr>
				<td>번호</td><td>${dto.idx}</td>
				<td>작성자</td><td>${dto.name}</td>
			</tr>
			<tr>
				<td>작성일</td><td>${dto.postdate}</td>
				<td>조회수</td><td>${dto.visitcount}</td>
			</tr>
			<tr>
				<td>제목</td>
				<td colspan="3">${dto.title}</td>
			</tr>
			<tr>
				<td>내용</td>
				<td colspan="3" height="100">${dto.content}</td>
			</tr>
			
			<!-- 첨부파일 -->
			<tr>
				<td>첨부파일</td>
				<td>
					<c:if test="${not empty dto.ofile}">
						${dto.ofile}
						<a href="/download.do?ofile=${dto.ofile}&sfile=${dto.sfile}&idx=${dto.idx}">[다운로드]</a>
					</c:if>
				</td>
				<td>다운로드수</td>
				<td>${dto.downcount}</td>
			</tr>
			
			<!-- 하단 메뉴 (버튼) -->
			<tr>
			    <td colspan="4" align="center">
			        <button type = "button" class="btn btn-primary" onclick = "location.href='/pass.do?mode=edit&idx=${param.idx}';">수정</button>
			        <button type = "button" class="btn btn-primary" onclick = "location.href='/pass.do?mode=delete&idx=${param.idx}';">삭제</button>
			        <c:choose>
			            <c:when test="${map.searchField != null && map.searchWord != null}">
			                <button type = "button" class="btn btn-primary" onclick = "location.href='/list.do?searchField=${map.searchField}&searchWord=${map.searchWord}';">목록</button>
			            </c:when>
			            <c:otherwise>
			                <button type = "button" class="btn btn-primary" onclick = "location.href='/list.do';">목록</button>
			            </c:otherwise>
			        </c:choose>
			    </td>
			</tr>

		</table>
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