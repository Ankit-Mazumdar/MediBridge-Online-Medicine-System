
package servlet;

import dao.PatientAppointmentDAO;
import model.PatientBean;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/JoinConsultationServlet")
public class JoinConsultationServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        PatientBean patient = (session == null) ? null :
            (PatientBean) session.getAttribute("patient");

        if (patient == null) {
            response.sendRedirect(
                request.getContextPath() + "/Patient/PatientLogin.jsp"
            );
            return;
        }

        String id = request.getParameter("appointmentId");

        if (id == null || !id.matches("\\d+")) {
            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid appointment ID."
            );
            return;
        }

        int appointmentId = Integer.parseInt(id);

        PatientAppointmentDAO dao = new PatientAppointmentDAO();

        String room = dao.getMeetingRoomForPatient(
            appointmentId,
            patient.getEmail()
        );

        if (room == null || room.trim().isEmpty()) {
            response.sendError(
                HttpServletResponse.SC_FORBIDDEN,
                "The consultation is not available for this appointment."
            );
            return;
        }

        response.sendRedirect(
            request.getContextPath() +
            "/Patient/consultation.jsp?appointmentId=" +
            appointmentId
        );
    }
}
