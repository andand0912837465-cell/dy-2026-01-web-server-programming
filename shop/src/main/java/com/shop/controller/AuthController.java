package com.shop.controller;

import com.shop.dto.MemberDto;
import com.shop.entity.Member;
import com.shop.service.MemberService;
import jakarta.servlet.http.HttpSession;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("/auth")
@RequiredArgsConstructor
public class AuthController {

    private final MemberService memberService;

    @GetMapping("/login")
    public String loginPage(@RequestParam(required = false) String redirectUri,
                            @RequestParam(required = false) String alert,
                            Model model) {
        model.addAttribute("loginRequest", new MemberDto.LoginRequest());
        model.addAttribute("redirectUri", redirectUri);
        model.addAttribute("showAlert", "login".equals(alert));
        return "auth/login";
    }

    @PostMapping("/login")
    public String login(@Valid @ModelAttribute("loginRequest") MemberDto.LoginRequest request,
                        BindingResult bindingResult,
                        @RequestParam(required = false) String redirectUri,
                        HttpSession session,
                        Model model) {
        if (bindingResult.hasErrors()) {
            return "auth/login";
        }
        return memberService.login(request.getEmail())
                .map(member -> {
                    session.setAttribute("loginEmail", member.getEmail());
                    session.setAttribute("loginRole", member.getRole());
                    if (redirectUri != null && !redirectUri.isBlank()) {
                        return "redirect:" + redirectUri;
                    }
                    return "redirect:/";
                })
                .orElseGet(() -> {
                    model.addAttribute("error", "가입되지 않은 이메일입니다. 먼저 회원가입을 해주세요.");
                    return "auth/login";
                });
    }

    @GetMapping("/register")
    public String registerPage(Model model) {
        model.addAttribute("registerRequest", new MemberDto.RegisterRequest());
        return "auth/register";
    }

    @PostMapping("/register")
    public String register(@Valid @ModelAttribute("registerRequest") MemberDto.RegisterRequest request,
                           BindingResult bindingResult,
                           HttpSession session,
                           Model model) {
        if (bindingResult.hasErrors()) {
            return "auth/register";
        }
        try {
            Member member = memberService.register(request);
            session.setAttribute("loginEmail", member.getEmail());
            session.setAttribute("loginRole", member.getRole());
            return "redirect:/";
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", e.getMessage());
            return "auth/register";
        }
    }

    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }
}
