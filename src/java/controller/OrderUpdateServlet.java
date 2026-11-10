
package controller;

import dao.MedicineOrderDAO;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/OrderUpdateServlet")
public class OrderUpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check admin session
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("admin") == null) {

            response.sendRedirect(
                request.getContextPath() + "/login.jsp#admin"
            );

            return;
        }

        try {

            // Get order ID
            int orderId = Integer.parseInt(
                request.getParameter("order_id")
            );

            // Get admin action
            String action = request.getParameter("action");

            String status = "";

            // Convert action into order status
            if ("approve".equals(action)) {

                status = "APPROVED";

            } else if ("reject".equals(action)) {

                status = "REJECTED";

            } else if ("dispatch".equals(action)) {

                status = "OUT_FOR_DELIVERY";

            } else if ("deliver".equals(action)) {

                status = "DELIVERED";

            } else {

                response.sendError(
                    HttpServletResponse.SC_BAD_REQUEST,
                    "Invalid order action"
                );

                return;
            }

            // Call DAO
            MedicineOrderDAO dao = new MedicineOrderDAO();

            boolean updated = dao.updateOrderStatus(orderId, status);

            if (updated) {

                System.out.println(
                    "Order " + orderId + " updated to " + status
                );

                response.sendRedirect(
                    request.getContextPath() + "/AdminOrdersServlet"
                );

            } else {

                response.sendRedirect(
                    request.getContextPath() + "/AdminOrdersServlet?error=update"
                );
            }

        } catch (NumberFormatException e) {

            response.sendError(
                HttpServletResponse.SC_BAD_REQUEST,
                "Invalid Order ID"
            );

        } catch (Exception e) {

            e.printStackTrace();

            response.sendError(
                HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "Unable to update order"
            );
        }
    }
}
