package utils;

public class BoardPage {
    // static 메서드. BoardPage.pagingStr() 형식으로 사용가능
    public static String pagingStr(int totalCount, int pageSize, int blockPage, int pageNum, String reqUrl, String searchField, String searchWord) {
        String pagingStr = "";
        //전체 페이지수
        int totalPages = (int) (Math.ceil((double) totalCount / pageSize)); // 실수/정수 => 실수. 나머지가 있으면 올림(ceil)

        // 페이지 블록 시작하는 번호 구하기
        int pageTemp = (((pageNum - 1) / blockPage) * blockPage) + 1;

        // 검색 조건이 있을 경우 URL에 포함시키기
        String searchParam = "";
        if (searchWord != null && !searchWord.isEmpty()) {
            searchParam = "&searchField=" + searchField + "&searchWord=" + searchWord;
        }

        // 첫페이지, 이전 블록 이동 링크
        // pageTemp가 1이 아닌 경우. pageTemp가 1인 경우는 첫번째 블록구간이므로 이전 블록이 없음
        if (pageTemp != 1) {
            pagingStr += "<a href='" + reqUrl + "?pageNum=1" + searchParam + "'>[첫 페이지]</a> ";
            pagingStr += "<a href='" + reqUrl + "?pageNum=" + (pageTemp - 1) + searchParam + "'>[이전 블록]</a>";
        }

        // 페이지 블록 출력.
        int blockCount = 1;
        // blockCount는 1~5. 단 pageTemp는 totalPages보다 클 수 없음
        // pageTemp는 페이지 블록에 출력되는 페이지 번호
        while (blockCount <= blockPage && pageTemp <= totalPages) {
            // pageTemp가 현재 페이지와 같으면
            if (pageTemp == pageNum) {
                // 링크를 걸지 않음
                pagingStr += " " + pageTemp + " ";
            } else {
                pagingStr += " <a href='" + reqUrl + "?pageNum=" + pageTemp + searchParam + "'>" + pageTemp + "</a> ";
            }
            pageTemp++;
            blockCount++;
        }

        // 다음 블록, 마지막 페이지 이동 링크
        // pageTemp가 totalPage 보다 작아야 다음 페이지 블록이 존재함
        if (pageTemp <= totalPages) {
            pagingStr += "<a href='" + reqUrl + "?pageNum=" + pageTemp + searchParam + "'>[다음 블록]</a> ";
            pagingStr += "<a href='" + reqUrl + "?pageNum=" + totalPages + searchParam + "'>[마지막 페이지]</a>";
        }

        return pagingStr;
    }
}
