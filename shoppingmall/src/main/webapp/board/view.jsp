<%--
 * 20252374 최은교
 * 사용자가 작성한 1:1 문의글의 상세 내용과 관리자의 답변을 확인하는 웹 화면 페이지임.
 * 이전 목록 페이지에서 전달된 글 번호(boardNo)를 검증하고 레포지토리를 통해 매칭되는 문의글 레코드를 완벽히 긁어와 출력하는 기능을 제공한다.
 * 추가로, 고객이 선택했던 문의 분류, 작성자 ID, 등록일시와 함께 원본 제목 및 상세 본문 내용을 줄바꿈을 유지하여 온전히 노출하는 기능을 제공한다.
 * 상세로는 해당 문의글의 상태가 '답변완료'일 경우 백오피스 관리자가 작성한 공식 답변 내용(replyContent)을 전용 답변 상자에 실시간 렌더링하는 기능을 제공한다.
 * 아직 답변이 달리지 않은 '답변대기' 상태일 때는 신속한 처리를 약속하는 안내 문구를 유연하게 스위칭하여 보여주는 기능을 제공한다.
 *
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.board.BoardRepository" %>
<%@ page import="kr.ac.dy.cs.board.BoardDto" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // 1. list.jsp에서 넘겨준 글 번호(boardNo)를 안전하게 받습니다.
    String boardNoStr = request.getParameter("boardNo");

    if (boardNoStr == null || boardNoStr.isEmpty()) {
%>
<script>
    alert("잘못된 접근입니다.");
    location.href = "list.jsp";
</script>
<%
        return;
    }

    int boardNo = Integer.parseInt(boardNoStr);

    // 2. [연동 해결] 레포지토리를 직접 호출해서 해당 글 번호의 데이터를 긁어옵니다.
    BoardRepository repository = new BoardRepository();
    BoardDto board = repository.selectByBoardNo(boardNo);

    if (board == null) {
%>
<script>
    alert("존재하지 않거나 삭제된 문의글입니다.");
    location.href = "list.jsp";
</script>
<%
        return;
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SHOPMALL - 문의 내용 상세보기</title>
    <style>
        body { background-color: #f4f6f9; color: #333; font-family: 'Malgun Gothic', sans-serif; margin: 0; padding: 0; }
        .container { max-width: 800px; margin: 50px auto; padding: 0 20px; }
        .view-card { background: white; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); padding: 40px; }

        /* SHOPMALL 로고 스타일 헤더 */
        .view-header { border-bottom: 2px solid #ff6b81; padding-bottom: 15px; margin-bottom: 25px; }
        .view-header h2 { margin: 0 0 10px 0; font-size: 24px; font-family: 'Arial Black', sans-serif; letter-spacing: -1px; }
        .view-header h2 .brand-shop { color: #2c3e50; }
        .view-header h2 .brand-mall { color: #ff6b81; font-weight: bold; }

        /* 글 정보 영역 */
        .info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; background: #f8fafc; padding: 20px; border-radius: 8px; margin-bottom: 25px; font-size: 14px; }
        .info-item { display: flex; }
        .info-item .label { font-weight: bold; color: #747d8c; width: 80px; }
        .info-item .val { color: #2c3e50; }

        /* 제목 및 내용 영역 */
        .post-title { font-size: 20px; font-weight: bold; color: #111; margin-bottom: 20px; border-bottom: 1px solid #e2e8f0; padding-bottom: 15px; }
        .post-content { font-size: 15px; line-height: 1.8; color: #333; min-height: 200px; white-space: pre-wrap; word-break: break-all; margin-bottom: 30px; }

        /* ✨ 새로 추가된 관리자 답변 영역 스타일 */
        .reply-container { margin-top: 30px; border-top: 2px dashed #e2e8f0; padding-top: 30px; }
        .reply-box { background-color: #f8fafc; border-left: 4px solid #2c3e50; border-radius: 4px; padding: 25px; }
        .reply-box .reply-header { font-size: 15px; font-weight: bold; color: #2c3e50; margin-bottom: 12px; display: flex; align-items: center; gap: 6px; }
        .reply-box .reply-content { font-size: 14px; line-height: 1.7; color: #475569; white-space: pre-wrap; word-break: break-all; }
        .reply-waiting { background-color: #fffaf0; border: 1px dashed #ffe0b2; border-radius: 8px; padding: 20px; text-align: center; color: #fb8c00; font-size: 14px; font-weight: 500; }

        /* 하단 버튼 */
        .btn-box { margin-top: 35px; text-align: center; }
        .btn-list { display: inline-block; padding: 12px 35px; background-color: #2c3e50; color: white; text-decoration: none; border-radius: 6px; font-weight: bold; font-size: 15px; transition: background 0.2s; }
        .btn-list:hover { background-color: #1a252f; }
    </style>
</head>
<body>

<div class="container">
    <div class="view-card">
        <div class="view-header">
            <h2><span class="brand-shop">SHOP</span><span class="brand-mall">MALL</span> 1:1 문의 상세 내역</h2>
        </div>

        <!-- 글 정보 (분류, 처리상태, 작성자, 등록일) -->
        <div class="info-grid">
            <div class="info-item"><span class="label">문의분류</span><span class="val"><b style="color:#ff6b81;">[<%= board.getCategory() %>]</b></span></div>
            <div class="info-item"><span class="label">처리상태</span><span class="val"><%= board.getStatus() %></span></div>
            <div class="info-item"><span class="label">작성자</span><span class="val"><%= board.getUserId() %></span></div>
            <div class="info-item"><span class="label">등록일시</span><span class="val"><%= board.getRegDate().format(formatter) %></span></div>
        </div>

        <!-- 실제 입력창에 썼던 제목과 상세 내용 출력 구역! -->
        <div class="post-title">
            <%= board.getTitle() %>
        </div>
        <div class="post-content"><%= board.getContent() %></div>

        <!-- ⭐️ [핵심 추가] 관리자 답변 노출 영역 ⭐️ -->
        <div class="reply-container">
            <% if ("답변완료".equals(board.getStatus()) && board.getReplyContent() != null) { %>
            <!-- 답변이 완료되었을 때 보여주는 카드 -->
            <div class="reply-box">
                <div class="reply-header">💬 SHOPMALL 고객센터 답변</div>
                <div class="reply-content"><%= board.getReplyContent() %></div>
            </div>
            <% } else { %>
            <!-- 아직 답변이 안 달렸을 때 보여주는 안내창 -->
            <div class="reply-waiting">
                ⏳ 고객님의 문의가 접수되었습니다. 담당자가 확인 후 신속하게 답변해 드리겠습니다.
            </div>
            <% } %>
        </div>

        <!-- 목록으로 돌아가기 버튼 -->
        <div class="btn-box">
            <a href="list.jsp" class="btn-list">목록으로 돌아가기</a>
        </div>
    </div>
</div>

</body>
</html>