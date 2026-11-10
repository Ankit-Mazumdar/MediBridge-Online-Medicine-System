
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%!
    // Safely display text inside HTML.
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

<%
    // 1. Verify patient session.
    if (session == null || session.getAttribute("patientId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/Patient/PatientLogin.jsp"
        );
        return;
    }

    // 2. Receive order details from OrdersServlet.
    String medicineName =
        (String) request.getAttribute("orderedMedicineName");

    Object quantityObj =
        request.getAttribute("orderedQuantity");

    Object orderIdObj =
        request.getAttribute("orderId");

    Object totalAmountObj =
        request.getAttribute("totalAmount");

    // 3. Convert Integer and BigDecimal objects safely.
    String quantity = (quantityObj != null)
            ? quantityObj.toString() : null;

    String orderId = (orderIdObj != null)
            ? orderIdObj.toString() : null;

    String totalAmount = (totalAmountObj != null)
            ? totalAmountObj.toString() : null;

    // 4. Check whether the page received valid order details.
    if (medicineName == null || quantity == null
            || orderId == null || totalAmount == null) {

        response.sendRedirect(
            request.getContextPath() + "/Patient/viewMedicines.jsp"
        );
        return;
    }

    // 5. Prepare safely escaped display values.
    String safeMedicineName = escapeHTML(medicineName);
    String safeQuantity = escapeHTML(quantity);
    String safeOrderId = escapeHTML(orderId);
    String safeTotalAmount = escapeHTML(totalAmount);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Order Confirmation | MediBridge</title>

    <style>
        :root {
            --blue: #1863ff;
            --teal: #14c7c2;
            --navy: #102542;
            --white: #ffffff;
            --line: #e5e7eb;
            --ink-soft: #6b7280;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
            font-family: 'Segoe UI', Arial, sans-serif;

            background:
                radial-gradient(900px 480px at 12% -10%,
                    rgba(20,199,194,0.14), transparent 60%),
                radial-gradient(900px 480px at 100% 110%,
                    rgba(24,99,255,0.14), transparent 55%),
                #f7fbff;
        }

        .box {
            width: 100%;
            max-width: 600px;
            background: var(--white);
            border: 1px solid var(--line);
            border-radius: 24px;
            padding: 45px;
            text-align: center;
            box-shadow: 0 20px 50px rgba(0,0,0,0.10);
        }

        .success-icon {
            width: 95px;
            height: 95px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: linear-gradient(135deg,var(--teal),var(--blue));
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 46px;
            font-weight: bold;
        }

        .badge {
            display: inline-block;
            padding: 10px 22px;
            border-radius: 999px;
            background: #eafbf9;
            color: #0aa6a1;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 22px;
        }

        h2 {
            font-size: 38px;
            color: var(--navy);
            margin-bottom: 10px;
        }

        .highlight {
            color: var(--teal);
        }

        .subtitle {
            color: var(--ink-soft);
            font-size: 17px;
            margin-bottom: 28px;
        }

        .card {
            background: #f8fbff;
            border-left: 5px solid var(--teal);
            border-radius: 14px;
            padding: 22px;
            text-align: left;
            margin-bottom: 20px;
        }

        .card h3 {
            color: var(--navy);
            margin-bottom: 12px;
        }

        .medicine-name {
            color: var(--blue);
            font-size: 19px;
            font-weight: 700;
            margin-bottom: 10px;
        }

        .card p {
            color: var(--navy);
            margin-top: 8px;
        }

        .info {
            background: #f3f7ff;
            border-radius: 14px;
            padding: 20px;
            text-align: left;
            color: var(--navy);
            line-height: 2;
            margin-bottom: 25px;
            font-weight: 600;
        }

        .status {
            display: inline-block;
            background: #fff5df;
            color: #a66a00;
            border-radius: 20px;
            padding: 5px 12px;
            font-size: 13px;
            margin-top: 10px;
        }

        .btn {
            display: block;
            text-decoration: none;
            padding: 14px;
            border-radius: 12px;
            font-weight: 600;
            transition: .3s;
        }

        .btn-primary {
            background: linear-gradient(135deg,var(--blue),#4f8cff);
            color: white;
            margin-bottom: 12px;
        }

        .btn-secondary {
            background: linear-gradient(135deg,var(--teal),#0aa6a1);
            color: white;
        }

        .btn:hover {
            transform: translateY(-2px);
        }

        @media(max-width: 600px) {
            .box {
                padding: 28px 20px;
            }

            h2 {
                font-size: 30px;
            }
        }
    </style>
</head>

<body>

<div class="box">

    <div class="success-icon">✓</div>

    <div class="badge">ORDER CONFIRMED</div>

    <h2>
        Order <span class="highlight">Successful</span>
    </h2>

    <p class="subtitle">
        Your medicine order has been placed successfully.
    </p>

    <div class="card">

        <h3>Medicine Ordered</h3>

        <div class="medicine-name">
            <%= safeMedicineName %>
        </div>

        <p>Order ID: #<%= safeOrderId %></p>

        <p>Quantity: <%= safeQuantity %></p>

        <p>Total Amount: Rs. <%= safeTotalAmount %></p>

        <div class="status">
            Payment / Order Status: PENDING
        </div>

    </div>

    <div class="info">
        ✓ Order saved successfully<br>
        ✓ Medicine stock updated successfully<br>
        ✓ Order submitted for processing
    </div>

    <a href="<%= request.getContextPath() %>/Patient/viewMedicines.jsp"
       class="btn btn-primary">
        Back to Medicines
    </a>
<a href="<%= request.getContextPath() %>/OrdersServlet"  class="btn btn-secondary">
    View Order History
</a>
       
      

</div>

</body>
</html>
