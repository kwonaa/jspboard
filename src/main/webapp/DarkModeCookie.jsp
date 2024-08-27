<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String darkMode = request.getParameter("darkMode"); // 클라이언트에서 전송한 다크모드 상태값 가져오기

    if(darkMode != null){
	    // 쿠키 생성
	    Cookie darkModeCookie = new Cookie("darkMode", darkMode);
	    darkModeCookie.setPath(request.getContextPath()); // 쿠키 적용 경로 설정
	    darkModeCookie.setMaxAge(60 * 60 * 24 * 30); // 30일 유효 기간 설정 (초 단위)
	
	    // 쿠키를 응답에 추가
	    response.addCookie(darkModeCookie);
    }
%>
