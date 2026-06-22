package kr.ac.dy.cs.tmp;

import lombok.*;

import java.time.LocalDateTime;

@AllArgsConstructor
@NoArgsConstructor
@Builder
@Getter
@Setter
public class MemberPointDto {


    private String userId;
    private int point;
    private String desc;//지급형태(회원가입,로그인)
    private LocalDateTime createdAt;


}
