package kr.ac.dy.cs.util;

import java.sql.Connection;

public class OracleDbConnector implements Connector {

    public void hi() {
        System.out.println("Hi!!");
    }


    @Override
    public Connection getConnection() {



        return null;
    }

    @Override
    public void closeConnection(Connection connection) {

    }
}
