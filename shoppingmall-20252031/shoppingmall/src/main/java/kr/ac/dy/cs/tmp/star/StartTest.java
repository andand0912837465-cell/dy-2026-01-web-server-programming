package kr.ac.dy.cs.tmp.star;

public class StartTest  {


    public static void main(String[] args) {

        Marine m1 = new Marine();
        Medic d1 = new Medic();
        Tank t1 = new Tank();

        Obj[] arrObj = {m1, d1, t1};
        for (Obj o : arrObj) {
            o.move();
        }

        m1.move();
        d1.move();
        t1.move();





    }
}
