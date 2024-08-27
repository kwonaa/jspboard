package model2.mvcboard;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.oreilly.servlet.MultipartRequest;

import fileupload.FileUtil;
import utils.JSFunction;

/**
 * Servlet implementation class EditController
 */
@WebServlet("/edit.do")
public class EditController extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public EditController() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String idx = request.getParameter("idx"); // 글번호
		MVCBoardDAO dao = new MVCBoardDAO(); // dao 생성
		MVCBoardDTO dto = dao.selectView(idx); // 상세정보 dto에 저장
		request.setAttribute("dto", dto); // "dto" attribute name으로 전달
		request.getRequestDispatcher("/Edit.jsp").forward(request, response); // view로 포워딩. 주소 변경 없음.
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// 1. 파일 업로드 처리
		// 업로드 디렉터리의 물리적 경로 확인
		String saveDirectory = request.getServletContext().getRealPath("/Uploads"); // webapp 안에 Uploads 폴더 만들어야 함
		int maxPostSize = 5*1024*1024; // 첨부파일 최대 크기 5MB로 지정
		MultipartRequest mr = FileUtil.uploadFile(request, saveDirectory, maxPostSize); // 파일 업로드
		if (mr == null) {
            // 파일 업로드 실패
            JSFunction.alertBack(response, "첨부 파일이 제한 용량을 초과합니다.");
            return;
        }
		
		// 2. 파일 업로드 외 처리
		// 수정 내용을 매개변수에서 얻어옴
		String idx = mr.getParameter("idx");
		String prevOfile = mr.getParameter("prevOfile");
		String prevSfile = mr.getParameter("prevSfile");
		String name = mr.getParameter("name");
		String title = mr.getParameter("title");
		String content = mr.getParameter("content");
		
		// 비밀번호는 session에서 가져옴
		HttpSession session = request.getSession();
		String pass = (String)session.getAttribute("pass");
		
		// 폼에 입력한 값을 DTO에 저장
		MVCBoardDTO dto = new MVCBoardDTO();
		dto.setIdx(idx);
		dto.setName(name);
		dto.setTitle(title);
		dto.setContent(content);
		dto.setPass(pass);
		
		// 원본 파일명과 저장된 파일 이름 설정 // 업로드된 원본파일명을 변경해서 중복방지
		String fileName = mr.getFilesystemName("ofile");
		if(fileName != null) {
			// 첨부 파일이 있을 경우 파일명 변경
			// 새로운 파일명 생성
			String now = new SimpleDateFormat("yyyyMMdd_HmsS").format(new Date());
            String ext = fileName.substring(fileName.lastIndexOf("."));
            String newFileName = now + ext;

            // 파일명 변경
            File oldFile = new File(saveDirectory + File.separator + fileName);
            File newFile = new File(saveDirectory + File.separator + newFileName);
            oldFile.renameTo(newFile);
            
            // DTO에 저장
            dto.setOfile(fileName); // 원래 파일 이름
            dto.setSfile(newFileName); // 서버에 저장된 파일 이름
            
            // 기존 파일 삭제
            FileUtil.deleteFile(request, "/Uploads", prevSfile);
		} else {
			// 첨부 파일이 없으면 기존 이름 유지
			dto.setOfile(prevOfile);
			dto.setSfile(prevSfile);
		}
		
		// DB에 수정 내용 반영
		MVCBoardDAO dao = new MVCBoardDAO();
		int result = dao.updatePost(dto);
		dao.close();
		
		// 성공 or 실패
		if(result == 1) { // 수정 성공
			session.removeAttribute("pass");
			response.sendRedirect("/view.do?idx="+idx);	
		} else {
			JSFunction.alertLocation(response, "비밀번호 검증을 다시 진행해주세요.", "/view.do?idx="+idx);
		}
	}
}
