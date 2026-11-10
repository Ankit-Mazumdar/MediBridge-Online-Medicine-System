
package Servlets;

import admin.Admin;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/admin/profile")
public class AdminProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        response.setHeader("Cache-Control",
                "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("admin") == null) {

            response.sendRedirect(
                request.getContextPath() + "/admin/login.jsp");
            return;
        }

        Admin admin = (Admin) session.getAttribute("admin");

        request.setAttribute("adminName", admin.getFullName());
        request.setAttribute("adminEmail", admin.getEmail());

        request.getRequestDispatcher("/admin/profile.jsp")
               .forward(request, response);
    }
}
