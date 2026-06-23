package kr.ac.dy.cs.tmp;


import kr.ac.dy.cs.tmp.dt.Monitor;

public class Sample {

    private int age;
    protected int age101;
    public int age201;
    int age301;

    private void test2(final int age) {

    }

    public void test() {
        Monitor myMonitor = new Monitor();

        test2(age);
        age = 10;
        age101 = 20;
        age201 = 30;
        age301 = 40;

        try {
            myMonitor.display();
        } catch (Exception e) {

        }
    }
}
