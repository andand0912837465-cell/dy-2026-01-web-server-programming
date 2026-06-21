/**
 * 20251240 공호준
 * 비밀번호를 암호화하는 클래스.
 * 비밀번호 평문을 받아서 salt를 더해 sha256 알고리즘으로 암호화하여 반환함.
 * 해싱을 사용해서 복호화가 불가능해 안전하게 저장할 수 있음.
 * slat는 'shoppingmall!'으로 고정된 형태로 모든 사용자가 동일하게 사용함.
 */

package kr.ac.dy.cs.util;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class SHA256 {

    public static String hashing(String password) {

        password = password + "shoppingmall!"; // salt 추가

        String result = "";

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");

            md.update(password.getBytes());
            byte[] byteData = md.digest();

            StringBuilder sb = new StringBuilder();
            for (byte b : byteData) {
                sb.append(String.format("%02x", b));
            }

            result = sb.toString();

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }

        return result;

    }
}
