package kr.ac.dy.cs.member;

import java.time.LocalDateTime;

public class MemberService {

    private MemberRepository memberRepository;

    public MemberService() {
        memberRepository = new MemberRepository();
    }


    /**
     * 로그인 처리
     */
    public boolean isLogin(String userId, String password) {
        MemberDto member = memberRepository.select(userId, password);
        return member != null;
    }


    /**
     * 회원가입 비즈니스 로직 처리 클래스
     */
    public boolean register(MemberRegisterForm memberRegisterForm) {

        //member테이블에 추가
        MemberDto member = MemberDto.builder()
                .userId(memberRegisterForm.getId())
                .userName(memberRegisterForm.getName())
                .email(memberRegisterForm.getEmail())
                .password(memberRegisterForm.getPassword())
                .regDate(LocalDateTime.now())
                .build();
        int affected = memberRepository.insert(member);

        //member_point테이블에 추가

        if (affected > 0) {
            return true;
        }
        return false;
    }


}
