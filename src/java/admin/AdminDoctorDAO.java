
package admin;

import model.Doctor;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class AdminDoctorDAO {

    // Fetch all doctors currently stored in Oracle
    public List<Doctor> getAllDoctors() {

        List<Doctor> doctors = new ArrayList<Doctor>();

        String sql = "SELECT DOCTOR_ID, FULL_NAME, EMAIL, PHONE, "
                   + "SPECIALIZATION, QUALIFICATION, STATUS, CREATED_AT "
                   + "FROM DOCTOR ORDER BY CREATED_AT DESC NULLS LAST";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                Doctor doctor = new Doctor();

                doctor.setDoctorId(rs.getString("DOCTOR_ID"));
                doctor.setFullName(rs.getString("FULL_NAME"));
                doctor.setEmail(rs.getString("EMAIL"));
                doctor.setPhone(rs.getString("PHONE"));
                doctor.setSpecialization(
                        rs.getString("SPECIALIZATION"));
                doctor.setQualification(
                        rs.getString("QUALIFICATION"));
                doctor.setStatus(rs.getString("STATUS"));

                doctors.add(doctor);
            }

        } catch (Exception e) {
            System.out.println("Error fetching doctors: "
                    + e.getMessage());
            e.printStackTrace();
        }

        return doctors;
    }

    // Approve or reject a doctor
    
public boolean updateDoctorStatus(String email, String status) {

    if (email == null || email.trim().isEmpty()) {
        return false;
    }

    if (!"APPROVED".equals(status) && !"REJECTED".equals(status)) {
        return false;
    }

    String findIdSql =
        "SELECT DOCTOR_ID FROM DOCTOR WHERE LOWER(TRIM(EMAIL)) = LOWER(TRIM(?))";

    String nextIdSql =
        "SELECT NVL(MAX(TO_NUMBER(DOCTOR_ID)), 0) + 1 " +
        "FROM DOCTOR WHERE REGEXP_LIKE(DOCTOR_ID, '^[0-9]+$')";

    String updateSql =
        "UPDATE DOCTOR SET DOCTOR_ID = ?, STATUS = ? " +
        "WHERE LOWER(TRIM(EMAIL)) = LOWER(TRIM(?))";

    String rejectSql =
        "UPDATE DOCTOR SET STATUS = ? " +
        "WHERE LOWER(TRIM(EMAIL)) = LOWER(TRIM(?))";

    try (java.sql.Connection con = util.DBConnection.getConnection()) {

        if (con == null) {
            return false;
        }

        con.setAutoCommit(false);

        try {
            String doctorId = null;

            try (java.sql.PreparedStatement ps =
                     con.prepareStatement(findIdSql)) {

                ps.setString(1, email);

                try (java.sql.ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }

                    doctorId = rs.getString("DOCTOR_ID");
                }
            }

            int updated;

            if ("APPROVED".equals(status) &&
                    (doctorId == null || doctorId.trim().isEmpty())) {

                try (java.sql.Statement st = con.createStatement();
                     java.sql.ResultSet rs = st.executeQuery(nextIdSql)) {

                    rs.next();
                    doctorId = rs.getString(1);
                }

                try (java.sql.PreparedStatement ps =
                         con.prepareStatement(updateSql)) {

                    ps.setString(1, doctorId);
                    ps.setString(2, "APPROVED");
                    ps.setString(3, email);

                    updated = ps.executeUpdate();
                }

            } else if ("APPROVED".equals(status)) {

                try (java.sql.PreparedStatement ps =
                         con.prepareStatement(
                             "UPDATE DOCTOR SET STATUS = ? " +
                             "WHERE LOWER(TRIM(EMAIL)) = LOWER(TRIM(?))")) {

                    ps.setString(1, "APPROVED");
                    ps.setString(2, email);
                    updated = ps.executeUpdate();
                }

            } else {

                try (java.sql.PreparedStatement ps =
                         con.prepareStatement(rejectSql)) {

                    ps.setString(1, "REJECTED");
                    ps.setString(2, email);
                    updated = ps.executeUpdate();
                }
            }

            if (updated > 0) {
                con.commit();
                return true;
            }

            con.rollback();
            return false;

        } catch (Exception e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}


   
public boolean addDoctor(Doctor doctor) {

    String idSql =
        "SELECT NVL(MAX(TO_NUMBER(DOCTOR_ID)), 0) + 1 " +
        "FROM DOCTOR " +
        "WHERE REGEXP_LIKE(DOCTOR_ID, '^[0-9]+$')";

    String insertSql =
        "INSERT INTO DOCTOR " +
        "(DOCTOR_ID, FULL_NAME, EMAIL, PASSWORD, PHONE, GENDER, " +
        "SPECIALIZATION, QUALIFICATION, MEDICAL_REGISTRATION_NO, " +
        "EXPERIENCE, STATUS) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'APPROVED')";

    try (Connection con = DBConnection.getConnection()) {

        if (con == null) {
            return false;
        }

        con.setAutoCommit(false);

        try {
            String doctorId = null;

            try (PreparedStatement ps = con.prepareStatement(idSql);
                 ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    doctorId = rs.getString(1);
                }
            }

            if (doctorId == null) {
                con.rollback();
                return false;
            }

            try (PreparedStatement ps =
                     con.prepareStatement(insertSql)) {

                ps.setString(1, doctorId);
                ps.setString(2, doctor.getFullName());
                ps.setString(3, doctor.getEmail());
                ps.setString(4, doctor.getPassword());
                ps.setString(5, doctor.getPhone());
                ps.setString(6, doctor.getGender());
                ps.setString(7, doctor.getSpecialization());
                ps.setString(8, doctor.getQualification());
                ps.setString(9, doctor.getMedicalRegistrationNo());

                if (doctor.getExperience() == null) {
                    ps.setNull(10, java.sql.Types.NUMERIC);
                } else {
                    ps.setInt(10, doctor.getExperience());
                }

                int rows = ps.executeUpdate();

                if (rows > 0) {
                    con.commit();
                    return true;
                }

                con.rollback();
                return false;
            }

        } catch (Exception e) {
            con.rollback();
            throw e;

        } finally {
            con.setAutoCommit(true);
        }

    } catch (Exception e) {
        e.printStackTrace();
        return false;
    }
}
    
    

public byte[] getDoctorDocumentByEmail(String email, String type) {

    if (email == null || email.trim().isEmpty()) {
        return null;
    }

    String column;

    if ("certificate".equals(type)) {
        column = "MEDICAL_CERTIFICATE";
    } else if ("govtId".equals(type)) {
        column = "GOVT_ID_PHOTO";
    } else {
        return null;
    }

    String sql = "SELECT " + column
               + " FROM DOCTOR "
               + "WHERE LOWER(TRIM(EMAIL)) = LOWER(TRIM(?))";

    try (java.sql.Connection con = util.DBConnection.getConnection();
         java.sql.PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, email.trim());

        try (java.sql.ResultSet rs = ps.executeQuery()) {

            if (!rs.next()) {
                return null;
            }

            java.sql.Blob blob = rs.getBlob(1);

            if (blob == null) {
                return null;
            }

            long length = blob.length();

            if (length <= 0 || length > 10L * 1024 * 1024) {
                return null;
            }

            return blob.getBytes(1, (int) length);
        }

    } catch (Exception e) {
        e.printStackTrace();
        return null;
    }
}



}
