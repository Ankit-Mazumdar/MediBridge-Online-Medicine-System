
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%!
    // Converts special characters into safe HTML characters.
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
    // Check whether the patient is logged in.
    if (session == null || session.getAttribute("patientId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/Patient/PatientLogin.jsp"
        );
        return;
    }

    // Receive medicine details from viewMedicines.jsp.
    String medicineId = request.getParameter("medicine_id");
    String medicineName = request.getParameter("medicine_name");
    String price = request.getParameter("price");
    String stock = request.getParameter("stock");

    // Redirect if medicine details are missing.
    if (medicineId == null || medicineName == null
            || price == null || stock == null) {
        response.sendRedirect(
            request.getContextPath() + "/Patient/viewMedicines.jsp"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Order Medicine | MediBridge</title>

    <style>
        :root {
            --blue: #1863ff;
            --teal: #14c7c2;
            --navy: #102542;
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
                    rgba(20,199,194,.14), transparent 60%),
                radial-gradient(900px 480px at 100% 110%,
                    rgba(24,99,255,.14), transparent 55%),
                #f7fbff;
        }

        .container {
            width: 100%;
            max-width: 520px;
            background: white;
            padding: 38px;
            border-radius: 24px;
            border: 1px solid var(--line);
            box-shadow: 0 20px 50px rgba(0,0,0,.09);
        }

        h2 {
            color: var(--navy);
            font-size: 30px;
            margin-bottom: 10px;
        }

        .subtitle {
            color: var(--ink-soft);
            margin-bottom: 25px;
        }

        .medicine-card {
            background: #f3f7ff;
            padding: 20px;
            border-radius: 14px;
            margin-bottom: 25px;
        }

        .medicine-card h3 {
            color: var(--blue);
            margin-bottom: 12px;
        }

        .medicine-card p {
            color: var(--navy);
            margin: 8px 0;
        }

        label {
            display: block;
            font-weight: 600;
            color: var(--navy);
            margin-bottom: 8px;
        }

        input[type=number] {
            width: 100%;
            padding: 13px;
            border: 1px solid var(--line);
            border-radius: 10px;
            font-size: 16px;
            margin-bottom: 20px;
        }

        .btn {
            width: 100%;
            padding: 15px;
            background: linear-gradient(135deg,var(--blue),#4f8cff);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }

        .back {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: var(--blue);
            text-decoration: none;
        }
    </style>
</head>

<body>

<div class="container">

    <h2>Order Medicine</h2>

    <p class="subtitle">
        Review your medicine details and enter the required quantity.
    </p>

    <div class="medicine-card">

        <h3><%= escapeHTML(medicineName) %></h3>

        <p>Medicine ID: <%= escapeHTML(medicineId) %></p>

        <p>Price: Rs. <%= escapeHTML(price) %></p>

        <p>Available Stock: <%= escapeHTML(stock) %></p>

    </div>

    <form action="<%= request.getContextPath() %>/OrdersServlet"
          method="post">

        <input type="hidden"
               name="medicine_id"
               value="<%= escapeHTML(medicineId) %>">

        <label>Quantity</label>

        <input type="number"
               name="quantity"
               min="1"
               max="<%= escapeHTML(stock) %>"
               placeholder="Enter quantity"
               required>

        <button type="submit" class="btn">
            Place Order
        </button>

    </form>

    <a class="back"
       href="<%= request.getContextPath() %>/Patient/viewMedicines.jsp">
        Back to Medicines
    </a>

</div>

</body>
</html>
