package kr.ac.dy.cs.member;

import lombok.*;

import java.time.LocalDateTime;

/**
 * 회원정보 데이터 클래스
 */
@Setter
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class MemberDto {

    private String userId;
    private String userName;
    private String email;
    private String password;
    private String otp_key;
    private LocalDateTime regDate;

}
