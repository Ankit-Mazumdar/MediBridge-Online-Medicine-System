package servlet;

import dao.DoctorDAO;
import model.Doctor;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/DoctorLoginServlet")
public class DoctorLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        DoctorDAO dao = new DoctorDAO();

        Doctor doctor = dao.loginDoctor(email, password);
       System.out.println("Doctor Status = " + (doctor == null ? "NULL" : doctor.getStatus()));

        if (doctor == null) {

            response.sendRedirect("login.jsp?error=NotFound#doctor");

        } else if ("PENDING".equals(doctor.getStatus())) {

            response.sendRedirect("login.jsp?error=Pending#doctor");

        } else if ("REJECTED".equals(doctor.getStatus())) {

            response.sendRedirect("login.jsp?error=Rejected#doctor");

        } else if ("APPROVED".equals(doctor.getStatus())) {

            HttpSession session = request.getSession();

            session.setAttribute("doctor", doctor);

            response.sendRedirect("doctor/dashboard.jsp");

        } else {

            response.sendRedirect("login.jsp?error=Invalid#doctor");
        }
    }
}