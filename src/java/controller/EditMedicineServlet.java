
package controller;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import util.DBConnection;

@WebServlet("/EditMedicineServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 2 * 1024 * 1024,
    maxRequestSize = 3 * 1024 * 1024
)
public class EditMedicineServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        if (request.getSession(false) == null ||
            request.getSession(false).getAttribute("admin") == null) {
            response.sendRedirect(
                request.getContextPath() + "/admin/adminLogin.jsp"
            );
            return;
        }

        request.setCharacterEncoding("UTF-8");

        int medicineId;
        String name = request.getParameter("medicine_name");
        String description = request.getParameter("description");
        String priceText = request.getParameter("price");

        try {
            medicineId = Integer.parseInt(
                request.getParameter("medicine_id")
            );

            if (medicineId <= 0 || name == null ||
                name.trim().isEmpty() || name.trim().length() > 150 ||
                description == null || description.length() > 1000 ||
                priceText == null) {
                redirect(request, response, medicineId, "invalidInput");
                return;
            }

            BigDecimal price = new BigDecimal(priceText.trim());

            if (price.compareTo(BigDecimal.ZERO) <= 0 ||
                price.scale() > 2) {
                redirect(request, response, medicineId, "invalidInput");
                return;
            }

            Part imagePart = request.getPart("medicine_image");

            byte[] imageBytes = null;
            String imageType = null;

            if (imagePart != null && imagePart.getSize() > 0) {

                if (imagePart.getSize() > 2 * 1024 * 1024) {
                    redirect(request, response, medicineId, "imageTooLarge");
                    return;
                }

                try (InputStream input = imagePart.getInputStream()) {
                    imageBytes = new byte[(int) imagePart.getSize()];
                    int offset = 0;
                    int count;

                    while (offset < imageBytes.length &&
                           (count = input.read(
                               imageBytes, offset,
                               imageBytes.length - offset
                           )) != -1) {
                        offset += count;
                    }

                    if (offset != imageBytes.length) {
                        redirect(request, response, medicineId, "invalidImage");
                        return;
                    }
                }

                imageType = detectImageType(imageBytes);

                if (imageType == null) {
                    redirect(request, response, medicineId, "invalidImage");
                    return;
                }
            }

            try (Connection con = DBConnection.getConnection()) {

                int rows;

                if (imageBytes != null) {

                    String sql =
                        "UPDATE MEDICINE SET MEDICINE_NAME = ?, " +
                        "DESCRIPTION = ?, PRICE = ?, " +
                        "IMAGE_DATA = ?, IMAGE_TYPE = ? " +
                        "WHERE MEDICINE_ID = ?";

                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, name.trim());
                        ps.setString(2, description.trim());
                        ps.setBigDecimal(3, price);
                        ps.setBytes(4, imageBytes);
                        ps.setString(5, imageType);
                        ps.setInt(6, medicineId);

                        rows = ps.executeUpdate();
                    }

                } else {

                    // No new photo selected: preserve the existing image.
                    String sql =
                        "UPDATE MEDICINE SET MEDICINE_NAME = ?, " +
                        "DESCRIPTION = ?, PRICE = ? " +
                        "WHERE MEDICINE_ID = ?";

                    try (PreparedStatement ps = con.prepareStatement(sql)) {
                        ps.setString(1, name.trim());
                        ps.setString(2, description.trim());
                        ps.setBigDecimal(3, price);
                        ps.setInt(4, medicineId);

                        rows = ps.executeUpdate();
                    }
                }

                if (rows > 0) {
                    response.sendRedirect(
                        request.getContextPath() +
                        "/admin/manageStock.jsp?success=medicineEdited"
                    );
                } else {
                    redirect(request, response, medicineId, "medicineNotFound");
                }
            }

        } catch (NumberFormatException e) {
            response.sendRedirect(
                request.getContextPath() +
                "/admin/manageStock.jsp?error=invalidInput"
            );

        } catch (IllegalStateException e) {
            response.sendRedirect(
                request.getContextPath() +
                "/admin/manageStock.jsp?error=imageTooLarge"
            );

        } catch (Exception e) {
            getServletContext().log("Error editing medicine", e);

            response.sendRedirect(
                request.getContextPath() +
                "/admin/manageStock.jsp?error=editFailed"
            );
        }
    }

    private String detectImageType(byte[] data) {

        if (data == null || data.length < 8) {
            return null;
        }

        // JPEG signature
        if ((data[0] & 0xFF) == 0xFF &&
            (data[1] & 0xFF) == 0xD8 &&
            (data[2] & 0xFF) == 0xFF) {
            return "image/jpeg";
        }

        // PNG signature
        if ((data[0] & 0xFF) == 0x89 &&
            data[1] == 0x50 &&
            data[2] == 0x4E &&
            data[3] == 0x47 &&
            data[4] == 0x0D &&
            data[5] == 0x0A &&
            data[6] == 0x1A &&
            data[7] == 0x0A) {
            return "image/png";
        }

        return null;
    }

    private void redirect(HttpServletRequest request,
                          HttpServletResponse response,
                          int id,
                          String error) throws IOException {

        response.sendRedirect(
            request.getContextPath() +
            "/admin/editMedicine.jsp?id=" + id + "&error=" + error
        );
    }
}
