
<%@ page import="model.Doctor" %>
<%@ page import="java.text.SimpleDateFormat" %>

<%@ page contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%
    Doctor doctor = (Doctor) request.getAttribute("doctorProfile");

    if (doctor == null) {
        response.sendRedirect(
            request.getContextPath() + "/DoctorProfileServlet");
        return;
    }

    String context = request.getContextPath();

    String initials = "DR";

    if (doctor.getFullName() != null &&
        !doctor.getFullName().trim().isEmpty()) {

        String[] parts = doctor.getFullName().trim().split("\\s+");

        initials = parts[0].substring(0, 1).toUpperCase();

        if (parts.length > 1) {
            initials += parts[parts.length - 1]
                    .substring(0, 1).toUpperCase();
        }
    }

    String fees = doctor.getConsultationFees() == null
            || doctor.getConsultationFees() <= 0
            ? "" : String.valueOf(doctor.getConsultationFees());

    String createdDate = "Not available";

    if (doctor.getCreatedAt() != null) {
        createdDate = new SimpleDateFormat("dd MMM yyyy")
                .format(doctor.getCreatedAt());
    }

    String status = doctor.getStatus() == null
            ? "Unknown" : doctor.getStatus();

    String success = request.getParameter("success");
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Doctor Profile | MediBridge</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <link rel="stylesheet" href="<%= context %>/css/style.css">

    <link rel="stylesheet" href="<%= context %>/css/doctor-profile.css">

</head>

<body class="profile-page">


<header class="profile-header">

    <a href="<%= context %>/doctor/dashboard.jsp"
       class="profile-brand">

        <span class="brand-icon">M</span>
        <span>MediBridge</span>

    </a>

    <nav class="profile-nav">

        <a href="<%= context %>/doctor/dashboard.jsp">
            Dashboard
        </a>

        <a href="<%= context %>/doctor/appointments.jsp">
            Appointments
        </a>

        <a href="<%= context %>/DoctorProfileServlet"
           class="active">
            Profile
        </a>

        <a href="<%= context %>/DoctorLogoutServlet"
           class="logout-link">
            Logout
        </a>

    </nav>

</header>



<main class="profile-container">

    <div class="profile-heading">

        <div>
            <span class="eyebrow">ACCOUNT SETTINGS</span>

            <h1>My Profile</h1>

            <p>Manage your professional information and account settings.</p>
        </div>

<a href="<%= context %>/doctor/dashboard.jsp" class="back-btn">
    ← Dashboard
