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

    // =================================================================
    // 20251246 김나우
    // 단일 트랜잭션 커넥션을 활용한 결함 방어형 회원 정보 수정 비즈니스 로직
    // H2 DB 파일 잠김 결함을 방어하기 위해 Repository 계층과 직접 연동
    // =================================================================
    /**
     * 회원 정보 수정 요청을 처리함 (비밀번호 검증 및 정보 갱신 일괄 수행)
     * @param member 변경할 회원의 id, 신규 name, 신규 email 데이터가 바인딩된 DTO 객체
     * @param rawPassword 본인 인증을 위한 사용자의 평문 비밀번호 (1234)
     * @return 검증 및 수정 최종 성공 시 true, 실패 시 false 반환
     */
    public boolean safeModifyMember(MemberDto member, String rawPassword) {
        // 필수 파라미터 유효성 검증 및 예외 처리
        if (member == null || member.getUserId() == null || member.getUserId().isBlank() || rawPassword == null) {
            return false;
        }

        // 입력받은 신규 이름과 이메일의 공백 유무 유효성 추가 확인
        if (member.getUserName() == null || member.getUserName().isBlank() ||
                member.getEmail() == null || member.getEmail().isBlank()) {
            return false;
        }

        // Repository 계층의 단일 트랜잭션 메서드를 호출하여 결과 반환
        return memberRepository.verifyAndUpdate(member, rawPassword);
    }

    // =================================================================
    // 20251246 김나우
    // 안전한 회원 탈퇴(소프트 딜리트) 비즈니스 로직 확장
    // =================================================================
    /**
     * 회원의 상태를 탈퇴('N')로 변경하는 비즈니스 검증 로직
     * @param userId 세션에서 검증된 현재 로그인된 회원의 고유 식별자
     * @return 최종 탈퇴 처리 결과 성공 시 true, 실패 시 false
     */
    public boolean processWithdrawal(String userId) {
        if (userId == null || userId.isBlank()) {
            return false;
        }
        return memberRepository.withdrawMember(userId);
    }
}