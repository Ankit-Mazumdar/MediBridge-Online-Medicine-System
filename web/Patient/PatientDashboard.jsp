
<%@ page import="model.PatientBean" %>
<%@ page import="model.Appointment" %>
<%@ page import="dao.PatientAppointmentDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Date" %>
<%@ page import="dao.PatientPrescriptionDAO" %>

<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect(
            request.getContextPath() + "/Patient/PatientLogin.jsp"
        );
        return;
    }

    PatientPrescriptionDAO prescriptionDAO =
            new PatientPrescriptionDAO();

    int prescriptionCount =
            prescriptionDAO.getPrescriptionCountByPatient(
                    patient.getEmail()
            );

    /* ================= APPOINTMENTS ================= */

/* ================= APPOINTMENTS ================= */

PatientAppointmentDAO appointmentDAO =
        new PatientAppointmentDAO();

List<Appointment> allAppointments =
        appointmentDAO.getAppointmentsByPatient(
                patient.getEmail()
        );

Date today = new Date();

int upcomingCount = 0;
Appointment nextAppointment = null;

java.util.Set<String> doctorIds =
        new java.util.HashSet<String>();

if (allAppointments != null) {

    for (Appointment appointment : allAppointments) {

        if (appointment.getDoctorId() != null) {
            doctorIds.add(appointment.getDoctorId());
        }

        String status = appointment.getStatus();

        if ("IN_CONSULTATION".equalsIgnoreCase(status)) {

            // Prioritize ongoing consultation.
            nextAppointment = appointment;

        } else if (
                appointment.getAppointmentDate() != null &&
                !appointment.getAppointmentDate().before(today) &&
                ("PENDING".equalsIgnoreCase(status) ||
                 "ACCEPTED".equalsIgnoreCase(status))
        ) {

            upcomingCount++;

            if (nextAppointment == null) {
                nextAppointment = appointment;
            }
        }
    }
}

