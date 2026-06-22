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
    /**
     * 20251246 김나우
     * 마이페이지 진입 시 필요한 회원 정보를 조회하는 비즈니스 로직
     */
    public MemberDto getMyPageInfo(String userId) {
        // 인풋 데이터 예외 처리 및 유효성 검증 (기존 로그인 처리 방식의 톤 유지)
        if (userId == null || userId.isBlank()) {
            return null;
        }

        // 1단계에서 확장 구현한 memberRepository.selectById 메서드를 호출하여 단건 데이터 반환
        return memberRepository.selectById(userId);
    }
}
