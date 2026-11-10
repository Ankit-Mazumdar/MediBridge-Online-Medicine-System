
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>

<%@ page import="model.Doctor" %>
<%@ page import="model.DoctorAvailability" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");

    // Authentication check
    if (doctor == null) {
        response.sendRedirect(
            request.getContextPath() + "/login.jsp"
        );
        return;
    }

    // Availability data
    List<DoctorAvailability> availabilityList =
        (List<DoctorAvailability>) request.getAttribute("availabilityList");

    // If opened directly, load through AvailabilityServlet
    if (availabilityList == null) {
        response.sendRedirect(
            request.getContextPath() + "/AvailabilityServlet"
        );
        return;
    }

    // Messages
    String success = request.getParameter("success");
    String error = request.getParameter("error");

    // Today's date for date picker minimum
    SimpleDateFormat inputDateFormat =
        new SimpleDateFormat("yyyy-MM-dd");

    String todayDate = inputDateFormat.format(new Date());

    // Date display format
    SimpleDateFormat displayDateFormat =
        new SimpleDateFormat("EEEE, dd MMMM yyyy");

    // Doctor initials
    String initials = "DR";

    if (doctor.getFullName() != null &&
        !doctor.getFullName().trim().isEmpty()) {

        String[] parts =
            doctor.getFullName().trim().split("\\s+");

        initials = parts[0].substring(0, 1).toUpperCase();

        if (parts.length > 1) {
            initials += parts[parts.length - 1]
                .substring(0, 1).toUpperCase();
        }
    }

    // Doctor status
    String status =
        (doctor.getStatus() != null)
        ? doctor.getStatus()
        : "Pending";

    String statusClass = "status-" + status.toLowerCase();
%>


<!DOCTYPE html>

<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Availability | MediBridge</title>

    <!-- ========================================================
         FONTS
         ======================================================== -->

    <link rel="preconnect"
          href="https://fonts.googleapis.com">

    <link
        href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
        rel="stylesheet"
    >

    <!-- ========================================================
         WEBSITE CSS
         ======================================================== -->

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/style.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/dashboard.css">

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/availability.css">

    <!-- ========================================================
         DATE INPUT STYLING
         ======================================================== -->

    <style>

        .form-group input[type="date"] {
            width: 100%;
            padding: 13px 15px;
            border: 1px solid #dbe3ed;
            border-radius: 9px;
            background: #ffffff;
            color: #172b4d;
            font-family: 'Inter', sans-serif;
            font-size: 14px;
            outline: none;
            box-sizing: border-box;
        }

        .form-group input[type="date"]:focus {
            border-color: #2684ff;
            box-shadow: 0 0 0 3px rgba(38, 132, 255, 0.10);
        }

        .schedule-date {
            color: #172b4d;
            font-weight: 700;
            font-size: 15px;
        }

        .schedule-day p {
            margin-top: 6px;
        }

        button.delete-btn {
            font-family: inherit;
            cursor: pointer;
            border: none;
        }

    </style>

</head>

<body class="dash-page">

<!-- ============================================================
     HEADER
     ============================================================ -->

<header class="dash-header">

    <!-- ========================================================
         TOP ROW
         ======================================================== -->

    <div class="dash-topline">

        <!-- MEDIBRIDGE BRAND -->

        <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp"
           class="brand">

            <svg
                class="logo-mark"
                viewBox="0 0 48 48"
                xmlns="http://www.w3.org/2000/svg"
            >

                <defs>

                    <linearGradient
                        id="availabilityLogoGrad"
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
                    fill="url(#availabilityLogoGrad)"
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

        <!-- DOCTOR INFORMATION -->

        <div class="dash-user">

            <div class="dash-user-info">

                <strong>
                    Dr. <%= doctor.getFullName() %>
                </strong>

                <span class="status-badge <%= statusClass %>">
                    <%= status %>
                </span>

            </div>

            <!-- DOCTOR AVATAR -->

            <a
                href="${pageContext.request.contextPath}/doctor/profile.jsp"
                class="dash-avatar"
                title="View Profile"
            >

                <%= initials %>

            </a>

        </div>

    </div>

    <!-- ========================================================
         NAVIGATION
         ======================================================== -->

    <nav class="dash-nav">

        <a href="${pageContext.request.contextPath}/doctor/dashboard.jsp">
            Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/doctor/appointments.jsp">
            Appointments
        </a>

        <a href="${pageContext.request.contextPath}/doctor/patients.jsp">
            Patients
        </a>

        <a href="${pageContext.request.contextPath}/AvailabilityServlet"
           class="active">
            Availability
        </a>

        <a href="${pageContext.request.contextPath}/doctor/prescriptions.jsp">
            Prescriptions
        </a>

        <a href="${pageContext.request.contextPath}/doctor/profile.jsp">
            Profile
        </a>

        <a
            href="${pageContext.request.contextPath}/DoctorLogoutServlet"
            class="dash-logout"
        >
            Logout
        </a>

    </nav>

</header>

<!-- ============================================================
     MAIN CONTENT
     ============================================================ -->