int myDoctorsCount = doctorIds.size();



    /* ================= PATIENT INITIALS ================= */

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
                    .substring(0, 1)
                    .toUpperCase();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Patient Dashboard | MediBridge</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/PatientDashboard.css?v=10">

    <style>

        .patient-appointment-preview {
            padding: 20px;
            border: 1px solid #e3e9ef;
            border-radius: 12px;
            background: #f8fbfd;
        }

        .appointment-preview-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            padding-bottom: 15px;
            border-bottom: 1px solid #e3e9ef;
        }

        .appointment-preview-header div {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .appointment-preview-header strong {
            color: #073b66;
        }

        .appointment-preview-header span {
            color: #68798a;
            font-size: 13px;
        }

        .appointment-status {
            padding: 6px 12px;
            border-radius: 20px;
            background: #fff4d6;
            color: #9a6b00 !important;
            font-size: 12px !important;
            font-weight: bold;
        }

        .appointment-preview-details {
            display: grid;
            grid-template-columns:
                repeat(auto-fit, minmax(130px, 1fr));
            gap: 20px;
            padding: 20px 0;
        }

        .appointment-preview-details div {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .appointment-preview-details span {
            color: #68798a;
            font-size: 13px;
        }

        .appointment-preview-details strong {
            color: #1d2d3d;
        }
        
        .consultation-ready {
    margin-top: 15px;
    padding: 18px;
    background: #ecfdf5;
    border: 1px solid #a7f3d0;
    border-radius: 12px;
}

.consultation-ready strong {
    color: #065f46;
    font-size: 16px;
}

.consultation-ready p {
    color: #475569;
    margin: 8px 0 15px;
    font-size: 14px;
}

.join-consultation-btn {
    display: inline-block;
    padding: 13px 22px;
    border-radius: 8px;
    background: #059669;
    color: white;
    font-weight: 700;
    text-decoration: none;
}

.join-consultation-btn:hover {
    background: #047857;
}

    </style>

</head>


<body class="patient-dash-page">


<header class="patient-dash-header">

    <div class="patient-dash-topline">


        <!-- MediBridge Brand -->

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
           class="brand">

            <svg class="logo-mark"
                 viewBox="0 0 48 48"
                 xmlns="http://www.w3.org/2000/svg">

                <defs>

                    <linearGradient id="patientLogoGrad"
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
                        fill="url(#patientLogoGrad)"/>

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


        <!-- Patient Information -->

        <div class="patient-dash-user">

            <div class="patient-dash-user-info">

                <strong>
                    <%= patient.getName() %>
                </strong>

                <span>
                    Patient
                </span>

            </div>

            <a href="<%= request.getContextPath() %>/Patient/profile.jsp"
               class="patient-dash-avatar"
               title="View Profile">

                <%= initials %>

            </a>

        </div>

    </div>


    <!-- Navigation -->

    <nav class="patient-dash-nav">

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
           class="active">
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

        <!-- Emergency link can be enabled later -->

        <!--
        <a href="<%= request.getContextPath() %>/emergency/emergency.jsp">
            Emergency
        </a>
        -->

        <a href="<%= request.getContextPath() %>/Patient/profile.jsp">
            Profile
        </a>

        <a href="<%= request.getContextPath() %>/PatientLogoutServlet"
           class="patient-dash-logout">
            Logout
        </a>

    </nav>

</header>


<main class="patient-dash-main">

    <div class="patient-dash-container">


        <!-- Page Heading -->

        <div class="patient-dash-heading">

            <div>

                <span class="patient-welcome-label">
                    Welcome back
                </span>

                <h1>
                    <%= patient.getName() %>
                </h1>

                <p>
                    Here is an overview of your healthcare journey.
                </p>

            </div>

        </div>


        <!-- ================= STATISTICS ================= -->

        <div class="patient-stat-grid">


            <!-- Upcoming Appointments -->

            <div class="patient-stat-card">

                <div class="patient-stat-icon patient-stat-icon-blue">

                    <svg width="24"
                         height="24"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2">

                        <rect x="3"
                              y="5"
                              width="18"
                              height="16"
                              rx="2"/>

                        <path d="M16 3v4"/>
                        <path d="M8 3v4"/>
                        <path d="M3 10h18"/>

                    </svg>

                </div>


                <div class="patient-stat-content">

                    <span class="patient-stat-label">
                        Upcoming Appointments
                    </span>

                    <span class="patient-stat-description">
                        Your scheduled consultations
                    </span>

                    <strong class="patient-stat-value">
                        <%= upcomingCount %>
                    </strong>

                </div>

            </div>


            <!-- My Doctors -->

            <a href="<%= request.getContextPath() %>/MyDoctorsServlet"
               class="patient-stat-card patient-stat-link">

                <div class="patient-stat-icon patient-stat-icon-teal">

                    <svg width="24"
                         height="24"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2">

                        <circle cx="12"
                                cy="7"
                                r="4"/>

                        <path d="M5 21c0-4 3-7 7-7s7 3 7 7"/>

                        <path d="M19 3v5"/>
                        <path d="M16.5 5.5h5"/>

                    </svg>

                </div>


                <div class="patient-stat-content">

                    <span class="patient-stat-label">
                        My Doctors
                    </span>

                    <span class="patient-stat-description">
                        View and manage your doctors
                    </span>

                    <strong class="patient-stat-value">
                        <%= myDoctorsCount %>
                    </strong>

                </div>


                <span class="patient-stat-arrow">
                    &rarr;
                </span>

            </a>


            <!-- Prescriptions -->

            <a href="<%= request.getContextPath() %>/Patient/prescriptions.jsp"
               class="patient-stat-card patient-stat-link">

                <div class="patient-stat-icon patient-stat-icon-purple">

                    <svg width="24"
                         height="24"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2">

                        <rect x="5"
                              y="3"
                              width="14"
                              height="18"
                              rx="2"/>

                        <path d="M8 8h8"/>
                        <path d="M8 12h8"/>
                        <path d="M8 16h5"/>

                    </svg>

                </div>


                <div class="patient-stat-content">

                    <span class="patient-stat-label">
                        Prescriptions
                    </span>

                    <span class="patient-stat-description">
                        View your prescriptions
                    </span>

                    <strong class="patient-stat-value">
                        <%= prescriptionCount %>
                    </strong>

                </div>


                <span class="patient-stat-arrow">
                    &rarr;
                </span>

            </a>

        </div>


        <!-- ================= MAIN CONTENT ================= -->

        <div class="patient-content-grid">


            <!-- Upcoming Appointments -->

            <div class="patient-dash-panel">

                <div class="patient-panel-head">

                    <div>

                        <h2>
                            Upcoming Appointments
                        </h2>

                        <p>
                            Your scheduled consultations
                        </p>

                    </div>


                    <a href="<%= request.getContextPath() %>/AppointmentHistoryServlet"
                       class="patient-panel-link">

                        Appointment History &rarr;

                    </a>

                </div>


                <%
                    if (nextAppointment != null) {
                %>

                <div class="patient-appointment-preview">

                    <div class="appointment-preview-header">

                        <div>

                            <h3>
                                <%= nextAppointment.getDoctorName() %>
                            </h3>

                            <p class="doctor-specialization">
                                <%= nextAppointment.getSpecialization() %>
                            </p>

                            <span>
                                Appointment
                            </span>

                        </div>


                        <span class="appointment-status">
                            <%= nextAppointment.getStatus() %>
                        </span>

                    </div>


                    <div class="appointment-preview-details">

                        <div>

                            <span>
                                Date
                            </span>

                            <strong>
                                <%= nextAppointment.getAppointmentDate() %>
                            </strong>

                        </div>


                        <div>

                            <span>
                                Time
                            </span>

                            <strong>
                                <%= nextAppointment.getAppointmentTime() %>
                            </strong>

                        </div>


                        <div>

                            <span>
                                Reason
                            </span>

                            <strong>
                                <%= nextAppointment.getReason() %>
                            </strong>

                        </div>

                    </div>


<% if ("IN_CONSULTATION".equalsIgnoreCase(
        nextAppointment.getStatus()) &&
       nextAppointment.getMeetingRoom() != null &&
       !nextAppointment.getMeetingRoom().trim().isEmpty()) { %>

    <div class="consultation-ready">

        <strong>Doctor has started your consultation!</strong>

        <p>
            Your doctor is waiting. Click below to join the video call.
        </p>

        <a href="<%= request.getContextPath() %>/JoinConsultationServlet?appointmentId=<%= nextAppointment.getAppointmentId() %>"
           class="join-consultation-btn">

            Join Consultation

        </a>

    </div>

<% } else { %>

    <a href="<%= request.getContextPath() %>/UpcomingAppointmentServlet"
       class="patient-action-btn">

        View All Appointments

    </a>

<% } %>

                </div>


                <%
                    } else {
                %>

                <div class="patient-empty-state">

                    <div class="patient-empty-icon">
                        &#10003;
                    </div>

                    <strong>
                        No upcoming appointments
                    </strong>

                    <span>
                        Your scheduled appointments will appear here.
                    </span>

                    <a href="<%= request.getContextPath() %>/PatientAppointmentServlet"
                       class="patient-action-btn">

                        Book an Appointment

                    </a>

                </div>

                <%
                    }
                %>

            </div>


            <!-- Health Overview -->

            <div class="patient-dash-panel">

                <div class="patient-panel-head">

                    <div>

                        <h2>
                            Profile Overview
                        </h2>

                        <p>
                            Your basic health information
                        </p>

                    </div>

                </div>


                <div class="health-info-grid">


                    <div class="health-info-item">

                        <span>
                            Blood Group
                        </span>

                        <strong>
                            <%= patient.getBloodGroup() != null
                                ? patient.getBloodGroup()
                                : "Not added" %>
                        </strong>

                    </div>


                    <div class="health-info-item">

                        <span>
                            Gender
                        </span>

                        <strong>
                            <%= patient.getGender() != null
                                ? patient.getGender()
                                : "Not added" %>
                        </strong>

                    </div>


                    <div class="health-info-item">

                        <span>
                            Contact
                        </span>

                        <strong>
                            <%= patient.getContact() != null
                                ? patient.getContact()
                                : "Not added" %>
                        </strong>

                    </div>


                    <div class="health-info-item">

                        <span>
                            Email
                        </span>

                        <strong>
                            <%= patient.getEmail() %>
                        </strong>

                    </div>

                </div>


                <a href="<%= request.getContextPath() %>/Patient/profile.jsp"
                   class="health-profile-link">

                    View Full Profile &rarr;

                </a>

            </div>

        </div>

    </div>

</main>

<script>

    const currentConsultationId =
        "<%= nextAppointment != null &&
             "IN_CONSULTATION".equalsIgnoreCase(nextAppointment.getStatus())
             ? nextAppointment.getAppointmentId() : "" %>";

    const consultationCheckUrl =
        "<%= request.getContextPath() %>/PatientConsultationStatusServlet";

    function checkConsultation() {

        fetch(consultationCheckUrl, {
            method: "GET",
            cache: "no-store"
        })
        .then(response => {

            if (!response.ok) {
                return "";
            }

            return response.text();
        })
        .then(activeAppointmentId => {

            activeAppointmentId = activeAppointmentId.trim();

            if (activeAppointmentId !== currentConsultationId) {
                window.location.reload();
            }

        })
        .catch(error => {
            console.log("Consultation status check failed:", error);
        });
    }

    // Check every five seconds.
    setInterval(checkConsultation, 5000);

</script>
</body>
</html>
