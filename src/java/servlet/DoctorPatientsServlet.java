
package servlet;

import dao.AppointmentDAO;
import model.Appointment;
import model.Doctor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/DoctorPatientsServlet")
public class DoctorPatientsServlet extends HttpServlet {

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

        List<Appointment> patients =
                dao.getCompletedAppointmentsByDoctor(
                        doctor.getDoctorId()
                );

        request.setAttribute("patients", patients);

        request.getRequestDispatcher(
                "/doctor/patients.jsp"
        ).forward(request, response);
    }
}
