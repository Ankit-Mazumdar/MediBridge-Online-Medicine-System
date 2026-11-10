
package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.UUID;

import model.Appointment;
import model.Doctor;
import model.DoctorAvailability;
import util.DBConnection;

public class PatientAppointmentDAO {

    // ============================================================
    // GET APPROVED DOCTORS WITH FUTURE ACTIVE AVAILABILITY
    // ============================================================

public List<Doctor> getApprovedDoctors() {

    List<Doctor> doctors = new ArrayList<Doctor>();

    String sql =
            "SELECT DOCTOR_ID, FULL_NAME, EMAIL, PHONE, "
          + "GENDER, SPECIALIZATION, QUALIFICATION, "
          + "EXPERIENCE, STATUS, "
          + "NVL(CONSULTATION_FEES, 0) AS CONSULTATION_FEES "
          + "FROM DOCTOR "
          + "WHERE UPPER(TRIM(STATUS)) = 'APPROVED' "
          + "ORDER BY FULL_NAME";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {

            Doctor doctor = new Doctor();

            doctor.setDoctorId(rs.getString("DOCTOR_ID"));
            doctor.setFullName(rs.getString("FULL_NAME"));
            doctor.setEmail(rs.getString("EMAIL"));
            doctor.setPhone(rs.getString("PHONE"));
            doctor.setGender(rs.getString("GENDER"));
            doctor.setSpecialization(rs.getString("SPECIALIZATION"));
            doctor.setQualification(rs.getString("QUALIFICATION"));
            doctor.setExperience(rs.getInt("EXPERIENCE"));
            doctor.setStatus(rs.getString("STATUS"));
            doctor.setConsultationFees(
                    rs.getDouble("CONSULTATION_FEES"));

            doctors.add(doctor);
        }

    } catch (Exception e) {
        e.printStackTrace();
    }