<main class="availability-container">

    <!-- ========================================================
         PAGE HEADING
         ======================================================== -->

    <div class="page-heading">

        <div>

            <h1>
                Manage Availability
            </h1>

            <p>
                Select specific dates and times when you are available
                for consultations.
            </p>

        </div>

        <div class="heading-icon">
            Calendar
        </div>

    </div>

    <!-- ========================================================
         SUCCESS MESSAGE
         ======================================================== -->

    <% if (success != null) { %>

        <div class="message success-message">
            Success:
            <%= success %>
        </div>

    <% } %>

    <!-- ========================================================
         ERROR MESSAGE
         ======================================================== -->

    <% if (error != null) { %>

        <div class="message error-message">
            Error:
            <%= error %>
        </div>

    <% } %>

    <!-- ========================================================
         CONTENT GRID
         ======================================================== -->

    <div class="content-grid">

        <!-- ====================================================
             ADD AVAILABILITY
             ==================================================== -->

        <section class="availability-card">

            <!-- CARD HEADER -->

            <div class="card-header">

                <div>

                    <h2>
                        Add Availability
                    </h2>

                    <p>
                        Create a consultation schedule for a specific date.
                    </p>

                </div>

                <div class="card-icon blue-icon">
                    +
                </div>

            </div>

            <!-- =================================================
                 AVAILABILITY FORM
                 ================================================= -->

            <form
                action="${pageContext.request.contextPath}/AvailabilityServlet"
                method="post"
            >

                <input type="hidden"
                       name="action"
                       value="add">

                <!-- AVAILABLE DATE -->

                <div class="form-group">

                    <label for="availabilityDate">
                        Available Date
                    </label>

                    <input
                        type="date"
                        id="availabilityDate"
                        name="availabilityDate"
                        min="<%= todayDate %>"
                        required
                    >

                    <small>
                        Select the exact date when you are available.
                    </small>

                </div>

                <!-- TIME ROW -->

                <div class="time-row">

                    <!-- START TIME -->

                    <div class="form-group">

                        <label for="startTime">
                            Start Time
                        </label>

                        <input
                            type="time"
                            id="startTime"
                            name="startTime"
                            required
                        >

                    </div>

                    <!-- END TIME -->

                    <div class="form-group">

                        <label for="endTime">
                            End Time
                        </label>

                        <input
                            type="time"
                            id="endTime"
                            name="endTime"
                            required
                        >

                    </div>

                </div>

                <!-- CONSULTATION DURATION -->

                <div class="form-group">

                    <label for="slotDuration">
                        Consultation Duration
                    </label>

                    <select
                        id="slotDuration"
                        name="slotDuration"
                        required
                    >

                        <option value="">
                            Select duration
                        </option>

                        <option value="15">
                            15 Minutes
                        </option>

                        <option value="30">
                            30 Minutes
                        </option>

                        <option value="60">
                            60 Minutes
                        </option>

                    </select>

                    <small>
                        Each consultation will use this amount of time.
                    </small>

                </div>

                <!-- SAVE BUTTON -->

                <button
                    type="submit"
                    class="save-btn"
                >
                    Save Availability
                </button>

            </form>

        </section>

        <!-- ====================================================
             EXISTING AVAILABILITY
             ==================================================== -->

        <section class="availability-card">

            <!-- CARD HEADER -->

            <div class="card-header">

                <div>

                    <h2>
                        Your Schedule
                    </h2>

                    <p>
                        Your upcoming consultation availability.
                    </p>

                </div>

                <div class="card-icon teal-icon">
                    OK
                </div>

            </div>

            <!-- =================================================
                 NO AVAILABILITY
                 ================================================= -->

            <% if (availabilityList == null ||
                   availabilityList.isEmpty()) { %>

                <div class="empty-state">

                    <div class="empty-icon">
                        Calendar
                    </div>

                    <h3>
                        No availability added
                    </h3>

                    <p>
                        Add your first consultation schedule
                        using the form.
                    </p>

                </div>

            <% } else { %>

                <!-- =================================================
                     AVAILABILITY LIST
                     ================================================= -->

                <div class="schedule-list">

                    <% for (DoctorAvailability availability :
                           availabilityList) { %>

                        <div class="schedule-item">

                            <!-- DATE AND TIME -->

                            <div class="schedule-day">

                                <span class="day-dot"></span>

                                <div>

                                    <h3 class="schedule-date">

                                        <%= displayDateFormat.format(
                                                availability.getAvailabilityDate()
                                           ) %>

                                    </h3>

                                    <p>

                                        <%= availability.getStartTime() %>

                                        -

                                        <%= availability.getEndTime() %>

                                    </p>

                                </div>

                            </div>

                            <!-- DURATION AND DELETE -->

                            <div class="schedule-details">

                                <span class="duration-badge">

                                    <%= availability.getSlotDuration() %>
                                    min

                                </span>

                                <form
                                    action="${pageContext.request.contextPath}/AvailabilityServlet"
                                    method="post"
                                    onsubmit="return confirm('Are you sure you want to delete this availability?');"
                                    style="margin: 0;"
                                >

                                    <input
                                        type="hidden"
                                        name="action"
                                        value="delete"
                                    >

                                    <input
                                        type="hidden"
                                        name="id"
                                        value="<%= availability.getAvailabilityId() %>"
                                    >

                                    <button
                                        type="submit"
                                        class="delete-btn"
                                    >
                                        Delete
                                    </button>

                                </form>

                            </div>

                        </div>

                    <% } %>

                </div>

            <% } %>

        </section>

    </div>

</main>

</body>

</html>