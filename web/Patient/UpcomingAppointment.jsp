<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="model.PatientBean"%>

<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/Patient/PatientLogin.jsp");
        return;
    }

    List<Appointment> appointments =
            (List<Appointment>)
            request.getAttribute("appointments");

    String initials = "PT";

    if (patient.getName() != null &&
        !patient.getName().trim().isEmpty()) {

        String[] parts =
                patient.getName().trim().split("\\s+");

        initials =
                parts[0].substring(0, 1).toUpperCase();

        if (parts.length > 1) {
            initials +=
                    parts[parts.length - 1]
                    .substring(0, 1).toUpperCase();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Upcoming Appointments | MediBridge</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/PatientProfile.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/UpcomingAppointment.css?v=4">

</head>

<body class="patient-profile-page">


<!-- ================= HEADER ================= -->

<header class="patient-profile-header">

    <div class="patient-profile-topline">

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
           class="brand">

            <svg class="logo-mark"
                 viewBox="0 0 48 48"
                 xmlns="http://www.w3.org/2000/svg">

                <defs>

                    <linearGradient id="upcomingLogoGrad"
                                    x1="0"
                                    y1="0"
                                    x2="1"
                                    y2="1">

                        <stop offset="0%"
                              stop-color="#ffffff"/>

                        <stop offset="100%"
                              stop-color="#c9f7f5"/>

                    </linearGradient>

                </defs>

                <circle cx="24"
                        cy="24"
                        r="22"
                        fill="url(#upcomingLogoGrad)"/>

                <path d="M8 24 H16 L19 15 L24 33 L28 24 H40"
                      fill="none"
                      stroke="#0a2540"
                      stroke-width="2.6"
                      stroke-linecap="round"
                      stroke-linejoin="round"/>

            </svg>

            <span class="brand-name">
                MediBridge
            </span>

        </a>


        <div class="patient-profile-user">

            <div class="patient-profile-user-info">

                <strong>
                    <%= patient.getName() %>
                </strong>

                <span>
                    Patient
                </span>

            </div>

            <div class="patient-profile-avatar">
                <%= initials %>
            </div>

        </div>

    </div>


    <!-- ================= NAVIGATION ================= -->

 <nav class="patient-profile-nav">

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/PatientAppointmentServlet">
            Appointments
        </a>

        <a href="<%= request.getContextPath() %>/Patient/prescriptions.jsp">
            Prescriptions
        </a>

        <a href="<%= request.getContextPath() %>/Patient/viewMedicines.jsp">
            View Medicines
        </a>

        <a href="<%= request.getContextPath() %>/OrdersServlet">
            Order History
        </a>

        <a href="<%= request.getContextPath() %>/Patient/profile.jsp"
           >
            Profile
        </a>

        <a href="<%= request.getContextPath() %>/PatientLogoutServlet"
           class="patient-profile-logout">
            Logout
        </a>

    </nav>

</header>


<!-- ================= MAIN ================= -->

<main class="upcoming-main">

    <div class="upcoming-page">


        <!-- PAGE HEADING -->

        <div class="upcoming-heading">
            
            <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
   class="back-dashboard-btn">
    &#8592; Back to Dashboard
</a>

            <span>
                PATIENT CARE
            </span>

            <h1>
                Upcoming Appointments
            </h1>

            <p>
                View your scheduled appointments and their current status.
            </p>

        </div>


        <!-- SUCCESS MESSAGE -->

        <%
            if ("true".equals(
                    request.getParameter("cancelled"))) {
        %>

        <div class="upcoming-message success-message">

            Appointment cancelled successfully.

        </div>

        <%
            }
        %>


        <!-- ERROR MESSAGE -->

        <%
            if ("cancel".equals(
                    request.getParameter("error"))) {
        %>

        <div class="upcoming-message error-message">

            Unable to cancel the appointment.
            Please try again.

        </div>

        <%
            }
        %>


        <%
            boolean found = false;

            if (appointments != null) {

                for (Appointment appointment :
                        appointments) {

                    if (appointment.getAppointmentDate() != null &&
                        !appointment.getAppointmentDate()
                                .before(new java.util.Date()) &&
                        !"CANCELLED".equals(
                                appointment.getStatus()) &&
                        !"REJECTED".equals(
                                appointment.getStatus())) {

                        found = true;
        %>


        <!-- ================= APPOINTMENT CARD ================= -->

        <div class="upcoming-card">


            <!-- HEADER -->

            <div class="upcoming-card-header">

                <div class="upcoming-doctor">

                    <div class="upcoming-avatar">
                        Dr
                    </div>

                    <div>

                        <h2>
                            <%= appointment.getDoctorName() %>
                        </h2>

                        <p>
                            <%= appointment.getSpecialization() %>
                        </p>

                    </div>

                </div>


                <span class="upcoming-status <%= appointment.getStatus().toLowerCase() %>">

                    <%= appointment.getStatus() %>

                </span>

            </div>


            <!-- DETAILS -->

            <div class="upcoming-details">

                <div class="upcoming-detail">

                    <span>
                        Date
                    </span>

                    <strong>
                        <%= appointment.getAppointmentDate() %>
                    </strong>

                </div>


                <div class="upcoming-detail">

                    <span>
                        Time
                    </span>

                    <strong>
                        <%= appointment.getAppointmentTime() %>
                    </strong>

                </div>


                <div class="upcoming-detail">

                    <span>
                        Reason
                    </span>

                    <strong>

                        <%= appointment.getReason() != null &&
                            !appointment.getReason()
                                    .trim().isEmpty()
                            ? appointment.getReason()
                            : "Not specified" %>

                    </strong>

                </div>

            </div>


            <!-- FOOTER -->

            <div class="upcoming-footer">

                <span class="appointment-id">

                    Appointment ID:

                    <strong>
                        <%= appointment.getAppointmentId() %>
                    </strong>

                </span>


                <%
                    if ("PENDING".equals(
                            appointment.getStatus()) ||
                        "ACCEPTED".equals(
                            appointment.getStatus())) {
                %>

                <form action="<%= request.getContextPath() %>/UpcomingAppointmentServlet"
                      method="post">

                    <input type="hidden"
                           name="action"
                           value="cancel">

                    <input type="hidden"
                           name="appointmentId"
                           value="<%= appointment.getAppointmentId() %>">

                    <button type="submit"
                            class="upcoming-cancel">

                        Cancel Appointment

                    </button>

                </form>

                <%
                    }
                %>

            </div>

        </div>


        <%
                    }
                }
            }


            if (!found) {
        %>


        <!-- ================= EMPTY STATE ================= -->

        <div class="upcoming-empty">

            <div class="upcoming-empty-icon">
                &#10003;
            </div>

            <h2>
                No Upcoming Appointments
            </h2>

            <p>
                You currently have no upcoming appointments.
            </p>

            <a href="<%= request.getContextPath() %>/PatientAppointmentServlet"
               class="upcoming-book">

                Book an Appointment

            </a>

        </div>


        <%
            }
        %>


    </div>

</main>


</body>
</html>