<%@page import="java.util.List"%>
<%@page import="model.Doctor"%>
<%@page import="model.DoctorAvailability"%>
<%@page import="model.PatientBean"%>
<%@page import="dao.PatientAppointmentDAO"%>

<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/Patient/PatientLogin.jsp");
        return;
    }

    List<Doctor> doctors =
            (List<Doctor>) request.getAttribute("doctors");

    List<DoctorAvailability> availability =
            (List<DoctorAvailability>)
            request.getAttribute("availability");

    String selectedDoctorId =
            (String) request.getAttribute("selectedDoctorId");

    String appointmentDate =
            (String) request.getAttribute("appointmentDate");

    String selectedDay =
            (String) request.getAttribute("selectedDay");

    PatientAppointmentDAO appointmentDAO =
            new PatientAppointmentDAO();

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

    <title>Appointments | MediBridge</title>

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/PatientDashboard.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/PatientProfile.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/PatientAppointment.css">

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

                    <linearGradient id="appointmentLogoGrad"
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
                        fill="url(#appointmentLogoGrad)"/>

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

<main class="appointment-main">

    <div class="appointment-page">

        <!-- PAGE HEADING -->

        <div class="appointment-heading">

            <span>
                PATIENT CARE
            </span>

            <h1>
                Book an Appointment
            </h1>

            <p>
                Choose a doctor, select a date and book an available time slot.
            </p>

        </div>


        <!-- ================= MESSAGES ================= -->

        <%
            if ("duplicate".equals(
                    request.getParameter("error"))) {
        %>

        <div class="error-message">

            You already have an appointment with this doctor
            on this date. You can book only one appointment
            with the same doctor per day.

        </div>

        <%
            }

            if ("booked".equals(
                    request.getParameter("error"))) {
        %>

        <div class="error-message">

            This appointment slot has already been booked.
            Please select another available slot.

        </div>

        <%
            }
        %>


        <!-- ================= DOCTORS ================= -->

        <section class="appointment-section">

            <div class="appointment-section-heading">

                <div class="appointment-section-icon">
                    D
                </div>

                <div>

                    <h2>
                        Choose a Doctor
                    </h2>

                    <p>
                        Select a doctor to view available appointments.
                    </p>

                </div>

            </div>


            <div class="doctor-grid">

                <%
                    if (doctors != null &&
                        !doctors.isEmpty()) {

                        for (Doctor doctor : doctors) {
                %>

                <div class="doctor-card">

                    <div class="doctor-card-top">

                        <div class="doctor-avatar">
                            Dr
                        </div>

                        <div>

                            <h2>
                                <%= doctor.getFullName() %>
                            </h2>

                            <p class="specialization">
                                <%= doctor.getSpecialization() %>
                            </p>

                        </div>

                    </div>


                    <div class="doctor-details">

                        <div class="doctor-detail">

                            <span>
                                Qualification
                            </span>

                            <strong>
                                <%= doctor.getQualification() %>
                            </strong>

                        </div>


                        <div class="doctor-detail">

                            <span>
                                Experience
                            </span>

                            <strong>
                                <%= doctor.getExperience() %> years
                            </strong>

                        </div>


                        <div class="doctor-detail">

                            <span>
                                Gender
                            </span>

                            <strong>
                                <%= doctor.getGender() %>
                            </strong>

                        </div>


                        <div class="doctor-detail">

                            <span>
                                Contact
                            </span>

                            <strong>
                                <%= doctor.getPhone() %>
                            </strong>

                        </div>

                    </div>


                    <div class="doctor-email">

                        <span>
                            Email
                        </span>

                        <strong>
                            <%= doctor.getEmail() %>
                        </strong>

                    </div>


                    <form action="<%= request.getContextPath() %>/PatientAppointmentServlet"
                          method="get">

                        <input type="hidden"
                               name="doctorId"
                               value="<%= doctor.getDoctorId() %>">

                        <button type="submit"
                                class="select-button">

                            Select Doctor

                            <span>
                                &rarr;
                            </span>

                        </button>

                    </form>

                </div>

                <%
                        }

                    } else {
                %>

                <div class="empty-message">

                    No approved doctors are currently available.

                </div>

                <%
                    }
                %>

            </div>

        </section>


        <!-- ================= DATE ================= -->

        <%
            if (selectedDoctorId != null) {
        %>

        <section class="appointment-section date-section"
                 id="date-section">

            <div class="appointment-section-heading">

                <div class="appointment-section-icon teal">
                    D
                </div>

                <div>

                    <h2>
                        Select Appointment Date
                    </h2>

                    <p>
                        Choose a date to check the doctor's availability.
                    </p>

                </div>

            </div>


            <form action="<%= request.getContextPath() %>/PatientAppointmentServlet"
                  method="get"
                  class="date-form">

                <input type="hidden"
                       name="doctorId"
                       value="<%= selectedDoctorId %>">

                <div class="date-input-group">

                    <label>
                        Appointment Date
                    </label>

                    <input type="date"
                           name="appointmentDate"
                           value="<%= appointmentDate != null
                                      ? appointmentDate : "" %>"
                           required>

                </div>


                <button type="submit"
                        class="select-button">

                    Check Availability

                    <span>
                        &rarr;
                    </span>

                </button>

            </form>

        </section>

        <%
            }
        %>



