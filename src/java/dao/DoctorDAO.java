package dao;

import model.Doctor;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class DoctorDAO {

    public boolean registerDoctor(Doctor doctor) {

        boolean result = false;

        String q1 = "INSERT INTO DOCTOR "
                + "(FULL_NAME, EMAIL, PASSWORD, PHONE, GENDER, "
                + "SPECIALIZATION, QUALIFICATION, MEDICAL_REGISTRATION_NO, "
                + "EXPERIENCE, MEDICAL_CERTIFICATE, GOVT_ID_PHOTO, STATUS) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'PENDING')";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(q1);

            ps.setString(1, doctor.getFullName());
            ps.setString(2, doctor.getEmail());
            ps.setString(3, doctor.getPassword());
            ps.setString(4, doctor.getPhone());
            ps.setString(5, doctor.getGender());
            ps.setString(6, doctor.getSpecialization());
            ps.setString(7, doctor.getQualification());
            ps.setString(8, doctor.getMedicalRegistrationNo());

            if (doctor.getExperience() != null) {
                ps.setInt(9, doctor.getExperience());
            } else {
                ps.setNull(9, java.sql.Types.INTEGER);
            }

            if (doctor.getMedicalCertificate() != null) {
                ps.setBytes(10, doctor.getMedicalCertificate());
            } else {
                ps.setNull(10, java.sql.Types.BLOB);
            }

            if (doctor.getGovtIdPhoto() != null) {
                ps.setBytes(11, doctor.getGovtIdPhoto());
            } else {
                ps.setNull(11, java.sql.Types.BLOB);
            }

            int rows = ps.executeUpdate();

            if (rows > 0) {
                result = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {

            System.out.println("Doctor registration failed.");
            System.out.println("Error: " + e.getMessage());
        }

        return result;
    }
    
    public Doctor loginDoctor(String email, String password) {

    Doctor doctor = null;

    String q1 = "SELECT * FROM DOCTOR "
            + "WHERE EMAIL = ? AND PASSWORD = ?";

    try {

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(q1);

        ps.setString(1, email);
        ps.setString(2, password);

        java.sql.ResultSet rs = ps.executeQuery();

        if (rs.next()) {

            
            System.out.println("DB STATUS = " + rs.getString("STATUS"));
            doctor = new Doctor();

            doctor.setDoctorId(rs.getString("DOCTOR_ID"));
            doctor.setFullName(rs.getString("FULL_NAME"));
            doctor.setEmail(rs.getString("EMAIL"));
            doctor.setPassword(rs.getString("PASSWORD"));
            doctor.setPhone(rs.getString("PHONE"));
            doctor.setGender(rs.getString("GENDER"));
            doctor.setSpecialization(rs.getString("SPECIALIZATION"));
            doctor.setQualification(rs.getString("QUALIFICATION"));
            doctor.setMedicalRegistrationNo(
                    rs.getString("MEDICAL_REGISTRATION_NO")
            );
            doctor.setExperience(rs.getInt("EXPERIENCE"));
            
            // Assuming your Doctor.java has status
            doctor.setStatus(rs.getString("STATUS"));
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {

        System.out.println("Doctor login failed.");
        System.out.println("Error: " + e.getMessage());
    }

    return doctor;
}
}