package utils;

import java.io.PrintWriter;

import javax.servlet.http.HttpServletResponse;

// js를 실행하는 클래스
public class JSFunction {
	// alert 출력
	// 메시지 알림창을 띄운 후 명시한 url로 이동
	public static void alertLocation(HttpServletResponse response, String msg, String url) {
		try {
			response.setContentType("text/html;charset=UTF-8"); // 한글 인코딩
			PrintWriter writer = response.getWriter();
			String script = ""
					+ "<script>"
					+ "		alert('"+msg+"');"
					+ "		location.href='"+url+"';"
					+ "</script>";
			writer.print(script); // js 코드를 클라이언트 브라우저로 전송해서 실행함.
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
	// alert 출력 후 이전 페이지로 이동
	public static void alertBack(HttpServletResponse response, String msg) {
		try {
			response.setContentType("text/html; charset=UTF-8");
			PrintWriter writer = response.getWriter();
			String script = ""
						  + "<script>"
						  + "	alert('"+msg+"');"
						  + "	history.back();"
						  + "</script>";
			writer.print(script);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	
}
