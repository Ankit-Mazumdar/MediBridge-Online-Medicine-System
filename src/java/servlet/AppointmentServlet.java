
package servlet;

import dao.AppointmentDAO;
import model.Appointment;
import model.Doctor;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class AppointmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Doctor doctor = (session == null) ? null :
                (Doctor) session.getAttribute("doctor");

        if (doctor == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        AppointmentDAO dao = new AppointmentDAO();

        List<Appointment> appointments =
            dao.getAppointmentsByDoctor(doctor.getDoctorId());

        request.setAttribute("appointments", appointments);

        request.getRequestDispatcher(
            "/doctor/appointments.jsp"
        ).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Doctor doctor = (session == null) ? null :
                (Doctor) session.getAttribute("doctor");

        if (doctor == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String id = request.getParameter("appointmentId");

        if (action == null || id == null) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Missing appointment information.");
            return;
        }

        try {

            int appointmentId = Integer.parseInt(id);

            AppointmentDAO dao = new AppointmentDAO();

            // START CONSULTATION
            if ("start".equals(action)) {

                String meetingRoom = dao.startConsultation(
                    appointmentId,
                    doctor.getDoctorId()
                );

                if (meetingRoom == null) {
                    response.sendError(
                        HttpServletResponse.SC_CONFLICT,
                        "Unable to start consultation. " +
                        "Check the appointment status."
                    );
                    return;
                }

                // Keep the room in this doctor's session.
                session.setAttribute(
                    "consultationRoom_" + appointmentId,
                    meetingRoom
                );

                response.sendRedirect(
                    request.getContextPath() +
                    "/doctor/consultation.jsp?appointmentId=" +
                    appointmentId
                );

                return;
            }

            // OTHER APPOINTMENT ACTIONS
            String status = null;

            if ("accept".equals(action)) {

                status = "ACCEPTED";

            } else if ("reject".equals(action)) {

                status = "REJECTED";

            } else if ("complete".equals(action)) {

                status = "COMPLETED";

            } else {

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid appointment action.");
                return;
            }

            boolean updated = dao.updateAppointmentStatus(
                appointmentId,
                doctor.getDoctorId(),
                status
            );

            if (!updated) {
                response.sendError(
                    HttpServletResponse.SC_CONFLICT,
                    "Appointment could not be updated. " +
                    "It may already have changed status."
                );
                return;
            }

            response.sendRedirect(
                request.getContextPath() + "/AppointmentServlet"
            );

        } catch (NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid appointment ID."
            );
        }
    }
}
