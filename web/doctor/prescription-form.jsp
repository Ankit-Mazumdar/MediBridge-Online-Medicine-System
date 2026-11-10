<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Doctor" %>
<%@ page import="model.Appointment" %>

<%
    Doctor doctor =
            (Doctor) session.getAttribute("doctor");

    if (doctor == null) {
        response.sendRedirect("../login.jsp");
        return;
    }

    Appointment appointment =
            (Appointment) request.getAttribute("appointment");

    if (appointment == null) {
        response.sendRedirect("../AppointmentServlet");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Write Prescription | MediBridge</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <!-- Google Fonts -->
    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <!-- MediBridge CSS -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/prescription.css">

</head>


<body class="prescription-page">


<!-- =====================================================
     HEADER
     ===================================================== -->

<header class="prescription-header">

    <div class="prescription-header-inner">

        <div class="prescription-brand">
            MediBridge
        </div>

        <div class="prescription-doctor">
            Dr. <%= doctor.getFullName() %>
        </div>

    </div>

</header>


<!-- =====================================================
     MAIN
     ===================================================== -->

<main class="prescription-main">


    <!-- PAGE HEADING -->

    <div class="prescription-heading">

        <span class="heading-tag">
            Doctor Panel
        </span>

        <h1>
            Write Prescription
        </h1>

        <p>
            Create a prescription for your patient consultation.
        </p>

    </div>


    <!-- =================================================
         PATIENT INFORMATION
         ================================================= -->

    <section class="patient-card">

        <div class="patient-card-header">

            <h2>
                Patient Information
            </h2>

            <span class="patient-badge">
                Consultation
            </span>

        </div>


        <div class="patient-info-grid">


            <div class="patient-info">

                <span class="label">
                    Patient Name
                </span>

                <span class="value">
                    <%= appointment.getPatientName() %>
                </span>

            </div>


            <div class="patient-info">

                <span class="label">
                    Email
                </span>

                <span class="value">
                    <%= appointment.getPatientEmail() %>
                </span>

            </div>


            <div class="patient-info">

                <span class="label">
                    Phone
                </span>

                <span class="value">
                    <%= appointment.getPatientPhone() %>
                </span>

            </div>


            <div class="patient-info">

                <span class="label">
                    Appointment Date
                </span>

                <span class="value">
                    <%= appointment.getAppointmentDate() %>
                </span>

            </div>


            <div class="patient-info">

                <span class="label">
                    Appointment Time
                </span>

                <span class="value">
                    <%= appointment.getAppointmentTime() %>
                </span>

            </div>


            <div class="patient-info">

                <span class="label">
                    Reason
                </span>

                <span class="value">
                    <%= appointment.getReason() %>
                </span>

            </div>


        </div>

    </section>


    <!-- =================================================
         PRESCRIPTION FORM
         ================================================= -->

    <section class="prescription-card">


        <div class="prescription-card-header">

            <h2>
                Prescription Details
            </h2>

            <p>
                Enter the diagnosis, medicines and instructions
                for this consultation.
            </p>

        </div>


        <form action="<%= request.getContextPath() %>/PrescriptionServlet"
              method="post"
              >


            <!-- APPOINTMENT ID -->

            <input type="hidden"
                   name="appointmentId"
                   value="<%= appointment.getAppointmentId() %>">


            <!-- PATIENT NAME -->

            <input type="hidden"
                   name="patientName"
                   value="<%= appointment.getPatientName() %>">


            <!-- ================= DIAGNOSIS ================= -->

            <div class="form-group">

                <label for="diagnosis">
                    Diagnosis
                    <span class="required">*</span>
                </label>

                <textarea
                    id="diagnosis"
                    name="diagnosis"
                    rows="4"
                    placeholder="Enter the patient's diagnosis..."
                    required></textarea>

            </div>


            <!-- ================= MEDICINES ================= -->

            <div class="form-group">

                <label for="medicines">
                    Medicines & Dosage
                    <span class="required">*</span>
                </label>

                <textarea
                    id="medicines"
                    name="medicines"
                    rows="7"
                    placeholder="Example:

Paracetamol 500mg
Dosage: 1 tablet
Frequency: 2 times daily
Duration: 3 days

Cetirizine 10mg
Dosage: 1 tablet
Frequency: Once daily
Duration: 5 days"
                    required></textarea>

            </div>


            <!-- ================= INSTRUCTIONS ================= -->

            <div class="form-group">

                <label for="instructions">
                    Instructions
                </label>

                <textarea
                    id="instructions"
                    name="instructions"
                    rows="5"
                    placeholder="Enter additional instructions for the patient..."></textarea>

            </div>


          


            <!-- ================= PRIVACY ================= -->

            <div class="privacy-note">

                🔒 Prescription information is securely associated
                with this patient's appointment.

            </div>


            <!-- ================= ACTIONS ================= -->

            <div class="form-actions">

                <a href="<%= request.getContextPath() %>/AppointmentServlet"
                   class="btn-cancel-prescription">

                    Cancel

                </a>


                <button type="submit"
                        class="btn-save-prescription">

                    ✓
                    Save Prescription

                </button>

            </div>


        </form>

    </section>


</main>

</body>

</html>