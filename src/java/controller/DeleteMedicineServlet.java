
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.DBConnection;

@WebServlet("/DeleteMedicineServlet")
public class DeleteMedicineServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Admin login check
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String idValue = request.getParameter("medicine_id");
        String action = request.getParameter("action");

        if (idValue == null || action == null) {
            redirect(response, request, "error", "invalidInput");
            return;
        }

        int medicineId;

        try {
            medicineId = Integer.parseInt(idValue);
        } catch (NumberFormatException e) {
            redirect(response, request, "error", "invalidInput");
            return;
        }

        if (!"deactivate".equals(action)
                && !"reactivate".equals(action)) {
            redirect(response, request, "error", "invalidInput");
            return;
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Lock the medicine row while processing the action.
            String checkSql =
                "SELECT STATUS FROM MEDICINE " +
                "WHERE MEDICINE_ID = ? FOR UPDATE";

            String currentStatus = null;

            try (PreparedStatement ps =
                    con.prepareStatement(checkSql)) {

                ps.setInt(1, medicineId);

                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        currentStatus = rs.getString("STATUS");
                    }
                }
            }

            if (currentStatus == null) {
                con.rollback();
                redirect(response, request,
                         "error", "medicineNotFound");
                return;
            }

            // DEACTIVATE
            if ("deactivate".equals(action)) {

                // Count orders for this medicine that are NOT delivered.
                String orderSql =
                    "SELECT COUNT(*) " +
                    "FROM MEDICINE_ORDER_ITEMS MI " +
                    "JOIN MEDICINE_ORDER MO " +
                    "ON MI.ORDER_ID = MO.ORDER_ID " +
                    "WHERE MI.MEDICINE_ID = ? " +
                    "AND NVL(UPPER(MO.ORDER_STATUS), " +
                    "'NOT_DELIVERED') <> 'DELIVERED'";

                int pendingOrders = 0;

                try (PreparedStatement ps =
                        con.prepareStatement(orderSql)) {

                    ps.setInt(1, medicineId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            pendingOrders = rs.getInt(1);
                        }
                    }
                }

                if (pendingOrders > 0) {
                    con.rollback();
                    redirect(response, request,
                             "error", "medicineHasActiveOrders");
                    return;
                }

                String updateSql =
                    "UPDATE MEDICINE " +
                    "SET STATUS = 'INACTIVE' " +
                    "WHERE MEDICINE_ID = ?";

                try (PreparedStatement ps =
                        con.prepareStatement(updateSql)) {

                    ps.setInt(1, medicineId);
                    ps.executeUpdate();
                }

                con.commit();

                redirect(response, request,
                         "success", "medicineDeactivated");
                return;
            }

            // REACTIVATE
            if ("reactivate".equals(action)) {

                String updateSql =
                    "UPDATE MEDICINE " +
                    "SET STATUS = 'ACTIVE' " +
                    "WHERE MEDICINE_ID = ?";

                try (PreparedStatement ps =
                        con.prepareStatement(updateSql)) {

                    ps.setInt(1, medicineId);
                    ps.executeUpdate();
                }

                con.commit();

                redirect(response, request,
                         "success", "medicineReactivated");
                return;
            }

        } catch (SQLException e) {

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException ignored) {
                }
            }

            e.printStackTrace();

            redirect(response, request,
                     "error", "actionFailed");

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
    }

    private void redirect(HttpServletResponse response,
                          HttpServletRequest request,
                          String parameter,
                          String value)
            throws IOException {

        response.sendRedirect(
            request.getContextPath()
            + "/admin/manageStock.jsp?"
            + parameter + "=" + value
        );
    }
}
