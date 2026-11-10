<%@ page import="model.PatientBean" %>

<%
    PatientBean patient = (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect("PatientLogin.jsp");
        return;
    }

    String initials = "PT";

    if (patient.getName() != null &&
        !patient.getName().trim().isEmpty()) {

        String[] parts = patient.getName().trim().split("\\s+");

        initials = parts[0].substring(0, 1).toUpperCase();

        if (parts.length > 1) {
            initials += parts[parts.length - 1]
                    .substring(0, 1).toUpperCase();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <title>Change Password | MediBridge</title>

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

</head>


<body class="patient-profile-page">


<header class="patient-profile-header">

    <div class="patient-profile-topline">

        <a href="PatientDashboard.jsp"
           class="brand">

            <svg class="logo-mark"
                 viewBox="0 0 48 48"
                 xmlns="http://www.w3.org/2000/svg">

                <defs>

                    <linearGradient id="profileLogoGrad"
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
                        fill="url(#profileLogoGrad)"/>

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


    <nav class="patient-profile-nav">

        <a href="PatientDashboard.jsp">
            Dashboard
        </a>

        <a href="appointments.jsp">
            Appointments
        </a>

        <a href="doctors.jsp">
            Doctors
        </a>

        <a href="prescriptions.jsp">
            Prescriptions
        </a>

        <a href="medicalRecords.jsp">
            Medical Records
        </a>

        <a href="profile.jsp"
           class="active">
            Profile
        </a>

        <a href="../PatientLogoutServlet"
           class="patient-profile-logout">
            Logout
        </a>

    </nav>

</header>



<main class="patient-profile-main">

    <div class="patient-profile-container">


        <div class="patient-profile-heading">

            <span>
                ACCOUNT SECURITY
            </span>

            <h1>
                Change Password
            </h1>

            <p>
                Update your account password securely.
            </p>

        </div>


        <%
            String error = request.getParameter("error");

            if ("wrong".equals(error)) {
        %>

        <div class="error-message">
            Current password is incorrect.
        </div>

        <%
            } else if ("mismatch".equals(error)) {
        %>

        <div class="error-message">
            New password and confirm password do not match.
        </div>

        <%
            } else if ("failed".equals(error)) {
        %>

        <div class="error-message">
            Password could not be changed. Please try again.
        </div>

        <%
            }
        %>



        <section class="profile-panel">

            <div class="profile-panel-heading">

                <div class="profile-section-icon security">
                    S
                </div>

                <div>

                    <h2>
                        Change Password
                    </h2>

                    <p>
                        Enter your current password and choose a new one.
                    </p>

                </div>

            </div>


            <form action="<%= request.getContextPath() %>/ChangePasswordServlet"
                method="post"
                class="edit-profile-form">


                <div class="form-group full-width">

                    <label>
                        Current Password
                    </label>

                    <input type="password"
                           name="currentPassword"
                           required>

                </div>


                <div class="form-group">

                    <label>
                        New Password
                    </label>

                    <input type="password"
                           name="newPassword"
                           required>

                </div>


                <div class="form-group">

                    <label>
                        Confirm New Password
                    </label>

                    <input type="password"
                           name="confirmPassword"
                           required>

                </div>


                <div class="edit-profile-actions">

                    <a href="<%= request.getContextPath() %>/Patient/profile.jsp"
                        class="cancel-profile-button">
                         Cancel
                     </a>

                    <button type="submit"
                            class="save-profile-button">
                        Change Password
                    </button>

                </div>


            </form>

        </section>


        <div class="profile-actions">

            <a href="<%= request.getContextPath() %>/Patient/profile.jsp"
                class="back-dashboard">
                 &larr; Back to Profile
             </a>

        </div>


    </div>

</main>


</body>
</html>