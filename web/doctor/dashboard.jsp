
<%@ page import="model.Doctor" %>
<%@ page import="model.Appointment" %>
<%@ page import="dao.AppointmentDAO" %>
<%@ page import="java.util.List" %>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");

    // ------------------------------------------------------------
    // Authentication check
    // ------------------------------------------------------------
    if (doctor == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    // ------------------------------------------------------------
    // Doctor information
    // ------------------------------------------------------------
    String initials = "DR";

    if (doctor.getFullName() != null &&
        !doctor.getFullName().trim().isEmpty()) {

        String[] parts = doctor.getFullName().trim().split("\\s+");

        initials = parts[0].substring(0, 1).toUpperCase();

        if (parts.length > 1) {
            initials += parts[parts.length - 1]
                    .substring(0, 1)
                    .toUpperCase();
        }
    }

    String status =
            (doctor.getStatus() != null)
            ? doctor.getStatus()
            : "Pending";

    String statusClass =
            "status-" + status.toLowerCase();


    // ------------------------------------------------------------
    // REAL DASHBOARD DATA
    // ------------------------------------------------------------

    AppointmentDAO appointmentDAO = new AppointmentDAO();

    int todaysAppointments =
            appointmentDAO.countToday(doctor.getDoctorId());

    List<Appointment> todaysSchedule =
            appointmentDAO.getTodaysSchedule(doctor.getDoctorId());


    // ------------------------------------------------------------
    // Patient module is not created yet
    // ------------------------------------------------------------

    int upcomingPatients = 0;
    int totalPatients = 0;

%>

<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Doctor Dashboard | MediBridge</title>

    <meta
        name="viewport"
        content="width=device-width, initial-scale=1.0"
    >

    <!-- Fonts -->
    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link
        href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
        rel="stylesheet"
    >

    <!-- Main CSS -->
    <link rel="stylesheet"
          href="../css/style.css">

    <!-- Dashboard CSS -->
    <link rel="stylesheet"
          href="../css/dashboard.css">

</head>


<body class="dash-page">


<!-- ============================================================
     HEADER
     ============================================================ -->

<header class="dash-header">

    <!-- Top row -->

    <div class="dash-topline">

        <!-- Brand -->

        <a href="dashboard.jsp"
           class="brand">

            <svg
                class="logo-mark"
                viewBox="0 0 48 48"
                xmlns="http://www.w3.org/2000/svg"
            >

                <defs>

                    <linearGradient
                        id="dashLogoGrad"
                        x1="0"
                        y1="0"
                        x2="1"
                        y2="1"
                    >

                        <stop
                            offset="0%"
                            stop-color="#ffffff"
                        />

                        <stop
                            offset="100%"
                            stop-color="#bfe4ff"
                        />

                    </linearGradient>

                </defs>


                <circle
                    cx="24"
                    cy="24"
                    r="22"
                    fill="url(#dashLogoGrad)"
                />


                <path
                    d="M8 24 H16 L19 15 L24 33 L28 24 H40"
                    fill="none"
                    stroke="#0a2540"
                    stroke-width="2.6"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />

            </svg>


            <span class="brand-name">
                MediBridge
            </span>

        </a>


        <!-- Doctor information -->

        <div class="dash-user">

            <div class="dash-user-info">

                <strong>
                    Dr. <%= doctor.getFullName() %>
                </strong>

                <span class="status-badge <%= statusClass %>">
                    <%= status %>
                </span>

            </div>


            <a
                href="profile.jsp"
                class="dash-avatar"
                title="View Profile"
            >
                <%= initials %>
            </a>

        </div>

    </div>


    <!-- Navigation -->

    <nav class="dash-nav">

        <a href="dashboard.jsp"
           class="active">
            Dashboard
        </a>

        <a href="appointments.jsp">
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

        <a
            href="../DoctorLogoutServlet"
            class="dash-logout"
        >
            Logout
        </a>

    </nav>

</header>



<!-- ============================================================
     MAIN
     ============================================================ -->

<main class="dash-main">

    <div class="dash-container">


        <!-- ========================================================
             PAGE HEADING
             ======================================================== -->

        <div class="dash-heading">

            <h1>
                Dashboard
            </h1>

            <p>
                Here's what's happening with your patients today.
            </p>

        </div>



        <!-- ========================================================
             STAT CARDS
             ======================================================== -->

        <div class="stat-grid">


            <!-- Today's Appointments -->

            <div class="stat-card">

                <div class="stat-icon stat-icon-blue">

                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                    >

                        <rect
                            x="3"
                            y="5"
                            width="18"
                            height="16"
                            rx="2"
                        />

                        <path d="M16 3v4" />

                        <path d="M8 3v4" />

                        <path d="M3 10h18" />

                    </svg>

                </div>


                <div>

                    <span class="stat-label">
                        Today's Appointments
                    </span>

                    <strong class="stat-value">
                        <%= todaysAppointments %>
                    </strong>

                </div>

            </div>



            <!-- Upcoming Patients -->

            <div class="stat-card">

                <div class="stat-icon stat-icon-teal">

                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                    >

                        <circle
                            cx="12"
                            cy="8"
                            r="4"
                        />

                        <path
                            d="M4 21c0-4 3.5-7 8-7s8 3 8 7"
                        />

                    </svg>

                </div>


                <div>

                    <span class="stat-label">
                        Upcoming Patients
                    </span>

                    <strong class="stat-value">
                        <%= upcomingPatients %>
                    </strong>

                </div>

            </div>



            <!-- Total Patients -->

            <div class="stat-card">

                <div class="stat-icon stat-icon-navy">

                    <svg
                        width="24"
                        height="24"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2"
                    >

                        <circle
                            cx="9"
                            cy="8"
                            r="3.2"
                        />

                        <path
                            d="M2.5 20c0-3.6 2.9-6 6.5-6s6.5 2.4 6.5 6"
                        />

                        <circle
                            cx="18"
                            cy="8.5"
                            r="2.4"
                        />

                        <path
                            d="M15.5 14.2c2.9.4 4.9 2.5 5 5.8"
                        />

                    </svg>

                </div>


                <div>

                    <span class="stat-label">
                        Total Patients
                    </span>

                    <strong class="stat-value">
                        <%= totalPatients %>
                    </strong>

                </div>

            </div>

        </div>



        <!-- ========================================================
             TODAY'S APPOINTMENTS
             ======================================================== -->

        <div class="dash-panel">


            <!-- Panel header -->

            <div class="dash-panel-head">

                <h2>
                    Today's Appointments
                </h2>

                <a
                    href="appointments.jsp"
                    class="panel-link"
                >

                    View all

                    <svg
                        width="14"
                        height="14"
                        viewBox="0 0 24 24"
                        fill="none"
                        stroke="currentColor"
                        stroke-width="2.5"
                    >

                        <path d="M5 12h14" />

                        <path d="M13 6l6 6-6 6" />

                    </svg>

                </a>

            </div>



            <!-- ====================================================
                 EMPTY APPOINTMENT STATE

                 Currently no fake appointments are displayed.
                 When DAO is connected, this section should be
                 replaced with the real appointment list.
                 ==================================================== -->

            <div class="appt-list">

                <% if (todaysAppointments == 0) { %>

                    <div class="appt-empty">

                        No appointments scheduled for today.

                    </div>

                <% } %>

            </div>


        </div>


    </div>

</main>


</body>

</html>