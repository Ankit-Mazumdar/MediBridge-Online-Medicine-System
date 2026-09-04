package servlet;

import dao.DoctorDAO;
import model.Doctor;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

@WebServlet("/DoctorRegistrationServlet")
public class DoctorRegistrationServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName = "";
        String email = "";
        String password = "";
        String phone = "";
        String gender = "";
        String specialization = "";
        String qualification = "";
        String medicalRegistrationNo = "";
        Integer experience = null;

        byte[] medicalCertificate = null;
        byte[] govtIdPhoto = null;

        try {

            // Create factory
            DiskFileItemFactory factory = new DiskFileItemFactory();

            // Create file upload object
            ServletFileUpload upload = new ServletFileUpload(factory);

            // Read all form data
            List<FileItem> items = upload.parseRequest(request);

            // Read each form field
            for (FileItem item : items) {

                if (item.isFormField()) {

                    String name = item.getFieldName();
                    String value = item.getString("UTF-8");

                    if (name.equals("fullName")) {
                        fullName = value;
                    }
                    else if (name.equals("email")) {
                        email = value;
                    }
                    else if (name.equals("password")) {
                        password = value;
                    }
                    else if (name.equals("phone")) {
                        phone = value;
                    }
                    else if (name.equals("gender")) {
                        gender = value;
                    }
                    else if (name.equals("specialization")) {
                        specialization = value;
                    }
                    else if (name.equals("qualification")) {
                        qualification = value;
                    }
                    else if (name.equals("medicalRegistrationNo")) {
                        medicalRegistrationNo = value;
                    }
                    else if (name.equals("experience")) {
                        experience = Integer.parseInt(value);
                    }

                }
                else {

                    // File upload
                    String name = item.getFieldName();

                    if (name.equals("medicalCertificate")) {
                        medicalCertificate = item.get();
                    }

                    else if (name.equals("govtIdPhoto")) {
                        govtIdPhoto = item.get();
                    }
                }
            }

            // Create Doctor object
            Doctor doctor = new Doctor();

            doctor.setFullName(fullName);
            doctor.setEmail(email);
            doctor.setPassword(password);
            doctor.setPhone(phone);
            doctor.setGender(gender);
            doctor.setSpecialization(specialization);
            doctor.setQualification(qualification);
            doctor.setMedicalRegistrationNo(medicalRegistrationNo);
            doctor.setExperience(experience);

            doctor.setMedicalCertificate(medicalCertificate);
            doctor.setGovtIdPhoto(govtIdPhoto);

            // Create DAO object
            DoctorDAO dao = new DoctorDAO();

            // Register doctor
            boolean result = dao.registerDoctor(doctor);

            if (result) {
    response.sendRedirect("registrationSuccess.jsp");
}
            else {
                response.sendRedirect("doctorRegister.jsp?error=RegistrationFailed");
            }

        }
        catch (Exception e) {

            System.out.println("Registration Error: " + e.getMessage());

            response.sendRedirect("doctorRegister.jsp?error=RegistrationFailed");
        }
    }
}