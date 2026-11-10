
package servlet;

import dao.DoctorProfileDAO;
import model.Doctor;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DoctorChangePasswordServlet")
public class DoctorChangePasswordServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("doctor") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Doctor doctor = (Doctor) session.getAttribute("doctor");

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (currentPassword == null ||
                newPassword == null ||
                confirmPassword == null ||
                currentPassword.trim().isEmpty() ||
                newPassword.trim().isEmpty() ||
                confirmPassword.trim().isEmpty()) {

            response.sendRedirect(
                    "DoctorProfileServlet?error=empty");
            return;
        }

        if (newPassword.length() < 8) {
            response.sendRedirect(
                    "DoctorProfileServlet?error=weak");
            return;
        }

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(
                    "DoctorProfileServlet?error=mismatch");
            return;
        }

        DoctorProfileDAO dao = new DoctorProfileDAO();

        boolean updated = dao.changePassword(
                doctor.getDoctorId(),
                currentPassword,
                newPassword);

        if (updated) {

            doctor.setPassword(newPassword);

            session.setAttribute("doctor", doctor);

            response.sendRedirect(
                    "DoctorProfileServlet?success=password");

        } else {

            response.sendRedirect(
                    "DoctorProfileServlet?error=incorrect");
        }
    }
}
