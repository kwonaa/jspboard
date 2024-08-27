package model2.mvcboard;

import java.sql.Date;

public class MVCBoardDTO {
	// 멤버 변수 선언
	private String idx; // 글번호
	private String name; // 작성자명
	private String title; // 글제목
	private String content; // 글내용
	private Date postdate; // 작성날짜 // java.sql.Date 임포트
    private String ofile; // original file name
    private String sfile; // saved file name
    private int downcount; // 다운로드횟수
    private String pass; // 비밀번호
    private int visitcount; // 조회수
    
    // getter, setter
	public String getIdx() {
		return idx;
	}
	public void setIdx(String idx) {
		this.idx = idx;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getTitle() {
		return title;
	}
	public void setTitle(String title) {
		this.title = title;
	}
	public String getContent() {
		return content;
	}
	public void setContent(String content) {
		this.content = content;
	}
	public Date getPostdate() {
		return postdate;
	}
	public void setPostdate(Date postdate) {
		this.postdate = postdate;
	}
	public String getOfile() {
		return ofile;
	}
	public void setOfile(String ofile) {
		this.ofile = ofile;
	}
	public String getSfile() {
		return sfile;
	}
	public void setSfile(String sfile) {
		this.sfile = sfile;
	}
	public int getDowncount() {
		return downcount;
	}
	public void setDowncount(int downcount) {
		this.downcount = downcount;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public int getVisitcount() {
		return visitcount;
	}
	public void setVisitcount(int visitcount) {
		this.visitcount = visitcount;
	}
    
    
    
}
