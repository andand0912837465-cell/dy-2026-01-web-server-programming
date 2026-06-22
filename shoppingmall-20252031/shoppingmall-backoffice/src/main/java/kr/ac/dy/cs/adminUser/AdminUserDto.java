package kr.ac.dy.cs.adminUser;

import lombok.*;

import java.time.LocalDateTime;

/**
 * 관리자 정보
 */
@Getter
@Setter
@ToString
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class AdminUserDto {
    private String adminId;
    private String adminName;
    private String password;
    private String usingYn;
    private LocalDateTime regDt;
}
