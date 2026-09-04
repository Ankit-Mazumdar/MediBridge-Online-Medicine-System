package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Appointment;
import util.DBConnection;

public class AppointmentDAO {

    // Get all appointments for a particular doctor
    public List<Appointment> getAppointmentsByDoctor(String doctorId) {

        List<Appointment> appointments = new ArrayList<Appointment>();

        String sql = "SELECT APPOINTMENT_ID, DOCTOR_ID, PATIENT_NAME, "
                   + "PATIENT_EMAIL, PATIENT_PHONE, APPOINTMENT_DATE, "
                   + "APPOINTMENT_TIME, REASON, STATUS, CREATED_AT "
                   + "FROM APPOINTMENT "
                   + "WHERE DOCTOR_ID = ? "
                   + "ORDER BY APPOINTMENT_DATE DESC, APPOINTMENT_TIME ASC";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, doctorId);

            ResultSet rs = ps.executeQuery();

            while (rs.next()) {

                Appointment appointment = new Appointment();

                appointment.setAppointmentId(
                    rs.getInt("APPOINTMENT_ID")
                );

                appointment.setDoctorId(
                    rs.getString("DOCTOR_ID")
                );

                appointment.setPatientName(
                    rs.getString("PATIENT_NAME")
                );

                appointment.setPatientEmail(
                    rs.getString("PATIENT_EMAIL")
                );

                appointment.setPatientPhone(
                    rs.getString("PATIENT_PHONE")
                );

                appointment.setAppointmentDate(
                    rs.getDate("APPOINTMENT_DATE")
                );

                appointment.setAppointmentTime(
                    rs.getString("APPOINTMENT_TIME")
                );

                appointment.setReason(
                    rs.getString("REASON")
                );

                appointment.setStatus(
                    rs.getString("STATUS")
                );

                appointment.setCreatedAt(
                    rs.getTimestamp("CREATED_AT")
                );

                appointments.add(appointment);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            e.printStackTrace();
        }

        return appointments;
    }


    // Count appointments for a doctor
    public int getAppointmentCount(String doctorId) {

        int count = 0;

        String sql = "SELECT COUNT(*) FROM APPOINTMENT "
                   + "WHERE DOCTOR_ID = ?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, doctorId);

            ResultSet rs = ps.executeQuery();

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
    
    public int countToday(String doctorId) {

    int count = 0;

    String sql =
        "SELECT COUNT(*) FROM APPOINTMENT " +
        "WHERE DOCTOR_ID = ? " +
        "AND TRUNC(APPOINTMENT_DATE) = TRUNC(SYSDATE)";

    try {

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, doctorId);

        ResultSet rs = ps.executeQuery();

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
    
    public List<Appointment> getTodaysSchedule(String doctorId) {

    List<Appointment> appointments = new ArrayList<Appointment>();

    String sql =
        "SELECT * FROM APPOINTMENT " +
        "WHERE DOCTOR_ID = ? " +
        "AND TRUNC(APPOINTMENT_DATE) = TRUNC(SYSDATE) " +
        "ORDER BY APPOINTMENT_TIME";

    try {

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, doctorId);

        ResultSet rs = ps.executeQuery();

        while (rs.next()) {

            Appointment appointment = new Appointment();

            appointment.setAppointmentId(
                    rs.getInt("APPOINTMENT_ID"));

            appointment.setDoctorId(
                    rs.getString("DOCTOR_ID"));

            appointment.setPatientName(
                    rs.getString("PATIENT_NAME"));

            appointment.setPatientEmail(
                    rs.getString("PATIENT_EMAIL"));

            appointment.setPatientPhone(
                    rs.getString("PATIENT_PHONE"));

            appointment.setAppointmentDate(
                    rs.getDate("APPOINTMENT_DATE"));

            appointment.setAppointmentTime(
                    rs.getString("APPOINTMENT_TIME"));

            appointment.setReason(
                    rs.getString("REASON"));

            appointment.setStatus(
                    rs.getString("STATUS"));

            appointments.add(appointment);
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return appointments;
}
    public boolean updateAppointmentStatus(int appointmentId, String doctorId, String status) {

    String sql = "UPDATE APPOINTMENT "
               + "SET STATUS = ? "
               + "WHERE APPOINTMENT_ID = ? "
               + "AND DOCTOR_ID = ?";

    try {

        Connection con = DBConnection.getConnection();

        PreparedStatement ps = con.prepareStatement(sql);

        ps.setString(1, status);
        ps.setInt(2, appointmentId);
        ps.setString(3, doctorId);

        int result = ps.executeUpdate();

        ps.close();
        con.close();

        return result > 0;

    } catch (Exception e) {

        e.printStackTrace();
    }

    return false;
}
}