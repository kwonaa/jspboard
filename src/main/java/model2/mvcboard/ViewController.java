package model2.mvcboard;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ViewController
 */
@WebServlet("/view.do")
public class ViewController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public ViewController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		// 게시물 불러오기
		MVCBoardDAO dao = new MVCBoardDAO();
		String idx = request.getParameter("idx"); // 글번호
		String searchField = request.getParameter("searchField");
		String searchWord = request.getParameter("searchWord");
		
		Map<String, String> map = new HashMap<String, String>();
		map.put("searchField", searchField);
		map.put("searchWord", searchWord);
		
		
		dao.updateVisitCount(idx); // 조회수 1 증가
		MVCBoardDTO dto = dao.selectView(idx); // 상세정보
		dao.close();
		
        // 조회수 증가 처리
        boolean visit = false;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if (cookie.getName().equals("visit" + idx)) {
                    visit = true;
                    break;
                }
            }
        }

		/*
		 * if (!visit) { dao.updateVisitCount(idx); Cookie visitCookie = new
		 * Cookie("visit" + idx, "true"); visitCookie.setMaxAge(24 * 60 * 60); // 1 day
		 * response.addCookie(visitCookie); }
		 */	
		
		
		// 줄바꿈문자를 <br>로 변경
		//dto.setContent(dto.getContent().replaceAll("\r\n", "<br/>"));
		
		// 게시물(dto) 저장 후 뷰로 포워드
		request.setAttribute("map", map);
		request.setAttribute("dto", dto); // attribute name "dto"에 dto를 저장
		request.getRequestDispatcher("/View.jsp").forward(request, response); // 포워딩. 주소 변경 안 됨
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
