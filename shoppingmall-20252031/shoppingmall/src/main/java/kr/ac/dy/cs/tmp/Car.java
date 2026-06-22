package kr.ac.dy.cs.tmp;

/**
 * 자동차를 추상화
 */
public class Car {

    /**
     * 속도
     */
    private int speed = 0;

    public void speedUp(int speedValue) {
        if (speed + speedValue > 300) {
            speed = 300;
        } else {
            speed += speedValue;
        }
    }

}
