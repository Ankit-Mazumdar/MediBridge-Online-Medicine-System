
package servlet;

import dao.DoctorProfileDAO;
import model.Doctor;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DoctorProfileServlet")
public class DoctorProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
                session.getAttribute("doctor") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        Doctor loggedDoctor =
                (Doctor) session.getAttribute("doctor");

        DoctorProfileDAO dao = new DoctorProfileDAO();

        Doctor doctor =
                dao.getDoctorProfile(loggedDoctor.getDoctorId());

        if (doctor == null) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp");
            return;
        }

        request.setAttribute("doctorProfile", doctor);

        request.getRequestDispatcher(
                "/doctor/profile.jsp").forward(request, response);
    }
}
