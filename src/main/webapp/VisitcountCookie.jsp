<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String visitcount = request.getParameter("visitcount");

    // 쿠키 생성
    Cookie visitcountCookie = new Cookie("Visitcount", visitcount);
    visitcountCookie.setPath(request.getContextPath()); // 쿠키 적용 경로 설정
    visitcountCookie.setMaxAge(60 * 60 * 24 * 30); // 30일 유효 기간 설정 (초 단위)

    // 쿠키를 응답에 추가
    response.addCookie(visitcountCookie);
%>