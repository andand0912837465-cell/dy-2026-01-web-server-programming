<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>로그인</title>
</head>
<body>
<%
  String loginId = "";
  Cookie[] cookies = request.getCookies();
  if (cookies != null) {
    for (Cookie cookie : cookies) {
      if ("saveId".equals(cookie.getName())) {
        loginId = cookie.getValue();
        break;
      }
    }
  }

  String checked = (loginId != null && loginId.length() > 0) ? "checked" : "";
%>

  <form method="post" action="loginSubmit.jsp">
    <dl>
      <dt>
        <label for="loginId">아이디</label>
      </dt>
      <dd>
        <input type="text" name="loginId" id="loginId"
               value="<%=loginId%>"
               minlength="5"
               required placeholder="아이디를 입력해 주세요."/>
      </dd>
      <dt>
        <label for="password">비밀번호</label>
      </dt>
      <dd>
        <input type="password" name="password" id="password"
               required placeholder="비밀번호를 입력해 주세요."/>
      </dd>
    </dl>
    <div>
      <input type="checkbox"
             <%=checked%>
             name="saveIdYn" id="saveIdYn" value="1"/>
      <label for="saveIdYn">아이디 저장</label>
    </div>


    <button type="submit">로그인</button>

  </form>



</body>
</html>
