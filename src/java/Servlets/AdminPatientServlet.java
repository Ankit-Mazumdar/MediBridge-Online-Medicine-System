
package Servlets;

import dao.AdminPatientDAO;
import model.PatientBean;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/patients")
public class AdminPatientServlet extends HttpServlet {

    private final AdminPatientDAO dao = new AdminPatientDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // Protect the page: only logged-in admins can access it.
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin/login.jsp"
            );
            return;
        }

        List<PatientBean> patients = dao.getAllPatients();

        request.setAttribute("patients", patients);
        request.setAttribute(
            "totalPatients",
            dao.getTotalPatients()
        );

        request.getRequestDispatcher("/admin/patients.jsp")
               .forward(request, response);
    }
}
