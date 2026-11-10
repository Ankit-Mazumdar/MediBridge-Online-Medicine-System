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

@WebServlet("/admin/update-emergency-request")
public class UpdateEmergencyStatusServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp#admin");
            return;
        }

        String type = request.getParameter("type");
        String status = request.getParameter("status");
        String id = request.getParameter("requestId");

        String table;
        String column;
        String section;

        if ("ambulance".equals(type)) {
            table = "AMBULANCE_REQUEST";
            column = "REQUEST_STATUS";
            section = "ambulance";
        } else if ("blood".equals(type)) {
            table = "REQUEST_BLOOD";
            column = "REQUEST_STATUS";
            section = "blood";
        } else if ("room".equals(type)) {
            table = "EMERGENCY_ROOM";
            column = "REQUEST_STATUS";
            section = "room";
        } else if ("doctor".equals(type)) {
            table = "EMERGENCY_DOCTOR";
            column = "DOCTOR_STATUS";
            section = "doctor";
        } else {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid request type.");
            return;
        }

        if (!isValid(status, "PENDING", "APPROVED", "REJECTED",
                "COMPLETED", "IN_PROGRESS", "ASSIGNED")) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid status.");
            return;
        }

        try {
            int requestId = Integer.parseInt(id);

            String sql = "UPDATE " + table +
                    " SET " + column + " = ? WHERE REQUEST_ID = ?";

            try (Connection con = DBConnection.getConnection()) {
                if (con == null) {
                    throw new ServletException(
                            "Database connection is unavailable.");
                }

                try (PreparedStatement ps = con.prepareStatement(sql)) {
                    ps.setString(1, status.trim().toUpperCase());
                    ps.setInt(2, requestId);

                    int updated = ps.executeUpdate();

                    if (updated == 0) {
                        response.sendError(
                                HttpServletResponse.SC_NOT_FOUND,
                                "Emergency request was not found.");
                        return;
                    }
                }
            }

            // Reload the same section; SQL sorting moves terminal
            // requests to the bottom and the JSP hides their update form.
            response.sendRedirect(
                    request.getContextPath()
                    + "/admin/emergency-requests?section=" + section);

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid request ID.");
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(
                    "Error updating emergency request", e);
        }
    }

    private boolean isValid(String value, String... allowed) {
        if (value == null) {
            return false;
        }

        for (String item : allowed) {
            if (item.equalsIgnoreCase(value.trim())) {
                return true;
            }
        }

        return false;
    }
}
