
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>MediBridge | Blood Request Successful</title>

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
            width: 85%;
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
            line-height: 1.6;
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

        .button:hover {
            background: #084298;
        }

        @media(max-width: 600px) {
            .container {
                padding: 25px 18px;
            }

            .header {
                padding: 20px;
            }
        }

    </style>

</head>

<body>

<div class="header">
    MediBridge
</div>

<div class="container">

    <div class="success-icon">✅</div>

    <h1>Blood Request Submitted!</h1>

    <p class="message">
        Your blood request has been successfully submitted
        to the MediBridge blood bank team.
    </p>

    <div class="details">

        <p>
            <strong>Patient Name:</strong>
            <%= request.getAttribute("patient_name") %>
        </p>

        <p>
            <strong>Blood Group:</strong>
            <%= request.getAttribute("blood_group") %>
        </p>

        <p>
            <strong>Units Required:</strong>
            <%= request.getAttribute("units_required") %>
        </p>

        <p>
            <strong>Contact Number:</strong>
            <%= request.getAttribute("contact_number") %>
        </p>

        <p>
            <strong>Request Status:</strong>
            <span class="status">Pending</span>
        </p>

    </div>

    <p class="message">
        Your request is waiting for admin review.
        The blood bank team will contact you using the
        provided contact number.
    </p>

    <a class="button"
       href="<%= request.getContextPath() %>/emergency/request_blood.jsp">
        ← Back to Blood Bank
    </a>

    <a class="button"
       href="<%= request.getContextPath() %>/index.jsp">
        Home
    </a>

</div>

</body>
</html>
