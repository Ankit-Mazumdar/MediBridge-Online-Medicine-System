package Servlets;

import dao.PatientDAO;
import model.PatientBean;
import java.io.IOException;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.annotation.WebServlet;

@WebServlet("/PatientRegisterServlet")

public class PatientRegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String contact = request.getParameter("contact");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String dobString = request.getParameter("dob");
        String gender = request.getParameter("gender");
        String bloodGroup = request.getParameter("bloodGroup");
        String address = request.getParameter("address");
        String securityQuestion = request.getParameter("securityQuestion");
        String securityAnswer = request.getParameter("securityAnswer");

        // Check password confirmation
        if (password == null || !password.equals(confirmPassword)) {
//            response.sendRedirect("Patient/PatientRegister.jsp?error=password");
                response.sendRedirect(request.getContextPath() + "/Patient/PatientRegister.jsp?error=password");
            return;
        }

        PatientDAO dao = new PatientDAO();

        // Check whether account already exists
        if (dao.emailExists(email)) {
//            response.sendRedirect("Patient/PatientRegister.jsp?error=email");
                response.sendRedirect(request.getContextPath() + "/Patient/PatientRegister.jsp?error=email");
            return;
        }

        try {

            PatientBean patient = new PatientBean();

            patient.setName(name);
            patient.setEmail(email);
            patient.setContact(contact);
            patient.setPassword(password);
            patient.setDob(Date.valueOf(dobString));
            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setAddress(address);
            patient.setSecurityQuestion(securityQuestion);
            patient.setSecurityAnswer(securityAnswer);

            boolean registered = dao.registerPatient(patient);

            if (registered) {

                // Registration successful
                response.sendRedirect(
//                    "Patient/PatientLogin.jsp?registered=true"
                        request.getContextPath() + "/Patient/PatientLogin.jsp?registered=true"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath() + "/Patient/PatientRegister.jsp?error=failed"
                );

                    
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                request.getContextPath() + "/Patient/PatientRegister.jsp?error=failed"
            );
        }
    }
}