// 20251258 김상범
// 사용자 로그인 및 회원가입 검증 비즈니스 로직을 처리하는 서비스 클래스
package kr.ac.dy.cs.quizmaster.service;

import kr.ac.dy.cs.quizmaster.dto.User;
import kr.ac.dy.cs.quizmaster.repository.UserRepository;

public class UserService {
    private final UserRepository userRepository = new UserRepository();

    public boolean login(String userId, String password) {
        if (userId == null || userId.isBlank() || password == null || password.isBlank()) {
            return false;
        }
        User user = userRepository.findByUserId(userId);
        return user != null && user.getPassword().equals(password);
    }

    public boolean register(String userId, String name, String password) {
        if (userId == null || userId.isBlank() || name == null || name.isBlank() || password == null || password.isBlank()) {
            return false;
        }
        if (userRepository.findByUserId(userId) != null) {
            return false;
        }
        userRepository.save(new User(userId, name, password));
        return true;
    }

    public User getUser(String userId) {
        return userRepository.findByUserId(userId);
    }
}
