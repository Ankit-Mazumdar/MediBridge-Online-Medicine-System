
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import java.util.UUID;
import java.sql.SQLException;

import model.Appointment;
import util.DBConnection;

public class AppointmentDAO {

    // Get active appointments for a particular doctor.
    // COMPLETED and REJECTED appointments will not appear here.
    public List<Appointment> getAppointmentsByDoctor(String doctorId) {

        List<Appointment> appointments = new ArrayList<Appointment>();

        String sql =
            "SELECT APPOINTMENT_ID, DOCTOR_ID, PATIENT_NAME, " +
            "PATIENT_EMAIL, PATIENT_PHONE, APPOINTMENT_DATE, " +
            "APPOINTMENT_TIME, REASON, STATUS, CREATED_AT " +
            "FROM APPOINTMENT " +
            "WHERE DOCTOR_ID = ? " +
            "AND STATUS IN ('PENDING', 'ACCEPTED', 'IN_CONSULTATION') " +
            "ORDER BY APPOINTMENT_DATE DESC, APPOINTMENT_TIME ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

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

                    appointment.setCreatedAt(
                        rs.getTimestamp("CREATED_AT"));

                    appointments.add(appointment);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }


    // Get completed appointments for the doctor's Patients section.
    // Each completed appointment is shown as a separate visit record.
    public List<Appointment> getCompletedAppointmentsByDoctor(
            String doctorId) {

        List<Appointment> appointments = new ArrayList<Appointment>();

        String sql =
            "SELECT APPOINTMENT_ID, DOCTOR_ID, PATIENT_NAME, " +
            "PATIENT_EMAIL, PATIENT_PHONE, APPOINTMENT_DATE, " +
            "APPOINTMENT_TIME, REASON, STATUS, CREATED_AT " +
            "FROM APPOINTMENT " +
            "WHERE DOCTOR_ID = ? " +
            "AND STATUS = 'COMPLETED' " +
            "ORDER BY APPOINTMENT_DATE DESC, APPOINTMENT_TIME DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

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

                    appointment.setCreatedAt(
                        rs.getTimestamp("CREATED_AT"));

                    appointments.add(appointment);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }


