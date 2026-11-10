
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="model.MedicineOrder" %>
<%@ page import="model.MedicineOrderItem" %>

<%!
    public String escapeHTML(String value) {
        if (value == null) {
            return "";
        }

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Medicine Order History | MediBridge</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            margin: 0;
            padding: 30px;
            color: #263445;
        }

        .container {
            max-width: 1000px;
            margin: auto;
        }

        h2 {
            color: #183b64;
            margin-bottom: 8px;
        }

        .subtitle {
            color: #718096;
            margin-bottom: 25px;
        }

        .order-card {
            background: white;
            padding: 22px;
            margin-bottom: 20px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0,0,0,0.06);
        }

        .order-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 12px;
            border-bottom: 1px solid #e5eaf0;
            padding-bottom: 15px;
        }

        .order-id {
            font-size: 18px;
            font-weight: bold;
            color: #183b64;
        }

        .order-date {
            color: #718096;
            font-size: 14px;
            margin-top: 5px;
        }

        .status {
            padding: 8px 14px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
            display: inline-block;
        }

        .pending {
            background: #fff4d6;
            color: #946200;
        }

        .approved {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .delivery {
            background: #e0f2fe;
            color: #0369a1;
        }

        .delivered {
            background: #dcfce7;
            color: #15803d;
        }

        .rejected {
            background: #fee2e2;
            color: #b91c1c;
        }

        .medicine-heading {
            margin-top: 20px;
            margin-bottom: 8px;
            font-weight: bold;
            color: #183b64;
        }

        .medicine-row {
            display: flex;
            justify-content: space-between;
            padding: 12px 0;
            border-bottom: 1px solid #edf0f4;
            font-size: 14px;
            gap: 10px;
        }

        .medicine-name {
            font-weight: bold;
            margin-bottom: 5px;
        }

        .quantity {
            color: #718096;
        }

        .medicine-price {
            white-space: nowrap;
        }

        .total {
            display: flex;
            justify-content: space-between;
            margin-top: 18px;
            font-size: 17px;
            font-weight: bold;
        }

        .empty {
            background: white;
            padding: 45px 20px;
            text-align: center;
            border-radius: 12px;
            color: #718096;
        }

        .empty h3 {
            color: #183b64;
        }

        .back-btn {
            display: inline-block;
            margin-top: 15px;
            padding: 11px 20px;
            background: #183b64;
            color: white;
            text-decoration: none;
            border-radius: 7px;
        }

        .back-btn:hover {
            background: #24558a;
        }

        @media(max-width: 600px) {
            body {
                padding: 15px;
            }

            .medicine-row {
                flex-wrap: wrap;
            }
        }
        .back-dashboard {
    display: inline-block;
    margin: 12px 0 20px;
    padding: 10px 18px;
    background: #eef4ff;
    color: #2563eb;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 600;
    transition: 0.3s ease;
}

.back-dashboard:hover {
    background: #2563eb;
    color: #fff;
}
    </style>
</head>

<body>
    
        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
   class="back-dashboard">
    ← Back to Dashboard
</a>

<div class="container">

    <h2>Your Medicine Orders</h2>

    <p class="subtitle">
        View your previously ordered medicines, quantities,
        order dates and delivery status.
    </p>

    <%
        List<MedicineOrder> orders =
            (List<MedicineOrder>) request.getAttribute("orders");

        SimpleDateFormat dateFormat =
            new SimpleDateFormat("dd MMM yyyy", Locale.ENGLISH);

        if (orders == null || orders.isEmpty()) {
    %>

        <!-- Show this only when there are no orders -->

        <div class="empty">
            <h3>No Orders Found</h3>

            <p>
                You haven't placed any medicine orders yet.
                Your orders will appear here once you place an order.
            </p>
        </div>

    <%
        } else {

            // Display order cards only when orders exist

            for (MedicineOrder order : orders) {

                String status = order.getOrderStatus();

                String statusText = "Pending";
                String statusClass = "pending";

                if ("APPROVED".equalsIgnoreCase(status)) {
                    statusText = "Order Confirmed";
                    statusClass = "approved";
                }
                else if ("OUT_FOR_DELIVERY".equalsIgnoreCase(status)) {
                    statusText = "Out for Delivery";
                    statusClass = "delivery";
                }
                else if ("DELIVERED".equalsIgnoreCase(status)) {
                    statusText = "Delivery Complete";
                    statusClass = "delivered";
                }
                else if ("REJECTED".equalsIgnoreCase(status)) {
                    statusText = "Order Rejected";
                    statusClass = "rejected";
                }
    %>

    

        <div class="order-card">

            <div class="order-header">

                <div>
                    <div class="order-id">
                        Order #<%= order.getId() %>
                    </div>

                    <div class="order-date">
                        Order Date:

                        <%= order.getOrderDate() != null
                            ? dateFormat.format(order.getOrderDate())
                            : "N/A" %>
                    </div>
                </div>

                <span class="status <%= statusClass %>">
                    <%= statusText %>
                </span>

            </div>

            <div class="medicine-heading">
                Ordered Medicines
            </div>

            <%
                List<MedicineOrderItem> items = order.getItems();

                if (items != null && !items.isEmpty()) {

                    for (MedicineOrderItem item : items) {
            %>

                <div class="medicine-row">

                    <div>
                        <div class="medicine-name">
                            <%= escapeHTML(item.getMedicineName()) %>
                        </div>

                        <div class="quantity">
                            Quantity: <%= item.getQuantity() %>
                        </div>
                    </div>

                    <div class="medicine-price">
                        Rs. <%= String.format(Locale.US, "%.2f",
                            item.getLineTotal()) %>
                    </div>

                </div>

            <%
                    }

                } else {
            %>

                <p class="quantity">
                    No medicine details available for this order.
                </p>

            <%
                }
            %>

            <div class="total">

                <span>Total Amount</span>

                <span>
                    Rs. <%= String.format(Locale.US, "%.2f",
                        order.getTotalAmount()) %>
                </span>

            </div>
                <% if ("REJECTED".equalsIgnoreCase(status)) { %>

                <p style="margin-top: 18px;
                          color: #b91c1c;
                          font-size: 14px;
                          line-height: 1.6;">

                    Your order has been rejected.
                    For refund-related assistance, please contact our
                    helpline: <strong>199-158-8520</strong>

                </p>

            <% } %>

        </div>

        </div>

    <%
            }
        }
    %>

    <a href="<%= request.getContextPath() %>/Patient/viewMedicines.jsp"
       class="back-btn">
        &#8592; Back To Medicines
    </a>

</div>

</body>
</html>
