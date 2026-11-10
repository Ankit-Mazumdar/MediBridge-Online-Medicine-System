
package Servlets;

import dao.PatientAppointmentDAO;
import model.Appointment;
import model.PatientBean;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/AppointmentHistoryServlet")
public class AppointmentHistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        PatientBean patient = (session == null)
                ? null
                : (PatientBean) session.getAttribute("patient");

        if (patient == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");
            return;
        }

        PatientAppointmentDAO dao =
                new PatientAppointmentDAO();

        List<Appointment> appointments =
                dao.getAppointmentsByPatient(
                        patient.getEmail());

        request.setAttribute("appointments", appointments);

        request.getRequestDispatcher(
                "/Patient/AppointmentHistory.jsp"
        ).forward(request, response);
    }
}
