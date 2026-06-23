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
    private LocalDateTime regDate;
    private String status;

    // 직접 추가해서 톰캣이 확실히 인식하게 함
    public String getStatus() {
        return this.status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

}


