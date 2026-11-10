package Servlets;

import dao.AppointmentDAO;
import dao.PrescriptionDAO;
import model.Appointment;
import model.Doctor;
import model.Prescription;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;

import java.io.IOException;
import java.util.List;
//

@MultipartConfig
//@WebServlet("/PrescriptionServlet")
public class PrescriptionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Doctor doctor =
                (Doctor) session.getAttribute("doctor");

        // Check doctor login
        if (doctor == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        String doctorId = doctor.getDoctorId();

        String action = request.getParameter("action");

        /*
         * =====================================================
         * OPEN PRESCRIPTION FORM FOR AN APPOINTMENT
         * =====================================================
         */

        if ("create".equals(action)) {

            String appointmentIdString =
                    request.getParameter("appointmentId");

            if (appointmentIdString == null) {
                response.sendRedirect("AppointmentServlet");
                return;
            }

            int appointmentId =
                    Integer.parseInt(appointmentIdString);

            AppointmentDAO appointmentDAO =
                    new AppointmentDAO();

            List<Appointment> appointments =
                    appointmentDAO.getAppointmentsByDoctor(doctorId);

            Appointment selectedAppointment = null;

            for (Appointment appointment : appointments) {

                if (appointment.getAppointmentId()
                        == appointmentId) {

                    selectedAppointment = appointment;
                    break;
                }
            }

            if (selectedAppointment == null) {

                response.sendRedirect("AppointmentServlet");
                return;
            }

            request.setAttribute(
                    "appointment",
                    selectedAppointment
            );

            request.getRequestDispatcher(
                    "doctor/prescription-form.jsp"
            ).forward(request, response);

            return;
        }


        /*
         * =====================================================
         * SHOW ALL PRESCRIPTIONS
         * =====================================================
         */

        PrescriptionDAO prescriptionDAO =
                new PrescriptionDAO();

        List<Prescription> prescriptions =
                prescriptionDAO.getPrescriptionsByDoctor(
                        doctorId
                );

        request.setAttribute(
                "prescriptions",
                prescriptions
        );

        request.getRequestDispatcher(
                "doctor/prescriptions.jsp"
        ).forward(request, response);
    }


    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        Doctor doctor =
                (Doctor) session.getAttribute("doctor");

        // Check doctor login
        if (doctor == null) {

            response.sendRedirect("login.jsp");
            return;
        }

        String doctorId = doctor.getDoctorId();
        System.out.println("========== PRESCRIPTION SAVE START ==========");
System.out.println("Doctor ID = " + doctorId);

        String appointmentIdString =
                request.getParameter("appointmentId");
        System.out.println("Appointment ID String = " + appointmentIdString);

        String patientName =
                request.getParameter("patientName");

        String diagnosis =
                request.getParameter("diagnosis");

        String medicines =
                request.getParameter("medicines");

        String instructions =
                request.getParameter("instructions");
        
        System.out.println("Patient Name = " + patientName);
System.out.println("Diagnosis = " + diagnosis);
System.out.println("Medicines = " + medicines);
System.out.println("Instructions = " + instructions);

String prescriptionFile = null;

Part prescriptionFilePart =
        request.getPart("prescriptionFile");

//String prescriptionFile = null;
if (prescriptionFilePart != null
        && prescriptionFilePart.getSize() > 0) {

    prescriptionFile =
            prescriptionFilePart.getSubmittedFileName();
}
//if (prescriptionFilePart != null
//        && prescriptionFilePart.getSize() > 0) {
//
//    String contentDisposition =
//            prescriptionFilePart.getHeader("content-disposition");
//
//    if (contentDisposition != null) {
//
//        String[] parts =
//                contentDisposition.split(";");
//
//        for (String part : parts) {
//
//            if (part.trim().startsWith("filename")) {
//
//                prescriptionFile =
//                        part.substring(
//                                part.indexOf('=') + 1
//                        ).trim();
//
//                prescriptionFile =
//                        prescriptionFile.replace("\"", "");
//
//                break;
//            }
//        }
//    }
//}

System.out.println("Appointment ID String = "
        + appointmentIdString);

System.out.println("Patient Name = "
        + patientName);

System.out.println("Diagnosis = "
        + diagnosis);

System.out.println("Medicines = "
        + medicines);

System.out.println("Instructions = "
        + instructions);

System.out.println("Prescription File = "
        + prescriptionFile);


        if (appointmentIdString == null) {

            response.sendRedirect("AppointmentServlet");
            return;
        }

        int appointmentId =
                Integer.parseInt(appointmentIdString);


        Prescription prescription =
                new Prescription();

        prescription.setAppointmentId(
                appointmentId
        );

        prescription.setDoctorId(
                doctorId
        );

        prescription.setPatientName(
                patientName
        );

        prescription.setDiagnosis(
                diagnosis
        );

        prescription.setMedicines(
                medicines
        );

        prescription.setInstructions(
                instructions
        );
        prescription.setPrescriptionFile(
        prescriptionFile
);


        PrescriptionDAO prescriptionDAO =
                new PrescriptionDAO();

        boolean saved =
                prescriptionDAO.savePrescription(
                        prescription
                );
        
        System.out.println("Prescription DAO saved = " + saved);
System.out.println("========== PRESCRIPTION SAVE END ==========");


        if (saved) {

            response.sendRedirect(
                    "PrescriptionServlet"
            );

        } else {

            response.sendRedirect(
                    "AppointmentServlet"
            );
        }
    }
}