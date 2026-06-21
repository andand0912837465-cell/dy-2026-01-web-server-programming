package kr.ac.dy.cs.member;

import org.jboss.aerogear.security.otp.api.Base32;

import java.time.LocalDateTime;

public class MemberService {

    private final MemberRepository memberRepository;

    public MemberService() {
        memberRepository = new MemberRepository();
    }

    /**
     * 로그인 처리
     */
    public boolean isLogin(String userId, String password) {
        if (userId == null || userId.isBlank() || password == null || password.isBlank()) {
            return false;
        }

        return memberRepository.select(userId, password) != null;
    }

    /**
     * 회원가입 비즈니스 로직 처리 클래스
     */
    public boolean register(MemberRegisterForm memberRegisterForm) {
        MemberDto member = MemberDto.builder()
                .userId(memberRegisterForm.getId())
                .userName(memberRegisterForm.getName())
                .email(memberRegisterForm.getEmail())
                .password(memberRegisterForm.getPassword())
                .otp_key(Base32.random())
                .regDate(LocalDateTime.now())
                .build();

        return memberRepository.insert(member) > 0;
    }
}
