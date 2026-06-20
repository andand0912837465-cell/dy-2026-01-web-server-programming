<%--
 * 20252374 최은교
 * 백오피스 관리자 전용 1:1 고객 문의글 상세 조회 및 답변 등록 웹 화면 페이지임[cite: 31, 57].
 * 특정 문의글 번호(boardNo)를 기반으로 고객이 남긴 카테고리, 제목, 질문 내용 및 접수 시간을 화면에 온전히 뿌려주는 기능을 제공한다[cite: 34, 35, 56].
 * 추가로, 하단 폼 영역에서 관리자가 작성한 실시간 텍스트 내용을 POST 방식으로 받아 DB 내부의 원본 데이터를 안전하게 업데이트하는 기능을 제공한다[cite: 36, 37, 57].
 * 상세로는 답변 등록이 완료되었을 때 브라우저 경고창(Alert)을 띄우고 다시 관리 목록 페이지로 리다이렉트하는 유저 피드백 기능을 제공한다[cite: 38].
 * 텍스트 입력창(textarea) 안에 이미 등록되었던 이전 답변 내역을 세팅하여 수정 및 상시 재조회가 용이하도록 돕는 기능을 제공한다[cite: 57, 58].
 *
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.board.BoardService" %>
<%@ page import="kr.ac.dy.cs.board.BoardDto" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%
  if (!SessionUtils.isLoginYn(session)) {
    response.sendRedirect("/auth/adminLogin.jsp");
    return;
  }

  String loginId = (String) session.getAttribute("loginId");
  Date loginAt = (Date) session.getAttribute("loginAt");
  String loginAtStr = loginAt != null ?
          new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(loginAt) : "-";
  String nowStr = new SimpleDateFormat("yyyy년 MM월 dd일 (E) HH:mm", java.util.Locale.KOREAN).format(new Date());

  String boardNoStr = request.getParameter("boardNo");
  if (boardNoStr == null || boardNoStr.isEmpty()) {
    response.sendRedirect("adminList.jsp");
    return;
  }

  int boardNo = Integer.parseInt(boardNoStr);
  BoardService boardService = new BoardService();
  BoardDto board = boardService.getQuestionDetail(boardNo);

  if (board == null) {
%>
<script>
  alert("존재하지 않는 문의글입니다.");
  location.href = "adminList.jsp";
</script>
<%
    return;
  }

  // 답변 처리 POST 로직
  if ("POST".equalsIgnoreCase(request.getMethod())) {
    request.setCharacterEncoding("utf-8");
    String replyContent = request.getParameter("replyContent");

    if (replyContent != null && !replyContent.trim().isEmpty()) {
      boardService.answerQuestion(boardNo, replyContent);
%>
<script>
  alert("답변이 정상 등록되었습니다.");
  location.href = "adminList.jsp";
</script>
<%
      return;
    }
  }

  java.util.Date regDate = java.sql.Timestamp.valueOf(board.getRegDate());
  String regDateStr = new SimpleDateFormat("yyyy-MM-dd HH:mm").format(regDate);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>문의 상세 및 답변 - SHOPMALL ADMIN</title>
  <link rel="stylesheet" href="/css/main.css">
  <style>
    .view-detail-box { padding: 10px 5px;
    }
    .meta-info-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; background: #f8fafc; padding: 20px; border-radius: 8px;
      margin-bottom: 25px; font-size: 14px; border: 1px solid #edf2f7; }
    .meta-item { display: flex;
    }
    .meta-item .lbl { font-weight: bold; color: #64748b; width: 90px;
    }
    .meta-item .val { color: #1e293b; }

    .origin-title { font-size: 18px; font-weight: bold;
      color: #0f172a; margin-bottom: 15px; padding-bottom: 15px; border-bottom: 1px solid #e2e8f0; }
    .origin-content { font-size: 15px; line-height: 1.7;
      color: #334155; min-height: 120px; white-space: pre-wrap; margin-bottom: 30px; }

    .reply-form-section { background: #fafafa; border: 1px solid #e2e8f0;
      border-radius: 8px; padding: 25px; }
    .reply-form-section h4 { margin-top: 0; margin-bottom: 15px; font-size: 15px; color: #1e293b;
    }
    .reply-input { width: 100%; min-height: 120px; padding: 15px; border: 1px solid #cbd5e1; border-radius: 6px; box-sizing: border-box;
      font-family: inherit; font-size: 14px; resize: none; }
    .reply-input:focus { border-color: #7c5cfc; outline: none;
    }

    .action-btns { margin-top: 20px; text-align: center; display: flex; gap: 10px; justify-content: flex-end;
    }
    .btn-action { padding: 10px 24px; border: none; border-radius: 6px; font-size: 14px; font-weight: bold; cursor: pointer;
      text-decoration: none; display: inline-block; }
    .btn-action.submit { background-color: #7c5cfc; color: white;
    }
    .btn-action.submit:hover { background-color: #6346e0; }
    .btn-action.back { background-color: #94a3b8; color: white;
    }
    .btn-action.back:hover { background-color: #64748b; }
  </style>
</head>
<body class="dashboard-page">

<aside class="dash-sidebar">
  <div class="dash-logo"><a href="/dashboard/index.jsp">SHOP<span>MALL</span></a><div class="dash-logo-sub">ADMIN CONSOLE</div></div>
  <nav class="dash-nav">
    <div class="nav-group">
      <div class="nav-group-title">MAIN</div>
      <a href="/dashboard/index.jsp" class="nav-item"><span class="nav-icon">▦</span> 대시보드</a>
    </div>
    <div class="nav-group">
      <div class="nav-group-title">운영</div>
      <a href="#" class="nav-item"><span class="nav-icon">📦</span> 상품 관리</a>
      <a href="#" class="nav-item"><span class="nav-icon">🛒</span> 주문 관리</a>
      <a href="/member/list.jsp" class="nav-item"><span class="nav-icon">👥</span> 회원 관리</a>
      <a href="/board/adminList.jsp" class="nav-item active"><span class="nav-icon">💬</span> 문의글 관리</a>
      <a href="/notice/list.jsp" class="nav-item"><span class="nav-icon">📢</span> 공지사항 관리</a>
      <a href="#" class="nav-item"><span class="nav-icon">🎁</span> 프로모션</a>
    </div>
  </nav>
  <div class="dash-sidebar-foot">© 2026 SHOPMALL ADMIN</div>
</aside>

<main class="dash-main">
  <header class="dash-topbar">
    <div class="dash-page-title"><h1>문의글 상세보기</h1><p><%= nowStr %></p></div>
    <div class="dash-user">
      <div class="dash-user-info"><span class="dash-user-id"><strong><%= loginId %></strong>님</span></div>
      <div class="dash-user-avatar"><%= loginId.substring(0, 1).toUpperCase() %></div>
    </div>
  </header>

  <section class="dash-panel" style="margin-top: 20px;">
    <div class="view-detail-box">
      <div class="meta-info-grid">
        <div class="meta-item"><span class="lbl">문의 구분</span><span class="val"><%= board.getCategory() %></span></div>
        <div class="meta-item"><span class="lbl">처리 상태</span><span class="val"><%= board.getStatus() %></span></div>
        <div class="meta-item"><span class="lbl">작성자 ID</span><span class="val"><code><%= board.getUserId() %></code></span></div>
        <div class="meta-item"><span class="lbl">접수 일시</span><span class="val"><%= regDateStr %></span></div>
      </div>

      <div class="origin-title">제목: <%= board.getTitle() %></div>
      <div class="origin-content"><%= board.getContent() %></div>

      <div class="reply-form-section">
        <h4>✍️ 관리자 답변 달기</h4>
        <form method="post">
          <textarea name="replyContent" class="reply-input" placeholder="고객에게 전달할 공식 답변을 입력하세요..."><%= board.getReplyContent() != null ? board.getReplyContent() : "" %></textarea>
          <div class="action-btns">
            <a href="adminList.jsp" class="btn-action back">목록으로</a>
            <button type="submit" class="btn-action submit">답변 등록</button>
          </div>
        </form>
      </div>
    </div>
  </section>
</main>

</body>
</html>