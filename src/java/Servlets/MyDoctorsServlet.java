package Servlets;

import dao.PatientAppointmentDAO;
import model.Appointment;
import model.PatientBean;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

@WebServlet("/MyDoctorsServlet")

public class MyDoctorsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        PatientBean patient =
                (PatientBean) session.getAttribute("patient");

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

        List<Appointment> doctors =
                new ArrayList<Appointment>();

        if (appointments != null) {

            for (Appointment appointment : appointments) {

                boolean alreadyAdded = false;

                for (Appointment doctor : doctors) {

                    if (doctor.getDoctorId().equals(
                            appointment.getDoctorId())) {

                        alreadyAdded = true;
                        break;
                    }
                }

                if (!alreadyAdded) {
                    doctors.add(appointment);
                }
            }
        }

        request.setAttribute(
                "doctors",
                doctors);

        request.getRequestDispatcher(
                "Patient/MyDoctors.jsp"
        ).forward(request, response);
    }
}