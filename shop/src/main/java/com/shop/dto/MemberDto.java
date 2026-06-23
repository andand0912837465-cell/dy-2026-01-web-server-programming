package com.shop.dto;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.Setter;

public class MemberDto {

    @Getter @Setter
    public static class RegisterRequest {
        @NotBlank(message = "이메일을 입력해주세요")
        @Email(message = "올바른 이메일 형식을 입력해주세요")
        private String email;
    }

    @Getter @Setter
    public static class LoginRequest {
        @NotBlank(message = "이메일을 입력해주세요")
        @Email(message = "올바른 이메일 형식을 입력해주세요")
        private String email;
    }
}
