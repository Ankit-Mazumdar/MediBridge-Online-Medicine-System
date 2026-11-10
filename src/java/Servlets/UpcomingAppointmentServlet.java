package Servlets;

import dao.PatientAppointmentDAO;
import model.Appointment;
import model.PatientBean;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;

@WebServlet("/UpcomingAppointmentServlet")
public class UpcomingAppointmentServlet extends HttpServlet {

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

        String email =
                patient.getEmail();

        PatientAppointmentDAO dao =
                new PatientAppointmentDAO();

        List<Appointment> appointments =
                dao.getAppointmentsByPatient(email);

        request.setAttribute(
                "appointments",
                appointments);

        request.getRequestDispatcher(
                "Patient/UpcomingAppointment.jsp"
        ).forward(request, response);
    }


    protected void doPost(HttpServletRequest request,
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

        String action =
                request.getParameter("action");


        if ("cancel".equals(action)) {

            String appointmentIdString =
                    request.getParameter("appointmentId");


            if (appointmentIdString == null ||
                appointmentIdString.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/UpcomingAppointmentServlet");

                return;
            }


            try {

                int appointmentId =
                        Integer.parseInt(
                                appointmentIdString);


                PatientAppointmentDAO dao =
                        new PatientAppointmentDAO();

                boolean cancelled =
                        dao.cancelAppointment(
                                appointmentId,
                                patient.getEmail());


                if (cancelled) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/UpcomingAppointmentServlet"
                            + "?cancelled=true");

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/UpcomingAppointmentServlet"
                            + "?error=cancel");

                }

            } catch (NumberFormatException e) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/UpcomingAppointmentServlet"
                        + "?error=cancel");
            }

            return;
        }


        response.sendRedirect(
                request.getContextPath()
                + "/UpcomingAppointmentServlet");
    }
}