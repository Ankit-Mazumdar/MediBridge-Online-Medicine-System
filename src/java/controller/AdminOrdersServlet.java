
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.MedicineOrder;
import model.MedicineOrderItem;
import util.DBConnection;

@WebServlet("/AdminOrdersServlet")
public class AdminOrdersServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // 1. Check admin login
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(contextPath + "/login.jsp#admin");
            return;
        }

        // 2. SQL query to get all orders and medicine details
        String sql =
            "SELECT mo.ORDER_ID, mo.PATIENT_ID, " +
            "p.NAME AS PATIENT_NAME, " +
            "p.EMAIL AS PATIENT_EMAIL, " +
            "p.CONTACT AS PATIENT_CONTACT, " +
            "p.ADDRESS AS PATIENT_ADDRESS, " +
            "mo.ORDER_DATE, mo.ORDER_STATUS, mo.TOTAL_AMOUNT, " +
            "moi.MEDICINE_ID, m.MEDICINE_NAME, " +
            "moi.QUANTITY, moi.UNIT_PRICE, moi.LINE_TOTAL " +
            "FROM MEDICINE_ORDER mo " +
            "JOIN PATIENT p ON mo.PATIENT_ID = p.PATIENT_ID " +
            "LEFT JOIN MEDICINE_ORDER_ITEMS moi " +
            "ON mo.ORDER_ID = moi.ORDER_ID " +
            "LEFT JOIN MEDICINE m " +
            "ON moi.MEDICINE_ID = m.MEDICINE_ID " +

            // Show pending orders first
            "ORDER BY " +
            "CASE mo.ORDER_STATUS " +
            "WHEN 'PENDING' THEN 1 " +
            "WHEN 'APPROVED' THEN 2 " +
            "WHEN 'OUT_FOR_DELIVERY' THEN 3 " +
            "WHEN 'DELIVERED' THEN 4 " +
            "WHEN 'REJECTED' THEN 5 " +
            "ELSE 6 END, " +
            "mo.ORDER_DATE DESC, mo.ORDER_ID DESC";

        // 3. Store orders using Order ID
        Map<Integer, MedicineOrder> orderMap =
            new LinkedHashMap<Integer, MedicineOrder>();

        try (
            Connection con = DBConnection.getConnection();
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery()
        ) {

            // 4. Read order details
            while (rs.next()) {

                int orderId = rs.getInt("ORDER_ID");

                MedicineOrder order = orderMap.get(orderId);

                // Create order only once
                if (order == null) {

                    order = new MedicineOrder();

                    order.setId(orderId);
                    order.setPatientId(rs.getInt("PATIENT_ID"));

                    order.setPatientName(
                        rs.getString("PATIENT_NAME")
                    );

                    order.setPatientEmail(
                        rs.getString("PATIENT_EMAIL")
                    );

                    order.setPatientContact(
                        rs.getString("PATIENT_CONTACT")
                    );

                    order.setPatientAddress(
                        rs.getString("PATIENT_ADDRESS")
                    );

                    order.setOrderDate(
                        rs.getDate("ORDER_DATE")
                    );

                    order.setOrderStatus(
                        rs.getString("ORDER_STATUS")
                    );

                    order.setTotalAmount(
                        rs.getDouble("TOTAL_AMOUNT")
                    );

                    orderMap.put(orderId, order);
                }

                // 5. Add medicine details to the order
                int medicineId = rs.getInt("MEDICINE_ID");

                if (!rs.wasNull()) {

                    MedicineOrderItem item =
                        new MedicineOrderItem();

                    item.setMedicineId(medicineId);

                    item.setMedicineName(
                        rs.getString("MEDICINE_NAME")
                    );

                    item.setQuantity(
                        rs.getInt("QUANTITY")
                    );

                    item.setUnitPrice(
                        rs.getDouble("UNIT_PRICE")
                    );

                    item.setLineTotal(
                        rs.getDouble("LINE_TOTAL")
                    );

                    order.getItems().add(item);
                }
            }

            // 6. Convert Map into List
            List<MedicineOrder> orders =
                new ArrayList<MedicineOrder>(orderMap.values());

            // 7. Calculate order statistics
            int pendingCount = 0;
            int approvedCount = 0;
            int deliveryCount = 0;
            int deliveredCount = 0;
            int rejectedCount = 0;

            for (MedicineOrder order : orders) {

                String status = order.getOrderStatus();

                if ("PENDING".equalsIgnoreCase(status)) {
                    pendingCount++;
                }
                else if ("APPROVED".equalsIgnoreCase(status)) {
                    approvedCount++;
                }
                else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) {
                    deliveryCount++;
                }
                else if ("DELIVERED".equalsIgnoreCase(status)) {
                    deliveredCount++;
                }
                else if ("REJECTED".equalsIgnoreCase(status)) {
                    rejectedCount++;
                }
            }

            // 8. Send data to JSP
            request.setAttribute("orders", orders);

            request.setAttribute("totalOrders", orders.size());
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("approvedCount", approvedCount);
            request.setAttribute("deliveryCount", deliveryCount);
            request.setAttribute("deliveredCount", deliveredCount);
            request.setAttribute("rejectedCount", rejectedCount);

            // 9. Open admin orders page
            request.getRequestDispatcher(
                "/admin/manageOrders.jsp"
            ).forward(request, response);

        }
        catch (Exception e) {

            getServletContext().log(
                "Error loading admin medicine orders", e
            );

            request.setAttribute(
                "orders",
                new ArrayList<MedicineOrder>()
            );

            request.setAttribute(
                "errorMessage",
                "Unable to load medicine orders. Please try again."
            );

            request.getRequestDispatcher(
                "/admin/manageOrders.jsp"
            ).forward(request, response);
        }
    }
}
