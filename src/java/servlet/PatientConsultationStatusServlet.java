
package servlet;

import dao.PatientAppointmentDAO;
import model.PatientBean;
import model.Appointment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/PatientConsultationStatusServlet")
public class PatientConsultationStatusServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/plain");
        response.setCharacterEncoding("UTF-8");
        response.setHeader("Cache-Control", "no-cache, no-store");

        HttpSession session = request.getSession(false);

        PatientBean patient = (session == null) ? null :
            (PatientBean) session.getAttribute("patient");

        if (patient == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        PatientAppointmentDAO dao = new PatientAppointmentDAO();

        List<Appointment> appointments =
            dao.getAppointmentsByPatient(patient.getEmail());

        String activeAppointmentId = "";

        if (appointments != null) {
            for (Appointment appointment : appointments) {

                if ("IN_CONSULTATION".equalsIgnoreCase(
                        appointment.getStatus())
                    && appointment.getMeetingRoom() != null
                    && !appointment.getMeetingRoom().trim().isEmpty()) {

                    activeAppointmentId =
                        String.valueOf(appointment.getAppointmentId());

                    break;
                }
            }
        }

        response.getWriter().write(activeAppointmentId);
    }
}
