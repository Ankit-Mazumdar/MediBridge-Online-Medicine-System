package Servlets;

import dao.PatientDAO;
import model.PatientBean;

import java.io.IOException;
import java.sql.Date;
import javax.servlet.annotation.WebServlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
@WebServlet("/EditProfileServlet")
public class EditProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        PatientBean patient =
                (PatientBean) session.getAttribute("patient");

        if (patient == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");

            return;
        }

        request.getRequestDispatcher(
                "Patient/EditProfile.jsp")
                .forward(request, response);
    }


    protected void doPost(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession();

        PatientBean patient =
                (PatientBean) session.getAttribute("patient");

        if (patient == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");

            return;
        }


        String name =
                request.getParameter("name");

        String contact =
                request.getParameter("contact");

        String dobString =
                request.getParameter("dob");

        String gender =
                request.getParameter("gender");

        String bloodGroup =
                request.getParameter("bloodGroup");

        String address =
                request.getParameter("address");


        try {

            Date dob = null;

            if (dobString != null &&
                !dobString.trim().isEmpty()) {

                dob = Date.valueOf(dobString);
            }


            patient.setName(name);
            patient.setContact(contact);
            patient.setDob(dob);
            patient.setGender(gender);
            patient.setBloodGroup(bloodGroup);
            patient.setAddress(address);


            PatientDAO dao =
                    new PatientDAO();

            boolean updated =
                    dao.updatePatient(patient);


            if (updated) {

                /*
                 * Update session data so the
                 * new information appears immediately.
                 */

                session.setAttribute(
                        "patient",
                        patient);

                session.setAttribute(
                        "patientName",
                        patient.getName());


                response.sendRedirect(
                        request.getContextPath()
                        + "/Patient/profile.jsp"
                        + "?updated=true");

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Patient/EditProfile.jsp"
                        + "?error=failed");
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/EditProfile.jsp"
                    + "?error=invalid");
        }
    }
}