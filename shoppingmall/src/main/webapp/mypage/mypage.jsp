<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page import="kr.ac.dy.cs.member.MemberDto" %>
<%--
 * 20251246 김나우
 * 로그인한 사용자의 개인정보를 조회하는 마이페이지 메인 클래스임.
 * * 기능 설명:
 * 1. OTP 2차 인증 성공 시 세션에 저장되는 최종 로그인 아이디(loginId)를 확보함.
 * 2. 비로그인 상태로 URL을 통한 강제 진입 시 예외 처리를 통해 로그인 페이지로 리다이렉트함.
 * 3. MemberService 계층의 getMyPageInfo를 호출하여 데이터베이스로부터 최신 회원 정보를 단건 조회함.
 * 4. 조회된 데이터를 테이블 형태로 화면에 출력하며, 내부 기능인 정보 수정(update.jsp) 및 회원 탈퇴(delete.jsp)로 이동할 수 있는 직관적인 UI 구상을 포함함.
--%>
<%--
 * 20251246 김나우 UI수정
 * 유연한 사이드 내비게이션 바와 메인 카드 보드를 분할 배치함.
 * 쿠폰과 주문 조회는 UI만 생성해 놓았습니다.
--%>
<%
  String contextPath = request.getContextPath();
  String loginId = (String) session.getAttribute("loginId");

  if (loginId == null || loginId.trim().isEmpty()) {
%>
<script>
  alert("로그인이 필요한 서비스입니다.");
  location.href = "../auth/login.jsp";
</script>
<%
    return;
  }

  MemberService memberService = new MemberService();
  MemberDto member = memberService.getMyPageInfo(loginId);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>MY ACCOUNT - SHOPMALL</title>
  <link rel="stylesheet" href="<%= contextPath %>/css/main.css">

  <style>
    .dashboard {
      display: flex;
      gap: 60px;
      margin: 60px auto;
      max-width: 1200px;
      min-height: 550px; /* 푸터가 처지는 현상을 방지하는 최소 높이 확보 */
      font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
      color: #111;
    }
    /* 좌측 독자적 서브 메뉴 */
    .sidebar {
      width: 200px;
      flex-shrink: 0;
    }
    .sidebar h3 {
      font-size: 13px;
      letter-spacing: 0.8px;
      color: #999;
      margin-bottom: 18px;
      font-weight: 600;
      text-transform: uppercase;
    }
    .sidebar ul {
      list-style: none;
      padding: 0;
      margin: 0 0 35px 0;
    }
    .sidebar ul li {
      margin-bottom: 14px;
    }
    .sidebar ul li a {
      text-decoration: none;
      color: #666;
      font-size: 14px;
      transition: color 0.15s ease;
    }
    .sidebar ul li a:hover, .sidebar ul li a.active {
      color: #000;
      font-weight: 600;
    }
    /* 우측 메인 대시보드 보드 */
    .content-panel {
      flex-grow: 1;
    }
    /* 웰컴 배너 최상단 배치 */
    .welcome-headline {
      margin-bottom: 40px;
      padding-bottom: 20px;
      border-bottom: 1px solid #f1f1f1;
    }
    .welcome-headline h1 {
      font-size: 26px;
      font-weight: 700;
      margin: 0 0 6px 0;
      letter-spacing: -0.5px;
    }
    .welcome-headline p {
      margin: 0;
      color: #777;
      font-size: 14px;
    }
    /* 모던 카드형 정보 레이아웃 (라운딩 및 내부 여백 조절) */
    .profile-card {
      background: #fafafa;
      border: 1px solid #eeeeee;
      border-radius: 8px; /* 부드러운 곡선 미세 조정 */
      padding: 30px 40px;
      display: grid;
      grid-template-columns: repeat(3, 1fr);
      gap: 20px;
      margin-bottom: 30px;
    }
    .info-field {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }
    .info-field .field-label {
      font-size: 11px;
      color: #999;
      text-transform: uppercase;
      letter-spacing: 0.5px;
      font-weight: 600;
    }
    .info-field .field-value {
      font-size: 15px;
      font-weight: 500;
      color: #111;
    }
    /* 쇼핑몰 전용 미니멀 퀵 대시보드 추가 구획 */
    .quick-status {
      display: grid;
      grid-template-columns: repeat(2, 1fr);
      gap: 20px;
    }
    .status-box {
      border: 1px solid #eeeeee;
      border-radius: 8px;
      padding: 25px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }
    .status-box span {
      font-size: 14px;
      color: #555;
    }
    .status-box strong {
      font-size: 20px;
      font-weight: 600;
      color: #000;
    }
    .error-box {
      padding: 25px;
      background: #fdf2f2;
      border: 1px solid #f5c6cb;
      color: #721c24;
      font-size: 14px;
      border-radius: 6px;
    }
  </style>
