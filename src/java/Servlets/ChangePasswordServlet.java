package Servlets;

import dao.PatientDAO;
import model.PatientBean;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class ChangePasswordServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        PatientBean patient =
                (PatientBean) session.getAttribute("patient");

        if (patient == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");
            return;
        }

        request.getRequestDispatcher(
                "Patient/ChangePassword.jsp")
                .forward(request, response);
    }

    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        PatientBean patient =
                (PatientBean) session.getAttribute("patient");

        if (patient == null) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");
            return;
        }

        String currentPassword =
                request.getParameter("currentPassword");

        String newPassword =
                request.getParameter("newPassword");

        String confirmPassword =
                request.getParameter("confirmPassword");

        if (!newPassword.equals(confirmPassword)) {
            response.sendRedirect(
                    request.getContextPath()
                    + "/ChangePasswordServlet"
                    + "?error=mismatch");
            return;
        }

        PatientDAO dao = new PatientDAO();

        if (!dao.checkPassword(
                patient.getEmail(),
                currentPassword)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/ChangePasswordServlet"
                    + "?error=wrong");
            return;
        }

        if (dao.updatePassword(
                patient.getEmail(),
                newPassword)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/profile.jsp"
                    + "?passwordChanged=true");

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/ChangePasswordServlet"
                    + "?error=failed");
        }
    }
}