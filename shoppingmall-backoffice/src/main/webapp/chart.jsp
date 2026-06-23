<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>매출 통계 분석</title>
  <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
  <style>
    body { font-family: 'Malgun Gothic', sans-serif; background-color: #f4f7f6; padding: 40px; }
    .chart-container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 12px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
  </style>
</head>
<body>

<div class="chart-container">
  <h2 style="color: #2c3e50; text-align: center; margin-bottom: 30px;">📊 카테고리별 누적 매출 통계</h2>

  <canvas id="categorySalesChart"></canvas>

  <div style="text-align: center; margin-top: 30px;">
    <button onclick="location.href='index.jsp'" style="padding: 10px 20px; background: #2c3e50; color: white; border: none; border-radius: 5px; cursor: pointer;">
      메인 홈으로 돌아가기
    </button>
  </div>
</div>

<script>
  document.addEventListener('DOMContentLoaded', function() {
    const ctx = document.getElementById('categorySalesChart').getContext('2d');
    new Chart(ctx, {
      type: 'bar',
      data: {
        labels: ['프리미엄 의류', '스마트 전자기기', '신선 식품', '자기계발 도서'],
        datasets: [{
          label: '주간 누적 판매량 (건)',
          data: [1240, 853, 2105, 430],
          backgroundColor: ['#3498db', '#e74c3c', '#f1c40f', '#1abc9c']
        }]
      },
      options: { responsive: true }
    });
  });
</script>

</body>
</html>