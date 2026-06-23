package kr.ac.dy.cs.order;
// 주문 db의 정보를 조회하고 수정하는 코드
/**
 * 20252377 양효재
 * 부분 구현된 주문 관리 기능이 남아 있어서 개선 진행하였다.
 * 회원별 조회만 가능하던 구조를 주문 전체 목록과 상세 조회까지 확장하고,
 * 취소 환불 흐름에 필요한 컬럼도 같이 관리하도록 보완했다.
 */
import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Set;

public class OrderRepository {

    public List<OrderDto> selectAll(){

        List<OrderDto> orders = new ArrayList<>();

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
                select *
                from PUBLIC.ORDERS
                order by ORDER_DATE desc, ORDER_ID desc
                """;

        try {
            prepareOrdersTable(connection);

            PreparedStatement psmt = connection.prepareStatement(sql);
            ResultSet rs = psmt.executeQuery();

            while(rs.next()){
                orders.add(mapOrder(rs));
            }

            rs.close();
            psmt.close();
        } catch(Exception e){
            e.printStackTrace();
        } finally {
            connector.closeConnection(connection);
        }

        return orders;
    }

    public OrderDto selectByOrderId(Long orderId){

        if(orderId == null || orderId <= 0){
            return null;
        }

        OrderDto order = null;

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql = """
                select *
                from PUBLIC.ORDERS
                where ORDER_ID = ?
                """;

        try {
            prepareOrdersTable(connection);

            PreparedStatement psmt = connection.prepareStatement(sql);
            psmt.setLong(1, orderId);

            ResultSet rs = psmt.executeQuery();

            if(rs.next()){
                order = mapOrder(rs);
            }

            rs.close();
            psmt.close();
        } catch(Exception e){
            e.printStackTrace();
        } finally {
            connector.closeConnection(connection);
        }

        return order;
    }

    public List<OrderDto> selectByMember(String memberId){

        List<OrderDto> orders = new ArrayList<>();

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();



        try {
            prepareOrdersTable(connection);

            System.out.println("=================================");
            System.out.println("DB URL : "
                    + connection.getMetaData().getURL());
            System.out.println("조회 memberId : "
                    + memberId);
            System.out.println("=================================");

            String sql = """
    select *
    from PUBLIC.ORDERS
    where MEMBER_ID = ?
    order by ORDER_DATE desc
""";

            PreparedStatement psmt =
                    connection.prepareStatement(sql);

            psmt.setString(1, memberId);

            ResultSet rs = psmt.executeQuery();

            int count = 0;

            while(rs.next()){

                count++;

                System.out.println(
                        "주문 발견 : "
                                + rs.getLong("order_id")
                                + " / "
                                + rs.getString("product_name")
                );

                OrderDto order = mapOrder(rs);
                orders.add(order);
            }

            System.out.println(
                    "조회된 주문 수 : " + count);

        } catch(Exception e){
            e.printStackTrace();
        } finally {
            connector.closeConnection(connection);
        }

        return orders;
    }

    public int updateStatus(
            Long orderId,
            String status){

        int affected = 0;

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();

        String sql =
                "update PUBLIC.ORDERS set STATUS=? where ORDER_ID=?";

        try{
            prepareOrdersTable(connection);

            PreparedStatement psmt =
                    connection.prepareStatement(sql);

            psmt.setString(1,status);
            psmt.setLong(2,orderId);

            affected = psmt.executeUpdate();

        }catch(Exception e){
            e.printStackTrace();
        } finally {
            connector.closeConnection(connection);
        }

        return affected;
    }

    private OrderDto mapOrder(ResultSet rs) throws Exception{

        Set<String> columns = readColumns(rs);

        OrderDto order = new OrderDto();

        order.setOrderId(firstLong(rs, columns, "ORDER_ID"));
        order.setMemberId(firstString(rs, columns, "MEMBER_ID"));
        order.setOrderNumber(defaultString(
                firstString(rs, columns, "ORDER_NUMBER", "ORDER_NO", "ORDER_CODE"),
                "ORD-" + order.getOrderId()));
        order.setProductId(firstString(rs, columns, "PRODUCT_ID"));
        order.setProductName(firstString(rs, columns, "PRODUCT_NAME"));
        order.setPrice(firstInt(rs, columns, "PRICE"));
        order.setQuantity(firstInt(rs, columns, "QUANTITY"));
        order.setStatus(defaultString(firstString(rs, columns, "STATUS"), "결제완료"));
        order.setReceiverName(firstString(rs, columns, "RECEIVER_NAME", "ORDER_NAME", "RECIPIENT_NAME"));
        order.setReceiverPhone(firstString(rs, columns, "RECEIVER_PHONE", "PHONE", "PHONE_NUMBER", "TEL"));
        order.setZipCode(firstString(rs, columns, "ZIP_CODE", "POST_CODE"));
        order.setAddressMain(firstString(rs, columns, "ADDRESS_MAIN", "ADDRESS", "ROAD_ADDRESS"));
        order.setAddressDetail(firstString(rs, columns, "ADDRESS_DETAIL", "DETAIL_ADDRESS"));
        order.setPaymentMethod(firstString(rs, columns, "PAYMENT_METHOD", "PAY_METHOD"));
        order.setRequestMessage(firstString(rs, columns, "REQUEST_MESSAGE", "DELIVERY_REQUEST", "ORDER_MESSAGE"));
        order.setCancelReason(firstString(rs, columns, "CANCEL_REASON"));
        order.setRefundReason(firstString(rs, columns, "REFUND_REASON"));
        order.setRefundAmount(firstInt(rs, columns, "REFUND_AMOUNT"));

        Timestamp date = firstTimestamp(rs, columns, "ORDER_DATE", "REG_DATE", "CREATED_AT");
        if(date != null){
            order.setOrderDate(date.toLocalDateTime());
        }

        return order;
    }

    private void prepareOrdersTable(Connection connection) throws Exception{
        Statement stmt = null;

        try{
            stmt = connection.createStatement();
            stmt.executeUpdate("""
                    CREATE TABLE IF NOT EXISTS PUBLIC.ORDERS (
                        ORDER_ID BIGINT AUTO_INCREMENT PRIMARY KEY,
                        MEMBER_ID VARCHAR(50) NOT NULL,
                        ORDER_NUMBER VARCHAR(50),
                        PRODUCT_ID VARCHAR(30),
                        PRODUCT_NAME VARCHAR(200) NOT NULL,
                        PRICE INT NOT NULL,
                        QUANTITY INT NOT NULL,
                        STATUS VARCHAR(50) DEFAULT '결제완료',
                        ORDER_DATE TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        RECEIVER_NAME VARCHAR(100),
                        RECEIVER_PHONE VARCHAR(50),
                        ZIP_CODE VARCHAR(20),
                        ADDRESS_MAIN VARCHAR(300),
                        ADDRESS_DETAIL VARCHAR(300),
                        PAYMENT_METHOD VARCHAR(50),
                        REQUEST_MESSAGE VARCHAR(500),
                        CANCEL_REASON VARCHAR(500),
                        REFUND_REASON VARCHAR(500),
                        REFUND_AMOUNT INT DEFAULT 0
                    )
                    """);
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS ORDER_NUMBER VARCHAR(50)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS PRODUCT_ID VARCHAR(30)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS RECEIVER_NAME VARCHAR(100)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS RECEIVER_PHONE VARCHAR(50)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS ZIP_CODE VARCHAR(20)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS ADDRESS_MAIN VARCHAR(300)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS ADDRESS_DETAIL VARCHAR(300)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS PAYMENT_METHOD VARCHAR(50)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS REQUEST_MESSAGE VARCHAR(500)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS CANCEL_REASON VARCHAR(500)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS REFUND_REASON VARCHAR(500)");
            stmt.executeUpdate("ALTER TABLE PUBLIC.ORDERS ADD COLUMN IF NOT EXISTS REFUND_AMOUNT INT DEFAULT 0");
        } finally {
            try{
                if(stmt != null){
                    stmt.close();
                }
            }catch(Exception e){
                e.printStackTrace();
            }
        }
    }

    private Set<String> readColumns(ResultSet rs) throws Exception{
        Set<String> columns = new HashSet<>();
        ResultSetMetaData metaData = rs.getMetaData();

        for(int i = 1; i <= metaData.getColumnCount(); i++){
            columns.add(metaData.getColumnLabel(i).toUpperCase(Locale.ROOT));
        }

        return columns;
    }

    private String firstString(ResultSet rs, Set<String> columns, String... names) throws Exception{
        for(String name : names){
            if(columns.contains(name.toUpperCase(Locale.ROOT))){
                String value = rs.getString(name);
                if(value != null && !value.isBlank()){
                    return value;
                }
            }
        }

        return null;
    }

    private long firstLong(ResultSet rs, Set<String> columns, String... names) throws Exception{
        for(String name : names){
            if(columns.contains(name.toUpperCase(Locale.ROOT))){
                long value = rs.getLong(name);
                if(!rs.wasNull()){
                    return value;
                }
            }
        }

        return 0L;
    }

    private int firstInt(ResultSet rs, Set<String> columns, String... names) throws Exception{
        for(String name : names){
            if(columns.contains(name.toUpperCase(Locale.ROOT))){
                int value = rs.getInt(name);
                if(!rs.wasNull()){
                    return value;
                }
            }
        }

        return 0;
    }

    private Timestamp firstTimestamp(ResultSet rs, Set<String> columns, String... names) throws Exception{
        for(String name : names){
            if(columns.contains(name.toUpperCase(Locale.ROOT))){
                Timestamp value = rs.getTimestamp(name);
                if(value != null){
                    return value;
                }
            }
        }

        return null;
    }

    private String defaultString(String value, String defaultValue){
        return value == null || value.isBlank() ? defaultValue : value;
    }

}
