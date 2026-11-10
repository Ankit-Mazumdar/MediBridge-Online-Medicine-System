
package admin;

import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class AdminDAO {

    public Admin getAdminByEmail(String email) {

        Admin admin = null;

        String q1 = "SELECT * FROM ADMIN "
                  + "WHERE LOWER(TRIM(EMAIL)) = LOWER(TRIM(?))";

        try {

            Connection con = DBConnection.getConnection();

            if (con == null) {
                System.out.println("Database connection failed.");
                return null;
            }

            PreparedStatement ps = con.prepareStatement(q1);

            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                System.out.println("ADMIN STATUS = "
                        + rs.getString("STATUS"));

                admin = new Admin();

                admin.setAdminId(rs.getInt("ADMIN_ID"));
                admin.setFullName(rs.getString("FULL_NAME"));
                admin.setEmail(rs.getString("EMAIL"));
                admin.setPassword(rs.getString("PASSWORD"));
                admin.setStatus(rs.getString("STATUS"));
            } else {
                System.out.println(
                        "No admin record found for: " + email);
            }

            rs.close();
            ps.close();
            con.close();

        } catch (Exception e) {

            System.out.println("Admin login lookup failed.");
            System.out.println("Error: " + e.getMessage());
            e.printStackTrace();
        }

        return admin;
    }
}
