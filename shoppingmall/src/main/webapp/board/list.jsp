<%--
 * 20252374 최은교
 * 쇼핑몰 사용자의 1:1 문의글 목록을 보여주는 웹 화면 페이지임.
 * 세션에 저장된 로그인 정보를 기반으로 현재 접속한 회원이 과거에 작성했던 1:1 문의 내역만 필터링하여 리스트 형태로 보여주는 기능을 제공한다.
 * 추가로, 접수된 문의의 유형(카테고리), 제목, 등록일을 출력하고 관리자의 답변 여부에 따라 '답변대기' 또는 '답변완료' 배지를 다르게 시각화하는 기능을 제공한다.
 * 상세로는 가상 번호 계산 알고리즘을 적용하여 게시글 번호를 최신순(역순)으로 정렬하여 사용자에게 직관적으로 제공하는 기능을 제공한다.
 * 제목 클릭 시 글 고유 번호(boardNo)를 파라미터로 지참하여 상세 내역 페이지(view.jsp)로 이동하는 링크 기능을 제공한다.
 *
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="kr.ac.dy.cs.board.BoardService" %>
<%@ page import="kr.ac.dy.cs.board.BoardDto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.format.DateTimeFormatter" %>
<%
    // 1. 현재 로그인한 회원의 세션 아이디를 가져옵니다.
    String currentLoginId = (String) session.getAttribute("loginId");
    boolean isLogin = (currentLoginId != null && !currentLoginId.isEmpty());

    // 2. 로그인된 경우에만 본인의 문의 내역을 긁어옵니다.
    List<BoardDto> boardList = null;
    if (isLogin) {
        BoardService boardService = new BoardService();
        boardList = boardService.getMyQuestions(currentLoginId);
    }

    DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SHOPMALL - 고객센터</title>
    <style>
        body { background-color: #f4f6f9; color: #333; font-family: 'Malgun Gothic', sans-serif; margin: 0; padding: 0; }
        .container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }

        /* 상단 SHOPMALL 로고 감성 타이틀 배너 */
        .search-banner {
            text-align: center;
            padding: 50px 0;
            background: #fff;
            border-bottom: 1px solid #e2e8f0;
            margin-bottom: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
        }
        /* 로고 글자 느낌 그대로 굵직하게 스타일 적용 */
        .search-banner h1 {
            font-size: 38px;
            margin: 0 0 12px 0;
            font-family: 'Arial Black', 'Impact', sans-serif;
            letter-spacing: -1px;
        }
        .search-banner h1 .brand-shop {
            color: #2c3e50; /* SHOP 부분의 세련된 다크 그레이 */
        }
        .search-banner h1 .brand-mall {
            color: #ff6b81; /* MALL 부분의 화사한 코랄 핑크 */
            font-weight: bold;
        }
        .search-banner p {
            color: #747d8c;
            font-size: 15px;
            margin: 0;
            font-weight: 500;
        }

        /* 로그인 안내 띠 배너 */
        .login-alert-banner { background-color: #fff0f2; border: 1px solid #ffe0e6; padding: 15px; border-radius: 8px; text-align: center; font-size: 15px; color: #ff6b81; margin-bottom: 35px; font-weight: bold; }
        .btn-mini-login { display: inline-block; padding: 6px 16px; background-color: #ff6b81; color: white; text-decoration: none; border-radius: 20px; margin-left: 10px; font-size: 13px; }

        /* FAQ 카테고리 동그라미 아이콘 구역 */
        .faq-categories { display: flex; justify-content: space-between; margin-bottom: 40px; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .category-item { text-align: center; flex: 1; cursor: pointer; text-decoration: none; color: #333; }
        .icon-circle { width: 70px; height: 70px; background-color: #f8fafc; border: 1px solid #e2e8f0; border-radius: 50%; margin: 0 auto 12px auto; display: flex; align-items: center; justify-content: center; font-size: 24px; transition: all 0.2s; }

        /* 마우스 올렸을 때 브랜드 컬러(코랄 핑크)로 하이라이트 효과! */
        .category-item:hover .icon-circle {
            background-color: #ff6b81;
            color: white;
            border-color: #ff6b81;
            transform: translateY(-5px);
        }
        .category-item span { font-size: 14px; font-weight: 500; }

        /* 하단 2분할 레이아웃 (좌: 나의 문의내역 / 우: 1:1 상담 안내) */
        .cs-bottom-section { display: flex; gap: 30px; }
        .left-box { flex: 2; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); }
        .right-box { flex: 1; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 12px rgba(0,0,0,0.03); display: flex; flex-direction: column; justify-content: space-between; }

        .section-title { font-size: 18px; font-weight: bold; margin-top: 0; margin-bottom: 20px; color: #111; display: flex; align-items: center; gap: 8px; }
        .user-tag { font-size: 13px; color: #ff6b81; margin-left: 8px; font-weight: normal; }

        /* 문의내역 테이블 스타일 */
        .board-table { width: 100%; border-collapse: collapse; font-size: 14px; }
        .board-table th { background-color: #f8fafc; color: #475569; padding: 12px; border-bottom: 1px solid #e2e8f0; font-weight: 600; }
        .board-table td { padding: 14px 12px; border-bottom: 1px solid #f1f5f9; text-align: center; color: #334155; }
        .board-table td.title-cell { text-align: left; font-weight: 500; }
        .board-table td a { text-decoration: none; color: #334155; }
        .board-table td a:hover { color: #ff6b81; }

        .status-badge { display: inline-block; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; background-color: #e2e8f0; color: #475569; }
        .status-badge.waiting { background-color: #fff2e6; color: #ff8c00; }

        /* 우측 1:1 상담 안내 및 대형 문의 버튼 (로고의 짙은 네이비 블루 계열 매칭) */
        .info-txt { font-size: 14px; color: #666; line-height: 1.6; margin-bottom: 20px; }
        .btn-big-write { display: flex; align-items: center; justify-content: center; height: 55px; background-color: #2c3e50; color: white; text-decoration: none; border-radius: 8px; font-size: 16px; font-weight: bold; transition: background 0.2s; }
        .btn-big-write:hover { background-color: #1a252f; }
    </style>
</head>
<body>

<div class="container">

    <div class="search-banner">
        <h1>
            <span class="brand-shop">SHOP</span><span class="brand-mall">MALL</span>이 도와드릴게요!
        </h1>
        <p>자주 묻는 질문을 확인하거나 1:1 상담을 이용해 보세요.</p>
    </div>

    <% if (!isLogin) { %>
    <div class="login-alert-banner">
        🔒 로그인하시면 본인의 1:1 문의 내역을 안전하게 확인하실 수 있습니다.
        <a href="/auth/login.jsp" class="btn-mini-login">로그인</a>
    </div>
    <% } %>

    <div class="faq-categories">
        <a href="#" class="category-item"><div class="icon-circle">👑</div><span>멤버십</span></a>
        <a href="#" class="category-item"><div class="icon-circle">👤</div><span>회원정보</span></a>
        <a href="#" class="category-item"><div class="icon-circle">🎫</div><span>쿠폰/혜택</span></a>
        <a href="#" class="category-item"><div class="icon-circle">💳</div><span>주문/결제</span></a>
        <a href="#" class="category-item"><div class="icon-circle">🚚</div><span>배송문의</span></a>
        <a href="#" class="category-item"><div class="icon-circle">🔄</div><span>취소/반품</span></a>
        <a href="#" class="category-item"><div class="icon-circle">🔒</div><span>안전거래</span></a>
    </div>

    <div class="cs-bottom-section">

        <div class="left-box">
            <div class="section-title">
                📋 나의 문의 내역
                <% if(isLogin) { %>
                <span class="user-tag">(👤 <%= currentLoginId %>님 계정)</span>
                <% } %>
            </div>

            <table class="board-table">
                <thead>
                <tr>
                    <th width="12%">번호</th>
                    <th width="18%">상태</th>
                    <th width="45%">문의 제목</th>
                    <th width="25%">작성일</th>
                </tr>
                </thead>
                <tbody>
                <% if (!isLogin) { %>
                <tr>
                    <td colspan="4" style="padding: 40px; color: #999;">로그인 후 문의 내역 조회가 가능합니다.</td>
                </tr>
                <% } else if (boardList == null || boardList.isEmpty()) { %>
                <tr>
                    <td colspan="4" style="padding: 40px; color: #999;">접수하신 1:1 문의 내역이 없습니다.</td>
                </tr>
                <% } else { %>
                <%
                    // ✨ 전체 리스트 개수를 미리 구해둡니다. (예: 내 글이 3개면 3)
                    int totalCount = boardList.size();

                    // 인덱스로 역순 가상 번호를 뽑기 위해 기본 for 루프로 변경했습니다.
                    for (int i = 0; i < boardList.size(); i++) {
                        BoardDto board = boardList.get(i);

                        // ✨ 전체 개수에서 현재 반복 도는 숫자(i)를 빼서 순서대로 '3, 2, 1'이 나오도록 계산합니다.
                        int virtualNo = totalCount - i;
                %>
                <tr>
                    <td><%= virtualNo %></td>
                    <td>
                        <% if ("답변대기".equals(board.getStatus())) { %>
                        <span class="status-badge waiting">답변대기</span>
                        <% } else { %>
                        <span class="status-badge">답변완료</span>
                        <% } %>
                    </td>
                    <td class="title-cell">
                        <a href="view.jsp?boardNo=<%= board.getBoardNo() %>"><%= board.getTitle() %></a>
                    </td>
                    <td><%= board.getRegDate().format(formatter) %></td>
                </tr>
                <% } %>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="right-box">
            <div>
                <div class="section-title">💬 1:1 상담 안내</div>
                <div class="info-txt">
                    고객센터 운영시간: 평일 09:00 ~ 18:00<br>
                    (토/일/공휴일 휴무)<br><br>
                    불편하신 사항을 남겨주시면 담당자가 확인 후 평일 기준 24시간 이내에 친절하고 신속하게 답변해 드리겠습니다.
                </div>
            </div>

            <a href="write.jsp" class="btn-big-write">문의글 작성 ➔</a>
        </div>

    </div>

</div>

</body>
</html>