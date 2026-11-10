
package Servlets;

import admin.Admin;
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

@WebServlet("/admin/change-password")
public class ChangeAdminPasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("admin") == null) {

            response.sendRedirect(
                request.getContextPath() + "/admin/login.jsp");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (currentPassword == null ||
            newPassword == null ||
            confirmPassword == null ||
            currentPassword.trim().isEmpty() ||
            newPassword.trim().isEmpty() ||
            confirmPassword.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/admin/profile.jsp")
                   .forward(request, response);
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error",
                    "New password and confirm password do not match.");

            request.getRequestDispatcher("/admin/profile.jsp")
                   .forward(request, response);
            return;
        }

        if (newPassword.equals(currentPassword)) {
            request.setAttribute("error",
                    "New password must be different from current password.");

            request.getRequestDispatcher("/admin/profile.jsp")
                   .forward(request, response);
            return;
        }

        String sql = "UPDATE ADMIN SET PASSWORD = ? "
                   + "WHERE ADMIN_ID = ? AND PASSWORD = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setObject(2, admin.getAdminId());
            ps.setString(3, currentPassword);

            int result = ps.executeUpdate();

            if (result > 0) {

                admin.setPassword(newPassword);
                session.setAttribute("admin", admin);

                request.setAttribute("success",
                        "Password changed successfully!");

            } else {

                request.setAttribute("error",
                        "Current password is incorrect.");
            }

        } catch (Exception e) {
            e.printStackTrace();

            request.setAttribute("error",
                    "Something went wrong. Please try again.");
        }

        request.getRequestDispatcher("/admin/profile.jsp")
               .forward(request, response);
    }
}
