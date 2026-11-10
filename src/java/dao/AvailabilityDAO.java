package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import model.DoctorAvailability;
import util.DBConnection;

public class AvailabilityDAO {

    // ============================================================
    // CHECK OVERLAPPING AVAILABILITY
    // ============================================================

    private boolean hasOverlappingAvailability(
            Connection con,
            DoctorAvailability availability) throws Exception {

        String sql =
                "SELECT COUNT(*) "
                + "FROM DOCTOR_AVAILABILITY "
                + "WHERE DOCTOR_ID = ? "
                + "AND TRUNC(AVAILABILITY_DATE) = ? "
                + "AND STATUS = 'ACTIVE' "
                + "AND START_TIME < ? "
                + "AND END_TIME > ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, availability.getDoctorId());
            ps.setDate(2, availability.getAvailabilityDate());
            ps.setString(3, availability.getEndTime());
            ps.setString(4, availability.getStartTime());

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }

        return false;
    }

    // ============================================================
    // ADD DATE-BASED AVAILABILITY
    // ============================================================

    public boolean addAvailability(
            DoctorAvailability availability) {

        String sql =
                "INSERT INTO DOCTOR_AVAILABILITY "
                + "(DOCTOR_ID, DAY_OF_WEEK, AVAILABILITY_DATE, "
                + "START_TIME, END_TIME, SLOT_DURATION, STATUS) "
                + "VALUES (?, ?, ?, ?, ?, ?, 'ACTIVE')";

        try (Connection con = DBConnection.getConnection()) {

            if (con == null) {
                System.out.println("Database connection unavailable.");
                return false;
            }

            // Prevent overlapping schedules for the same doctor/date.
            if (hasOverlappingAvailability(con, availability)) {

                System.out.println(
                        "Overlapping availability already exists."
                );

                return false;
            }

            try (PreparedStatement ps = con.prepareStatement(sql)) {

                ps.setString(1, availability.getDoctorId());
                ps.setString(2, availability.getDayOfWeek());
                ps.setDate(3, availability.getAvailabilityDate());
                ps.setString(4, availability.getStartTime());
                ps.setString(5, availability.getEndTime());
                ps.setInt(6, availability.getSlotDuration());

                return ps.executeUpdate() > 0;
            }

        } catch (Exception e) {

            System.out.println("Availability insert failed.");
            e.printStackTrace();

            return false;
        }
    }

    // ============================================================
    // GET DATE-BASED AVAILABILITY FOR A DOCTOR
    // ============================================================

    public List<DoctorAvailability> getAvailabilityByDoctor(
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

            if (con == null) {
                return list;
            }

            ps.setString(1, doctorId);

            try (ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {

                    DoctorAvailability availability =
                            new DoctorAvailability();

                    availability.setAvailabilityId(
                            rs.getInt("AVAILABILITY_ID")
                    );

                    availability.setDoctorId(
                            rs.getString("DOCTOR_ID")
                    );

                    availability.setDayOfWeek(
                            rs.getString("DAY_OF_WEEK")
                    );

                    availability.setAvailabilityDate(
                            rs.getDate("AVAILABILITY_DATE")
                    );

                    availability.setStartTime(
                            rs.getString("START_TIME")
                    );

                    availability.setEndTime(
                            rs.getString("END_TIME")
                    );

                    availability.setSlotDuration(
                            rs.getInt("SLOT_DURATION")
                    );

                    availability.setStatus(
                            rs.getString("STATUS")
                    );

                    list.add(availability);
                }
            }

        } catch (Exception e) {

            System.out.println(
                    "Failed to load doctor availability."
            );

            e.printStackTrace();
        }

        return list;
    }

    // ============================================================
    // DELETE AVAILABILITY
    // ============================================================

    public boolean deleteAvailability(
            int availabilityId,
            String doctorId) {

        String sql =
                "DELETE FROM DOCTOR_AVAILABILITY "
                + "WHERE AVAILABILITY_ID = ? "
                + "AND DOCTOR_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            if (con == null) {
                return false;
            }

            ps.setInt(1, availabilityId);
            ps.setString(2, doctorId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {

            System.out.println("Availability delete failed.");
            e.printStackTrace();

            return false;
        }
    }
}