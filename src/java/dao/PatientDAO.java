package dao;


import java.sql.PreparedStatement;
import java.sql.ResultSet;
import model.PatientBean;
import util.DBConnection;
import java.sql.Connection;


public class PatientDAO {

    public boolean emailExists(String email) {

        boolean exists = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT EMAIL FROM PATIENT WHERE EMAIL = ?";
            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                exists = true;
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return exists;
    }

    public boolean registerPatient(PatientBean p) {

        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "INSERT INTO PATIENT " +
                    "(PATIENT_ID, NAME, EMAIL, CONTACT, PASSWORD, DOB, GENDER, " +
                    "BLOOD_GROUP, ADDRESS, SECURITY_QUESTION, SECURITY_ANSWER) " +
                    "VALUES (PATIENT_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, p.getName());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getContact());
            ps.setString(4, p.getPassword());
            ps.setDate(5, p.getDob());
            ps.setString(6, p.getGender());
            ps.setString(7, p.getBloodGroup());
            ps.setString(8, p.getAddress());
            ps.setString(9, p.getSecurityQuestion());
            ps.setString(10, p.getSecurityAnswer());

            int result = ps.executeUpdate();

            if (result > 0) {
                status = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

    public PatientBean loginPatient(String email, String password) {

        PatientBean p = null;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM PATIENT WHERE EMAIL = ? AND PASSWORD = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                p = new PatientBean();

                p.setPatientId(rs.getInt("PATIENT_ID"));
                p.setName(rs.getString("NAME"));
                p.setEmail(rs.getString("EMAIL"));
                p.setContact(rs.getString("CONTACT"));
                p.setPassword(rs.getString("PASSWORD"));
                p.setDob(rs.getDate("DOB"));
                p.setGender(rs.getString("GENDER"));
                p.setBloodGroup(rs.getString("BLOOD_GROUP"));
                p.setAddress(rs.getString("ADDRESS"));
                p.setSecurityQuestion(rs.getString("SECURITY_QUESTION"));
                p.setSecurityAnswer(rs.getString("SECURITY_ANSWER"));
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }


    /* Forgot Password */

    public PatientBean getPatientByEmail(String email) {
        PatientBean p = null;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "SELECT * FROM PATIENT WHERE EMAIL = ?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                p = new PatientBean();

                p.setPatientId(rs.getInt("PATIENT_ID"));
                p.setName(rs.getString("NAME"));
                p.setEmail(rs.getString("EMAIL"));
                p.setContact(rs.getString("CONTACT"));
                p.setPassword(rs.getString("PASSWORD"));
                p.setDob(rs.getDate("DOB"));
                p.setGender(rs.getString("GENDER"));
                p.setBloodGroup(rs.getString("BLOOD_GROUP"));
                p.setAddress(rs.getString("ADDRESS"));
                p.setSecurityQuestion(rs.getString("SECURITY_QUESTION"));
                p.setSecurityAnswer(rs.getString("SECURITY_ANSWER"));
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return p;
    }


    public boolean updatePassword(String email, String newPassword) {
        boolean status = false;

        try {
            Connection con = DBConnection.getConnection();

            String sql = "UPDATE PATIENT SET PASSWORD = ? WHERE EMAIL = ?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, newPassword);
            ps.setString(2, email);

            int result = ps.executeUpdate();

            if (result > 0) {
                status = true;
            }

            ps.close();
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
    
    public boolean updatePatient(PatientBean p) {

    boolean status = false;

    try {
        Connection con = DBConnection.getConnection();

        String sql =
                "UPDATE PATIENT SET "
                + "NAME = ?, "
                + "CONTACT = ?, "
                + "DOB = ?, "
                + "GENDER = ?, "
                + "BLOOD_GROUP = ?, "
                + "ADDRESS = ? "
                + "WHERE PATIENT_ID = ?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, p.getName());
        ps.setString(2, p.getContact());
        ps.setDate(3, p.getDob());
        ps.setString(4, p.getGender());
        ps.setString(5, p.getBloodGroup());
        ps.setString(6, p.getAddress());
        ps.setInt(7, p.getPatientId());

        int result = ps.executeUpdate();

        if (result > 0) {
            status = true;
        }

        ps.close();
        con.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return status;
   }
    
    public boolean checkPassword(String email, String password) {

    boolean valid = false;

    try {
        Connection con = DBConnection.getConnection();

        String sql =
                "SELECT COUNT(*) FROM PATIENT "
                + "WHERE EMAIL = ? AND PASSWORD = ?";

        PreparedStatement ps =
                con.prepareStatement(sql);

        ps.setString(1, email);
        ps.setString(2, password);

        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            valid = rs.getInt(1) > 0;
        }

        rs.close();
        ps.close();
        con.close();

    } catch (Exception e) {
        e.printStackTrace();
    }

    return valid;
  }
}