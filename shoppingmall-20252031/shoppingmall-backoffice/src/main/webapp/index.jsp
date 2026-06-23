<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="kr.ac.dy.cs.util.SessionUtils" %>
<%
    boolean isLoggedIn = SessionUtils.isLoginYn(session);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SHOPMALL ADMIN - 쇼핑몰 관리자 시스템</title>
    <link rel="stylesheet" href="/css/main.css">
</head>
<body class="admin-landing">

<!-- ===== 상단 헤더 ===== -->
<header class="admin-header">
    <div class="container header-inner">
        <a href="/index.jsp" class="logo">SHOP<span>MALL</span> ADMIN</a>
        <nav class="admin-nav">
            <a href="#about">소개</a>
            <a href="#features">주요 기능</a>
            <a href="#login-guide">로그인 안내</a>
            <% if (isLoggedIn) { %>
                <a href="/dashboard/index.jsp" class="btn-header-login">대시보드</a>
            <% } else { %>
                <a href="/auth/adminLogin.jsp" class="btn-header-login">로그인</a>
            <% } %>
        </nav>
    </div>
</header>

<!-- ===== 히어로 ===== -->
<section class="admin-hero">
    <div class="container admin-hero-inner">
        <div class="admin-hero-text">
            <span class="hero-eyebrow">BACKOFFICE SYSTEM</span>
            <h1>쇼핑몰을 더 똑똑하게,<br>관리자 시스템 한곳에서.</h1>
            <p class="hero-desc">
                상품, 주문, 회원, 통계까지 — 쇼핑몰 운영에 필요한 모든 기능을<br>
                직관적인 화면에서 한눈에 관리하실 수 있습니다.
            </p>
            <div class="hero-actions">
                <% if (isLoggedIn) { %>
                    <a href="/dashboard/index.jsp" class="btn-primary">대시보드로 이동 →</a>
                <% } else { %>
                    <a href="/auth/adminLogin.jsp" class="btn-primary">관리자 로그인</a>
                <% } %>
                <a href="#login-guide" class="btn-secondary">로그인 절차 안내</a>
            </div>
            <div class="hero-meta">
                <div><strong>99.9%</strong><span>시스템 안정성</span></div>
                <div><strong>24/7</strong><span>운영 모니터링</span></div>
                <div><strong>SSL</strong><span>보안 접속</span></div>
            </div>
        </div>
        <div class="admin-hero-card">
            <div class="card-bar">
                <span class="dot red"></span>
                <span class="dot yellow"></span>
                <span class="dot green"></span>
                <span class="card-title">SHOPMALL Admin Dashboard</span>
            </div>
            <div class="card-body">
                <div class="stat-row">
                    <div class="stat">
                        <span class="stat-label">오늘의 주문</span>
                        <span class="stat-value">128 건</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">금일 매출</span>
                        <span class="stat-value">₩ 4,820,000</span>
                    </div>
                </div>
                <div class="stat-row">
                    <div class="stat">
                        <span class="stat-label">신규 회원</span>
                        <span class="stat-value">37 명</span>
                    </div>
                    <div class="stat">
                        <span class="stat-label">재고 부족</span>
                        <span class="stat-value alert">12 종</span>
                    </div>
                </div>
                <div class="chart-mock">
                    <span style="height: 40%"></span>
                    <span style="height: 70%"></span>
                    <span style="height: 55%"></span>
                    <span style="height: 85%"></span>
                    <span style="height: 60%"></span>
                    <span style="height: 95%"></span>
                    <span style="height: 75%"></span>
                </div>
            </div>
        </div>
    </div>
</section>

<!-- ===== 소개 ===== -->
<section id="about" class="admin-about">
    <div class="container">
        <div class="section-title">
            <span class="eyebrow">ABOUT</span>
            <h2>SHOPMALL 관리자 시스템이란?</h2>
            <p>쇼핑몰 운영자가 사용하는 전용 백오피스(Back-office)로,<br>
                일반 고객용 쇼핑몰과 분리된 안전한 환경에서 운영됩니다.</p>
        </div>
        <div class="about-grid">
            <div class="about-item">
                <div class="about-icon">🔒</div>
                <h3>안전한 접근 통제</h3>
                <p>관리자 계정으로만 로그인할 수 있으며, 세션·쿠키 기반의 안전한 인증을 통해 정보를 보호합니다.</p>
            </div>
            <div class="about-item">
                <div class="about-icon">⚡</div>
                <h3>빠른 운영 처리</h3>
                <p>상품 등록, 주문 처리, 회원 관리 등 반복 업무를 빠르고 간편하게 처리할 수 있도록 설계되었습니다.</p>
            </div>
            <div class="about-item">
                <div class="about-icon">📊</div>
                <h3>한눈에 보는 데이터</h3>
                <p>매출, 방문자, 재고 등 핵심 지표를 대시보드에서 한번에 확인하고 의사결정에 활용할 수 있습니다.</p>
            </div>
        </div>
    </div>
</section>

