<%--
 * 20252374 최은교
 * 사용자가 작성한 1:1 문의 폼 데이터를 데이터베이스에 최종 저장 처리하는 백엔드 프로세싱 페이지임.
 * 요청 데이터의 한글 깨짐을 방지하기 위해 UTF-8 캐릭터 인코딩을 수립하고 세션에서 현재 글을 쓰는 유저의 고유 ID를 안전하게 적출하는 기능을 제공한다.
 * 추가로, 넘어온 파라미터(제목, 내용, 카테고리)의 무결성을 검증하고 기본값을 보정하여 데이터 바구니 객체(BoardDto)에 빌더 패턴으로 담아내는 기능을 제공한다.
 * 상세로는 비즈니스 서비스 계층(BoardService)의 등록 메서드를 호출하여 최종적으로 데이터베이스에 INSERT 명령을 수행하는 기능을 제공한다.
 * 저장이 성공적으로 완료되면 안내 메시지를 팝업하고 문의 목록 화면(list.jsp)으로 브라우저를 자동 리다이렉트하는 동적 네비게이션 기능을 제공한다.
 *
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.board.BoardDto" %>
<%@ page import="kr.ac.dy.cs.board.BoardService" %>
<%
    // 1. 한글 깨짐 방지 설정
    request.setCharacterEncoding("utf-8");

    // 2. loginSubmit.jsp와 똑같이 "loginId"로 세션을 뽑아옵니다!
    String currentLoginId = (String) session.getAttribute("loginId");

    // 만약 로그인을 안 한 상태로 이 페이지에 튕겨왔다면 로그인 페이지로 보냅니다.
    if (currentLoginId == null || currentLoginId.isEmpty()) {
%>
<script>
    alert('로그인 세션이 없거나 만료되었습니다. 로그인 후 다시 이용해 주세요.');
    location.href = 'auth/login.jsp';
</script>
<%
        return;
    }

    // 3. write.jsp 폼 태그 입력값 가져오기
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String category = request.getParameter("category");

    if (category == null || category.isEmpty()) {
        category = "기타";
    }

    // 4. 데이터 바구니(Dto)에 로그인 세션 아이디(admin)와 함께 담기
    BoardDto dto = BoardDto.builder()
            .userId(currentLoginId) // 여기 진짜 admin이 쏙 들어갑니다.
            .category(category)
            .title(title)
            .content(content)
            .build();

    // 5. 자바 서비스 호출하여 H2 DB에 최종 저장
    BoardService boardService = new BoardService();
    boardService.registerQuestion(dto);
%>
<script>
    alert('고객 문의가 무사히 접수되었습니다!');
    location.href = 'list.jsp';
</script>