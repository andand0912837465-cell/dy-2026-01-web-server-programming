package kr.ac.dy.cs.adminUser;

public class AdminUserService {

    private final AdminUserRepository adminUserRepository;

    public AdminUserService() {
        adminUserRepository = new AdminUserRepository();
    }

    /**
     * 관리자 로그인 여부 리턴
     */
    public boolean isLogin(String adminId, String password) {
        AdminUserDto adminUser = adminUserRepository.getAdminUser(adminId);
        if (adminUser == null) {
            return false;
        }

        if (!java.util.Objects.equals(password, adminUser.getPassword())) {
            return false;
        }

        return "Y".equalsIgnoreCase(adminUser.getUsingYn());
    }

    /**
     * 관리자 계정 등록
     */
    public boolean register(AdminUserDto adminUser) {
        if (adminUser == null
                || adminUser.getAdminId() == null || adminUser.getAdminId().isBlank()
                || adminUser.getAdminName() == null || adminUser.getAdminName().isBlank()
                || adminUser.getPassword() == null || adminUser.getPassword().isBlank()) {
            return false;
        }

        adminUser.setUsingYn("Y");
        return adminUserRepository.insert(adminUser) > 0;
    }
}
