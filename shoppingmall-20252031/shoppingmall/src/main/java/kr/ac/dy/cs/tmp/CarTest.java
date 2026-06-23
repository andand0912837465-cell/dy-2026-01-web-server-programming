package kr.ac.dy.cs.tmp;

/**
 * 자동차를 추상화
 */
public class CarTest {

    public static void main(String[] args) {

        Car myCar = new Car();
        myCar.speedUp(10);
        myCar.speedUp(100);
        myCar.speedUp(300);

        SuperCar mySuperCar = new SuperCar();
        mySuperCar.setColor(10);

        Car car1 = mySuperCar;

       // ((SuperCar)car1).set




    }

}
