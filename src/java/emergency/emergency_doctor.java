
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

@WebServlet("/emergency_doctor")
public class emergency_doctor extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String patientName = request.getParameter("patientName");
        String contact = request.getParameter("contact");
        String problem = request.getParameter("problem");
        String description = request.getParameter("description");

        // Basic validation
        if (patientName == null || patientName.trim().isEmpty()
                || contact == null || contact.trim().isEmpty()
                || problem == null || problem.trim().isEmpty()
                || description == null || description.trim().isEmpty()) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Please fill in all required fields."
            );

            return;
        }

        String sql = "INSERT INTO emergency_doctor "
                + "(request_id, patient_name, contact, emergency_type, "
                + "description, doctor_status, request_date) "
                + "VALUES (emergency_doctor_seq.NEXTVAL, ?, ?, ?, ?, 'Pending', SYSDATE)";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new Exception("Database connection is unavailable.");
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, patientName.trim());
                ps.setString(2, contact.trim());
                ps.setString(3, problem.trim());
                ps.setString(4, description.trim());

                int result = ps.executeUpdate();

                if (result > 0) {

                    request.setAttribute("patientName", patientName);
                    request.setAttribute("contact", contact);
                    request.setAttribute("problem", problem);
                    request.setAttribute("description", description);
                    request.setAttribute("status", "Pending");

                    request.getRequestDispatcher(
                        "/emergency/emergency_doctor_success.jsp"
                    ).forward(request, response);

                } else {

                    response.sendError(
                        HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                        "Unable to submit emergency doctor request."
                    );

                }
            }

        } catch (Exception e) {

            e.printStackTrace();

            if (!response.isCommitted()) {
                response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to save emergency request. Please try again."
                );
            }
        }
    }
}
