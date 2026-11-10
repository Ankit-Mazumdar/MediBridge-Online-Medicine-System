<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.PatientBean" %>
<%@ page import="model.Prescription" %>
<%@ page import="java.util.List" %>

<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/Patient/PatientLogin.jsp");
        return;
    }

    List<Prescription> prescriptions =
            (List<Prescription>) request.getAttribute("prescriptions");

    if (prescriptions == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/PatientPrescriptionServlet");
        return;
    }

    String patientName = patient.getName();

    String initials = "";

    if (patientName != null && !patientName.trim().isEmpty()) {

        String[] nameParts =
                patientName.trim().split("\\s+");

        initials =
                nameParts[0].substring(0, 1).toUpperCase();

        if (nameParts.length > 1) {
            initials +=
                    nameParts[nameParts.length - 1]
                    .substring(0, 1)
                    .toUpperCase();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Prescriptions | MediBridge</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/PatientPrescriptions.css?v=2">

</head>


<body class="patient-prescription-page">


<!-- =====================================================
     HEADER
     ===================================================== -->

<header class="patient-prescription-header">

    <div class="patient-prescription-topline">


        <!-- BRAND -->

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


        <!-- PATIENT -->

        <div class="patient-prescription-user">

            <div class="patient-prescription-user-info">

                <strong>
                    <%= patient.getName() %>
                </strong>

                <span>
                    Patient
                </span>

            </div>


            <div class="patient-prescription-avatar">

                <%= initials %>

            </div>

        </div>

    </div>


    <!-- =================================================
         NAVIGATION
         ================================================= -->

   <nav class="patient-profile-nav">

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp">
            Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/PatientAppointmentServlet">
            Appointments
        </a>

<a href="<%= request.getContextPath() %>/Patient/prescriptions.jsp"
   class="active">
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


<!-- =====================================================
     MAIN
     ===================================================== -->

<main class="patient-prescription-main">

    <div class="patient-prescription-container">


        <!-- PAGE HEADING -->

        <section class="patient-prescription-heading">

            <span class="heading-tag">
                Medical Records
            </span>

            <h1>
                My Prescriptions
            </h1>

            <p>
                View your prescriptions, medicines and
                instructions provided by your doctors.
            </p>

        </section>


        <!-- =================================================
             SUMMARY
             ================================================= -->

        <div class="prescription-summary-card">

            <div class="summary-icon">

                <svg viewBox="0 0 24 24"
                     xmlns="http://www.w3.org/2000/svg"
                     aria-hidden="true">

                    <path d="M7 3h7l4 4v14H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linejoin="round"/>

                    <path d="M14 3v5h5"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linejoin="round"/>

                    <path d="M9 12h6M9 16h6"
                          fill="none"
                          stroke="currentColor"
                          stroke-width="1.8"
                          stroke-linecap="round"/>

                </svg>

            </div>

            <div class="summary-content">

                <strong>
                    <%= prescriptions.size() %>
                </strong>

                <span>
                    Total Prescriptions
                </span>

            </div>

        </div>


        <!-- =================================================
             EMPTY STATE
             ================================================= -->

        <% if (prescriptions.isEmpty()) { %>


            <section class="prescription-empty">

                <div class="empty-icon">

                    <svg viewBox="0 0 24 24"
                         xmlns="http://www.w3.org/2000/svg"
                         aria-hidden="true">

                        <path d="M7 3h7l4 4v14H7a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2z"
                              fill="none"
                              stroke="currentColor"
                              stroke-width="1.8"
                              stroke-linejoin="round"/>

                        <path d="M14 3v5h5"
                              fill="none"
                              stroke="currentColor"
                              stroke-width="1.8"
                              stroke-linejoin="round"/>

                        <path d="M9 12h6M9 16h6"
                              fill="none"
                              stroke="currentColor"
                              stroke-width="1.8"
                              stroke-linecap="round"/>

                    </svg>

                </div>

                <h2>
                    No prescriptions yet
                </h2>

                <p>
                    Prescriptions given by your doctors
                    will appear here after your consultation.
                </p>

                <a href="<%= request.getContextPath() %>/PatientAppointmentServlet"
                   class="book-appointment-btn">

                    Book an Appointment

                </a>

            </section>


        <% } else { %>


        <!-- =================================================
             PRESCRIPTION LIST
             ================================================= -->

        <section class="prescription-list">


            <% for (Prescription prescription : prescriptions) { %>


                <article class="prescription-card">


                    <!-- TOP -->

                    <div class="prescription-card-top">


                        <div class="doctor-info">


                            <div class="doctor-avatar">

                                <%
                                    String doctorName =
                                            prescription.getDoctorName();

                                    String doctorInitial = "D";

                                    if (doctorName != null &&
                                        !doctorName.trim().isEmpty()) {

                                        doctorInitial =
                                                doctorName
                                                .trim()
                                                .substring(0, 1)
                                                .toUpperCase();
                                    }
                                %>

                                <%= doctorInitial %>

                            </div>


                            <div>

                                <h2>

                                    <%= prescription.getDoctorName() != null
                                            ? prescription.getDoctorName()
                                            : "Doctor" %>

                                </h2>

                                <p>

                                    <%= prescription.getSpecialization() != null
                                            ? prescription.getSpecialization()
                                            : "Medical Specialist" %>

                                </p>

                            </div>

                        </div>


                        <span class="prescription-status">

                            PRESCRIBED

                        </span>


                    </div>


                    <!-- DATE -->

                    <div class="prescription-meta">

                        <span>

                            Prescription Date:
                            <strong>
                                <%= prescription.getCreatedAt() %>
                            </strong>

                        </span>

                        <span>

                            Appointment #
                            <strong>
                                <%= prescription.getAppointmentId() %>
                            </strong>

                        </span>

                    </div>


                    <!-- DETAILS -->

                    <div class="prescription-details">


                        <!-- DIAGNOSIS -->

                        <div class="prescription-section">

                            <span class="section-label">
                                Diagnosis
                            </span>

                            <p>
                                <%= prescription.getDiagnosis() %>
                            </p>

                        </div>


                        <!-- MEDICINES -->

                        <div class="prescription-section">

                            <span class="section-label">
                                Medicines & Dosage
                            </span>

                            <div class="medicine-box">

                                <%= prescription.getMedicines() %>

                            </div>

                        </div>


                        <!-- INSTRUCTIONS -->

                        <% if (prescription.getInstructions() != null
                                && !prescription.getInstructions()
                                .trim().isEmpty()) { %>

                            <div class="prescription-section">

                                <span class="section-label">
                                    Doctor's Instructions
                                </span>

                                <p>
                                    <%= prescription.getInstructions() %>
                                </p>

                            </div>

                        <% } %>


                    </div>


                    <!-- FOOTER -->

                    <div class="prescription-card-footer">


                        <span class="prescription-created">

                            Created on
                            <%= prescription.getCreatedAt() %>

                        </span>




                    </div>


                </article>


            <% } %>


        </section>


        <% } %>


    </div>

</main>

</body>

</html>