<!-- ================= SLOTS ================= -->

<%
    if (availability != null &&
        !availability.isEmpty() &&
        appointmentDate != null) {
%>

<section class="appointment-section availability-section"
         id="availability-section">

    <div class="appointment-section-heading">

        <div class="appointment-section-icon security">
            T
        </div>

        <div>
            <h2>Available Time Slots</h2>

            <p>
                Select an available time for your appointment.
            </p>
        </div>

    </div>

    <div class="selected-date">

        <span>Selected Day</span>

        <strong><%= selectedDay %></strong>

    </div>

    <div class="slot-container">

    <%
        for (DoctorAvailability a : availability) {

            String start = a.getStartTime();
            String end = a.getEndTime();

            int duration = a.getSlotDuration();

            try {

                String[] startParts = start.split(":");
                String[] endParts = end.split(":");

                int startMinutes =
                        Integer.parseInt(startParts[0]) * 60
                        + Integer.parseInt(startParts[1]);

                int endMinutes =
                        Integer.parseInt(endParts[0]) * 60
                        + Integer.parseInt(endParts[1]);

                // Validate availability data.
                if (duration <= 0 ||
                    endMinutes <= startMinutes) {
                    continue;
                }

                int slotNumber = 1;

                for (int time = startMinutes;
                     time + duration <= endMinutes;
                     time += duration, slotNumber++) {

                    int hour = time / 60;
                    int minute = time % 60;

                    String slot = String.format(
                            "%02d:%02d",
                            hour,
                            minute);

                    int endSlot = time + duration;

                    String endTime = String.format(
                            "%02d:%02d",
                            endSlot / 60,
                            endSlot % 60);

                    String appointmentTime = slot;

                    int availabilityId =
                            a.getAvailabilityId();

                    boolean booked =
                            appointmentDAO.isSlotBooked(
                                    selectedDoctorId,
                                    appointmentDate,
                                    appointmentTime);
    %>

        <% if (booked) { %>

            <div class="slot booked-slot">

                <div>
                    <strong>Slot <%= slotNumber %></strong>

                    <span>
                        <%= slot %> to <%= endTime %>
                    </span>
                </div>

                <span class="booked-text">
                    Booked
                </span>

            </div>

        <% } else { %>

            <form action="<%= request.getContextPath() %>/PatientAppointmentServlet"
                  method="post"
                  class="slot-form">

                <input type="hidden"
                       name="action"
                       value="book">

                <input type="hidden"
                       name="doctorId"
                       value="<%= selectedDoctorId %>">

                <input type="hidden"
                       name="appointmentDate"
                       value="<%= appointmentDate %>">

                <input type="hidden"
                       name="appointmentTime"
                       value="<%= appointmentTime %>">

                <!-- NEW REQUIRED FIELDS -->

                <input type="hidden"
                       name="availabilityId"
                       value="<%= availabilityId %>">

                <input type="hidden"
                       name="slotNumber"
                       value="<%= slotNumber %>">

                <button type="submit"
                        class="slot available-slot">

                    <div>

                        <strong>
                            Slot <%= slotNumber %>
                        </strong>

                        <span>
                            <%= slot %> to <%= endTime %>
                        </span>

                    </div>

                    <span class="available-text">
                        Available
                    </span>

                </button>

            </form>

        <% } %>

    <%
                }

            } catch (Exception e) {

                e.printStackTrace();

            }

        }
    %>

    </div>

</section>

<%
    } else if (appointmentDate != null) {
%>

<div class="empty-message">

    No availability for the selected date.

</div>

<%
    }
%>



<!-- ================= AUTO SCROLL ================= -->

<script>

window.addEventListener("load", function() {

    var availability =
        document.getElementById("availability-section");

    var date =
        document.getElementById("date-section");

    if (availability) {

        setTimeout(function() {

            availability.scrollIntoView({
                behavior: "smooth",
                block: "start"
            });

        }, 300);

    }
    else if (date) {

        setTimeout(function() {

            date.scrollIntoView({
                behavior: "smooth",
                block: "start"
            });

        }, 300);

    }

});

</script>

</body>
</html>