    return doctors;
}



    // ============================================================
    // GET ALL FUTURE ACTIVE AVAILABILITY FOR A DOCTOR
    // Kept for compatibility with existing callers.
    // ============================================================

    public List<DoctorAvailability> getDoctorAvailability(
            String doctorId) {

        List<DoctorAvailability> list =
                new ArrayList<DoctorAvailability>();

        String sql =
                "SELECT AVAILABILITY_ID, DOCTOR_ID, DAY_OF_WEEK, "
              + "AVAILABILITY_DATE, START_TIME, END_TIME, "
              + "SLOT_DURATION, STATUS "
              + "FROM DOCTOR_AVAILABILITY "
              + "WHERE DOCTOR_ID = ? "
              + "AND STATUS = 'ACTIVE' "
              + "AND AVAILABILITY_DATE IS NOT NULL "
              + "AND TRUNC(AVAILABILITY_DATE) >= TRUNC(SYSDATE) "
              + "ORDER BY AVAILABILITY_DATE, START_TIME";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    DoctorAvailability a =
                            new DoctorAvailability();

                    a.setAvailabilityId(
                            rs.getInt("AVAILABILITY_ID"));

                    a.setDoctorId(
                            rs.getString("DOCTOR_ID"));

                    a.setDayOfWeek(
                            rs.getString("DAY_OF_WEEK"));

                    a.setAvailabilityDate(
                            rs.getDate("AVAILABILITY_DATE"));

                    a.setStartTime(
                            rs.getString("START_TIME"));

                    a.setEndTime(
                            rs.getString("END_TIME"));

                    a.setSlotDuration(
                            rs.getInt("SLOT_DURATION"));

                    a.setStatus(
                            rs.getString("STATUS"));

                    list.add(a);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ============================================================
    // GET AVAILABILITY FOR ONE EXACT DATE
    // ============================================================

    public List<DoctorAvailability> getDoctorAvailability(
            String doctorId,
            String appointmentDate) {

        List<DoctorAvailability> list =
                new ArrayList<DoctorAvailability>();

        String sql =
                "SELECT AVAILABILITY_ID, DOCTOR_ID, DAY_OF_WEEK, "
              + "AVAILABILITY_DATE, START_TIME, END_TIME, "
              + "SLOT_DURATION, STATUS "
              + "FROM DOCTOR_AVAILABILITY "
              + "WHERE DOCTOR_ID = ? "
              + "AND STATUS = 'ACTIVE' "
              + "AND TRUNC(AVAILABILITY_DATE) = "
              + "TO_DATE(?, 'YYYY-MM-DD') "
              + "AND TRUNC(AVAILABILITY_DATE) >= TRUNC(SYSDATE) "
              + "ORDER BY START_TIME";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);
            ps.setString(2, appointmentDate);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    DoctorAvailability a =
                            new DoctorAvailability();

                    a.setAvailabilityId(
                            rs.getInt("AVAILABILITY_ID"));

                    a.setDoctorId(
                            rs.getString("DOCTOR_ID"));

                    a.setDayOfWeek(
                            rs.getString("DAY_OF_WEEK"));

                    a.setAvailabilityDate(
                            rs.getDate("AVAILABILITY_DATE"));

                    a.setStartTime(
                            rs.getString("START_TIME"));

                    a.setEndTime(
                            rs.getString("END_TIME"));

                    a.setSlotDuration(
                            rs.getInt("SLOT_DURATION"));

                    a.setStatus(
                            rs.getString("STATUS"));

                    list.add(a);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    // ============================================================
    // GET ALL BOOKED TIMES FOR ONE DOCTOR AND DATE
    // One query instead of one query for every slot.
    // ============================================================

    public Set<String> getBookedTimes(
            String doctorId,
            String appointmentDate) {

        Set<String> bookedTimes = new HashSet<String>();

        String sql =
                "SELECT APPOINTMENT_TIME "
              + "FROM APPOINTMENT "
              + "WHERE DOCTOR_ID = ? "
              + "AND TRUNC(APPOINTMENT_DATE) = "
              + "TO_DATE(?, 'YYYY-MM-DD') "
              + "AND STATUS NOT IN ('REJECTED', 'CANCELLED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);
            ps.setString(2, appointmentDate);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    bookedTimes.add(
                            rs.getString("APPOINTMENT_TIME"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookedTimes;
    }


    // ============================================================
    // CHECK WHETHER A SLOT IS ALREADY BOOKED
    // ============================================================

    public boolean isSlotBooked(
            String doctorId,
            String appointmentDate,
            String appointmentTime) {

        String sql =
                "SELECT COUNT(*) "
              + "FROM APPOINTMENT "
              + "WHERE DOCTOR_ID = ? "
              + "AND TRUNC(APPOINTMENT_DATE) = "
              + "TO_DATE(?, 'YYYY-MM-DD') "
              + "AND APPOINTMENT_TIME = ? "
              + "AND STATUS NOT IN ('REJECTED', 'CANCELLED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);
            ps.setString(2, appointmentDate);
            ps.setString(3, appointmentTime);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // ============================================================
    // GET DOCTOR DETAILS INCLUDING CONSULTATION FEE
    // ============================================================

    public Doctor getDoctorById(String doctorId) {

        Doctor doctor = null;

        String sql =
                "SELECT DOCTOR_ID, FULL_NAME, EMAIL, PHONE, "
              + "SPECIALIZATION, QUALIFICATION, EXPERIENCE, "
              + "STATUS, NVL(CONSULTATION_FEES, 0) "
              + "AS CONSULTATION_FEES "
              + "FROM DOCTOR "
              + "WHERE DOCTOR_ID = ? "
              + "AND STATUS = 'APPROVED'";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {

                    doctor = new Doctor();

                    doctor.setDoctorId(
                            rs.getString("DOCTOR_ID"));

                    doctor.setFullName(
                            rs.getString("FULL_NAME"));

                    doctor.setEmail(
                            rs.getString("EMAIL"));

                    doctor.setPhone(
                            rs.getString("PHONE"));

                    doctor.setSpecialization(
                            rs.getString("SPECIALIZATION"));

                    doctor.setQualification(
                            rs.getString("QUALIFICATION"));

                    doctor.setExperience(
                            rs.getInt("EXPERIENCE"));

                    doctor.setStatus(
                            rs.getString("STATUS"));

                    doctor.setConsultationFees(
                            rs.getDouble("CONSULTATION_FEES"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return doctor;
    }


    // ============================================================
    // OLD BOOKING METHOD
    // Kept for compatibility with existing callers.
    // New patient booking should use bookAppointmentWithDemoPayment.
    // ============================================================

    public boolean bookAppointment(
            String doctorId,
            String patientName,
            String patientEmail,
            String patientPhone,
            String appointmentDate,
            String appointmentTime,
            String reason) {

        String sql =
                "INSERT INTO APPOINTMENT "
              + "(DOCTOR_ID, PATIENT_NAME, PATIENT_EMAIL, "
              + "PATIENT_PHONE, APPOINTMENT_DATE, "
              + "APPOINTMENT_TIME, REASON, STATUS) "
              + "VALUES (?, ?, ?, ?, TO_DATE(?, 'YYYY-MM-DD'), "
              + "?, ?, 'PENDING')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, doctorId);
            ps.setString(2, patientName);
            ps.setString(3, patientEmail);
            ps.setString(4, patientPhone);
            ps.setString(5, appointmentDate);
            ps.setString(6, appointmentTime);
            ps.setString(7, reason);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // ============================================================
    // DEMO PAYMENT + TRANSACTION-SAFE APPOINTMENT BOOKING
    //
    // The availability row is locked while booking.
    // The server verifies the date, time, duration and slot number.
    // Payment is marked PAID only when the insert succeeds.
    // ============================================================

    public boolean bookAppointmentWithDemoPayment(
            int availabilityId,
            int slotNumber,
            String doctorId,
            String patientName,
            String patientEmail,
            String patientPhone,
            String appointmentDate,
            String appointmentTime,
            String reason) {

        Connection con = null;

        try {

            // Validate basic input.
            if (availabilityId <= 0 ||
                slotNumber <= 0 ||
                doctorId == null ||
                patientName == null ||
                patientEmail == null ||
                patientPhone == null ||
                appointmentDate == null ||
                appointmentTime == null ||
                reason == null) {

                return false;
            }

            Date selectedDate = Date.valueOf(appointmentDate);

            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // ----------------------------------------------------
            // 1. LOCK AND READ THE AVAILABILITY RECORD
            // ----------------------------------------------------

            String availabilitySql =
                    "SELECT START_TIME, END_TIME, SLOT_DURATION "
                  + "FROM DOCTOR_AVAILABILITY "
                  + "WHERE AVAILABILITY_ID = ? "
                  + "AND DOCTOR_ID = ? "
                  + "AND STATUS = 'ACTIVE' "
                  + "AND TRUNC(AVAILABILITY_DATE) = "
                  + "TO_DATE(?, 'YYYY-MM-DD') "
                  + "AND TRUNC(AVAILABILITY_DATE) >= TRUNC(SYSDATE) "
                  + "FOR UPDATE";

            String startTime;
            String endTime;
            int duration;

            try (PreparedStatement ps =
                    con.prepareStatement(availabilitySql)) {

                ps.setInt(1, availabilityId);
                ps.setString(2, doctorId);
                ps.setString(3, appointmentDate);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }

                    startTime = rs.getString("START_TIME");
                    endTime = rs.getString("END_TIME");
                    duration = rs.getInt("SLOT_DURATION");
                }
            }

            // ----------------------------------------------------
            // 2. VALIDATE SLOT TIME AND SLOT NUMBER
            // ----------------------------------------------------

            int startMinutes = convertTimeToMinutes(startTime);
            int endMinutes = convertTimeToMinutes(endTime);
            int selectedMinutes =
                    convertTimeToMinutes(appointmentTime);

            if (duration <= 0 ||
                startMinutes < 0 ||
                endMinutes <= startMinutes ||
                selectedMinutes < startMinutes ||
                selectedMinutes >= endMinutes) {

                con.rollback();
                return false;
            }

            int difference = selectedMinutes - startMinutes;

            if (difference % duration != 0) {
                con.rollback();
                return false;
            }

            int calculatedSlotNumber =
                    (difference / duration) + 1;

            if (calculatedSlotNumber != slotNumber ||
                selectedMinutes + duration > endMinutes) {

                con.rollback();
                return false;
            }

            // ----------------------------------------------------
            // 3. CHECK WHETHER SLOT IS ALREADY BOOKED
            // ----------------------------------------------------

            String bookedSql =
                    "SELECT COUNT(*) "
                  + "FROM APPOINTMENT "
                  + "WHERE DOCTOR_ID = ? "
                  + "AND TRUNC(APPOINTMENT_DATE) = "
                  + "TO_DATE(?, 'YYYY-MM-DD') "
                  + "AND APPOINTMENT_TIME = ? "
                  + "AND STATUS NOT IN ('REJECTED', 'CANCELLED')";

            try (PreparedStatement ps =
                    con.prepareStatement(bookedSql)) {

                ps.setString(1, doctorId);
                ps.setString(2, appointmentDate);
                ps.setString(3, appointmentTime);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next() && rs.getInt(1) > 0) {
                        con.rollback();
                        return false;
                    }
                }
            }

            // ----------------------------------------------------
            // 4. CHECK PATIENT'S SAME-DAY DUPLICATE APPOINTMENT
            // ----------------------------------------------------

            String duplicateSql =
                    "SELECT COUNT(*) "
                  + "FROM APPOINTMENT "
                  + "WHERE PATIENT_EMAIL = ? "
                  + "AND DOCTOR_ID = ? "
                  + "AND TRUNC(APPOINTMENT_DATE) = "
                  + "TO_DATE(?, 'YYYY-MM-DD') "
                  + "AND STATUS NOT IN ('CANCELLED', 'REJECTED')";

            try (PreparedStatement ps =
                    con.prepareStatement(duplicateSql)) {

                ps.setString(1, patientEmail);
                ps.setString(2, doctorId);
                ps.setString(3, appointmentDate);

                try (ResultSet rs = ps.executeQuery()) {

                    if (rs.next() && rs.getInt(1) > 0) {
                        con.rollback();
                        return false;
                    }
                }
            }

            // ----------------------------------------------------
            // 5. FETCH CURRENT DOCTOR CONSULTATION FEE
            // ----------------------------------------------------

            double consultationFee;

            String feeSql =
                    "SELECT NVL(CONSULTATION_FEES, 0) "
                  + "FROM DOCTOR "
                  + "WHERE DOCTOR_ID = ? "
                  + "AND STATUS = 'APPROVED'";

            try (PreparedStatement ps =
                    con.prepareStatement(feeSql)) {

                ps.setString(1, doctorId);

                try (ResultSet rs = ps.executeQuery()) {

                    if (!rs.next()) {
                        con.rollback();
                        return false;
                    }

                    consultationFee = rs.getDouble(1);
                }
            }

            // ----------------------------------------------------
            // 6. INSERT APPOINTMENT WITH DEMO PAYMENT
            // ----------------------------------------------------

            String paymentReference =
                    "DEMO-" + UUID.randomUUID().toString()
                    .replace("-", "").toUpperCase();

            String insertSql =
                    "INSERT INTO APPOINTMENT "
                  + "(DOCTOR_ID, PATIENT_NAME, PATIENT_EMAIL, "
                  + "PATIENT_PHONE, APPOINTMENT_DATE, "
                  + "APPOINTMENT_TIME, REASON, STATUS, "
                  + "AVAILABILITY_ID, SLOT_NUMBER, "
                  + "CONSULTATION_FEE, PAYMENT_STATUS, "
                  + "PAYMENT_REFERENCE) "
                  + "VALUES (?, ?, ?, ?, "
                  + "TO_DATE(?, 'YYYY-MM-DD'), "
                  + "?, ?, 'PENDING', ?, ?, ?, 'PAID', ?)";

            try (PreparedStatement ps =
                    con.prepareStatement(insertSql)) {

                ps.setString(1, doctorId);
                ps.setString(2, patientName);
                ps.setString(3, patientEmail);
                ps.setString(4, patientPhone);
                ps.setString(5, appointmentDate);
                ps.setString(6, appointmentTime);
                ps.setString(7, reason);
                ps.setInt(8, availabilityId);
                ps.setInt(9, slotNumber);
                ps.setDouble(10, consultationFee);
                ps.setString(11, paymentReference);

                int rows = ps.executeUpdate();

                if (rows <= 0) {
                    con.rollback();
                    return false;
                }
            }

            // ----------------------------------------------------
            // 7. COMMIT BOOKING AND DEMO PAYMENT TOGETHER
            // ----------------------------------------------------

            con.commit();

            return true;

        } catch (Exception e) {

            e.printStackTrace();

            if (con != null) {
                try {
                    con.rollback();
                } catch (SQLException rollbackError) {
                    rollbackError.printStackTrace();
                }
            }

            return false;

        } finally {

            if (con != null) {
                try {
                    con.setAutoCommit(true);
                    con.close();
                } catch (SQLException closeError) {
                    closeError.printStackTrace();
                }
            }
        }
    }


    // ============================================================
    // CONVERT HH:mm INTO MINUTES
    // ============================================================

    private int convertTimeToMinutes(String time) {

        try {

            if (time == null ||
                !time.matches("\\d{2}:\\d{2}")) {

                return -1;
            }

            String[] parts = time.split(":");

            int hour = Integer.parseInt(parts[0]);
            int minute = Integer.parseInt(parts[1]);

            if (hour < 0 || hour > 23 ||
                minute < 0 || minute > 59) {

                return -1;
            }

            return (hour * 60) + minute;

        } catch (Exception e) {
            return -1;
        }
    }


    // ============================================================
    // GET APPOINTMENTS BY PATIENT
    // ============================================================

    public List<Appointment> getAppointmentsByPatient(
            String patientEmail) {

        List<Appointment> appointments =
                new ArrayList<Appointment>();

String sql =
        "SELECT A.APPOINTMENT_ID, A.DOCTOR_ID, "
      + "D.FULL_NAME, D.SPECIALIZATION, "
      + "A.PATIENT_NAME, A.PATIENT_EMAIL, "
      + "A.PATIENT_PHONE, A.APPOINTMENT_DATE, "
      + "A.APPOINTMENT_TIME, A.REASON, "
      + "A.STATUS, A.CREATED_AT, A.MEETING_ROOM "
      + "FROM APPOINTMENT A "
      + "JOIN DOCTOR D "
      + "ON A.DOCTOR_ID = D.DOCTOR_ID "
      + "WHERE A.PATIENT_EMAIL = ? "
      + "ORDER BY A.APPOINTMENT_DATE DESC, "
      + "A.APPOINTMENT_TIME ASC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, patientEmail);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    Appointment appointment =
                            new Appointment();

                    appointment.setAppointmentId(
                            rs.getInt("APPOINTMENT_ID"));

                    appointment.setDoctorId(
                            rs.getString("DOCTOR_ID"));

                    appointment.setDoctorName(
                            rs.getString("FULL_NAME"));

                    appointment.setSpecialization(
                            rs.getString("SPECIALIZATION"));

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
                    
                    appointment.setMeetingRoom(
        rs.getString("MEETING_ROOM"));

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


    // ============================================================
    // CANCEL APPOINTMENT
    // ============================================================

    public boolean cancelAppointment(
            int appointmentId,
            String patientEmail) {

        String sql =
                "UPDATE APPOINTMENT "
              + "SET STATUS = 'CANCELLED' "
              + "WHERE APPOINTMENT_ID = ? "
              + "AND PATIENT_EMAIL = ? "
              + "AND STATUS IN ('PENDING', 'ACCEPTED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, appointmentId);
            ps.setString(2, patientEmail);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }


    // ============================================================
    // CHECK REDUNDANT APPOINTMENT
    // ============================================================

    public boolean hasPatientAppointmentOnDate(
            String patientEmail,
            String doctorId,
            String appointmentDate) {

        String sql =
                "SELECT COUNT(*) "
              + "FROM APPOINTMENT "
              + "WHERE PATIENT_EMAIL = ? "
              + "AND DOCTOR_ID = ? "
              + "AND TRUNC(APPOINTMENT_DATE) = "
              + "TO_DATE(?, 'YYYY-MM-DD') "
              + "AND STATUS NOT IN ('CANCELLED', 'REJECTED')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, patientEmail);
            ps.setString(2, doctorId);
            ps.setString(3, appointmentDate);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
    
    public String getMeetingRoomForPatient(int appointmentId,
                                       String patientEmail) {

    String room = null;

    String sql =
        "SELECT MEETING_ROOM " +
        "FROM APPOINTMENT " +
        "WHERE APPOINTMENT_ID = ? " +
        "AND PATIENT_EMAIL = ? " +
        "AND STATUS = 'IN_CONSULTATION'";

    try (Connection con = DBConnection.getConnection();
         PreparedStatement ps = con.prepareStatement(sql)) {

        ps.setInt(1, appointmentId);
        ps.setString(2, patientEmail);

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
