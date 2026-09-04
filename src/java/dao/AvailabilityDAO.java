package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.DoctorAvailability;
import util.DBConnection;

public class AvailabilityDAO {


    // ============================================================
    // ADD AVAILABILITY
    // ============================================================

    public boolean addAvailability(DoctorAvailability availability) {

        boolean result = false;

        String sql =
                "INSERT INTO DOCTOR_AVAILABILITY "
                + "(DOCTOR_ID, DAY_OF_WEEK, START_TIME, END_TIME, "
                + "SLOT_DURATION, STATUS) "
                + "VALUES (?, ?, ?, ?, ?, 'ACTIVE')";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, availability.getDoctorId());
            ps.setString(2, availability.getDayOfWeek());
            ps.setString(3, availability.getStartTime());
            ps.setString(4, availability.getEndTime());
            ps.setInt(5, availability.getSlotDuration());

            int rows = ps.executeUpdate();

            if (rows > 0) {
                result = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {

            System.out.println("Availability insert failed.");
            e.printStackTrace();
        }

        return result;
    }


    // ============================================================
    // GET AVAILABILITY FOR A DOCTOR
    // ============================================================

    public List<DoctorAvailability> getAvailabilityByDoctor(
            String doctorId) {

        List<DoctorAvailability> list =
                new ArrayList<DoctorAvailability>();

        String sql =
                "SELECT AVAILABILITY_ID, DOCTOR_ID, DAY_OF_WEEK, "
                + "START_TIME, END_TIME, SLOT_DURATION, STATUS "
                + "FROM DOCTOR_AVAILABILITY "
                + "WHERE DOCTOR_ID = ? "
                + "AND STATUS = 'ACTIVE' "
                + "ORDER BY AVAILABILITY_ID";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setString(1, doctorId);

            ResultSet rs = ps.executeQuery();

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

            rs.close();
            ps.close();
            con.close();

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

        boolean result = false;

        String sql =
                "DELETE FROM DOCTOR_AVAILABILITY "
                + "WHERE AVAILABILITY_ID = ? "
                + "AND DOCTOR_ID = ?";

        try {

            Connection con = DBConnection.getConnection();

            PreparedStatement ps =
                    con.prepareStatement(sql);

            ps.setInt(1, availabilityId);
            ps.setString(2, doctorId);

            int rows = ps.executeUpdate();

            if (rows > 0) {
                result = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {

            System.out.println(
                    "Availability delete failed."
            );

            e.printStackTrace();
        }

        return result;
    }
}