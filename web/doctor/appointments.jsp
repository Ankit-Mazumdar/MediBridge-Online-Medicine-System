<%@ page import="model.Doctor" %>
<%@ page import="model.Appointment" %>
<%@ page import="java.util.List" %>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");

    if (doctor == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    List<Appointment> appointments =
        (List<Appointment>) request.getAttribute("appointments");

    if (appointments == null) {
        response.sendRedirect("../AppointmentServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Appointments | MediBridge</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

<!--    <link rel="stylesheet"
          href="../css/style.css">

    <link rel="stylesheet"
          href="../css/appointment.css">-->

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/style.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/appointment.css">

</head>


<body class="appointment-page">


<!-- ================= HEADER ================= -->

<header class="appointment-header">

    <div class="header-top">

        <a href="dashboard.jsp" class="brand">
            MediBridge
        </a>

        <div class="doctor-info">

            <span>
                Dr. <%= doctor.getFullName() %>
            </span>

            <a href="profile.jsp">
                Profile
            </a>

        </div>

    </div>


    <!-- ================= NAVIGATION ================= -->

    <nav class="appointment-nav">
        
        <a href="<%= request.getContextPath() %>/doctor/dashboard.jsp">
    Dashboard
</a>

<a href="<%= request.getContextPath() %>/AppointmentServlet" class="active">
    Appointments
</a>

<a href="<%= request.getContextPath() %>/doctor/patients.jsp">
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

<!--        <a href="dashboard.jsp">
            Dashboard
        </a>

        <a href="../AppointmentServlet" class="active">
            Appointments
        </a>

        <a href="patients.jsp">
            Patients
        </a>

        <a href="availability.jsp">
            Availability
        </a>

        <a href="prescriptions.jsp">
            Prescriptions
        </a>

        <a href="profile.jsp">
            Profile
        </a>

        <a href="../DoctorLogoutServlet" class="logout">
            Logout
        </a>-->

    </nav>

</header>


<!-- ================= MAIN ================= -->

<main class="appointment-main">

    <div class="appointment-container">


        <!-- ================= PAGE HEADING ================= -->

        <div class="page-heading">

            <span class="heading-tag">
                Doctor Panel
            </span>

            <h1>
                Appointments
            </h1>

            <p>
                View and manage your patient appointments.
            </p>

        </div>


        <!-- ================= SUMMARY ================= -->

        <div class="appointment-summary">

            <div class="summary-card">

                <span>
                    Total Appointments
                </span>

                <strong>
                    <%= appointments.size() %>
                </strong>

            </div>

        </div>


        <!-- ================= APPOINTMENT PANEL ================= -->

        <div class="appointment-panel">

            <div class="panel-header">

                <div>

                    <h2>
                        Appointment Details
                    </h2>

                    <p>
                        Your scheduled patient appointments
                    </p>

                </div>

            </div>


            <!-- ================= NO APPOINTMENTS ================= -->

            <% if (appointments.isEmpty()) { %>

                <div class="empty-state">

                    <div class="empty-icon">
                        [Calendar]
                    </div>

                    <h3>
                        No appointments yet
                    </h3>

                    <p>
                        You currently have no appointments.
                        Patient bookings will appear here once available.
                    </p>

                </div>


            <!-- ================= APPOINTMENTS EXIST ================= -->

            <% } else { %>

                <div class="appointment-list">

                    <% for (Appointment appointment : appointments) { %>


                        <div class="appointment-card">


                            <!-- DATE -->

                            <div class="appointment-date">

                                <span class="date-label">
                                    Date
                                </span>

                                <strong>
                                    <%= appointment.getAppointmentDate() %>
                                </strong>

                            </div>


                            <!-- TIME -->

                            <div class="appointment-time">

                                <span class="time-label">
                                    Time
                                </span>

                                <strong>
                                    <%= appointment.getAppointmentTime() %>
                                </strong>

                            </div>


                            <!-- PATIENT DETAILS -->

                            <div class="patient-details">

                                <span class="patient-label">
                                    Patient
                                </span>

                                <h3>
                                    <%= appointment.getPatientName() %>
                                </h3>


                                <% if (appointment.getPatientPhone() != null &&
                                       !appointment.getPatientPhone().trim().isEmpty()) { %>

                                    <p>
                                        Phone:
                                        <%= appointment.getPatientPhone() %>
                                    </p>

                                <% } %>


                                <% if (appointment.getPatientEmail() != null &&
                                       !appointment.getPatientEmail().trim().isEmpty()) { %>

                                    <p>
                                        Email:
                                        <%= appointment.getPatientEmail() %>
                                    </p>

                                <% } %>

                            </div>


                            <!-- STATUS -->

                            <div class="appointment-status">

                                <span class="status-label">
                                    Status
                                </span>

                                <span class="status-badge">
                                    <%= appointment.getStatus() %>
                                </span>

                            </div>
                                
                                <!-- ACTIONS -->

<% if ("PENDING".equalsIgnoreCase(appointment.getStatus())) { %>

    <div class="appointment-actions">

        <form action="<%= request.getContextPath() %>/AppointmentServlet"
              method="post">

            <input type="hidden"
                   name="appointmentId"
                   value="<%= appointment.getAppointmentId() %>">

            <input type="hidden"
                   name="action"
                   value="accept">

            <button type="submit" class="btn-accept">
                Accept
            </button>

        </form>


        <form action="<%= request.getContextPath() %>/AppointmentServlet"
              method="post">

            <input type="hidden"
                   name="appointmentId"
                   value="<%= appointment.getAppointmentId() %>">

            <input type="hidden"
                   name="action"
                   value="reject">

            <button type="submit" class="btn-reject">
                Reject
            </button>

        </form>

    </div>

<% } %>

<!-- ================= PRESCRIPTION ACTION ================= -->

<% if ("ACCEPTED".equalsIgnoreCase(appointment.getStatus())) { %>

    <div class="appointment-actions">

        <a href="<%= request.getContextPath() %>/PrescriptionServlet?action=create&appointmentId=<%= appointment.getAppointmentId() %>"
           class="btn-prescription">

            Write Prescription

        </a>

    </div>

<% } %>



                            <!-- REASON -->

                            <% if (appointment.getReason() != null &&
                                   !appointment.getReason().trim().isEmpty()) { %>

                                <div class="appointment-reason">

                                    <span>
                                        Reason
                                    </span>

                                    <p>
                                        <%= appointment.getReason() %>
                                    </p>

                                </div>

                            <% } %>


                        </div>


                    <% } %>

                </div>

            <% } %>


        </div>

    </div>

</main>


</body>

</html>