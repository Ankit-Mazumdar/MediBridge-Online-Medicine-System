
package admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/doctorDocument")
public class AdminDoctorDocumentServlet extends HttpServlet {

    private final AdminDoctorDAO dao = new AdminDoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Only a logged-in admin may access these documents.
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Admin login required.");
            return;
        }

        // Use email because a pending doctor may not have a Doctor ID.
        String email = request.getParameter("email");
        String type = request.getParameter("type");

        if (email == null || email.trim().isEmpty()
                || !("certificate".equals(type)
                || "govtId".equals(type))) {

            response.sendError(HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid document request.");
            return;
        }

        byte[] data = dao.getDoctorDocumentByEmail(email, type);

        if (data == null || data.length == 0) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND,
                    "Document not found or unsupported.");
            return;
        }

        String contentType = detectImageType(data);

        if (contentType == null) {
            response.sendError(
                    HttpServletResponse.SC_UNSUPPORTED_MEDIA_TYPE,
                    "The uploaded file is not a supported image.");
            return;
        }

        response.setHeader("Cache-Control",
                "no-store, no-cache, must-revalidate, private");
        response.setHeader("Pragma", "no-cache");
        response.setHeader("X-Content-Type-Options", "nosniff");
        response.setHeader("Content-Security-Policy",
                "default-src 'none'; sandbox");
        response.setContentType(contentType);
        response.setContentLength(data.length);
        response.setHeader("Content-Disposition", "inline");

        response.getOutputStream().write(data);
        response.getOutputStream().flush();
    }

    private String detectImageType(byte[] data) {

        // JPEG
        if (data.length >= 3
                && (data[0] & 0xFF) == 0xFF
                && (data[1] & 0xFF) == 0xD8
                && (data[2] & 0xFF) == 0xFF) {
            return "image/jpeg";
        }

        // PNG
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

        // GIF
        if (data.length >= 6) {
            String signature =
                    new String(data, 0, 6, "US-ASCII");

            if ("GIF87a".equals(signature)
                    || "GIF89a".equals(signature)) {
                return "image/gif";
            }
        }

        // WebP
        if (data.length >= 12
                && data[0] == 'R'
                && data[1] == 'I'
                && data[2] == 'F'
                && data[3] == 'F'
                && data[8] == 'W'
                && data[9] == 'E'
                && data[10] == 'B'
                && data[11] == 'P') {
            return "image/webp";
        }

        return null;
    }
}
