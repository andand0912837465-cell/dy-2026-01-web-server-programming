package com.shop.service;

import com.shop.dto.MemberDto;
import com.shop.entity.Member;
import com.shop.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class MemberService {

    private final MemberRepository memberRepository;

    @Transactional
    public Member register(MemberDto.RegisterRequest request) {
        if (memberRepository.existsByEmail(request.getEmail())) {
            throw new IllegalArgumentException("이미 가입된 이메일입니다: " + request.getEmail());
        }
        Member member = Member.builder()
                .email(request.getEmail())
                .role("USER")
                .build();
        return memberRepository.save(member);
    }

    public Optional<Member> login(String email) {
        return memberRepository.findByEmail(email);
    }

    public boolean isAdmin(String email) {
        return memberRepository.findByEmail(email)
                .map(m -> "ADMIN".equals(m.getRole()))
                .orElse(false);
    }
}
