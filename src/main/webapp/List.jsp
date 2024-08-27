<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix = "c"  %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MVC 게시판</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<style>
	a{
		text-decoration: none; /* 링크 밑줄 없애기 */
	}
    h2 {
        cursor: pointer; /* 커서 모양 변경 */
    }
</style>
</head>
<body>
	<div class="form-check form-switch" style="position: absolute; right: 10px">
		<input class="form-check-input" type="checkbox" id="mySwitch" name="darkmode" value="yes" />
		<label class="form-check-label" for="mySwitch">Dark Mode</label>
	</div>
	<div class = "container" style="margin-top: 20px"> <!-- 좌우 여백 생김 -->
		<h2 onclick="location.href='/list.do';">목록</h2>
		
		<!-- 검색폼 -------------------------------------------------------->
		<form method="get">
			<table width="100%">
				<tr>
					<td align="center">
						<div class="input-group mb-3" style = "width:50%;">
							<select name="searchField" class="form-select">
								<!-- 셀렉박스 -->
								<option value="title" 
									<c:if test="${map.searchField == 'title'}">
									selected</c:if>>제목</option>
								<option value="content" 
									<c:if test="${map.searchField == 'content'}">
									selected</c:if>>내용</option>
								<option value="name" 
									<c:if test="${map.searchField == 'name'}">
									selected</c:if>>작성자</option>
							</select> 
							<input type = "text" name="searchWord" class="form-control" value="${map.searchWord}" style = "width:60%;"/>
							<input class = "btn btn-primary btn-sm" type = "submit" value = "검색" style = "width:10%;"/>
						</div>
					</td>
				</tr>
			</table>
		</form>
		<!-- 검색폼 end -->
		
		
		<table class = "table" border="1" width="90%">
			<tr align = "center">
				<th width="10%">번호</th>
				<th width="*">제목</th>
				<th width="15%">작성자</th>
				<th width="10%">조회수</th>
				<th width="15%">작성일</th>
				<th width="8%">첨부</th>
			</tr>
		<c:choose>
			<c:when test="${empty boardLists}"> <!-- 게시물이 없을 때 -->
			<tr>
				<td colspan="6" align="center">
					등록된 게시물이 없습니다.
				</td>
			</tr>
			</c:when>
			<c:otherwise> <!-- 게시물이 있을 때 -->
			<c:forEach items="${boardLists}" var="row" varStatus="loop"> 
			<tr align="center">
				<td>${row.idx}</td>
				<td align = "left">
					<%-- <a href = "/view.do?idx=${row.idx}">${row.title}</a> --%>
					<a href = "/view.do?idx=${row.idx} + &searchField=${map.searchField}&searchWord=${map.searchWord}">${row.title}</a>
				</td>
				<td>${row.name}</td>
				<td>${row.visitcount}</td>
				<td>${row.postdate}</td>
				<td>
				<c:if test="${not empty row.ofile}">
					<a href="/download.do?ofile=${row.ofile}&sfile=${row.sfile}&idx=${row.idx}">[Down]</a>
				</c:if>
				</td>
			</tr>
			</c:forEach>
			</c:otherwise>
		</c:choose>
		</table>
		
		<!-- 페이지번호. 글쓰기 ---------------------------------------------->
		<table width="100%">
			<tr align = "center">
				<td>
					${map.pagingImg}
				</td>
				<td width="100">
				<button type="button" class="btn btn-primary btn-sm" onclick="location.href='/write.do';">글쓰기</button>
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