
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.MedicineOrder;
import model.MedicineOrderItem;
import util.DBConnection;

public class MedicineOrderDAO {

    // 1. Get all medicine orders
    public List<MedicineOrder> getAllOrders() {

        List<MedicineOrder> orders = new ArrayList<>();

        String sql = "SELECT o.ORDER_ID, o.PATIENT_ID, " +
                     "o.ORDER_DATE, o.ORDER_STATUS, o.TOTAL_AMOUNT, " +
                     "p.NAME, p.EMAIL, p.CONTACT, p.ADDRESS " +
                     "FROM MEDICINE_ORDER o " +
                     "JOIN PATIENT p ON o.PATIENT_ID = p.PATIENT_ID " +
                     "ORDER BY o.ORDER_DATE DESC";

        String itemSql = "SELECT oi.MEDICINE_ID, m.MEDICINE_NAME, " +
                         "oi.QUANTITY, oi.UNIT_PRICE, oi.LINE_TOTAL " +
                         "FROM MEDICINE_ORDER_ITEMS oi " +
                         "LEFT JOIN MEDICINE m " +
                         "ON oi.MEDICINE_ID = m.MEDICINE_ID " +
                         "WHERE oi.ORDER_ID = ?";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return orders;
            }

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    MedicineOrder order = new MedicineOrder();

                    order.setId(rs.getInt("ORDER_ID"));
                    order.setPatientId(rs.getInt("PATIENT_ID"));

                    order.setOrderDate(rs.getDate("ORDER_DATE"));
                    order.setOrderStatus(rs.getString("ORDER_STATUS"));

                    order.setTotalAmount(
                        rs.getDouble("TOTAL_AMOUNT")
                    );

                    order.setPatientName(rs.getString("NAME"));
                    order.setPatientEmail(rs.getString("EMAIL"));

                    order.setPatientContact(
                        rs.getString("CONTACT")
                    );

                    order.setPatientAddress(
                        rs.getString("ADDRESS")
                    );

                    // Get medicines belonging to this order
                    List<MedicineOrderItem> items =
                        new ArrayList<>();

                    try (PreparedStatement itemPs =
                             con.prepareStatement(itemSql)) {

                        itemPs.setInt(1, order.getId());

                        try (ResultSet itemRs =
                                 itemPs.executeQuery()) {

                            while (itemRs.next()) {

                                MedicineOrderItem item =
                                    new MedicineOrderItem();

                                item.setMedicineId(
                                    itemRs.getInt("MEDICINE_ID")
                                );

                                item.setMedicineName(
                                    itemRs.getString("MEDICINE_NAME")
                                );

                                item.setQuantity(
                                    itemRs.getInt("QUANTITY")
                                );

                                item.setUnitPrice(
                                    itemRs.getDouble("UNIT_PRICE")
                                );

                                item.setLineTotal(
                                    itemRs.getDouble("LINE_TOTAL")
                                );

                                items.add(item);
                            }
                        }
                    }

                    order.setItems(items);

                    orders.add(order);
                }
            }

        } catch (Exception e) {
            System.out.println("Error fetching medicine orders!");
            e.printStackTrace();
        }

        return orders;
    }


    // 2. Update order status
    public boolean updateOrderStatus(int orderId, String status) {

        String sql = "UPDATE MEDICINE_ORDER " +
                     "SET ORDER_STATUS = ? " +
                     "WHERE ORDER_ID = ?";

        if (!"APPROVED".equals(status) &&
            !"REJECTED".equals(status) &&
            !"OUT_FOR_DELIVERY".equals(status) &&
            !"DELIVERED".equals(status)) {

            return false;
        }

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, status);
                ps.setInt(2, orderId);

                int result = ps.executeUpdate();

                return result > 0;
            }

        } catch (Exception e) {
            System.out.println("Error updating order status!");
            e.printStackTrace();
        }

        return false;
    }


    // 3. Get total number of orders
    public int getTotalOrders() {

        String sql = "SELECT COUNT(*) FROM MEDICINE_ORDER";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return 0;
            }

            try (PreparedStatement ps = con.prepareStatement(sql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }


    // 4. Get orders count by status
    public int getOrderCount(String status) {

        String sql = "SELECT COUNT(*) FROM MEDICINE_ORDER " +
                     "WHERE ORDER_STATUS = ?";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return 0;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, status);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
    
    
    
    // 5. Get all orders belonging to a particular patient
    public List<MedicineOrder> getOrdersByPatientId(int patientId) {

        List<MedicineOrder> orders = new ArrayList<>();

        String sql = "SELECT ORDER_ID, PATIENT_ID, ORDER_DATE, " +
                     "ORDER_STATUS, TOTAL_AMOUNT " +
                     "FROM MEDICINE_ORDER " +
                     "WHERE PATIENT_ID = ? " +
                     "ORDER BY ORDER_DATE DESC, ORDER_ID DESC";

        String itemSql = "SELECT oi.MEDICINE_ID, m.MEDICINE_NAME, " +
                         "oi.QUANTITY, oi.UNIT_PRICE, oi.LINE_TOTAL " +
                         "FROM MEDICINE_ORDER_ITEMS oi " +
                         "LEFT JOIN MEDICINE m " +
                         "ON oi.MEDICINE_ID = m.MEDICINE_ID " +
                         "WHERE oi.ORDER_ID = ?";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                return orders;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, patientId);

                try (ResultSet rs = ps.executeQuery()) {

                    while (rs.next()) {

                        MedicineOrder order = new MedicineOrder();

                        order.setId(rs.getInt("ORDER_ID"));
                        order.setPatientId(rs.getInt("PATIENT_ID"));
                        order.setOrderDate(rs.getDate("ORDER_DATE"));
                        order.setOrderStatus(rs.getString("ORDER_STATUS"));
                        order.setTotalAmount(rs.getDouble("TOTAL_AMOUNT"));

                        List<MedicineOrderItem> items =
                                new ArrayList<>();

                        try (PreparedStatement itemPs =
                                con.prepareStatement(itemSql)) {

                            itemPs.setInt(1, order.getId());

                            try (ResultSet itemRs = itemPs.executeQuery()) {

                                while (itemRs.next()) {

                                    MedicineOrderItem item =
                                            new MedicineOrderItem();

                                    item.setMedicineId(
                                            itemRs.getInt("MEDICINE_ID"));

                                    item.setMedicineName(
                                            itemRs.getString("MEDICINE_NAME"));

                                    item.setQuantity(
                                            itemRs.getInt("QUANTITY"));

                                    item.setUnitPrice(
                                            itemRs.getDouble("UNIT_PRICE"));

                                    item.setLineTotal(
                                            itemRs.getDouble("LINE_TOTAL"));

                                    items.add(item);
                                }
                            }
                        }

                        order.setItems(items);
                        orders.add(order);
                    }
                }
            }

        } catch (Exception e) {
            System.out.println("Error fetching patient order history!");
            e.printStackTrace();
        }

        return orders;
    }


}
