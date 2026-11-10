
package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.DBConnection;

@WebServlet("/UpdatesStockServlet")
public class UpdatesStockServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String contextPath = request.getContextPath();

        // Check whether an admin is logged in
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(contextPath + "/login.jsp#admin");
            return;
        }

        String medicineIdValue = request.getParameter("medicine_id");
        String addStockValue = request.getParameter("add_stock");

        // Validate submitted values
        try {
            if (medicineIdValue == null || addStockValue == null) {
                response.sendRedirect(
                    contextPath + "/admin/manageStock.jsp?error=invalidInput");
                return;
            }

            int medicineId = Integer.parseInt(medicineIdValue);
            int addStock = Integer.parseInt(addStockValue);

            if (medicineId <= 0 || addStock <= 0) {
                response.sendRedirect(
                    contextPath + "/admin/manageStock.jsp?error=invalidInput");
                return;
            }

            String sql = "UPDATE MEDICINE "
                       + "SET STOCK = STOCK + ? "
                       + "WHERE MEDICINE_ID = ?";

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setInt(1, addStock);
                ps.setInt(2, medicineId);

                int rowsUpdated = ps.executeUpdate();

                if (rowsUpdated > 0) {
                    response.sendRedirect(
                        contextPath + "/admin/manageStock.jsp?success=stockUpdated");
                } else {
                    response.sendRedirect(
                        contextPath + "/admin/manageStock.jsp?error=medicineNotFound");
                }
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                contextPath + "/admin/manageStock.jsp?error=invalidInput");

        } catch (Exception e) {

            getServletContext().log("Error updating medicine stock", e);

            response.sendRedirect(
                contextPath + "/admin/manageStock.jsp?error=updateFailed");
        }
    }
}
