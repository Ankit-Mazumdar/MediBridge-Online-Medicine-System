<%
    String doctorId =
            (String) session.getAttribute("successDoctorId");

    String appointmentDate =
            (String) session.getAttribute("successDate");

    String appointmentTime =
            (String) session.getAttribute("successTime");

    String reason =
            (String) session.getAttribute("successReason");

    String patientName =
            (String) session.getAttribute("successPatientName");

    String patientEmail =
            (String) session.getAttribute("successPatientEmail");

    String patientPhone =
            (String) session.getAttribute("successPatientPhone");


    if (doctorId == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/PatientAppointmentServlet");

        return;
    }
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        Appointment Successful | MediBridge
    </title>

    <link rel="stylesheet"
          href="../css/style.css">

    <style>

        body {
            margin: 0;
            background: #f4f8fc;
            font-family: Arial, sans-serif;
        }

        .success-container {
            max-width: 700px;
            margin: 50px auto;
            background: white;
            padding: 40px;
            border-radius: 18px;
            box-shadow: 0 8px 30px rgba(0,0,0,0.08);
        }

        .success-icon {
            width: 70px;
            height: 70px;
            margin: 0 auto 20px;
            border-radius: 50%;
            background: #e8f8f2;
            color: #159a6b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 38px;
            font-weight: bold;
        }

        .success-container h1 {
            text-align: center;
            color: #073b66;
            margin-bottom: 10px;
        }

        .success-message {
            text-align: center;
            color: #667788;
            margin-bottom: 30px;
        }

        .summary {
            border: 1px solid #e0e7ee;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 30px;
        }

        .summary-title {
            padding: 15px 20px;
            background: #f1fbfb;
            color: #073b66;
            font-size: 18px;
            font-weight: bold;
        }

        .summary-row {
            display: flex;
            justify-content: space-between;
            gap: 20px;
            padding: 14px 20px;
            border-top: 1px solid #edf0f3;
        }

        .summary-label {
            font-weight: bold;
            color: #526475;
        }

        .summary-value {
            color: #1d2d3d;
            text-align: right;
        }

        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            background: #fff4d6;
            color: #9a6b00;
            font-weight: bold;
            font-size: 13px;
        }

        .dashboard-button {
            display: block;
            width: 100%;
            box-sizing: border-box;
            padding: 14px;
            text-align: center;
            text-decoration: none;
            border-radius: 8px;
            background: #073b66;
            color: white;
            font-weight: bold;
        }

        .dashboard-button:hover {
            background: #0b8f91;
        }

    </style>

</head>


<body>

<div class="success-container">

        <div class="success-icon">
            &#10003;
        </div>


    <h1>
        Appointment Booked Successfully!
    </h1>


    <p class="success-message">
        Your appointment request has been submitted.
        Please wait for the doctor to confirm it.
    </p>


    <div class="summary">

        <div class="summary-title">
            Appointment Summary
        </div>


        <div class="summary-row">

            <span class="summary-label">
                Patient Name
            </span>

            <span class="summary-value">
                <%= patientName %>
            </span>

        </div>


        <div class="summary-row">

            <span class="summary-label">
                Email
            </span>

            <span class="summary-value">
                <%= patientEmail %>
            </span>

        </div>


        <div class="summary-row">

            <span class="summary-label">
                Phone
            </span>

            <span class="summary-value">
                <%= patientPhone %>
            </span>

        </div>


        <div class="summary-row">

            <span class="summary-label">
                Doctor ID
            </span>

            <span class="summary-value">
                <%= doctorId %>
            </span>

        </div>


        <div class="summary-row">

            <span class="summary-label">
                Appointment Date
            </span>

            <span class="summary-value">
                <%= appointmentDate %>
            </span>

        </div>


        <div class="summary-row">

            <span class="summary-label">
                Appointment Time
            </span>

            <span class="summary-value">
                <%= appointmentTime %>
            </span>

        </div>


        <div class="summary-row">

            <span class="summary-label">
                Reason
            </span>

            <span class="summary-value">
                <%= reason %>
            </span>

        </div>


        <div class="summary-row">

            <span class="summary-label">
                Status
            </span>

            <span class="summary-value">

                <span class="status">
                    PENDING
                </span>

            </span>

        </div>

    </div>


    <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
       class="dashboard-button">

        Go to Dashboard

    </a>

</div>

</body>

</html>