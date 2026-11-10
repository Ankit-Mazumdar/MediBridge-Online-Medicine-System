
package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.util.List;
import dao.MedicineOrderDAO;
import model.MedicineOrder;

import util.DBConnection;

@WebServlet("/OrdersServlet")
public class OrdersServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Check patient login
        if (session == null || session.getAttribute("patientId") == null) {
            response.sendRedirect(
                request.getContextPath() + "/Patient/PatientLogin.jsp"
            );
            return;
        }

        Connection con = null;

        try {

            // 2. Get patient ID from session
            int patientId = Integer.parseInt(
                session.getAttribute("patientId").toString()
            );

            // 3. Read medicine ID and quantity
            String medicineIdParam = request.getParameter("medicine_id");
            String quantityParam = request.getParameter("quantity");

            if (medicineIdParam == null || quantityParam == null) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Medicine ID and quantity are required."
                );
                return;
            }

            int medicineId = Integer.parseInt(medicineIdParam);
            int quantity = Integer.parseInt(quantityParam);

            if (medicineId <= 0 || quantity <= 0) {
                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid medicine ID or quantity."
                );
                return;
            }

            // 4. Connect to Oracle
            con = DBConnection.getConnection();

            if (con == null) {
                throw new SQLException("Database connection failed.");
            }

            // Start transaction
            con.setAutoCommit(false);

            String medicineName;
            BigDecimal price;
            int availableStock;

            // 5. Fetch medicine details and lock its row
            String medicineSQL =
                "SELECT MEDICINE_NAME, PRICE, STOCK " +
                "FROM MEDICINE " +
                "WHERE MEDICINE_ID = ? FOR UPDATE";

            try (PreparedStatement ps =
                    con.prepareStatement(medicineSQL)) {

                ps.setInt(1, medicineId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        throw new SQLException("Medicine not found.");
                    }

                    medicineName = rs.getString("MEDICINE_NAME");
                    price = rs.getBigDecimal("PRICE");
                    availableStock = rs.getInt("STOCK");
                }
            }

            // 6. Check available stock
            if (quantity > availableStock) {
                throw new SQLException(
                    "Insufficient stock. Available quantity: "
                    + availableStock
                );
            }

            // 7. Calculate total amount using database price
            BigDecimal totalAmount =
                price.multiply(BigDecimal.valueOf(quantity));

            // 8. Generate order ID from Oracle sequence
            int orderId;

            String sequenceSQL =
                "SELECT MEDICINE_ORDER_SEQ.NEXTVAL FROM DUAL";

            try (Statement st = con.createStatement();
                 ResultSet rs = st.executeQuery(sequenceSQL)) {

                rs.next();
                orderId = rs.getInt(1);
            }

            // 9. Insert order into MEDICINE_ORDER
            String orderSQL =
                "INSERT INTO MEDICINE_ORDER " +
                "(ORDER_ID, PATIENT_ID, ORDER_DATE, " +
                "ORDER_STATUS, TOTAL_AMOUNT) " +
                "VALUES (?, ?, SYSDATE, 'PENDING', ?)";

            try (PreparedStatement ps =
                    con.prepareStatement(orderSQL)) {

                ps.setInt(1, orderId);
                ps.setInt(2, patientId);
                ps.setBigDecimal(3, totalAmount);

                ps.executeUpdate();
            }

            // 10. Insert medicine details into MEDICINE_ORDER_ITEMS
            String itemSQL =
                "INSERT INTO MEDICINE_ORDER_ITEMS " +
                "(ORDER_ID, MEDICINE_ID, QUANTITY, " +
                "UNIT_PRICE, LINE_TOTAL) " +
                "VALUES (?, ?, ?, ?, ?)";

            try (PreparedStatement ps =
                    con.prepareStatement(itemSQL)) {

                ps.setInt(1, orderId);
                ps.setInt(2, medicineId);
                ps.setInt(3, quantity);
                ps.setBigDecimal(4, price);
                ps.setBigDecimal(5, totalAmount);

                ps.executeUpdate();
            }

            // 11. Reduce available medicine stock
            String stockSQL =
                "UPDATE MEDICINE " +
                "SET STOCK = STOCK - ? " +
                "WHERE MEDICINE_ID = ? AND STOCK >= ?";

            try (PreparedStatement ps =
                    con.prepareStatement(stockSQL)) {

                ps.setInt(1, quantity);
                ps.setInt(2, medicineId);
                ps.setInt(3, quantity);

                int updated = ps.executeUpdate();

                if (updated != 1) {
                    throw new SQLException(
                        "Unable to update medicine stock."
                    );
                }
            }

            // 12. Commit the complete transaction
            con.commit();

            // 13. Send order details to confirmation page
            request.setAttribute(
                "orderedMedicineName", medicineName
            );

            request.setAttribute(
                "orderedQuantity", quantity
            );

            request.setAttribute(
                "orderId", orderId
            );

            request.setAttribute(
                "totalAmount", totalAmount
            );

            request.getRequestDispatcher(
                "/Patient/OrderConfirmation.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            rollbackTransaction(con);

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid patient ID, medicine ID or quantity."
            );

        } catch (SQLException e) {

            rollbackTransaction(con);

            getServletContext().log(
                "Medicine order database error", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to place order: " + e.getMessage()
            );

        } catch (Exception e) {

            rollbackTransaction(con);

            getServletContext().log(
                "Unexpected medicine order error", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "An unexpected error occurred while placing the order."
            );

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    getServletContext().log(
                        "Error closing database connection", e
                    );
                }
            }
        }
    }

    // Roll back all database changes if an order fails.
    private void rollbackTransaction(Connection con) {

        if (con != null) {
            try {
                con.rollback();
            } catch (SQLException e) {
                getServletContext().log(
                    "Transaction rollback failed", e
                );
            }
        }
    }
    
    
    // Display order history for the logged-in patient
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Check patient login
        if (session == null ||
            session.getAttribute("patientId") == null) {

            response.sendRedirect(
                request.getContextPath() +
                "/Patient/PatientLogin.jsp"
            );
            return;
        }

        try {

            int patientId = Integer.parseInt(
                session.getAttribute("patientId").toString()
            );

            // Fetch patient's orders
            MedicineOrderDAO dao = new MedicineOrderDAO();

            List<MedicineOrder> orders =
                    dao.getOrdersByPatientId(patientId);

            // Send orders to JSP
            request.setAttribute("orders", orders);

            request.getRequestDispatcher(
                "/Patient/orderHistory.jsp"
            ).forward(request, response);

        } catch (NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid patient session."
            );

        } catch (Exception e) {

            getServletContext().log(
                "Unable to load patient order history", e
            );

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to load order history."
            );
        }
    }

}
