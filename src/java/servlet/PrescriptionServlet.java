
package servlet;

import dao.AppointmentDAO;
import dao.PrescriptionDAO;
import model.Appointment;
import model.Doctor;
import model.Prescription;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

public class PrescriptionServlet extends HttpServlet {

    // ==========================================
    // DOCTOR: OPEN FORM / VIEW PRESCRIPTIONS
    // ==========================================

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

        String doctorId = doctor.getDoctorId();
        String action = request.getParameter("action");

        // Open prescription form
        if ("create".equals(action)) {

            String appointmentIdString =
                    request.getParameter("appointmentId");

            if (appointmentIdString == null ||
                    appointmentIdString.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath() + "/AppointmentServlet");
                return;
            }

            int appointmentId;

            try {
                appointmentId = Integer.parseInt(appointmentIdString);
            } catch (NumberFormatException e) {
                response.sendRedirect(
                        request.getContextPath() + "/AppointmentServlet");
                return;
            }

            AppointmentDAO appointmentDAO =
                    new AppointmentDAO();

            List<Appointment> appointments =
                    appointmentDAO.getAppointmentsByDoctor(doctorId);

            Appointment selectedAppointment = null;

            for (Appointment appointment : appointments) {

                if (appointment.getAppointmentId() == appointmentId) {
                    selectedAppointment = appointment;
                    break;
                }
            }

            if (selectedAppointment == null) {
                response.sendRedirect(
                        request.getContextPath() + "/AppointmentServlet");
                return;
            }

            request.setAttribute("appointment", selectedAppointment);

            request.getRequestDispatcher(
                    "/doctor/prescription-form.jsp"
            ).forward(request, response);

            return;
        }

        // Show all prescriptions
        PrescriptionDAO prescriptionDAO =
                new PrescriptionDAO();

        List<Prescription> prescriptions =
                prescriptionDAO.getPrescriptionsByDoctor(doctorId);

        request.setAttribute("prescriptions", prescriptions);

        request.getRequestDispatcher(
                "/doctor/prescriptions.jsp"
        ).forward(request, response);
    }


    // ==========================================
    // DOCTOR: SAVE PRESCRIPTION
    // ==========================================

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

        String doctorId = doctor.getDoctorId();

        String appointmentIdString =
                request.getParameter("appointmentId");

        String patientName =
                request.getParameter("patientName");

        String diagnosis =
                request.getParameter("diagnosis");

        String medicines =
                request.getParameter("medicines");

        String instructions =
                request.getParameter("instructions");

        // Validate required fields
        if (appointmentIdString == null ||
                appointmentIdString.trim().isEmpty() ||
                patientName == null ||
                diagnosis == null ||
                diagnosis.trim().isEmpty() ||
                medicines == null ||
                medicines.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/AppointmentServlet");
            return;
        }

        int appointmentId;

        try {
            appointmentId = Integer.parseInt(appointmentIdString);
        } catch (NumberFormatException e) {
            response.sendRedirect(
                    request.getContextPath() + "/AppointmentServlet");
            return;
        }

        // Verify appointment belongs to this doctor
        AppointmentDAO appointmentDAO =
                new AppointmentDAO();

        List<Appointment> appointments =
                appointmentDAO.getAppointmentsByDoctor(doctorId);

        boolean validAppointment = false;

        for (Appointment appointment : appointments) {

            if (appointment.getAppointmentId() == appointmentId) {
                validAppointment = true;
                break;
            }
        }

        if (!validAppointment) {
            response.sendRedirect(
                    request.getContextPath() + "/AppointmentServlet");
            return;
        }

        // Create prescription
        Prescription prescription = new Prescription();

        prescription.setAppointmentId(appointmentId);
        prescription.setDoctorId(doctorId);
        prescription.setPatientName(patientName);
        prescription.setDiagnosis(diagnosis.trim());
        prescription.setMedicines(medicines.trim());
        prescription.setInstructions(
                instructions == null ? "" : instructions.trim());

        // Save prescription
        PrescriptionDAO prescriptionDAO =
                new PrescriptionDAO();

        boolean saved =
                prescriptionDAO.savePrescription(prescription);

        if (saved) {

            response.sendRedirect(
                    request.getContextPath() + "/PrescriptionServlet");

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/AppointmentServlet");
        }
    }
}
