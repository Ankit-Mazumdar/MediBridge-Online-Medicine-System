package Servlets;

import dao.PatientDAO;
import model.PatientBean;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.WebServlet;

@WebServlet("/PatientLoginServlet")
public class PatientLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        PatientDAO dao = new PatientDAO();

        // 1. Check whether the email exists
        if (!dao.emailExists(email)) {

//            response.sendRedirect(
//                "Patient/PatientLogin.jsp?error=noaccount"
//            );

            response.sendRedirect(
    request.getContextPath() + "/Patient/PatientLogin.jsp?error=noaccount"
);

            return;
        }

        // 2. Email exists, so check the password
        PatientBean patient = dao.loginPatient(email, password);

        if (patient != null) {

            // 3. Login successful
            HttpSession session = request.getSession();

            session.setAttribute("patient", patient);
            session.setAttribute("patientId", patient.getPatientId());
            session.setAttribute("patientName", patient.getName());
            session.setAttribute("patientEmail", patient.getEmail());

//            response.sendRedirect(
//                "Patient/PatientDashboard.jsp"
//            );

            response.sendRedirect(
    request.getContextPath() + "/Patient/PatientDashboard.jsp"
);

        } else {

            // 4. Email exists but password is wrong
//            response.sendRedirect(
//                "Patient/PatientLogin.jsp?error=wrongpassword"
//            );

            response.sendRedirect(
    request.getContextPath() + "/Patient/PatientLogin.jsp?error=wrongpassword"
);
        }
    }
}