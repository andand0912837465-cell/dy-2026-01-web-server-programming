package kr.ac.dy.cs.tmp;

import jakarta.servlet.ServletOutputStream;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

public class RequestUtils {

    public void print(HttpServletRequest request
                      , HttpServletResponse response
    ) throws IOException {

        ServletOutputStream out = response.getOutputStream();
        out.println("Hello");

        System.out.println("Hello");

    }

}
