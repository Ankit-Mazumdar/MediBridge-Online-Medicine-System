<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MediBridge - Bed Request</title>

    <style>
        body {
            font-family: Arial, sans-serif;
            background: #eef6ff;
            margin: 0;
        }

        .header {
            background: #0b5ed7;
            color: white;
            padding: 20px 50px;
            font-size: 25px;
            font-weight: bold;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            background: white;
            padding: 35px;
            border-radius: 15px;
            box-shadow: 0 5px 20px rgba(0,0,0,0.15);
            text-align: center;
        }

        .success-icon {
            font-size: 60px;
        }

        h1 {
            color: #198754;
        }

        .message {
            color: #555;
            font-size: 16px;
        }

        .details {
            text-align: left;
            background: #f5f9ff;
            padding: 20px;
            border-radius: 10px;
            margin-top: 20px;
            overflow-wrap: anywhere;
        }

        .details p {
            margin: 12px 0;
        }

        .status {
            background: #fff3cd;
            color: #856404;
            padding: 6px 15px;
            border-radius: 20px;
            font-weight: bold;
        }

        .button {
            display: inline-block;
            margin: 25px 5px 0;
            padding: 12px 20px;
            background: #0b5ed7;
            color: white;
            text-decoration: none;
            border-radius: 8px;
        }
    </style>
</head>

<body>

<div class="header">MediBridge</div>

<div class="container">

    <div class="success-icon">✅</div>

    <h1>Bed Request Submitted!</h1>

    <p class="message">
        Your emergency bed request has been successfully received.
    </p>

    <div class="details">

        <p>
            <strong>Patient Name:</strong>
            <%= request.getAttribute("patient_name") %>
        </p>

        <p>
            <strong>Contact:</strong>
            <%= request.getAttribute("contact") %>
        </p>

        <p>
            <strong>Age:</strong>
            <%= request.getAttribute("patient_age") %>
        </p>

        <p>
            <strong>Bed Type:</strong>
            <%= request.getAttribute("bed_type") %>
        </p>

        <p>
            <strong>Status:</strong>
            <span class="status">Pending</span>
        </p>

    </div>

    <p class="message">
        Your request has been submitted for admin processing.
    </p>

    <a class="button"
       href="<%= request.getContextPath() %>/emergency/emergency.jsp">
        ← Back to Emergency
    </a>

    <a class="button"
       href="<%= request.getContextPath() %>/index.jsp">
        Home
    </a>

</div>

</body>
</html>