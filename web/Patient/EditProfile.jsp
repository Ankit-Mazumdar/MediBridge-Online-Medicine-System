<%@page import="model.PatientBean"%>

<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/Patient/PatientLogin.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Edit Profile | MediBridge</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/PatientProfile.css">

</head>

<body class="patient-profile-page">

<header class="patient-profile-header">

    <div class="patient-profile-topline">

        <!-- Brand -->

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
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


        <!-- Patient -->

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

                <%
                    String initials = "PT";

                    if (patient.getName() != null &&
                        !patient.getName().trim().isEmpty()) {

                        String[] parts =
                                patient.getName()
                                       .trim()
                                       .split("\\s+");

                        initials =
                                parts[0]
                                .substring(0, 1)
                                .toUpperCase();

                        if (parts.length > 1) {

                            initials +=
                                    parts[parts.length - 1]
                                    .substring(0, 1)
                                    .toUpperCase();
                        }
                    }
                %>

                <%= initials %>

            </div>

        </div>

    </div>


    <!-- Navigation -->

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


<main class="patient-profile-main">

    <div class="patient-profile-container">

        <div class="patient-profile-heading">

            <span>
                ACCOUNT
            </span>

            <h1>
                Edit Profile
            </h1>

            <p>
                Update your personal and health information.
            </p>

        </div>


        <section class="profile-panel">

            <div class="profile-panel-heading">

                <div class="profile-section-icon">
                    P
                </div>

                <div>

                    <h2>
                        Personal Information
                    </h2>

                    <p>
                        Update your account details
                    </p>

                </div>

            </div>


            <%
                if ("failed".equals(
                        request.getParameter("error"))) {
            %>

            <div class="error-message">
                Unable to update your profile. Please try again.
            </div>

            <%
                }

                if ("invalid".equals(
                        request.getParameter("error"))) {
            %>

            <div class="error-message">
                Please enter valid information.
            </div>

            <%
                }
            %>


            <form action="<%= request.getContextPath() %>/EditProfileServlet"
                  method="post"
                  class="edit-profile-form">


                <div class="form-group">

                    <label>Full Name</label>

                    <input type="text"
                           name="name"
                           value="<%= patient.getName() != null
                                   ? patient.getName() : "" %>"
                           required>

                </div>


                <div class="form-group">

                    <label>Email Address</label>

                    <input type="email"
                           value="<%= patient.getEmail() %>"
                           disabled>

                    <small>
                        Email address cannot be changed.
                    </small>

                </div>


                <div class="form-group">

                    <label>Contact Number</label>

                    <input type="text"
                           name="contact"
                           value="<%= patient.getContact() != null
                                   ? patient.getContact() : "" %>"
                           required>

                </div>


                <div class="form-group">

                    <label>Date of Birth</label>

                    <input type="date"
                           name="dob"
                           value="<%= patient.getDob() != null
                                   ? patient.getDob() : "" %>">

                </div>


                <div class="form-group">

                    <label>Gender</label>

                    <select name="gender">

                        <option value="">
                            Select Gender
                        </option>

                        <option value="Male"
                            <%= "Male".equals(patient.getGender())
                                ? "selected" : "" %>>
                            Male
                        </option>

                        <option value="Female"
                            <%= "Female".equals(patient.getGender())
                                ? "selected" : "" %>>
                            Female
                        </option>

                        <option value="Other"
                            <%= "Other".equals(patient.getGender())
                                ? "selected" : "" %>>
                            Other
                        </option>

                    </select>

                </div>


                <div class="form-group">

                    <label>Blood Group</label>

                    <select name="bloodGroup">

                        <option value="">
                            Select Blood Group
                        </option>

                        <option value="A+"
                            <%= "A+".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            A+
                        </option>

                        <option value="A-"
                            <%= "A-".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            A-
                        </option>

                        <option value="B+"
                            <%= "B+".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            B+
                        </option>

                        <option value="B-"
                            <%= "B-".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            B-
                        </option>

                        <option value="AB+"
                            <%= "AB+".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            AB+
                        </option>

                        <option value="AB-"
                            <%= "AB-".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            AB-
                        </option>

                        <option value="O+"
                            <%= "O+".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            O+
                        </option>

                        <option value="O-"
                            <%= "O-".equals(patient.getBloodGroup())
                                ? "selected" : "" %>>
                            O-
                        </option>

                    </select>

                </div>


                <div class="form-group full-width">

                    <label>Address</label>

                    <textarea name="address"
                              rows="4"><%= patient.getAddress() != null
                                      ? patient.getAddress() : "" %></textarea>

                </div>


                <div class="edit-profile-actions">

                    <a href="<%= request.getContextPath() %>/Patient/profile.jsp"
                       class="cancel-profile-button">
                        Cancel
                    </a>

                    <button type="submit"
                            class="save-profile-button">
                        Save Changes
                    </button>

                </div>

            </form>

        </section>


        <a href="<%= request.getContextPath() %>/Patient/profile.jsp"
           class="back-dashboard">
            &larr; Back to Profile
        </a>

    </div>

</main>

</body>
</html>