</head>
<body data-context-path="<%= contextPath %>">

<div class="top-bar">
  <div class="container">
    <span>오늘도 즐거운 쇼핑 되세요! 무료배송 5만원 이상 ✓</span>
    <div>
      <a href="<%= contextPath %>/auth/logout.jsp">로그아웃</a>
      <a href="<%= contextPath %>/board/list.jsp">고객센터</a>
      <a href="${pageContext.request.contextPath}/mypage/mypage.jsp" class="active">마이페이지</a>
    </div>
  </div>
</div>

<header>
  <div class="container header-inner">
    <a href="<%= contextPath %>/index.jsp" class="logo">SHOP<span>MALL</span></a>
    <div class="search-box">
      <label for="search" class="sr-only">상품 검색</label>
      <input id="search" type="text" placeholder="마이페이지 내에서는 상품 검색이 제한됩니다" disabled>
      <button type="button" aria-label="검색" disabled>Q</button>
    </div>
    <div class="header-icons">
      <a href="<%= contextPath %>/wishlist.jsp" class="icon-btn"><div class="icon">♥</div>찜</a>
      <a href="<%= contextPath %>/cart/cart.jsp" class="icon-btn"><div class="icon">🛒</div>장바구니</a>
      <div class="icon-btn"><div class="icon">i</div>My</div>
    </div>
  </div>
</header>

<main class="dashboard">

  <aside class="sidebar">
    <h3>쇼핑 정보</h3>
    <ul>
      <li><a href="#">주문/배송 조회</a></li>
      <li><a href="<%= contextPath %>/cart/cart.jsp">장바구니 관리</a></li>
      <li><a href="<%= contextPath %>/wishlist.jsp">나의 찜 목록</a></li>
    </ul>

    <h3>내 정보 관리</h3>
    <ul>
      <li><a href="${pageContext.request.contextPath}/mypage/mypage.jsp" class="active">마이페이지</a></li>
      <li><a href="update.jsp">회원 정보 수정</a></li>
      <li><a href="delete.jsp">회원 탈퇴 신청</a></li>
    </ul>
  </aside>

  <section class="content-panel">
    <% if (member != null) { %>
    <div class="welcome-headline">
      <h1>안녕하세요, <%= member.getUserName() %>님!</h1>
      <p>SHOPMALL 가입 정보 및 계정 보안 설정을 이곳에서 통합 관리할 수 있습니다.</p>
    </div>

    <div class="profile-card">
      <div class="info-field">
        <span class="field-label">계정 아이디</span>
        <span class="field-value"><%= member.getUserId() %></span>
      </div>
      <div class="info-field">
        <span class="field-label">사용자 이름</span>
        <span class="field-value"><%= member.getUserName() %></span>
      </div>
      <div class="info-field">
        <span class="field-label">이메일 주소</span>
        <span class="field-value"><%= member.getEmail() %></span>
      </div>
    </div>

    <div class="quick-status">
      <div class="status-box">
        <span>진행 중인 주문 / 배송 건수</span>
        <strong>0</strong>
      </div>
      <div class="status-box">
        <span>사용 가능한 쿠폰</span>
        <strong>0 장</strong>
      </div>
    </div>

    <% } else { %>
    <div class="error-box">
      회원 정보를 안전하게 로드하지 못했습니다. 지속적인 문제 발생 시 고객센터에 문의 바랍니다.
    </div>
    <% } %>
  </section>
</main>

<footer>
  <div class="container">
    <div class="footer-grid">
      <div>
        <h4>SHOPMALL</h4>
        <p>당신의 라이프 스타일을 완성하는 쇼핑몰<br>고객님의 만족이 저희의 행복입니다.</p>
        <p class="footer-contact">고객센터: 1588-0000<br>평일 09:00 ~ 18:00 (주말/공휴일 휴무)</p>
      </div>
      <div>
        <h4>MY ACCOUNT</h4>
        <ul>
          <li><a href="${pageContext.request.contextPath}/mypage/mypage.jsp" style="color:#aaa; text-decoration:none;">마이페이지</a></li>
          <li>장바구니</li>
          <li>위시리스트</li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">© 2026 SHOPMALL. All rights reserved.</div>
  </div>
</footer>

</body>
</html>