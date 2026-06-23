<%--
 * 학번: 20251246 / 성명: 김나우
 * 회원 탈퇴 전 본인 인증 및 최종 동의를 받는 입력 화면 JSP 클래스임.
 * * [주요 기능 명세]
 * 1. 세션 검증: session에서 "loginId"를 확보하여 비로그인 사용자의 주소창 강제 접근을 원천 차단함.
 * 2. 보안 인증: 탈퇴의 민감성을 고려하여 현재 비밀번호를 다시 한번 입력받아 본인 인증 데이터로 매핑함.
 * 3. 폼 전송: 사용자 입력 값과 탈퇴 의사를 POST 방식으로 처리 컨트롤러(deleteSubmit.jsp)에 안전하게 전송함.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%--
 * 학번: 20251246 / 성명: 김나우 UI수정
 * 회원 탈퇴 전 최종 패스워드 인증 및 경고 안내를 제공하는 고도화된 UI 화면임.
* 시각적 통일성: 마이페이지 개요 및 수정 화면과 동일한 2분할 대시보드 레이아웃을 공유함.
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
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>WITHDRAWAL - SHOPMALL</title>
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

        /* 탈퇴 안내 경고창 조절 */
        .warning-box {
            background: #fafafa;
            border: 1px solid #eeeeee;
            border-radius: 8px;
            padding: 30px;
            margin-bottom: 35px;
        }
        .warning-box h3 {
            font-size: 15px;
            font-weight: 600;
            color: #cc0000;
            margin: 0 0 15px 0;
        }
        .warning-box ul {
            padding-left: 20px;
            margin: 0;
        }
        .warning-box ul li {
            font-size: 14px;
            color: #555;
            line-height: 1.8;
            margin-bottom: 8px;
        }

        /* 입력 폼 제어 */
        .auth-form-zone {
            border-top: 1px solid #eeeeee;
            padding-top: 35px;
            max-width: 500px;
        }
        .form-group {
            margin-bottom: 20px;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .form-group label {
            font-size: 13px;
            font-weight: 600;
            color: #111;
        }
        .form-group input[type="password"] {
            width: 100%;
            padding: 11px 12px;
            font-size: 14px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        .form-group input:focus {
            border-color: #000;
            outline: none;
        }

        /* 버튼 정돈 */
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
        .btn-danger {
            background: #dc3545;
            color: #fff;
            border-color: #dc3545;
            transition: background 0.2s;
        }
        .btn-danger:hover {
            background: #bd2130;
        }
        .btn-cancel {
            background: #fff;
            color: #555;
        }
        .btn-cancel:hover {
            background: #f9f9f9;
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
            <li><a href="update.jsp">회원 정보 수정</a></li>
            <li><a href="delete.jsp" class="active">회원 탈퇴 신청</a></li>
        </ul>
    </aside>

    <section class="content-panel">
        <div class="welcome-headline">
            <h1>회원 탈퇴 신청</h1>
            <p>SHOPMALL 계정을 삭제하기 전에 아래 안내 사항을 반드시 확인해 주세요.</p>
        </div>

        <div class="warning-box">
            <h3>계정 삭제 전 확인 사항</h3>
            <ul>
                <li>탈퇴 처리 즉시 회원의 가입 정보, 보유 쿠폰 및 적립금 혜택이 전액 소멸되며 복구가 불가능합니다.</li>
                <li>본인 인증 성공 후 최종 버튼을 누르면 즉시 로그아웃됩니다.</li>
            </ul>
        </div>

        <div class="auth-form-zone">
            <form action="deleteSubmit.jsp" method="POST">
                <div class="form-group">
                    <label for="currentPassword">본인 인증 비밀번호 확인</label>
                    <input type="password" id="currentPassword" name="currentPassword" placeholder="현재 비밀번호를 입력해 주세요" required>
                </div>

                <div class="btn-group">
                    <input type="submit" value="안내 사항 확인 후 탈퇴" class="btn btn-danger" onclick="return confirm('정말로 탈퇴하시겠습니까? 이 동작은 취소할 수 없습니다.');">
                    <a href="mypage.jsp" class="btn btn-cancel">취소</a>
                </div>
            </form>
        </div>
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