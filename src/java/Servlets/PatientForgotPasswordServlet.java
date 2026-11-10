package Servlets;

import dao.PatientDAO;
import model.PatientBean;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class PatientForgotPasswordServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");

        PatientDAO dao = new PatientDAO();

        // STEP 1: Check Email
        if (action == null || "email".equals(action)) {

            String email = request.getParameter("email");

            PatientBean patient = dao.getPatientByEmail(email);

            if (patient == null) {
                response.sendRedirect("Patient/ForgotPassword.jsp?error=noaccount");
                return;
            }

            HttpSession session = request.getSession();

            session.setAttribute("resetEmail", email);
            session.setAttribute("resetQuestion",
                    patient.getSecurityQuestion());

            response.sendRedirect("Patient/ForgotPasswordQuestion.jsp");

        }

        // STEP 2: Verify Security Answer
        else if ("verify".equals(action)) {

            HttpSession session = request.getSession();

            String email = (String) session.getAttribute("resetEmail");
            String answer = request.getParameter("securityAnswer");

            if (email == null) {
                response.sendRedirect("Patient/ForgotPassword.jsp");
                return;
            }

            PatientBean patient = dao.getPatientByEmail(email);

            if (patient == null) {
                response.sendRedirect("Patient/ForgotPassword.jsp?error=noaccount");
                return;
            }

            if (answer == null ||
                    !answer.equalsIgnoreCase(patient.getSecurityAnswer())) {

                response.sendRedirect(
                        "Patient/ForgotPasswordQuestion.jsp?error=answer");
                return;
            }

            session.setAttribute("resetVerified", true);

            response.sendRedirect("Patient/ResetPassword.jsp");

        }

        // STEP 3: Reset Password
        else if ("reset".equals(action)) {

            HttpSession session = request.getSession();

            String email = (String) session.getAttribute("resetEmail");
            Boolean verified =
                    (Boolean) session.getAttribute("resetVerified");

            if (email == null || verified == null || !verified) {
                response.sendRedirect("Patient/ForgotPassword.jsp");
                return;
            }

            String password = request.getParameter("password");
            String confirmPassword =
                    request.getParameter("confirmPassword");

            if (password == null ||
                    !password.equals(confirmPassword)) {

                response.sendRedirect(
                        "Patient/ResetPassword.jsp?error=password");
                return;
            }

            boolean updated = dao.updatePassword(email, password);

            if (updated) {

                session.removeAttribute("resetEmail");
                session.removeAttribute("resetQuestion");
                session.removeAttribute("resetVerified");

                response.sendRedirect(
                        "Patient/PatientLogin.jsp?reset=true");

            } else {

                response.sendRedirect(
                        "Patient/ResetPassword.jsp?error=failed");
            }
        }
    }
}