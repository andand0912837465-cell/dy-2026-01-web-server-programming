// 20251258 김상범
// 사용자 정보를 저장하는 데이터 전송 객체 (DTO)
package kr.ac.dy.cs.quizmaster.dto;

public class User {
    private String userId;
    private String name;
    private String password;

    public User() {}

    public User(String userId, String name, String password) {
        this.userId = userId;
        this.name = name;
        this.password = password;
    }

    public String getUserId() { return userId; }
    public void setUserId(String userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
}
