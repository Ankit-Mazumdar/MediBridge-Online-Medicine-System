
package dao;

import model.Doctor;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DoctorProfileDAO {

    // 1. Fetch doctor profile
    public Doctor getDoctorProfile(String doctorId) {

        Doctor doctor = null;

        String sql = "SELECT DOCTOR_ID, FULL_NAME, EMAIL, PHONE, "
                + "GENDER, SPECIALIZATION, QUALIFICATION, "
                + "MEDICAL_REGISTRATION_NO, EXPERIENCE, STATUS, "
                + "CREATED_AT, CONSULTATION_FEES "
                + "FROM DOCTOR WHERE DOCTOR_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    doctor = new Doctor();

                    doctor.setDoctorId(rs.getString("DOCTOR_ID"));
                    doctor.setFullName(rs.getString("FULL_NAME"));
                    doctor.setEmail(rs.getString("EMAIL"));
                    doctor.setPhone(rs.getString("PHONE"));
                    doctor.setGender(rs.getString("GENDER"));
                    doctor.setSpecialization(
                            rs.getString("SPECIALIZATION"));
                    doctor.setQualification(
                            rs.getString("QUALIFICATION"));
                    doctor.setMedicalRegistrationNo(
                            rs.getString("MEDICAL_REGISTRATION_NO"));

                    int experience = rs.getInt("EXPERIENCE");

                    if (rs.wasNull()) {
                        doctor.setExperience(null);
                    } else {
                        doctor.setExperience(experience);
                    }

                    doctor.setStatus(rs.getString("STATUS"));
                    doctor.setCreatedAt(
                            rs.getTimestamp("CREATED_AT"));

                    double fees = rs.getDouble("CONSULTATION_FEES");

                    if (rs.wasNull()) {
                        doctor.setConsultationFees(null);
                    } else {
                        doctor.setConsultationFees(fees);
                    }
                }
            }

        } catch (Exception e) {
            System.out.println("Fetch doctor profile failed: "
                    + e.getMessage());
        }

        return doctor;
    }


    // 2. Change doctor password
    public boolean changePassword(
            String doctorId,
            String currentPassword,
            String newPassword) {

        String sql = "UPDATE DOCTOR SET PASSWORD = ? "
                + "WHERE DOCTOR_ID = ? AND PASSWORD = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, doctorId);
            ps.setString(3, currentPassword);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Change password failed: "
                    + e.getMessage());
        }

        return false;
    }


    // 3. Update consultation fees
    public boolean updateConsultationFees(
            String doctorId,
            double fees) {

        String sql = "UPDATE DOCTOR SET CONSULTATION_FEES = ? "
                + "WHERE DOCTOR_ID = ? AND STATUS = 'APPROVED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setDouble(1, fees);
            ps.setString(2, doctorId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Update consultation fees failed: "
                    + e.getMessage());
        }

        return false;
    }
}
