
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

@WebServlet("/emergency_blood")
public class emergency_blood extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Get form parameters
        String patientName = request.getParameter("patientName");
        String bloodGroup = request.getParameter("bloodGroup");
        String unitsRequired = request.getParameter("unitsRequired");
        String contactNumber = request.getParameter("contactNumber");

        // Validate required fields
        if (patientName == null || patientName.trim().isEmpty()
                || bloodGroup == null || bloodGroup.trim().isEmpty()
                || unitsRequired == null || unitsRequired.trim().isEmpty()
                || contactNumber == null || contactNumber.trim().isEmpty()) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please fill in all required fields."
            );
            return;
        }

        // Validate blood group
        String[] validGroups = {
            "A+", "A-", "B+", "B-",
            "O+", "O-", "AB+", "AB-"
        };

        boolean validBloodGroup = false;

        for (String group : validGroups) {
            if (group.equals(bloodGroup)) {
                validBloodGroup = true;
                break;
            }
        }

        if (!validBloodGroup) {
            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid blood group selected."
            );
            return;
        }

        // Validate units
        int units;

        try {
            units = Integer.parseInt(unitsRequired.trim());

            if (units <= 0) {
                response.sendError(
                        HttpServletResponse.SC_BAD_REQUEST,
                        "Units required must be greater than zero."
                );
                return;
            }

        } catch (NumberFormatException e) {

            response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Please enter valid units."
            );
            return;
        }

        // Insert blood request into Oracle
        String sql = "INSERT INTO request_blood "
                + "(request_id, patient_name, blood_group, units_required, "
                + "contact_number, request_status, request_date) "
                + "VALUES (request_blood_seq.NEXTVAL, ?, ?, ?, ?, "
                + "'PENDING', SYSDATE)";

        try {

            try (Connection con = DBConnection.getConnection();
                 PreparedStatement ps = con.prepareStatement(sql)) {

                if (con == null) {
                    throw new Exception("Database connection unavailable.");
                }

                ps.setString(1, patientName.trim());
                ps.setString(2, bloodGroup);
                ps.setInt(3, units);
                ps.setString(4, contactNumber.trim());

                int result = ps.executeUpdate();

                if (result <= 0) {
                    response.sendError(
                            HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                            "Blood request could not be submitted."
                    );
                    return;
                }
            }

            // Set attributes for success page
            request.setAttribute("patient_name", patientName);
            request.setAttribute("blood_group", bloodGroup);
            request.setAttribute("units_required", unitsRequired);
            request.setAttribute("contact_number", contactNumber);

            // Forward to success page
            request.getRequestDispatcher(
                    "/emergency/emergency_blood_success.jsp"
            ).forward(request, response);

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to submit blood request. Please try again."
            );
        }
    }
}