</a>

    </div>


    <% if ("password".equals(success)) { %>

        <div class="alert success">
            Password updated successfully.
        </div>

    <% } else if ("fees".equals(success)) { %>

        <div class="alert success">
            Consultation fees updated successfully.
        </div>

    <% } %>


    <% if (error != null) { %>

        <div class="alert error">

            <% if ("empty".equals(error)) { %>
                Please fill in all password fields.

            <% } else if ("weak".equals(error)) { %>
                Password must contain at least 8 characters.

            <% } else if ("mismatch".equals(error)) { %>
                New password and confirmation do not match.

            <% } else if ("incorrect".equals(error)) { %>
                Your current password is incorrect.

            <% } else if ("fees".equals(error)) { %>
                Please enter valid consultation fees.

            <% } else if ("updatefees".equals(error)) { %>
                Unable to update consultation fees. Please try again.

            <% } %>

        </div>

    <% } %>


    <!-- PROFILE OVERVIEW -->

    <section class="profile-hero">

        <div class="doctor-avatar">
            <%= initials %>
        </div>

        <div class="hero-info">

            <span class="doctor-label">MEDIBRIDGE DOCTOR</span>

            <h2>Dr. <%= doctor.getFullName() %></h2>

            <p><%= doctor.getEmail() %></p>

            <span class="profile-status">
                <%= status %>
            </span>

        </div>

        <div class="doctor-id">

            <span>DOCTOR ID</span>

            <strong><%= doctor.getDoctorId() %></strong>

        </div>

    </section>


    <!-- PERSONAL DETAILS -->

    <section class="profile-card">

        <div class="section-heading">

            <div>
                <h2>Personal Information</h2>
                <p>Your registered personal details.</p>
            </div>

            <span class="read-only">READ ONLY</span>

        </div>

        <div class="details-grid">

            <div class="detail-item">
                <label>Full Name</label>
                <strong><%= doctor.getFullName() %></strong>
            </div>

            <div class="detail-item">
                <label>Email Address</label>
                <strong><%= doctor.getEmail() %></strong>
            </div>

            <div class="detail-item">
                <label>Phone Number</label>
                <strong><%= doctor.getPhone() %></strong>
            </div>

            <div class="detail-item">
                <label>Gender</label>
                <strong><%= doctor.getGender() == null
                        ? "Not provided" : doctor.getGender() %></strong>
            </div>

        </div>

    </section>


    <!-- PROFESSIONAL DETAILS -->

    <section class="profile-card">

        <div class="section-heading">

            <div>
                <h2>Professional Information</h2>
                <p>Information submitted during doctor registration.</p>
            </div>

            <span class="read-only">VERIFIED DETAILS</span>

        </div>

        <div class="details-grid">

            <div class="detail-item">
                <label>Specialization</label>
                <strong><%= doctor.getSpecialization() %></strong>
            </div>

            <div class="detail-item">
                <label>Qualification</label>
                <strong><%= doctor.getQualification() == null
                        ? "Not provided" : doctor.getQualification() %></strong>
            </div>

            <div class="detail-item">
                <label>Medical Registration Number</label>
                <strong><%= doctor.getMedicalRegistrationNo() %></strong>
            </div>

            <div class="detail-item">
                <label>Experience</label>
                <strong><%= doctor.getExperience() == null
                        ? "Not provided"
                        : doctor.getExperience() + " Years" %></strong>
            </div>

            <div class="detail-item">
                <label>Registration Date</label>
                <strong><%= createdDate %></strong>
            </div>

            <div class="detail-item">
                <label>Account Status</label>
                <strong><%= status %></strong>
            </div>

        </div>

    </section>


    <!-- CONSULTATION FEES -->

    <section class="profile-card">

        <div class="section-heading">

            <div>
                <h2>Consultation Fees</h2>
                <p>Set the amount patients pay for your consultation.</p>
            </div>

            <span class="editable">EDITABLE</span>

        </div>

        <form action="<%= context %>/DoctorUpdateFeesServlet"
              method="post"
              class="profile-form">

            <div class="form-group">

                <label for="consultationFees">
                    Consultation Fees (₹)
                </label>

                <div class="fee-input">

                    <span>₹</span>

                    <input type="number"
                           id="consultationFees"
                           name="consultationFees"
                           min="0.01"
                           max="1000000"
                           step="0.01"
                           value="<%= fees %>"
                           placeholder="Enter your consultation fees"
                           required>

                </div>

                <small>Enter your consultation charge in Indian Rupees.</small>

            </div>

            <button type="submit" class="primary-btn">
                Save Consultation Fees
            </button>

        </form>

    </section>


    <!-- CHANGE PASSWORD -->

    <section class="profile-card">

        <div class="section-heading">

            <div>
                <h2>Change Password</h2>
                <p>Update your account password securely.</p>
            </div>

            <span class="editable">EDITABLE</span>

        </div>

        <form action="<%= context %>/DoctorChangePasswordServlet"
              method="post"
              class="profile-form">

            <div class="form-group">

                <label for="currentPassword">
                    Current Password
                </label>

                <input type="password"
                       id="currentPassword"
                       name="currentPassword"
                       placeholder="Enter current password"
                       autocomplete="current-password"
                       required>

            </div>

            <div class="details-grid">

                <div class="form-group">

                    <label for="newPassword">
                        New Password
                    </label>

                    <input type="password"
                           id="newPassword"
                           name="newPassword"
                           minlength="8"
                           placeholder="Minimum 8 characters"
                           autocomplete="new-password"
                           required>

                </div>

                <div class="form-group">

                    <label for="confirmPassword">
                        Confirm New Password
                    </label>

                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           minlength="8"
                           placeholder="Confirm new password"
                           autocomplete="new-password"
                           required>

                </div>

            </div>

            <button type="submit" class="primary-btn">
                Update Password
            </button>

        </form>

    </section>


    <footer class="profile-footer">
        © 2026 MediBridge. All rights reserved.
    </footer>

</main>

</body>
</html>
