
package servlet;

import dao.DoctorProfileDAO;
import model.Doctor;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/DoctorUpdateFeesServlet")
public class DoctorUpdateFeesServlet extends HttpServlet {

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

        String feesValue = request.getParameter("consultationFees");

        try {

            if (feesValue == null || feesValue.trim().isEmpty()) {
                response.sendRedirect(
                        "DoctorProfileServlet?error=fees");
                return;
            }

            double fees = Double.parseDouble(feesValue);

            if (!Double.isFinite(fees) ||
                    fees <= 0 ||
                    fees > 1000000 ||
                    fees != Math.floor(fees * 100) / 100) {

                response.sendRedirect(
                        "DoctorProfileServlet?error=fees");
                return;
            }

            DoctorProfileDAO dao = new DoctorProfileDAO();

            boolean updated = dao.updateConsultationFees(
                    doctor.getDoctorId(), fees);

            if (updated) {

                doctor.setConsultationFees(fees);

                session.setAttribute("doctor", doctor);

                response.sendRedirect(
                        "DoctorProfileServlet?success=fees");

            } else {

                response.sendRedirect(
                        "DoctorProfileServlet?error=updatefees");
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    "DoctorProfileServlet?error=fees");
        }
    }
}
