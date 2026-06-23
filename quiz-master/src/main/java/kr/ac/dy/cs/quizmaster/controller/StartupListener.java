// 20251258 김상범
// 애플리케이션 시작 시 데이터베이스 테이블과 초기 데이터를 자동 생성하는 리스너
package kr.ac.dy.cs.quizmaster.controller;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import kr.ac.dy.cs.quizmaster.util.DatabaseInitializer;

@WebListener
public class StartupListener implements ServletContextListener {
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        new DatabaseInitializer().initialize();
    }
}
