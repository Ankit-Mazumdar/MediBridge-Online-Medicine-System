
package admin;

import model.Doctor;

import java.io.IOException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/doctors")
public class AdminDoctorServlet extends HttpServlet {

    private final AdminDoctorDAO dao = new AdminDoctorDAO();

    private boolean isAdminLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("admin") != null;
    }

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp#admin");
            return;
        }

        List<Doctor> doctors = dao.getAllDoctors();
        request.setAttribute("doctors", doctors);

        request.getRequestDispatcher("/admin/doctors.jsp")
               .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (!isAdminLoggedIn(request)) {
            response.sendRedirect(
                    request.getContextPath() + "/login.jsp#admin");
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");
        String message;

        if ("status".equals(action)) {

            // Identify the doctor by email because a pending
            // doctor may not have a Doctor ID yet.
            String email = request.getParameter("email");
            String status = request.getParameter("status");

            if (isBlank(email) || status == null) {
                message = "invalid";
            } else if (!"APPROVED".equals(status)
                    && !"REJECTED".equals(status)) {
                message = "invalid";
            } else if (dao.updateDoctorStatus(
                    email.trim(), status)) {
                message = "updated";
            } else {
                message = "failed";
            }

        } else if ("add".equals(action)) {

            String fullName = request.getParameter("fullName");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String phone = request.getParameter("phone");
            String gender = request.getParameter("gender");
            String specialization =
                    request.getParameter("specialization");
            String qualification =
                    request.getParameter("qualification");
            String registrationNo =
                    request.getParameter("registrationNo");
            String experienceText =
                    request.getParameter("experience");

            if (isBlank(fullName) || isBlank(email)
                    || isBlank(password) || isBlank(phone)
                    || isBlank(specialization)
                    || isBlank(registrationNo)) {

                message = "missing";

            } else {
                try {
                    Doctor doctor = new Doctor();

                    doctor.setFullName(fullName.trim());
                    doctor.setEmail(email.trim());
                    doctor.setPassword(password);
                    doctor.setPhone(phone.trim());
                    doctor.setGender(gender);
                    doctor.setSpecialization(
                            specialization.trim());
                    doctor.setQualification(qualification);
                    doctor.setMedicalRegistrationNo(
                            registrationNo.trim());

                    if (experienceText != null
                            && !experienceText.trim().isEmpty()) {

                        int experience =
                                Integer.parseInt(experienceText);

                        if (experience < 0 || experience > 99) {
                            message = "invalidExperience";
                            response.sendRedirect(
                                request.getContextPath()
                                + "/admin/doctors?message=" + message);
                            return;
                        }

                        doctor.setExperience(experience);

                    } else {
                        doctor.setExperience(null);
                    }

                    message = dao.addDoctor(doctor)
                            ? "added" : "failed";

                } catch (NumberFormatException e) {
                    message = "invalidExperience";
                }
            }

        } else {
            message = "invalid";
        }

        response.sendRedirect(
                request.getContextPath()
                + "/admin/doctors?message=" + message);
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
