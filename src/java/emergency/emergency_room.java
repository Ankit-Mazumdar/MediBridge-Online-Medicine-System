
package emergency;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/emergency_room")
public class emergency_room extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Get form data from emergency_bed.jsp
        String patientName = request.getParameter("patient_name");
        String contact = request.getParameter("contact");
        String age = request.getParameter("patient_age");
        String bedType = request.getParameter("bed_type");

        // Validate fields
        if (patientName == null || patientName.trim().isEmpty()
                || contact == null || contact.trim().isEmpty()
                || age == null || age.trim().isEmpty()
                || bedType == null || bedType.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please fill in all required fields."
            );
            return;
        }

        int patientAge;

        try {
            patientAge = Integer.parseInt(age.trim());

            if (patientAge < 1 || patientAge > 120) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Please enter a valid patient age."
                );
                return;
            }

        } catch (NumberFormatException e) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid patient age."
            );
            return;
        }

        // Validate bed type
        if (!bedType.equals("Emergency")
                && !bedType.equals("ICU")
                && !bedType.equals("Trauma")) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid bed type."
            );
            return;
        }

        String sql = "INSERT INTO emergency_room "
                + "(request_id, patient_name, contact, patient_age, "
                + "bed_type, request_status, request_date) "
                + "VALUES (emergency_room_seq.NEXTVAL, ?, ?, ?, ?, "
                + "'pending', SYSDATE)";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new Exception("Database connection is unavailable.");
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, patientName.trim());
                ps.setString(2, contact.trim());
                ps.setInt(3, patientAge);
                ps.setString(4, bedType);

                int result = ps.executeUpdate();

                if (result <= 0) {
                    response.sendError(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Bed request could not be submitted."
                    );
                    return;
                }
            }

            // Send details to success JSP
            request.setAttribute("patient_name", patientName);
            request.setAttribute("contact", contact);
            request.setAttribute("patient_age", age);
            request.setAttribute("bed_type", bedType);

            request.getRequestDispatcher(
                    "/emergency/emergency_room_success.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            if (!response.isCommitted()) {
                response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Database error while submitting bed request."
                );
            }
        }
    }
}
