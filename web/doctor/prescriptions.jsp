<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Doctor" %>
<%@ page import="model.Prescription" %>
<%@ page import="java.util.List" %>

<%
Doctor doctor =
(Doctor) session.getAttribute("doctor");

if (doctor == null) {
    response.sendRedirect("../login.jsp");
    return;
}

List<Prescription> prescriptions =
        (List<Prescription>) request.getAttribute("prescriptions");

if (prescriptions == null) {
    response.sendRedirect("../PrescriptionServlet");
    return;
}


%>

<!DOCTYPE html>

<html lang="en">

<head>


<meta charset="UTF-8">

<title>Prescriptions | MediBridge</title>

<meta name="viewport"
      content="width=device-width, initial-scale=1.0">

<!-- Google Fonts -->

<link rel="preconnect"
      href="https://fonts.googleapis.com">

<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
      rel="stylesheet">


<!-- Prescription History CSS -->

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/prescription.css">

<link rel="stylesheet"
      href="<%= request.getContextPath() %>/css/prescriptions.css">
</head>

<body>

<!-- =====================================================
     HEADER
     ===================================================== -->

<header class="prescriptions-header">


<div class="prescriptions-header-inner">

    <div>

        <div class="prescriptions-brand">
            MediBridge
        </div>

        <div class="prescriptions-subtitle">
            Doctor Portal
        </div>

    </div>


    <div class="doctor-name">

        Dr. <%= doctor.getFullName() %>

    </div>

</div>


</header>

<!-- =====================================================
     MAIN
     ===================================================== -->

<main class="prescriptions-main">
    
    <div class="back-section">

    <a href="<%= request.getContextPath() %>/AppointmentServlet"
       class="back-link">

        ← Back to Appointments

    </a>

</div>


<!-- PAGE HEADING -->

<section class="page-heading">

    <span class="heading-tag">
        Medical Records
    </span>

    <h1>
        Prescriptions
    </h1>

    <p>
        View prescriptions created for your patients.
    </p>

</section>


<!-- =================================================
     STAT
     ================================================= -->

<div class="prescription-summary">

    <div class="summary-icon">
        RX
    </div>

    <div>

        <span class="summary-number">
            <%= prescriptions.size() %>
        </span>

        <span class="summary-label">
            Total Prescriptions
        </span>

    </div>

</div>


<!-- =================================================
     EMPTY STATE
     ================================================= -->

<% if (prescriptions.isEmpty()) { %>

    <section class="empty-card">

        <div class="empty-icon">
            RX
        </div>

        <h2>
            No prescriptions yet
        </h2>

        <p>
            Prescriptions created for your patients
            will appear here.
        </p>

        <a href="<%= request.getContextPath() %>/AppointmentServlet"
           class="btn-primary">

            Go to Appointments

        </a>

    </section>


<% } else { %>


    <!-- =================================================
         PRESCRIPTION LIST
         ================================================= -->

    <section class="prescription-list">


        <% for (Prescription prescription : prescriptions) { %>


            <article class="prescription-item">


                <!-- TOP -->

                <div class="prescription-item-top">


                    <div class="patient-heading">


                        <div class="patient-avatar">

                            <%= prescription.getPatientName()
                                    .substring(0, 1)
                                    .toUpperCase() %>

                        </div>


                        <div>

                            <h2>
                                <%= prescription.getPatientName() %>
                            </h2>

                            <p>
                                Appointment #
                                <%= prescription.getAppointmentId() %>
                            </p>

                        </div>

                    </div>


                    <span class="status-badge">
                        PRESCRIBED
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

                        <p class="medicine-text">
                            <%= prescription.getMedicines() %>
                        </p>

                    </div>


                    <!-- INSTRUCTIONS -->

                    <% if (prescription.getInstructions() != null &&
                           !prescription.getInstructions().trim().isEmpty()) { %>

                        <div class="prescription-section">

                            <span class="section-label">
                                Instructions
                            </span>

                            <p>
                                <%= prescription.getInstructions() %>
                            </p>

                        </div>

                    <% } %>


                </div>


                <!-- FOOTER -->

                <div class="prescription-item-footer">


                    <span class="created-date">

                        Created:
                        <%= prescription.getCreatedAt() %>

                    </span>


                    <% if (prescription.getPrescriptionFile() != null &&
                           !prescription.getPrescriptionFile().trim().isEmpty()) { %>

                        <span class="file-badge">
                            File Attached
                        </span>

                    <% } %>


                </div>


            </article>


        <% } %>


    </section>


<% } %>


<!-- =================================================
     BACK
     ================================================= -->




</main>

</body>

</html>
