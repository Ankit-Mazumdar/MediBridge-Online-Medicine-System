
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import model.PatientBean;
import util.DBConnection;

public class AdminPatientDAO {

    public List<PatientBean> getAllPatients() {

        List<PatientBean> patients = new ArrayList<>();

        String sql =
            "SELECT p.PATIENT_ID, p.NAME, p.EMAIL, p.CONTACT, " +
            "p.DOB, p.GENDER, p.BLOOD_GROUP, " +
            "COUNT(a.APPOINTMENT_ID) AS TOTAL_APPOINTMENTS " +
            "FROM PATIENT p " +
            "LEFT JOIN APPOINTMENT a " +
            "ON LOWER(TRIM(p.EMAIL)) = LOWER(TRIM(a.PATIENT_EMAIL)) " +
            "GROUP BY p.PATIENT_ID, p.NAME, p.EMAIL, p.CONTACT, " +
            "p.DOB, p.GENDER, p.BLOOD_GROUP " +
            "ORDER BY p.PATIENT_ID DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {

                PatientBean p = new PatientBean();

                p.setPatientId(rs.getInt("PATIENT_ID"));
                p.setName(rs.getString("NAME"));
                p.setEmail(rs.getString("EMAIL"));
                p.setContact(rs.getString("CONTACT"));
                p.setDob(rs.getDate("DOB"));
                p.setGender(rs.getString("GENDER"));
                p.setBloodGroup(rs.getString("BLOOD_GROUP"));

                p.setTotalAppointments(
                    rs.getInt("TOTAL_APPOINTMENTS")
                );

                patients.add(p);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return patients;
    }

    public int getTotalPatients() {

        String sql = "SELECT COUNT(*) FROM PATIENT";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }
}
