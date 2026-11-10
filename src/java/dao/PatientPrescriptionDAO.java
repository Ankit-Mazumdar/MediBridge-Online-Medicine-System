package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Prescription;
import util.DBConnection;

public class PatientPrescriptionDAO {

    /*
     * Get all prescriptions belonging to a patient
     * using the patient's email.
     */
    public List<Prescription> getPrescriptionsByPatient(
            String patientEmail) {

        List<Prescription> prescriptions =
                new ArrayList<Prescription>();

        String sql =
                "SELECT p.PRESCRIPTION_ID, "
              + "p.APPOINTMENT_ID, "
              + "p.DOCTOR_ID, "
              + "p.PATIENT_NAME, "
              + "p.DIAGNOSIS, "
              + "p.MEDICINES, "
              + "p.INSTRUCTIONS, "
              + "p.PRESCRIPTION_FILE, "
              + "p.CREATED_AT, "
              + "d.FULL_NAME, "
              + "d.SPECIALIZATION "
              + "FROM PRESCRIPTION p "
              + "JOIN APPOINTMENT a "
              + "ON p.APPOINTMENT_ID = a.APPOINTMENT_ID "
              + "JOIN DOCTOR d "
              + "ON p.DOCTOR_ID = d.DOCTOR_ID "
              + "WHERE a.PATIENT_EMAIL = ? "
              + "ORDER BY p.CREATED_AT DESC";

        try {

            Connection con =
                    DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, patientEmail);

            ResultSet rs =
                    ps.executeQuery();

            while (rs.next()) {

                Prescription prescription =
                        new Prescription();

                prescription.setPrescriptionId(
                        rs.getInt("PRESCRIPTION_ID"));

                prescription.setAppointmentId(
                        rs.getInt("APPOINTMENT_ID"));

                prescription.setDoctorId(
                        rs.getString("DOCTOR_ID"));

                prescription.setPatientName(
                        rs.getString("PATIENT_NAME"));

                prescription.setDiagnosis(
                        rs.getString("DIAGNOSIS"));

                prescription.setMedicines(
                        rs.getString("MEDICINES"));

                prescription.setInstructions(
                        rs.getString("INSTRUCTIONS"));

               

                prescription.setCreatedAt(
                        rs.getTimestamp("CREATED_AT"));

                prescription.setDoctorName(
                        rs.getString("FULL_NAME"));

                prescription.setSpecialization(
                        rs.getString("SPECIALIZATION"));

                prescriptions.add(prescription);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return prescriptions;
    }
    
    public int getPrescriptionCountByPatient(String patientEmail) {

    int count = 0;

    String sql =
            "SELECT COUNT(*) "
          + "FROM PRESCRIPTION p "
          + "JOIN APPOINTMENT a "
          + "ON p.APPOINTMENT_ID = a.APPOINTMENT_ID "
          + "WHERE a.PATIENT_EMAIL = ?";

    try {

        Connection con =
                DBConnection.getConnection();

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, patientEmail);

        ResultSet rs =
                ps.executeQuery();

        if (rs.next()) {
            count = rs.getInt(1);
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return count;
    }
}