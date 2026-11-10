package controller;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import util.DBConnection;

@WebServlet("/admin/emergency-requests")
public class AdminEmergencyServlet extends HttpServlet {

    private List<Map<String, Object>> getRequests(
            Connection con, String sql) throws Exception {

        List<Map<String, Object>> list =
                new ArrayList<Map<String, Object>>();

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row =
                        new HashMap<String, Object>();

                row.put("REQUEST_ID", rs.getObject("REQUEST_ID"));
                row.put("PATIENT_NAME", rs.getObject("PATIENT_NAME"));
                row.put("CONTACT", rs.getObject("CONTACT"));
                row.put("AGE", rs.getObject("AGE"));
                row.put("DETAIL", rs.getObject("DETAIL"));
                row.put("LOCATION", rs.getObject("LOCATION"));
                row.put("STATUS", rs.getObject("STATUS"));
                row.put("REQUEST_DATE", rs.getObject("REQUEST_DATE"));

                list.add(row);
            }
        }

        return list;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp#admin");
            return;
        }

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                throw new ServletException(
                        "Database connection is unavailable.");
            }

            // Completed and rejected requests are always sorted last.
            String activeFirstOrder =
                    " ORDER BY CASE " +
                    "WHEN UPPER(TRIM(REQUEST_STATUS)) " +
                    "IN ('COMPLETED','REJECTED') THEN 1 ELSE 0 END, " +
                    "REQUEST_DATE DESC";

            String ambulanceSQL =
                "SELECT REQUEST_ID, PATIENT_NAME, CONTACT, AGE, " +
                "AMBULANCE_TYPE || ' - ' || EMERGENCY_TYPE AS DETAIL, " +
                "PICKUP_LOCATION AS LOCATION, " +
                "REQUEST_STATUS AS STATUS, REQUEST_DATE " +
                "FROM AMBULANCE_REQUEST" + activeFirstOrder;

            String bloodSQL =
                "SELECT REQUEST_ID, PATIENT_NAME, " +
                "CONTACT_NUMBER AS CONTACT, " +
                "UNITS_REQUIRED AS AGE, " +
                "'Blood Group: ' || BLOOD_GROUP || " +
                "' | Units: ' || UNITS_REQUIRED AS DETAIL, " +
                "NULL AS LOCATION, " +
                "REQUEST_STATUS AS STATUS, REQUEST_DATE " +
                "FROM REQUEST_BLOOD " +
                "ORDER BY CASE WHEN UPPER(TRIM(REQUEST_STATUS)) " +
                "IN ('COMPLETED','REJECTED') THEN 1 ELSE 0 END, " +
                "REQUEST_DATE DESC";

            String roomSQL =
                "SELECT REQUEST_ID, PATIENT_NAME, CONTACT, " +
                "PATIENT_AGE AS AGE, " +
                "'Bed Type: ' || BED_TYPE AS DETAIL, " +
                "NULL AS LOCATION, " +
                "REQUEST_STATUS AS STATUS, REQUEST_DATE " +
                "FROM EMERGENCY_ROOM" + activeFirstOrder;

            String doctorSQL =
                "SELECT REQUEST_ID, PATIENT_NAME, CONTACT, " +
                "NULL AS AGE, " +
                "EMERGENCY_TYPE || ' - ' || DESCRIPTION AS DETAIL, " +
                "NULL AS LOCATION, " +
                "DOCTOR_STATUS AS STATUS, REQUEST_DATE " +
                "FROM EMERGENCY_DOCTOR " +
                "ORDER BY CASE WHEN UPPER(TRIM(DOCTOR_STATUS)) " +
                "IN ('COMPLETED','REJECTED') THEN 1 ELSE 0 END, " +
                "REQUEST_DATE DESC";

            request.setAttribute("ambulanceRequests",
                    getRequests(con, ambulanceSQL));
            request.setAttribute("bloodRequests",
                    getRequests(con, bloodSQL));
            request.setAttribute("roomRequests",
                    getRequests(con, roomSQL));
            request.setAttribute("doctorRequests",
                    getRequests(con, doctorSQL));

            request.getRequestDispatcher(
                    "/admin/emergencyRequests.jsp"
            ).forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException(
                    "Error loading emergency requests", e);
        }
    }
}
