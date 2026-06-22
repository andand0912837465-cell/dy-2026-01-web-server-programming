package kr.ac.dy.cs.member;

import jakarta.servlet.http.HttpServletRequest;
import lombok.*;

/**
 * 회원가입 입력 정보 데이터 클래스
 */
@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MemberRegisterForm {
    private String id;
    private String name;
    private String email;
    private String password;

    public static MemberRegisterForm get(HttpServletRequest request) {

        //Input tag name값
        String userId = request.getParameter("userId");
        String userName = request.getParameter("userName");
        String userEmail = request.getParameter("email");
        String password = request.getParameter("password");

        return MemberRegisterForm.builder()
                .id(userId)
                .name(userName)
                .email(userEmail)
                .password(password)
                .build();
    }


}
