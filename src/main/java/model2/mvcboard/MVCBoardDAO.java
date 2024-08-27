package model2.mvcboard;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import common.DBConnPool;

public class MVCBoardDAO extends DBConnPool{ // DBConnPool 상속
	
	public MVCBoardDAO() { // 디폴트 생성자. 생성자가 호출되면 부모 클래스의 생성자 public DBConnPool()가 호출됨.
	}
	
	// 전체 글의 수
	public int selectCount(Map<String, Object> map) {
		int totalCount=0;
		String query = "select count(*) from mvcboard";
		
		// 검색 조건 추가 (selectCount)
		if(map.get("searchWord") != null) {
            query += " WHERE " + map.get("searchField") + " "
                    + " LIKE '%" + map.get("searchWord") + "%'";
		}
		
		try {
			stmt = con.createStatement();
			rs=stmt.executeQuery(query);
			if(rs.next()) {
				totalCount = rs.getInt(1); // count(*)을 의미
			}
		} catch (Exception e) {
			System.out.println("게시물 카운트 중 예외 발생");
			e.printStackTrace();
		}
		return totalCount;
	}
	
	
	// 목록. 페이징 처리
	public List<MVCBoardDTO> selectListPage(Map<String, Object> map){
		List<MVCBoardDTO> board = new ArrayList<MVCBoardDTO>();
		// 쿼리문 작성
		String query = " "
				+ "select * from ( "
				+ "		select tb.*, rownum rNum from ( "
				+ "			select * from mvcboard ";
		
		// 검색 조건 추가 (selectListPage)
		if(map.get("searchWord") != null) {
			query += " where " + map.get("searchField")
					+ " like '%" + map.get("searchWord") + "%' ";
		}
		
		query += "		order by idx desc "
				+ "		) tb "
				+ " ) "
				+ " where rNum between ? and ?";
		
		// DBConnPool에서 변수 선언해놨었음
		try {
			psmt = con.prepareStatement(query); // prepared statement 객체 생성
			psmt.setString(1, map.get("start").toString()); // 첫번째 ?에 값 매핑
			psmt.setString(2, map.get("end").toString()); // 두번째 ?에 값 매핑
			rs = psmt.executeQuery();
			
			while (rs.next()) { // DTO에 쿼리 결과를 저장 // 한행씩
				MVCBoardDTO dto = new MVCBoardDTO();
				
				dto.setIdx(rs.getString("idx")); //getString(열의 인덱스 또는 열이름)
				dto.setName(rs.getString("name"));
				dto.setTitle(rs.getString("title"));
				dto.setContent(rs.getString("content"));
				dto.setPostdate(rs.getDate("postdate"));
				dto.setOfile(rs.getString("ofile"));
				dto.setSfile(rs.getString("sfile"));
				dto.setDowncount(rs.getInt("downcount"));
				dto.setPass(rs.getString("pass"));
				dto.setVisitcount(rs.getInt("visitcount"));
				
				board.add(dto); // list에 한행씩 추가
			}
		} catch (Exception e) {
			System.out.println("게시물 조회 중 예외 발생");
			e.printStackTrace();
		}
		return board; // list를 리턴
	}
	
	
	// 등록. 게시글 데이터를 받아 DB에 추가
	public int insertWrite(MVCBoardDTO dto) {
		int result =0;
		try {
			String query = "insert into mvcboard ( "
					+ " idx, name, title, content, ofile, sfile, pass) "
					+ " values ( "
					+ " seq_board_num.nextval,?,?,?,?,?,?)";
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getName());
			psmt.setString(2, dto.getTitle());
			psmt.setString(3, dto.getContent());
			psmt.setString(4, dto.getOfile());
			psmt.setString(5, dto.getSfile());
			psmt.setString(6, dto.getPass());
			result = psmt.executeUpdate(); // executeUpdate()의 리턴값은 영향을 받은 행의 수
		} catch (Exception e) {
			System.out.println("게시물 입력 중 예외 발생");
			e.printStackTrace();
		}
		return result; // 영향을 받은 행의 수 리턴
	}
	
	
	// 상세보기
	public MVCBoardDTO selectView(String idx) {
		MVCBoardDTO dto = new MVCBoardDTO(); // dto 생성
		String query = "select * from mvcboard where idx = ?"; // idx로 검색
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, idx);
			rs = psmt.executeQuery();
			
			if(rs.next()) { // select한 결과를 DTO 객체에 저장
				dto.setIdx(rs.getString(1)); //getString(열의 인덱스 또는 열이름)
				dto.setName(rs.getString(2));
				dto.setTitle(rs.getString(3));
				dto.setContent(rs.getString(4));
				dto.setPostdate(rs.getDate(5));
				dto.setOfile(rs.getString(6));
				dto.setSfile(rs.getString(7));
				dto.setDowncount(rs.getInt(8));
				dto.setPass(rs.getString(9));
				dto.setVisitcount(rs.getInt(10));
			}
		} catch (Exception e) {
			System.out.println("게시물 상세보기 중 예외 발생");
			e.printStackTrace();
		}
		return dto; // 결과 반환
	}
	
	
	
	// 조회수 증가
	public void updateVisitCount(String idx) {
		String query = "update mvcboard set "
				+ " visitcount = visitcount+1 "
				+ " where idx=?";
		try {
			psmt = con.prepareStatement(query);
			psmt.setString(1, idx);
			psmt.executeQuery();
		} catch (Exception e) {
			System.out.println("게시물 조회수 증가 중 예외 발생");
			e.printStackTrace();
		}
	}
	
	
	
	// 다운로드 횟수 증가
	public void downCountPlus(String idx) {
		String sql = "update mvcboard set "
				+ " downcount=downcount+1 "
				+ " where idx=? ";
		try {
			psmt = con.prepareStatement(sql);
			psmt.setString(1, idx);
			psmt.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	

	// 비밀번호 확인
	public boolean confirmPassword(String pass, String idx) {
		boolean isCorr = true; // 비밀번호 일치 여부 확인 flag
		try {
			String sql = "select count(*) from mvcboard where pass=? and idx=?";
			psmt = con.prepareStatement(sql);
			psmt.setString(1, pass);
			psmt.setString(2, idx);
			rs = psmt.executeQuery();
			rs.next();
			if(rs.getInt(1) == 0) { // count값이 0이면
				isCorr = false; // flag값 false로 변경
			}
		} catch (Exception e) {
			isCorr = false;
			e.printStackTrace();
		}
		return isCorr;
	}
	
	
	// 삭제
	public int deletePost(String idx) {
		int result = 0;
		try {
			String query = "delete from mvcboard where idx=?";
			psmt = con.prepareStatement(query);
			psmt.setString(1, idx);
			result = psmt.executeUpdate(); // 영향을 받은 행의 수 저장
		} catch (Exception e) {
			System.out.println("게시물 삭제 중 예외 발생");
			e.printStackTrace();
		}
		return result;
	}
	
	
	// 수정
	public int updatePost(MVCBoardDTO dto) {
		int result = 0;
		try {
			String query = "update mvcboard"
					+ " set title=?, name=?, content=?, ofile=?, sfile=? "
					+ " where idx=? and pass=?";
			
			psmt = con.prepareStatement(query);
			psmt.setString(1, dto.getTitle());
			psmt.setString(2, dto.getName());
			psmt.setString(3, dto.getContent());
			psmt.setString(4, dto.getOfile());
			psmt.setString(5, dto.getSfile());
			psmt.setString(6, dto.getIdx());
			psmt.setString(7, dto.getPass());
			
			result = psmt.executeUpdate(); // 영향을 받은 행의 수 저장
		} catch (Exception e) {
			System.out.println("게시물 수정 중 예외 발생");
			e.printStackTrace();
		}
		return result;
	}
	
	

	
	
}
