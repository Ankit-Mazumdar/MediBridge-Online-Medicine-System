<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="java.util.List"%>
<%@page import="model.Appointment"%>
<%@page import="model.PatientBean"%>

<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect("PatientLogin.jsp");
        return;
    }

    List<Appointment> doctors =
            (List<Appointment>)
            request.getAttribute("doctors");

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

    <title>My Doctors | MediBridge</title>

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
          href="<%= request.getContextPath() %>/css/MyDoctors.css">

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

                    <linearGradient id="doctorsLogoGrad"
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
                        fill="url(#doctorsLogoGrad)"/>

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
           class="active">
            Profile
        </a>

        <a href="<%= request.getContextPath() %>/PatientLogoutServlet"
           class="patient-profile-logout">
            Logout
        </a>

    </nav>
</header>


<!-- ================= MAIN ================= -->

<main class="doctors-page">

    <div class="patient-profile-container">


        <div class="patient-profile-heading">
            
            <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
   class="back-dashboard-btn">
    &#8592; Back to Dashboard
</a>

            <span>
                PATIENT CARE
            </span>

            <h1>
                My Doctors
            </h1>

            <p>
                Doctors you have booked appointments with.
            </p>

        </div>


        <%
            if (doctors != null && !doctors.isEmpty()) {

                for (Appointment doctor : doctors) {
        %>


        <div class="doctor-card">

            <div class="doctor-card-header">

                <div>

                    <h2>
                        <%= doctor.getDoctorName() %>
                    </h2>

                    <p class="specialization">
                        <%= doctor.getSpecialization() %>
                    </p>

                </div>

            </div>


            <div class="doctor-details">

                <div>

                    <strong>
                        Doctor ID
                    </strong>

                    <p>
                        <%= doctor.getDoctorId() %>
                    </p>

                </div>

            </div>


            <div class="doctor-card-footer">

                <a href="<%= request.getContextPath() %>/PatientAppointmentServlet?doctorId=<%= doctor.getDoctorId() %>"
                   class="book-doctor-button">

                    Book Appointment

                </a>

            </div>

        </div>


        <%
                }

            } else {
        %>


        <div class="empty-doctors">

            <h2>
                No Doctors Yet
            </h2>

            <p>
                You have not booked an appointment with any doctor yet.
            </p>

            <a href="<%= request.getContextPath() %>/PatientAppointmentServlet"
               class="book-doctor-button">

                Find a Doctor

            </a>

        </div>


        <%
            }
        %>


    </div>

</main>


</body>
</html>