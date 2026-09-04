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

//@WebServlet("/AppointmentServlet")
public class AppointmentServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Doctor doctor = (Doctor) session.getAttribute("doctor");

        // Check doctor login
        if (doctor == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        String doctorId = doctor.getDoctorId();

        AppointmentDAO appointmentDAO = new AppointmentDAO();

        List<Appointment> appointments =
                appointmentDAO.getAppointmentsByDoctor(doctorId);

        // Send appointments to JSP
        request.setAttribute("appointments", appointments);

        request.getRequestDispatcher(
                "doctor/appointments.jsp"
        ).forward(request, response);
    }
    
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Doctor doctor = (Doctor) session.getAttribute("doctor");

        if (doctor == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String doctorId = doctor.getDoctorId();

        String action = request.getParameter("action");
        String appointmentIdString =
                request.getParameter("appointmentId");

        if (action != null && appointmentIdString != null) {

            int appointmentId =
                    Integer.parseInt(appointmentIdString);

            String status = null;

            if (action.equals("accept")) {
                status = "ACCEPTED";
            }

            if (action.equals("reject")) {
                status = "REJECTED";
            }

            if (status != null) {

                AppointmentDAO appointmentDAO =
                        new AppointmentDAO();

                appointmentDAO.updateAppointmentStatus(
                        appointmentId,
                        doctorId,
                        status
                );
            }
        }

        response.sendRedirect("AppointmentServlet");
    }
}