
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Prescription;
import util.DBConnection;

public class PrescriptionDAO {

    // Save prescription
    public boolean savePrescription(Prescription prescription) {

        String sql =
            "INSERT INTO PRESCRIPTION " +
            "(PRESCRIPTION_ID, APPOINTMENT_ID, DOCTOR_ID, PATIENT_NAME, " +
            "DIAGNOSIS, MEDICINES, INSTRUCTIONS, CREATED_AT) " +
            "VALUES (PRESCRIPTION_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP)";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setInt(1, prescription.getAppointmentId());
            ps.setString(2, prescription.getDoctorId());
            ps.setString(3, prescription.getPatientName());
            ps.setString(4, prescription.getDiagnosis());
            ps.setString(5, prescription.getMedicines());
            ps.setString(6, prescription.getInstructions());

            System.out.println("PrescriptionDAO: Executing INSERT...");

            int result = ps.executeUpdate();

            System.out.println("PrescriptionDAO: INSERT result = " + result);

            ps.close();
            con.close();

            return result > 0;

        } catch (Exception e) {

            e.printStackTrace();
        }

        return false;
    }


    // Get prescriptions by doctor
    public List<Prescription> getPrescriptionsByDoctor(String doctorId) {

        List<Prescription> prescriptions =
                new ArrayList<Prescription>();

        String sql =
            "SELECT PRESCRIPTION_ID, APPOINTMENT_ID, DOCTOR_ID, " +
            "PATIENT_NAME, DIAGNOSIS, MEDICINES, INSTRUCTIONS, " +
            "CREATED_AT " +
            "FROM PRESCRIPTION " +
            "WHERE DOCTOR_ID = ? " +
            "ORDER BY CREATED_AT DESC";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, doctorId);

            ResultSet rs = ps.executeQuery();

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


    // Get prescription for a particular appointment
    public Prescription getPrescriptionByAppointment(
            int appointmentId,
            String doctorId) {

        Prescription prescription = null;

        String sql =
            "SELECT PRESCRIPTION_ID, APPOINTMENT_ID, DOCTOR_ID, " +
            "PATIENT_NAME, DIAGNOSIS, MEDICINES, INSTRUCTIONS, " +
            "CREATED_AT " +
            "FROM PRESCRIPTION " +
            "WHERE APPOINTMENT_ID = ? " +
            "AND DOCTOR_ID = ?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, appointmentId);
            ps.setString(2, doctorId);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                prescription = new Prescription();

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
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return prescription;
    }
}
