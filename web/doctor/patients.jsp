
<%@ page import="model.Doctor" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");

    if (doctor == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Appointment> patients =
        (List<Appointment>) request.getAttribute("patients");

    if (patients == null) {
        response.sendRedirect(
            request.getContextPath() + "/DoctorPatientsServlet");
        return;
    }

    SimpleDateFormat dateFormat =
        new SimpleDateFormat("dd MMM yyyy");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>My Patients | MediBridge</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/appointment.css">

    <style>

        .patients-main {
            padding: 45px 20px;
            min-height: 75vh;
        }

        .patients-container {
            max-width: 1150px;
            margin: auto;
        }

        .patients-heading {
            margin-bottom: 30px;
        }

        .patients-heading h1 {
            font-family: 'Manrope', sans-serif;
            font-size: 32px;
            margin: 10px 0;
        }

        .patients-heading p {
            color: #64748b;
        }

        .patients-summary {
            background: #ffffff;
            padding: 24px;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
            margin-bottom: 25px;
        }

        .patients-summary span {
            display: block;
            color: #64748b;
            font-size: 13px;
        }

        .patients-summary strong {
            display: block;
            font-size: 30px;
            margin-top: 8px;
            color: #0f766e;
        }

        .patient-table-wrapper {
            overflow-x: auto;
            background: white;
            border-radius: 14px;
            border: 1px solid #e2e8f0;
        }

        .patient-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 700px;
        }

        .patient-table th,
        .patient-table td {
            padding: 17px 20px;
            text-align: left;
            border-bottom: 1px solid #e2e8f0;
        }

        .patient-table th {
            background: #f8fafc;
            color: #64748b;
            font-size: 12px;
            text-transform: uppercase;
        }

        .patient-table td {
            font-size: 13px;
            color: #334155;
        }

        .patient-name {
            font-weight: 700;
            color: #0f172a;
        }

        .completed-label {
            display: inline-block;
            padding: 6px 11px;
            border-radius: 20px;
            background: #dcfce7;
            color: #15803d;
            font-size: 11px;
            font-weight: 700;
        }

        .patient-empty {
            text-align: center;
            padding: 65px 20px;
        }

        .patient-empty h3 {
            margin-bottom: 10px;
        }

        .patient-empty p {
            color: #64748b;
            font-size: 14px;
        }

    </style>

</head>

<body class="appointment-page">

<header class="appointment-header">

    <div class="header-top">

        <a href="<%= request.getContextPath() %>/doctor/dashboard.jsp"
           class="brand">
            MediBridge
        </a>

        <div class="doctor-info">

            <span>Dr. <%= doctor.getFullName() %></span>

            <a href="<%= request.getContextPath() %>/doctor/profile.jsp">
                Profile
            </a>

        </div>

    </div>

    <nav class="appointment-nav">

        <a href="<%= request.getContextPath() %>/doctor/dashboard.jsp">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/AppointmentServlet">
            Appointments
        </a>

        <a href="<%= request.getContextPath() %>/DoctorPatientsServlet"
           class="active">
            Patients
        </a>

        <a href="<%= request.getContextPath() %>/doctor/availability.jsp">
            Availability
        </a>

        <a href="<%= request.getContextPath() %>/doctor/prescriptions.jsp">
            Prescriptions
        </a>

        <a href="<%= request.getContextPath() %>/doctor/profile.jsp">
            Profile
        </a>

        <a href="<%= request.getContextPath() %>/DoctorLogoutServlet"
           class="logout">
            Logout
        </a>

    </nav>

</header>

<main class="patients-main">

    <div class="patients-container">

        <div class="patients-heading">

            <span class="heading-tag">Doctor Panel</span>

            <h1>My Patients</h1>

            <p>
                View patients whose appointments you have completed.
            </p>

        </div>

        <div class="patients-summary">

            <span>Total Completed Visits</span>

            <strong><%= patients.size() %></strong>

        </div>

        <div class="appointment-panel">

            <div class="panel-header">

                <div>
                    <h2>Patient Records</h2>
                    <p>Your completed appointment history</p>
                </div>

            </div>

            <% if (patients.isEmpty()) { %>

                <div class="patient-empty">

                    <h3>No completed patients yet</h3>

                    <p>
                        Patients will appear here after you complete
                        their consultations.
                    </p>

                </div>

            <% } else { %>

                <div class="patient-table-wrapper">

                    <table class="patient-table">

                        <thead>

                            <tr>
                                <th>Patient</th>
                                <th>Contact</th>
                                <th>Appointment Date</th>
                                <th>Time</th>
                                <th>Reason</th>
                                <th>Status</th>
                            </tr>

                        </thead>

                        <tbody>

                            <% for (Appointment patient : patients) { %>

                                <tr>

                                    <td class="patient-name">
                                        <%= patient.getPatientName() %>
                                    </td>

                                    <td>
                                        <%= patient.getPatientEmail() == null
                                            ? "N/A" : patient.getPatientEmail() %>
                                        <br>
                                        <%= patient.getPatientPhone() == null
                                            ? "N/A" : patient.getPatientPhone() %>
                                    </td>

                                    <td>
                                        <%= patient.getAppointmentDate() == null
                                            ? "N/A" :
                                            dateFormat.format(patient.getAppointmentDate()) %>
                                    </td>

                                    <td>
                                        <%= patient.getAppointmentTime() == null
                                            ? "N/A" : patient.getAppointmentTime() %>
                                    </td>

                                    <td>
                                        <%= patient.getReason() == null
                                            ? "N/A" : patient.getReason() %>
                                    </td>

                                    <td>
                                        <span class="completed-label">
                                            COMPLETED
                                        </span>
                                    </td>

                                </tr>

                            <% } %>

                        </tbody>

                    </table>

                </div>

            <% } %>

        </div>

    </div>

</main>

</body>
</html>
