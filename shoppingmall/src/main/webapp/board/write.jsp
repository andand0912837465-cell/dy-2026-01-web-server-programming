<%--
 * 20252374 최은교
 * 쇼핑몰 사용자가 새로운 1:1 문의글을 입력할 수 있는 웹 폼(Form) 화면 페이지임.
 * 주소창 강제 접근 등을 차단하기 위해 로그인 세션을 사전 검증하고, 비로그인 유저일 경우 경고창과 함께 로그인 페이지로 강제 튕겨내는 보안 기능을 제공한다.
 * 추가로, 사용자가 문의 유형(일반, 배송, 환불, 기타)을 드롭다운으로 선택하고 제목과 본문 내용을 자유롭게 작성할 수 있는 UI 입력 인터페이스를 제공한다.
 * 상세로는 작성 단추 클릭 시 JavaScript 유효성 검사(validateForm)를 실행하여 제목이나 내용이 유실된 채 전송되지 않도록 사전 차단하는 기능을 제공한다.
 * 폼 데이터를 POST 방식으로 전송 데이터 처리 페이지(writeSubmit.jsp)로 안전하게 연결해 주는 기능을 제공한다.
 *
--%>

<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // 혹시라도 로그인을 안 하고 주소창으로 바로 들어온 사용자가 있다면 미리 체크합니다.
    String currentLoginId = (String) session.getAttribute("loginId");
    if (currentLoginId == null || currentLoginId.isEmpty()) {
%>
<script>
    alert('로그인이 필요한 서비스입니다.');
    location.href = '/auth/login.jsp'; // 프로젝트 로그인 페이지 경로에 맞게 수정 가능
</script>
<%
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>SHOPMALL - 1:1 문의 작성</title>
    <style>
        body { background-color: #f8f9fa; color: #333; font-family: 'Malgun Gothic', sans-serif; margin: 0; padding: 0; }
        .write-container { max-width: 700px; margin: 60px auto; padding: 0 20px; }
        .write-card { background: white; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.06); padding: 40px; }
        .write-header { border-bottom: 2px solid #f1f2f6; padding-bottom: 20px; margin-bottom: 30px; }
        .write-header h2 { margin: 0; font-size: 24px; color: #111; display: flex; align-items: center; gap: 10px; }
        .write-header p { margin: 8px 0 0 0; color: #888; font-size: 14px; }

        .form-group { margin-bottom: 22px; }
        .form-group label { display: block; font-weight: bold; margin-bottom: 8px; color: #4b5563; font-size: 14px; }

        /* 입력창 스타일 */
        .form-control { width: 100%; padding: 12px 16px; border: 1px solid #ddd; border-radius: 6px; font-size: 15px; box-sizing: border-box; transition: all 0.2s; }
        .form-control:focus { border-color: #4834d4; outline: none; box-shadow: 0 0 0 3px rgba(72, 52, 212, 0.1); }
        select.form-control { height: 48px; background-color: white; }
        textarea.form-control { resize: none; min-height: 200px; font-family: inherit; }
        .form-control[readonly] { background-color: #f1f2f6; color: #777; cursor: not-allowed; }

        /* 버튼 구역 */
        .btn-group { display: flex; gap: 12px; margin-top: 35px; }
        .btn { flex: 1; height: 50px; border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer; display: flex; align-items: center; justify-content: center; text-decoration: none; transition: all 0.2s; }
        .btn-submit { background-color: #4834d4; color: white; }
        .btn-submit:hover { background-color: #3c2bb3; }
        .btn-cancel { background-color: #e4e7eb; color: #4b5563; }
        .btn-cancel:hover { background-color: #d1d5db; }
    </style>
    <script>
        // 빈 값이 있으면 전송을 막는 유효성 검사 스크립트
        function validateForm() {
            var title = document.getElementById("title").value.trim();
            var content = document.getElementById("content").value.trim();

            if (title == "") {
                alert("문의 제목을 입력해 주세요.");
                document.getElementById("title").focus();
                return false;
            }
            if (content == "") {
                alert("상세 내용을 입력해 주세요.");
                document.getElementById("content").focus();
                return false;
            }
            return true;
        }
    </script>
</head>
<body>

<div class="write-container">
    <div class="write-card">
        <div class="write-header">
            <h2>🛡️ 1:1 고객 문의 작성</h2>
            <p>작성하신 문의는 관리자 검토 후 신속하게 답변해 드립니다.</p>
        </div>

        <form action="writeSubmit.jsp" method="post" onsubmit="return validateForm();">

            <div class="form-group">
                <label>작성자 계정</label>
                <input type="text" class="form-control" value="<%= currentLoginId %>" readonly>
            </div>

            <div class="form-group">
                <label for="category">문의 유형</label>
                <select name="category" id="category" class="form-control">
                    <option value="일반">일반 문의</option>
                    <option value="배송">배송 문의</option>
                    <option value="환불">환불/반품 문의</option>
                    <option value="기타">기타 문의</option>
                </select>
            </div>

            <div class="form-group">
                <label for="title">문의 제목</label>
                <input type="text" name="title" id="title" class="form-control" placeholder="제목을 입력해 주세요.">
            </div>

            <div class="form-group">
                <label for="content">상세 내용</label>
                <textarea name="content" id="content" class="form-control" placeholder="불편하신 사항이나 궁금하신 점을 상세히 적어주세요."></textarea>
            </div>

            <div class="btn-group">
                <a href="list.jsp" class="btn btn-cancel">취소 및 돌아가기</a>
                <button type="submit" class="btn btn-submit">문의 등록하기</button>
            </div>

        </form>
    </div>
</div>

</body>
</html>