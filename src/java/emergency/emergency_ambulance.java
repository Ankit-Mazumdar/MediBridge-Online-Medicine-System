
package emergency;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/emergency_ambulance")
public class emergency_ambulance extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String patientName = request.getParameter("patientName");
        String contact = request.getParameter("contact");
        String ageValue = request.getParameter("age");
        String emergencyType = request.getParameter("emergencyType");
        String ambulanceType = request.getParameter("ambulanceType");
        String pickupLocation = request.getParameter("pickupLocation");

        if (patientName == null || patientName.trim().isEmpty()
                || contact == null || contact.trim().isEmpty()
                || ageValue == null || ageValue.trim().isEmpty()
                || emergencyType == null || emergencyType.trim().isEmpty()
                || ambulanceType == null || ambulanceType.trim().isEmpty()
                || pickupLocation == null || pickupLocation.trim().isEmpty()) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Please fill in all required fields.");
            return;
        }

        int age;

        try {
            age = Integer.parseInt(ageValue);

            if (age < 1 || age > 120) {
                response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                        "Please enter a valid patient age.");
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid patient age.");
            return;
        }

        patientName = patientName.trim();
        contact = contact.trim();
        pickupLocation = pickupLocation.trim();

        String sql = "INSERT INTO ambulance_request "
                + "(request_id, patient_name, contact, age, emergency_type, "
                + "ambulance_type, pickup_location, request_status) "
                + "VALUES (ambulance_seq.NEXTVAL, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new SQLException("Database connection is unavailable.");
            }

            try (PreparedStatement ps = con.prepareStatement(
                    sql, Statement.RETURN_GENERATED_KEYS)) {

                ps.setString(1, patientName);
                ps.setString(2, contact);
                ps.setInt(3, age);
                ps.setString(4, emergencyType);
                ps.setString(5, ambulanceType);
                ps.setString(6, pickupLocation);

                int result = ps.executeUpdate();

                if (result == 0) {
                    throw new SQLException("Ambulance request was not saved.");
                }
            }

            // Retrieve the newly inserted request ID.
            String idSql = "SELECT ambulance_seq.CURRVAL FROM dual";

            long requestId;

            try (PreparedStatement idPs = con.prepareStatement(idSql);
                 ResultSet rs = idPs.executeQuery()) {

                if (!rs.next()) {
                    throw new SQLException("Unable to retrieve request ID.");
                }

                requestId = rs.getLong(1);
            }

            request.setAttribute("requestId", requestId);
            request.setAttribute("patientName", patientName);
            request.setAttribute("contact", contact);
            request.setAttribute("age", age);
            request.setAttribute("emergencyType", emergencyType);
            request.setAttribute("ambulanceType", ambulanceType);
            request.setAttribute("pickupLocation", pickupLocation);

            request.getRequestDispatcher(
                    "/emergency/emergency_ambulance_success.jsp")
                    .forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to submit ambulance request. " + e.getMessage(), e);
        }
    }
}
