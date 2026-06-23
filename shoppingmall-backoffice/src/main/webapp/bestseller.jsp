<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>베스트셀러 추천</title>
  <style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; padding: 40px; }
    .dashboard { max-width: 800px; margin: 0 auto; }
    .header { background: #e74c3c; color: white; padding: 20px; border-radius: 10px 10px 0 0; text-align: center; }
    .item-list { list-style: none; padding: 0; margin: 0; background: white; border-radius: 0 0 10px 10px; }
    .item-list li { padding: 20px; border-bottom: 1px solid #eee; display: flex; justify-content: space-between; }
    .rank-badge { background: #f39c12; color: white; padding: 5px 15px; border-radius: 20px; font-weight: bold; }
  </style>
</head>
<body>
<div class="dashboard">
  <div class="header">
    <h2 style="margin:0;">🔥 이달의 베스트셀러 TOP 3</h2>
  </div>
  <ul class="item-list">
    <li>
      <div><span class="rank-badge">1위</span> <b>프리미엄 무지 반팔티</b></div>
      <div style="color: #7f8c8d;">누적 판매: 1,540건</div>
    </li>
    <li>
      <div><span class="rank-badge" style="background:#bdc3c7;">2위</span> <b>쿨링 여름용 와이드 슬랙스</b></div>
      <div style="color: #7f8c8d;">누적 판매: 1,205건</div>
    </li>
    <li>
      <div><span class="rank-badge" style="background:#d35400;">3위</span> <b>스마트 워치 메탈 스트랩</b></div>
      <div style="color: #7f8c8d;">누적 판매: 890건</div>
    </li>
  </ul>
  <div style="text-align: center; margin-top: 30px;">
    <button onclick="location.href='index.jsp'" style="padding: 12px 30px; background: #34495e; color: white; border: none; border-radius: 5px; cursor: pointer;">
      메인 홈으로 돌아가기
    </button>
  </div>
</div>
</body>
</html>