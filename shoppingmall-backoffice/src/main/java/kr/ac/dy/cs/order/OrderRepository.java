package kr.ac.dy.cs.order;
// 주문 db의 정보를 조회하고 수정하는 코드
import kr.ac.dy.cs.util.Connector;
import kr.ac.dy.cs.util.H2DbConnector;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderRepository {


    public List<OrderDto> selectByMember(String memberId){

        List<OrderDto> orders = new ArrayList<>();

        Connector connector = new H2DbConnector();
        Connection connection = connector.getConnection();



        try {

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

                OrderDto order = new OrderDto();

                order.setOrderId(
                        rs.getLong("order_id"));

                order.setMemberId(
                        rs.getString("member_id"));

                order.setProductName(
                        rs.getString("product_name"));

                order.setPrice(
                        rs.getInt("price"));

                order.setQuantity(
                        rs.getInt("quantity"));

                order.setStatus(
                        rs.getString("status"));

                Timestamp date =
                        rs.getTimestamp("order_date");

                if(date != null){
                    order.setOrderDate(
                            date.toLocalDateTime());
                }

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


}
