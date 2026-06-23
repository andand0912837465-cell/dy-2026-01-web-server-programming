<%--
 * 학번: 20251246 / 성명: 김나우
 * 마이페이지 내 회원 정보 수정 입력 화면을 제공하는 JSP 클래스임.
 * * [주요 기능 명세]
 * 1. 세션 검증: session 객체에서 "loginId"를 확보하여 유효성을 검증하고, 비로그인 상태 접근 시 강제 차단 및 로그인 페이지(login.jsp)로 리다이렉트 처리함.
 * 2. 데이터 프리셋: MemberService 계층의 getMyPageInfo(loginId) 메서드를 호출하여 데이터베이스로부터 현재 로그인된 회원의 최신 정보(아이디, 이름, 이메일)를 단건 조회함.
 * 3. 폼 바인딩: 조회된 기존 회원 데이터를 각 HTML 입력창(input value)에 자동으로 매핑하여 사용자에게 프리셋 화면으로 출력함.
 * 4. 식별자 보호: 회원 고유 식별자인 아이디(userId) 입력란에는 readonly 속성을 명시하여 임의 변경을 원천 차단함.
 * 5. 보안 인증: 데이터 무결성과 안전한 정보 변경을 보장하기 위해 본인 인증용 현재 비밀번호 입력 영역을 필수 항목으로 배치함.
 * 6. 데이터 전송: 사용자가 입력한 수정 값과 인증 데이터의 유실을 막기 위해 POST 전송 방식을 채택하여 처리 컨트롤러(updateSubmit.jsp)로 양식(Form)을 매핑함.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="kr.ac.dy.cs.member.MemberService" %>
<%@ page import="kr.ac.dy.cs.member.MemberDto" %>

<%--
 * 학번: 20251246 / 성명: 김나우
 * UI 변경 사항
 * 다른 파일들의 배치구조를 따르고 화면에 잘 보이도록 전반적인 수정
 * 수평 대조 레이아웃: 변경 전(기존 데이터 요약)과 변경 후(신규 입력 폼)를 양측에 분리 배치하여 직관성을 높임.
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
    <title>EDIT PROFILE - SHOPMALL</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/main.css">

    <style>
        .dashboard {
            display: flex;
            gap: 60px;
            margin: 60px auto;
            max-width: 1200px;
            min-height: 550px;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            color: #111;
        }
        /* 좌측 서브 메뉴 */
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
        /* 우측 메인 패널 */
        .content-panel {
            flex-grow: 1;
        }
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

        /* 💡 나우 기획: 변경 전 vs 변경 후 대조 섹션 컨테이너 */
        .compare-section {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 35px;
        }
        .compare-card {
            border: 1px solid #eeeeee;
            border-radius: 8px;
            padding: 30px;
        }
        .compare-card.before {
            background: #fafafa; /* 변경 전은 비활성화 톤으로 은은하게 처리 */
        }
        .compare-card h3 {
            font-size: 15px;
            font-weight: 600;
            margin: 0 0 25px 0;
            padding-bottom: 10px;
            border-bottom: 1px solid #eaeaea;
        }
        .compare-card.before h3 { color: #888; }
        .compare-card.after h3 { color: #007bff; }

        /* 폼 내부 필드 정돈 */
        .form-group {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            gap: 6px;
        }
        .form-group label {
            font-size: 12px;
            color: #777;
            font-weight: 600;
        }
        .static-value {
            font-size: 15px;
            color: #555;
            padding: 8px 0;
            font-weight: 500;
        }
        .form-group input[type="text"],
        .form-group input[type="email"],
        .form-group input[type="password"] {
            width: 100%;
            padding: 10px 12px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        .form-group input:focus {
            border-color: #111;
            outline: none;
        }
        .form-group input[readonly] {
            background: #f1f1f1;
            color: #aaa;
            cursor: not-allowed;
            border-color: #eee;
        }

        /* 하단 인증 및 액션 섹션 */
        .auth-footer-zone {
            border-top: 1px solid #eeeeee;
            padding-top: 35px;
            margin-top: 15px;
        }
        .auth-card {
            background: #fff;
            border: 1px solid #eeeeee;
            border-radius: 8px;
            padding: 25px 30px;
            max-width: 500px;
        }
        .btn-group {
            margin-top: 25px;
            display: flex;
            gap: 12px;
        }
        .btn {
            padding: 12px 28px;
            cursor: pointer;
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            border-radius: 6px;
            border: 1px solid #ddd;
            box-sizing: border-box;
            text-align: center;
        }
        .btn-submit {
            background: #111;
            color: #fff;
            border-color: #111;
            transition: background 0.2s;
        }
        .btn-submit:hover {
            background: #333;
        }
        .btn-cancel {
            background: #fff;
            color: #555;
        }
        .btn-cancel:hover {
            background: #f9f9f9;
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
            <li><a href="${pageContext.request.contextPath}/mypage/mypage.jsp">마이페이지</a></li>
            <li><a href="update.jsp" class="active">회원 정보 수정</a></li>
            <li><a href="delete.jsp">회원 탈퇴 신청</a></li>
        </ul>
    </aside>

    <section class="content-panel">
        <% if (member != null) { %>
        <div class="welcome-headline">
            <h1>회원 정보 수정</h1>
            <p>안전한 정보 변경을 위해 현재 데이터를 확인하고 신규 정보를 입력해 주세요.</p>
        </div>

        <form action="updateSubmit.jsp" method="POST">
            <div class="compare-section">

                <div class="compare-card before">
                    <h3>변경 전 (기존 정보)</h3>
                    <div class="form-group">
                        <label>계정 아이디</label>
                        <div class="static-value"><%= member.getUserId() %></div>
                    </div>
                    <div class="form-group">
                        <label>사용자 이름</label>
                        <div class="static-value"><%= member.getUserName() %></div>
                    </div>
                    <div class="form-group">
                        <label>이메일 주소</label>
                        <div class="static-value"><%= member.getEmail() %></div>
                    </div>
                </div>

                <div class="compare-card after">
                    <h3>변경 후 (수정 정보)</h3>
                    <div class="form-group">
                        <label for="userId">아이디 (변경 불가)</label>
                        <input type="text" id="userId" name="userId" value="<%= member.getUserId() %>" readonly>
                    </div>
                    <div class="form-group">
                        <label for="userName">새로운 이름</label>
                        <input type="text" id="userName" name="userName" value="<%= member.getUserName() %>" required>
                    </div>
                    <div class="form-group">
                        <label for="email">새로운 이메일</label>
                        <input type="email" id="email" name="email" value="<%= member.getEmail() %>" required>
                    </div>
                </div>

            </div>

            <div class="auth-footer-zone">
                <div class="auth-card">
                    <div class="form-group">
                        <label for="currentPassword" style="color: #cc0000;">본인 인증 비밀번호</label>
                        <input type="password" id="currentPassword" name="currentPassword" placeholder="현재 계정의 비밀번호를 입력하세요" required>
                    </div>
                    <div class="btn-group">
                        <input type="submit" value="수정 완료" class="btn btn-submit">
                        <a href="mypage.jsp" class="btn btn-cancel">취소</a>
                    </div>
                </div>
            </div>
        </form>

        <% } else { %>
        <div class="error-box">
            회원 정보를 안전하게 로드하지 못해 수정 폼을 구성할 수 없습니다. 다시 시도해 주세요.
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