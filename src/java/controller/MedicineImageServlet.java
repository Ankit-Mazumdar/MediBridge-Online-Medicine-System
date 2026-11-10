
package controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import util.DBConnection;

@WebServlet("/MedicineImageServlet")
public class MedicineImageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String idText = request.getParameter("id");

        if (idText == null || idText.trim().isEmpty()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        int medicineId;

        try {
            medicineId = Integer.parseInt(idText);
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        String sql =
            "SELECT IMAGE_DATA, IMAGE_TYPE "
            + "FROM MEDICINE WHERE MEDICINE_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, medicineId);

            try (ResultSet rs = ps.executeQuery()) {

                if (!rs.next()) {
                    response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                    );
                    return;
                }

                String imageType = rs.getString("IMAGE_TYPE");

                if (imageType == null
                        || !(imageType.equals("image/jpeg")
                        || imageType.equals("image/png"))) {

                    response.sendError(
                        HttpServletResponse.SC_NOT_FOUND
                    );
                    return;
                }

                try (InputStream input =
                         rs.getBinaryStream("IMAGE_DATA")) {

                    if (input == null) {
                        response.sendError(
                            HttpServletResponse.SC_NOT_FOUND
                        );
                        return;
                    }

                    response.setContentType(imageType);
                    response.setHeader(
                        "X-Content-Type-Options", "nosniff"
                    );
                    response.setHeader(
                        "Cache-Control", "private, max-age=3600"
                    );

                    try (OutputStream output =
                             response.getOutputStream()) {

                        byte[] buffer = new byte[4096];
                        int bytesRead;

                        while ((bytesRead = input.read(buffer)) != -1) {
                            output.write(buffer, 0, bytesRead);
                        }

                        output.flush();
                    }
                }
            }

        } catch (Exception e) {

            getServletContext().log(
                "Error retrieving medicine image: " + medicineId, e
            );

            if (!response.isCommitted()) {
                response.sendError(
                    HttpServletResponse.SC_INTERNAL_SERVER_ERROR
                );
            }
        }
    }
}
