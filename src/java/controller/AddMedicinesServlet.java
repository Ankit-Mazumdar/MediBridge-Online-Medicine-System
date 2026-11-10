
package controller;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Types;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import util.DBConnection;

@WebServlet("/AddMedicinesServlet")

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 2 * 1024 * 1024,
    maxRequestSize = 3 * 1024 * 1024
)

public class AddMedicinesServlet extends HttpServlet {

    private static final int MAX_IMAGE_SIZE = 2 * 1024 * 1024;

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // 1. Verify admin login
        if (session == null || session.getAttribute("admin") == null) {
            response.sendRedirect(
                request.getContextPath() + "/login.jsp"
            );
            return;
        }

        try {

            // 2. Read medicine details
            String name = request.getParameter("medicine_name");
            String description = request.getParameter("description");
            String priceText = request.getParameter("price");
            String stockText = request.getParameter("stock");

            if (name == null || name.trim().isEmpty()
                    || priceText == null || stockText == null) {

                redirect(request, response, "error=invalidInput");
                return;
            }

            name = name.trim();

            if (name.length() > 150
                    || (description != null
                    && description.length() > 1000)) {

                redirect(request, response, "error=invalidInput");
                return;
            }

            // 3. Validate price and stock
            BigDecimal price;
            int stock;

            try {
                price = new BigDecimal(priceText);
                stock = Integer.parseInt(stockText);

                if (price.compareTo(BigDecimal.ZERO) < 0
                        || stock < 0) {
                    throw new NumberFormatException();
                }

            } catch (NumberFormatException e) {
                redirect(request, response, "error=invalidInput");
                return;
            }

            // 4. Receive optional medicine image
            Part imagePart = request.getPart("medicine_image");

            byte[] imageBytes = null;
            String imageType = null;

            if (imagePart != null && imagePart.getSize() > 0) {

                if (imagePart.getSize() > MAX_IMAGE_SIZE) {
                    redirect(request, response, "error=imageTooLarge");
                    return;
                }

                imageBytes = readImage(imagePart);

                // 5. Validate actual image format
                imageType = detectImageType(imageBytes);

                if (imageType == null) {
                    redirect(request, response, "error=invalidImage");
                    return;
                }
            }

            // 6. Insert medicine and image into Oracle
            String sql = "INSERT INTO MEDICINE "
                    + "(MEDICINE_ID, MEDICINE_NAME, DESCRIPTION, "
                    + "PRICE, STOCK, IMAGE_DATA, IMAGE_TYPE) "
                    + "VALUES (MEDICINE_SEQ.NEXTVAL, ?, ?, ?, ?, ?, ?)";

            try (Connection con = DBConnection.getConnection()) {

                if (con == null) {
                    throw new Exception(
                        "Database connection unavailable."
                    );
                }

                try (PreparedStatement ps = con.prepareStatement(sql)) {

                    ps.setString(1, name);
                    ps.setString(2, description);
                    ps.setBigDecimal(3, price);
                    ps.setInt(4, stock);

                    if (imageBytes != null) {
                        ps.setBytes(5, imageBytes);
                        ps.setString(6, imageType);
                    } else {
                        ps.setNull(5, Types.BLOB);
                        ps.setNull(6, Types.VARCHAR);
                    }

                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        redirect(request, response,
                                "success=medicineAdded");
                    } else {
                        redirect(request, response,
                                "error=addFailed");
                    }
                }
            }

        } catch (IllegalStateException e) {

            getServletContext().log(
                "Medicine image upload exceeded the allowed size.", e
            );

            redirect(request, response, "error=imageTooLarge");

        } catch (Exception e) {

            getServletContext().log("Error adding medicine", e);

            redirect(request, response, "error=addFailed");
        }
    }

    // Read uploaded image into byte array
    private byte[] readImage(Part part) throws IOException {

        try (InputStream input = part.getInputStream();
             ByteArrayOutputStream output =
                     new ByteArrayOutputStream()) {

            byte[] buffer = new byte[4096];
            int bytesRead;

            while ((bytesRead = input.read(buffer)) != -1) {
                output.write(buffer, 0, bytesRead);
            }

            return output.toByteArray();
        }
    }

    // Validate image using file signature
    private String detectImageType(byte[] data) {

        // JPEG signature
        if (data.length >= 3
                && (data[0] & 0xFF) == 0xFF
                && (data[1] & 0xFF) == 0xD8
                && (data[2] & 0xFF) == 0xFF) {

            return "image/jpeg";
        }

        // PNG signature
        if (data.length >= 8
                && (data[0] & 0xFF) == 0x89
                && data[1] == 0x50
                && data[2] == 0x4E
                && data[3] == 0x47
                && data[4] == 0x0D
                && data[5] == 0x0A
                && data[6] == 0x1A
                && data[7] == 0x0A) {

            return "image/png";
        }

        return null;
    }

    // Common redirect method
    private void redirect(HttpServletRequest request,
                          HttpServletResponse response,
                          String parameter)
            throws IOException {

        response.sendRedirect(
            request.getContextPath()
            + "/admin/manageStock.jsp?" + parameter
        );
    }
}
