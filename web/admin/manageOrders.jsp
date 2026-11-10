
<%@ page import="java.util.List" %>
<%@ page import="model.MedicineOrder" %>
<%@ page import="model.MedicineOrderItem" %>

<%!
    public String escapeHTML(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }

    public String getStatusClass(String status) {
        if (status == null) return "pending";

        if ("APPROVED".equalsIgnoreCase(status))
            return "approved";

        if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status))
            return "delivery";

        if ("DELIVERED".equalsIgnoreCase(status))
            return "delivered";

        if ("REJECTED".equalsIgnoreCase(status))
            return "rejected";

        return "pending";
    }
%>

<%
    // Admin session protection
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp#admin");
        return;
    }

    List<MedicineOrder> orders =
        (List<MedicineOrder>) request.getAttribute("orders");

    Integer totalOrders =
        (Integer) request.getAttribute("totalOrders");

    Integer pendingCount =
        (Integer) request.getAttribute("pendingCount");

    Integer approvedCount =
        (Integer) request.getAttribute("approvedCount");

    Integer deliveryCount =
        (Integer) request.getAttribute("deliveryCount");

    Integer deliveredCount =
        (Integer) request.getAttribute("deliveredCount");

    Integer rejectedCount =
        (Integer) request.getAttribute("rejectedCount");

    String errorMessage =
        (String) request.getAttribute("errorMessage");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Medicine Orders | MediBridge</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        :root {
            --blue: #1863ff;
            --teal: #14c7c2;
            --navy: #102542;
            --ink: #1f2937;
            --muted: #6b7280;
            --line: #e5e7eb;
            --white: #ffffff;
            --danger: #dc2626;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background:
                radial-gradient(900px 480px at 12% -10%,
                rgba(20,199,194,.12), transparent 60%),
                #f7fbff;
            color: var(--ink);
            padding: 35px;
        }

        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
            margin-bottom: 30px;
        }

        h1 {
            color: var(--navy);
            font-size: 34px;
        }

        h1 span {
            color: var(--teal);
        }

        .subtitle {
            color: var(--muted);
            margin-top: 7px;
        }

        .back-btn {
            text-decoration: none;
            background: var(--navy);
            color: white;
            padding: 12px 18px;
            border-radius: 10px;
            font-weight: 600;
        }

        .stats {
            display: grid;
            grid-template-columns: repeat(5, 1fr);
            gap: 16px;
            margin-bottom: 30px;
        }

        .stat-card {
            background: white;
            padding: 22px;
            border-radius: 17px;
            border: 1px solid var(--line);
            box-shadow: 0 8px 25px rgba(0,0,0,.04);
        }

        .stat-card h3 {
            font-size: 27px;
            color: var(--navy);
            margin-bottom: 6px;
        }

        .stat-card p {
            color: var(--muted);
            font-size: 14px;
        }

        .order-card {
            background: white;
            border: 1px solid var(--line);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 22px;
            box-shadow: 0 10px 30px rgba(0,0,0,.05);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            padding-bottom: 18px;
            border-bottom: 1px solid var(--line);
        }

        .order-header h2 {
            color: var(--navy);
            font-size: 22px;
        }

        .order-date {
            color: var(--muted);
            font-size: 13px;
            margin-top: 5px;
        }

        .status {
            display: inline-block;
            padding: 7px 13px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 700;
        }

        .pending {
            background: #fff4d6;
            color: #946200;
        }

        .approved {
            background: #e4efff;
            color: #185abc;
        }

        .delivery {
            background: #e8e5ff;
            color: #5b45b5;
        }

        .delivered {
            background: #dcfce7;
            color: #15803d;
        }

        .rejected {
            background: #fee2e2;
            color: #b91c1c;
        }

        .section-title {
            font-size: 16px;
            color: var(--navy);
            font-weight: 700;
            margin: 20px 0 12px;
        }

        .patient-info {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 12px;
        }

        .info-box {
            background: #f8fafc;
            padding: 13px;
            border-radius: 10px;
            overflow-wrap: anywhere;
        }

        .info-box small {
            display: block;
            color: var(--muted);
            margin-bottom: 5px;
        }

        .info-box strong {
            color: var(--ink);
            font-size: 14px;
        }

        .table-container {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 500px;
        }

        th, td {
            padding: 13px;
            text-align: left;
            border-bottom: 1px solid var(--line);
        }

        th {
            background: #f3f7fc;
            color: var(--navy);
            font-size: 13px;
        }

        td {
            font-size: 14px;
        }

        .total-row {
            display: flex;
            justify-content: flex-end;
            margin-top: 18px;
            font-size: 19px;
            font-weight: 700;
            color: var(--navy);
        }

        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
            margin-top: 22px;
            padding-top: 18px;
            border-top: 1px solid var(--line);
        }

        .action-form {
            display: inline;
        }

        .btn {
            border: none;
            padding: 11px 17px;
            border-radius: 9px;
            cursor: pointer;
            color: white;
            font-weight: 600;
            font-size: 13px;
        }

        .approve-btn {
            background: #16a34a;
        }

        .reject-btn {
            background: var(--danger);
        }

        .delivery-btn {
            background: var(--blue);
        }

        .delivered-btn {
            background: #087f5b;
        }

        .btn:hover {
            opacity: .88;
        }

        .completed-message {
            color: #15803d;
            font-weight: 600;
            margin-top: 18px;
        }

        .rejected-message {
            color: var(--danger);
            font-weight: 600;
            margin-top: 18px;
        }

        .empty-state {
            background: white;
            border: 1px solid var(--line);
            border-radius: 18px;
            padding: 50px 20px;
            text-align: center;
            color: var(--muted);
        }

        .empty-state h2 {
            color: var(--navy);
            margin-bottom: 10px;
        }

        .error-message {
            background: #fee2e2;
            color: #b91c1c;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }

        @media(max-width: 1000px) {
            .stats {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media(max-width: 650px) {
            body {
                padding: 15px;
            }

            h1 {
                font-size: 27px;
            }

            .stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .patient-info {
                grid-template-columns: 1fr;
            }

            .order-card {
                padding: 17px;
            }
        }
    </style>
</head>

<body>

    <div class="page-header">
        <div>
            <h1>Medicine <span>Orders</span></h1>
            <p class="subtitle">
                View patient orders and manage medicine delivery.
            </p>
        </div>

        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp"
           class="back-btn">
            Back to Dashboard
        </a>
    </div>

    <% if (errorMessage != null) { %>
        <div class="error-message">
            <%= escapeHTML(errorMessage) %>
        </div>
    <% } %>

    <div class="stats">

        <div class="stat-card">
            <h3><%= totalOrders == null ? 0 : totalOrders %></h3>
            <p>Total Orders</p>
        </div>

        <div class="stat-card">
            <h3><%= pendingCount == null ? 0 : pendingCount %></h3>
            <p>Pending</p>
        </div>

        <div class="stat-card">
            <h3><%= approvedCount == null ? 0 : approvedCount %></h3>
            <p>Approved</p>
        </div>

        <div class="stat-card">
            <h3><%= deliveryCount == null ? 0 : deliveryCount %></h3>
            <p>Out for Delivery</p>
        </div>

        <div class="stat-card">
            <h3><%= deliveredCount == null ? 0 : deliveredCount %></h3>
            <p>Delivered</p>
        </div>

    </div>

    <%
        if (orders == null) {
    %>

        <div class="empty-state">
            <h2>Orders not loaded</h2>
            <p>Please open this page through the Admin Orders section.</p>
        </div>

    <%
        } else if (orders.isEmpty()) {
    %>

        <div class="empty-state">
            <h2>No Medicine Orders Yet</h2>
            <p>Patient medicine orders will appear here.</p>
        </div>

    <%
        } else {

            for (MedicineOrder order : orders) {

                String status = order.getOrderStatus();
                String statusClass = getStatusClass(status);

                List<MedicineOrderItem> items = order.getItems();
    %>

        <div class="order-card">

            <div class="order-header">

                <div>
                    <h2>Order #<%= order.getId() %></h2>

                    <p class="order-date">
                        Order Date:
                        <%= order.getOrderDate() == null
                            ? "N/A" : order.getOrderDate() %>
                    </p>
                </div>

                <span class="status <%= statusClass %>">
                    <%= escapeHTML(status) %>
                </span>

            </div>

            <h3 class="section-title">Patient Information</h3>

            <div class="patient-info">

                <div class="info-box">
                    <small>Patient Name</small>
                    <strong>
                        <%= escapeHTML(order.getPatientName()) %>
                    </strong>
                </div>

                <div class="info-box">
                    <small>Patient ID</small>
                    <strong><%= order.getPatientId() %></strong>
                </div>

                <div class="info-box">
                    <small>Email</small>
                    <strong>
                        <%= escapeHTML(order.getPatientEmail()) %>
                    </strong>
                </div>

                <div class="info-box">
                    <small>Contact Number</small>
                    <strong>
                        <%= escapeHTML(order.getPatientContact()) %>
                    </strong>
                </div>

                <div class="info-box" style="grid-column: 1 / -1;">
                    <small>Delivery Address</small>
                    <strong>
                        <%= escapeHTML(order.getPatientAddress()) %>
                    </strong>
                </div>

            </div>

            <h3 class="section-title">Ordered Medicines</h3>

            <div class="table-container">

                <table>
                    <tr>
                        <th>Medicine</th>
                        <th>Quantity</th>
                        <th>Unit Price</th>
                        <th>Line Total</th>
                    </tr>

                    <%
                        if (items != null && !items.isEmpty()) {

                            for (MedicineOrderItem item : items) {
                    %>

                        <tr>
                            <td>
                                <%= escapeHTML(item.getMedicineName()) %>
                            </td>

                            <td><%= item.getQuantity() %></td>

                            <td>
                                Rs. <%= String.format("%.2f", item.getUnitPrice()) %>
                            </td>

                            <td>
                                Rs. <%= String.format("%.2f", item.getLineTotal()) %>
                            </td>
                        </tr>

                    <%
                            }
                        } else {
                    %>

                        <tr>
                            <td colspan="4">No medicine items found.</td>
                        </tr>

                    <% } %>

                </table>

            </div>

            <div class="total-row">
                Total: Rs. <%= String.format("%.2f", order.getTotalAmount()) %>
            </div>

            <div class="actions">

                <% if ("PENDING".equalsIgnoreCase(status)) { %>

                    <form class="action-form"
                          action="<%= request.getContextPath() %>/OrderUpdateServlet"
                          method="post">

                        <input type="hidden"
                               name="order_id"
                               value="<%= order.getId() %>">

                        <input type="hidden"
                               name="action"
                               value="approve">

                        <button type="submit" class="btn approve-btn">
                            Approve Order
                        </button>
                    </form>

                    <form class="action-form"
                          action="<%= request.getContextPath() %>/OrderUpdateServlet"
                          method="post"
                          onsubmit="return confirm('Are you sure you want to reject this order?');">

                        <input type="hidden"
                               name="order_id"
                               value="<%= order.getId() %>">

                        <input type="hidden"
                               name="action"
                               value="reject">

                        <button type="submit" class="btn reject-btn">
                            Reject Order
                        </button>
                    </form>

                <% } else if ("APPROVED".equalsIgnoreCase(status)) { %>

                    <form class="action-form"
                          action="<%= request.getContextPath() %>/OrderUpdateServlet"
                          method="post">

                        <input type="hidden"
                               name="order_id"
                               value="<%= order.getId() %>">

                        <input type="hidden"
                               name="action"
                               value="dispatch">

                        <button type="submit" class="btn delivery-btn">
                            &#128666; Mark for Delivery
                        </button>
                    </form>

                <% } else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) { %>

                    <form class="action-form"
                          action="<%= request.getContextPath() %>/OrderUpdateServlet"
                          method="post"
                          onsubmit="return confirm('Confirm that this medicine order has been delivered to the patient?');">

                        <input type="hidden"
                               name="order_id"
                               value="<%= order.getId() %>">

                        <input type="hidden"
                               name="action"
                               value="deliver">

                        <button type="submit" class="btn delivered-btn">
                            &#10003; Mark as Delivered
                        </button>
                    </form>

                <% } else if ("DELIVERED".equalsIgnoreCase(status)) { %>

                    <p class="completed-message">
                        &#10003; This order has been delivered.
                    </p>

                <% } else if ("REJECTED".equalsIgnoreCase(status)) { %>

                    <p class="rejected-message">
                        This order was rejected.
                    </p>

                <% } %>

            </div>

        </div>

    <%
            }
        }
    %>

</body>
</html>