<!-- ===== 주요 기능 ===== -->
<section id="features" class="admin-features">
    <div class="container">
        <div class="section-title">
            <span class="eyebrow">FEATURES</span>
            <h2>주요 기능</h2>
            <p>관리자 페이지에서 사용하실 수 있는 주요 기능들입니다.</p>
        </div>
        <div class="feature-grid">
            <div class="feature-card">
                <span class="feature-num">01</span>
                <h3>상품 관리</h3>
                <p>상품 등록 · 수정 · 삭제, 카테고리 관리, 재고 현황을 관리합니다.</p>
            </div>
            <div class="feature-card">
                <span class="feature-num">02</span>
                <h3>주문 관리</h3>
                <p>접수된 주문 확인, 배송 상태 변경, 취소 · 반품 처리를 수행합니다.</p>
            </div>
            <div class="feature-card">
                <span class="feature-num">03</span>
                <h3>회원 관리</h3>
                <p>가입 회원 조회, 등급 변경, 적립금 지급 등 회원 관련 업무를 처리합니다.</p>
            </div>
            <div class="feature-card">
                <span class="feature-num">04</span>
                <h3>매출 통계</h3>
                <p>일별 · 월별 매출, 인기 상품, 회원 활동 등의 통계를 확인합니다.</p>
            </div>
            <div class="feature-card">
                <span class="feature-num">05</span>
                <h3>프로모션</h3>
                <p>쿠폰 발행, 할인 이벤트, 기획전 등 마케팅 활동을 운영합니다.</p>
            </div>
            <div class="feature-card">
                <span class="feature-num">06</span>
                <h3>관리자 계정</h3>
                <p>관리자 추가, 권한 설정, 접속 로그 등 시스템 운영을 관리합니다.</p>
            </div>
        </div>
    </div>
</section>

<!-- ===== 로그인 안내 ===== -->
<section id="login-guide" class="login-guide">
    <div class="container">
        <div class="section-title">
            <span class="eyebrow">HOW TO LOGIN</span>
            <h2>로그인 진행 방법</h2>
            <p>다음 절차에 따라 관리자 페이지에 로그인하실 수 있습니다.</p>
        </div>
        <div class="step-list">
            <div class="step">
                <div class="step-no">STEP 1</div>
                <h3>로그인 페이지 이동</h3>
                <p>상단 우측의 <em>로그인</em> 버튼 또는 아래 <em>관리자 로그인</em> 버튼을 클릭하여 로그인 페이지로 이동합니다.</p>
            </div>
            <div class="step">
                <div class="step-no">STEP 2</div>
                <h3>아이디 / 비밀번호 입력</h3>
                <p>발급받은 관리자 아이디와 비밀번호를 정확히 입력합니다. <em>아이디 저장</em>을 체크하면 다음 접속 시 아이디가 자동 입력됩니다.</p>
            </div>
            <div class="step">
                <div class="step-no">STEP 3</div>
                <h3>인증 및 세션 생성</h3>
                <p>입력한 정보가 일치하면 서버가 관리자 세션을 생성하고, 이후의 요청을 인증된 사용자로 처리합니다.</p>
            </div>
            <div class="step">
                <div class="step-no">STEP 4</div>
                <h3>관리자 메인 진입</h3>
                <p>로그인에 성공하면 자동으로 관리자 대시보드로 이동하며, 좌측 메뉴를 통해 각 기능을 이용하실 수 있습니다.</p>
            </div>
        </div>

        <div class="login-notice">
            <h4>⚠ 로그인 안내 사항</h4>
            <ul>
                <li>관리자 아이디는 일반 회원과 별도로 발급되며, 시스템 관리자에게 문의하셔야 합니다.</li>
                <li>비밀번호는 영문 · 숫자 · 특수문자를 조합하여 8자 이상으로 설정하는 것을 권장합니다.</li>
                <li>비밀번호 5회 이상 오류 입력 시, 일정 시간 동안 접속이 제한될 수 있습니다.</li>
                <li>공용 PC에서는 보안을 위해 <em>아이디 저장</em>을 사용하지 마시고, 사용 후 반드시 로그아웃하시기 바랍니다.</li>
            </ul>
        </div>

        <div class="login-cta">
            <h3>지금 바로 시작하세요</h3>
            <p>관리자 계정으로 로그인하시면 모든 기능을 이용하실 수 있습니다.</p>
            <% if (isLoggedIn) { %>
                <a href="/dashboard/index.jsp" class="btn-primary large">대시보드로 이동 →</a>
            <% } else { %>
                <a href="/auth/adminLogin.jsp" class="btn-primary large">관리자 로그인 →</a>
            <% } %>
        </div>
    </div>
</section>

<!-- ===== 푸터 ===== -->
<footer class="admin-footer">
    <div class="container footer-grid">
        <div>
            <h4>SHOPMALL ADMIN</h4>
            <p>쇼핑몰 운영자를 위한 통합 백오피스 시스템</p>
            <p class="footer-contact">관리자 문의: admin@shopmall.example.com</p>
        </div>
        <div>
            <h4>바로가기</h4>
            <ul>
                <li><a href="#about">시스템 소개</a></li>
                <li><a href="#features">주요 기능</a></li>
                <li><a href="#login-guide">로그인 안내</a></li>
            </ul>
        </div>
        <div>
            <h4>계정</h4>
            <ul>
                <li><a href="/auth/adminLogin.jsp">관리자 로그인</a></li>
                <li><a href="/adminUser/register.jsp">관리자 등록</a></li>
            </ul>
        </div>
        <div>
            <h4>보안</h4>
            <ul>
                <li>SSL 암호화 통신</li>
                <li>세션 기반 인증</li>
                <li>접속 로그 기록</li>
            </ul>
        </div>
    </div>
    <div class="footer-bottom">© 2026 SHOPMALL ADMIN. All rights reserved.</div>
</footer>

</body>
</html>