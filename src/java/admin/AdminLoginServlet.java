
package admin;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/adminLogin")
public class AdminLoginServlet extends HttpServlet {

    private final AdminDAO adminDAO = new AdminDAO();

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        System.out.println("===== ADMIN LOGIN REQUEST RECEIVED =====");

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        System.out.println("Email received: " + email);

        if (email == null || email.trim().isEmpty()
                || password == null || password.isEmpty()) {

            request.setAttribute("error",
                    "Please enter email and password.");

            request.getRequestDispatcher("/login.jsp")
                   .forward(request, response);
            return;
        }

        Admin admin = adminDAO.getAdminByEmail(email.trim());

        if (admin == null) {
            System.out.println("Admin account not found.");
        } else {
            System.out.println("Admin account found.");
            System.out.println("Admin status: " + admin.getStatus());
        }

        if (admin != null
                && "ACTIVE".equalsIgnoreCase(admin.getStatus())
                && password.equals(admin.getPassword())) {

            System.out.println("ADMIN LOGIN SUCCESSFUL");

            HttpSession oldSession = request.getSession(false);

            if (oldSession != null) {
                oldSession.invalidate();
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("admin", admin);
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(
                    request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }

        System.out.println("ADMIN LOGIN FAILED");

        request.setAttribute("error", "Invalid");
        request.getRequestDispatcher("/login.jsp")
               .forward(request, response);
    }
}
