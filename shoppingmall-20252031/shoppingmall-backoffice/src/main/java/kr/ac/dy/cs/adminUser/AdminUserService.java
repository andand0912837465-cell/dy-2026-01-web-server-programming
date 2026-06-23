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

        //비밀번호 불일치(널포함)
        if (password == null || !password.equals(adminUser.getPassword())) {
            return false;
        }

        //현재 사용여부 체크!!!



        return true;
    }


}
