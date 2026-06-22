package kr.ac.dy.cs.util;

import java.sql.Connection;

public interface Connector {

    Connection getConnection();

    void closeConnection(Connection connection);


}