    // Count all appointments for a doctor.
    public int getAppointmentCount(String doctorId) {

        int count = 0;

        String sql =
            "SELECT COUNT(*) FROM APPOINTMENT WHERE DOCTOR_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }


    // Count today's appointments for a doctor.
  // Count today's active appointments for a doctor.
public int countToday(String doctorId) {

    int count = 0;

    String sql =
        "SELECT COUNT(*) FROM APPOINTMENT " +
        "WHERE DOCTOR_ID = ? " +
        "AND TRUNC(APPOINTMENT_DATE) = TRUNC(SYSDATE) " +
        "AND STATUS IN ('PENDING', 'ACCEPTED', 'IN_CONSULTATION')";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, doctorId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return count;
}


    // Get today's appointment schedule.
    public List<Appointment> getTodaysSchedule(String doctorId) {

        List<Appointment> appointments = new ArrayList<Appointment>();

        String sql =
            "SELECT APPOINTMENT_ID, DOCTOR_ID, PATIENT_NAME, " +
            "PATIENT_EMAIL, PATIENT_PHONE, APPOINTMENT_DATE, " +
            "APPOINTMENT_TIME, REASON, STATUS, CREATED_AT " +
            "FROM APPOINTMENT " +
            "WHERE DOCTOR_ID = ? " +
            "AND TRUNC(APPOINTMENT_DATE) = TRUNC(SYSDATE) " +
            "AND STATUS IN ('PENDING', 'ACCEPTED', 'IN_CONSULTATION') " +
            "ORDER BY APPOINTMENT_TIME";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

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

                    appointment.setCreatedAt(
                        rs.getTimestamp("CREATED_AT"));

                    appointments.add(appointment);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return appointments;
    }


    // Update appointment status only through valid workflow transitions.
    //
    // PENDING         -> ACCEPTED
    // PENDING         -> REJECTED
    // ACCEPTED        -> IN_CONSULTATION
    // IN_CONSULTATION -> COMPLETED
    //
    // The current status condition prevents invalid transitions.
    public boolean updateAppointmentStatus(
            int appointmentId,
            String doctorId,
            String status) {

        String previousStatus;

        if ("ACCEPTED".equals(status) ||
            "REJECTED".equals(status)) {

            previousStatus = "PENDING";

        } else if ("IN_CONSULTATION".equals(status)) {

            previousStatus = "ACCEPTED";

        } else if ("COMPLETED".equals(status)) {

            previousStatus = "IN_CONSULTATION";

        } else {
            return false;
        }

        String sql =
            "UPDATE APPOINTMENT " +
            "SET STATUS = ? " +
            "WHERE APPOINTMENT_ID = ? " +
            "AND DOCTOR_ID = ? " +
            "AND STATUS = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, appointmentId);
            ps.setString(3, doctorId);
            ps.setString(4, previousStatus);

            int result = ps.executeUpdate();

            return result == 1;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    // Count unique patients with future appointments.
public int countUpcomingPatients(String doctorId) {

    int count = 0;

    String sql =
        "SELECT COUNT(DISTINCT LOWER(TRIM(PATIENT_EMAIL))) " +
        "FROM APPOINTMENT " +
        "WHERE DOCTOR_ID = ? " +
        "AND TRUNC(APPOINTMENT_DATE) > TRUNC(SYSDATE) " +
        "AND STATUS IN ('PENDING', 'ACCEPTED', 'IN_CONSULTATION') " +
        "AND PATIENT_EMAIL IS NOT NULL";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, doctorId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return count;
}


// Count unique patients who have appointments with this doctor.
public int countTotalPatients(String doctorId) {

    int count = 0;

    String sql =
        "SELECT COUNT(DISTINCT LOWER(TRIM(PATIENT_EMAIL))) " +
        "FROM APPOINTMENT " +
        "WHERE DOCTOR_ID = ? " +
        "AND STATUS <> 'REJECTED' " +
        "AND PATIENT_EMAIL IS NOT NULL";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setString(1, doctorId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return count;
}


// Start consultation and create/reuse the meeting room.
// Returns the meeting room name on success, null on failure.
public String startConsultation(int appointmentId, String doctorId) {

    String room = null;

    String selectSql =
        "SELECT STATUS, MEETING_ROOM " +
        "FROM APPOINTMENT " +
        "WHERE APPOINTMENT_ID = ? " +
        "AND DOCTOR_ID = ? FOR UPDATE";

    String updateSql =
        "UPDATE APPOINTMENT " +
        "SET STATUS = ?, MEETING_ROOM = ? " +
        "WHERE APPOINTMENT_ID = ? " +
        "AND DOCTOR_ID = ?";

    try (Connection con = DBConnection.getConnection()) {

        con.setAutoCommit(false);

        try {

            // Check the appointment and lock its row.
            try (PreparedStatement ps = con.prepareStatement(selectSql)) {

                ps.setInt(1, appointmentId);
                ps.setString(2, doctorId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        con.rollback();
                        return null;
                    }

                    String currentStatus = rs.getString("STATUS");
                    room = rs.getString("MEETING_ROOM");

                    // Generate a room only when starting for the first time.
                    if ("ACCEPTED".equalsIgnoreCase(currentStatus)) {

                        room = "MediBridge_" +
                               UUID.randomUUID().toString().replace("-", "");

                   } else if ("IN_CONSULTATION".equalsIgnoreCase(currentStatus)) {

    // Reuse the existing room if one is already saved.
    if (room != null && !room.trim().isEmpty()) {
        con.commit();
        return room;
    }

    // Older consultations may have no room saved.
    // Generate one now and save it.
    room = "MediBridge_" +
           UUID.randomUUID().toString().replace("-", "");

                    } else {

                        con.rollback();
                        return null;
                    }
                }
            }

            // Save the room and change appointment status.
            try (PreparedStatement ps = con.prepareStatement(updateSql)) {

                ps.setString(1, "IN_CONSULTATION");
                ps.setString(2, room);
                ps.setInt(3, appointmentId);
                ps.setString(4, doctorId);

                int rows = ps.executeUpdate();

                if (rows != 1) {
                    con.rollback();
                    return null;
                }
            }

            con.commit();

            return room;

        } catch (SQLException e) {

            con.rollback();
            throw e;
        }

    } catch (SQLException e) {

        e.printStackTrace();
        return null;
    }
}

public String getMeetingRoomForDoctor(int appointmentId,
                                     String doctorId) {

    String room = null;

    String sql =
        "SELECT MEETING_ROOM " +
        "FROM APPOINTMENT " +
        "WHERE APPOINTMENT_ID = ? " +
        "AND DOCTOR_ID = ? " +
        "AND STATUS = 'IN_CONSULTATION'";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, appointmentId);
        ps.setString(2, doctorId);

        try (ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                room = rs.getString("MEETING_ROOM");
            }
        }

    } catch (SQLException e) {
        e.printStackTrace();
    }

    return room;
}
}
