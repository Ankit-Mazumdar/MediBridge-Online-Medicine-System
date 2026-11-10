package Servlets;

import dao.PatientPrescriptionDAO;
import model.PatientBean;
import model.Prescription;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;


@WebServlet("/PatientPrescriptionServlet")
public class PatientPrescriptionServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // Check patient login
        if (session == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");
            return;
        }

        PatientBean patient =
                (PatientBean) session.getAttribute("patient");

        if (patient == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");
            return;
        }

        String patientEmail =
                patient.getEmail();

        PatientPrescriptionDAO dao =
                new PatientPrescriptionDAO();

        List<Prescription> prescriptions =
                dao.getPrescriptionsByPatient(
                        patientEmail);

        request.setAttribute(
                "prescriptions",
                prescriptions);

        request.getRequestDispatcher(
                "/Patient/prescriptions.jsp")
                .forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        doGet(request, response);
    }
}