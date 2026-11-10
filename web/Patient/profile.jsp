
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@ page import="model.PatientBean" %>

<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/Patient/PatientLogin.jsp");
        return;
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String patientName = patient.getName();
    String patientEmail = patient.getEmail();

    String initials = "PT";

    if (patientName != null && !patientName.trim().isEmpty()) {
        String[] parts = patientName.trim().split("\\s+");

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

    <title>My Profile | MediBridge</title>

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

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f3f6fb;
            color: #172b4d;
            font-family: 'Inter', sans-serif;
        }

        .profile-content {
            max-width: 900px;
            margin: auto;
            padding: 45px 20px 65px;
        }

        .profile-heading {
            margin-bottom: 28px;
        }

        .profile-heading span {
            color: #087e8b;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 1.5px;
        }

        .profile-heading h1 {
            font-family: 'Manrope', sans-serif;
            font-size: 30px;
            margin: 9px 0;
            color: #102a43;
        }

        .profile-heading p {
            color: #64748b;
            font-size: 14px;
        }

        .profile-hero {
            background: linear-gradient(120deg, #0a2540, #15516a);
            border-radius: 15px;
            padding: 30px;
            display: flex;
            align-items: center;
            gap: 22px;
            color: white;
            margin-bottom: 25px;
            box-shadow: 0 5px 18px rgba(15,23,42,.08);
        }

        .profile-hero-avatar {
            width: 82px;
            height: 82px;
            border-radius: 50%;
            background: #dff7f5;
            color: #087e8b;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 25px;
            font-weight: 800;
            flex-shrink: 0;
        }

        .profile-hero-info h2 {
            font-family: 'Manrope', sans-serif;
            font-size: 22px;
            margin: 0 0 7px;
        }

        .profile-hero-info p {
            color: #c8dce8;
            font-size: 14px;
            margin: 0 0 12px;
        }

        .profile-role {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 20px;
            background: rgba(39,197,181,.17);
            color: #8ff2df;
            font-size: 11px;
            font-weight: 700;
        }

        .profile-panel {
            background: white;
            border: 1px solid #e5eaf1;
            border-radius: 13px;
            padding: 27px 30px;
            margin-bottom: 23px;
            box-shadow: 0 3px 14px rgba(15,23,42,.035);
        }

        .profile-panel-heading {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 25px;
        }

        .profile-section-icon {
            width: 43px;
            height: 43px;
            border-radius: 11px;
            background: #e7f2ff;
            color: #2563a6;
            display: flex;
            justify-content: center;
            align-items: center;
            font-size: 17px;
            font-weight: 800;
        }

        .profile-panel-heading h2 {
            font-family: 'Manrope', sans-serif;
            font-size: 17px;
            margin: 0 0 5px;
        }

        .profile-panel-heading p {
            font-size: 12px;
            color: #64748b;
            margin: 0;
        }

        .profile-info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .profile-info-item {
            padding: 16px;
            background: #f8fafc;
            border: 1px solid #edf1f6;
            border-radius: 9px;
            min-width: 0;
        }

        .profile-info-item span {
            display: block;
            color: #64748b;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .profile-info-item strong {
            display: block;
            font-size: 14px;
            color: #172b4d;
            overflow-wrap: anywhere;
        }

        .profile-actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 15px;
            margin-top: 28px;
        }

        .edit-profile-btn {
            display: inline-block;
            padding: 13px 22px;
            background: #087e8b;
            color: white;
            border-radius: 8px;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            transition: .2s;
        }

        .edit-profile-btn:hover {
            background: #066874;
        }

        .back-dashboard {
            color: #087e8b;
            font-size: 13px;
            font-weight: 700;
            text-decoration: none;
        }

        @media(max-width:650px) {

            .profile-info-grid {
                grid-template-columns: 1fr;
                gap: 13px;
            }

            .profile-panel {
                padding: 22px;
            }

            .profile-hero {
                padding: 22px;
            }

        }

        @media(max-width:420px) {

            .profile-hero {
                align-items: flex-start;
                flex-direction: column;
            }

            .profile-actions {
                align-items: flex-start;
                flex-direction: column;
            }

        }

    </style>

</head>

<body class="patient-profile-page">

<header class="patient-profile-header">

    <div class="patient-profile-topline">

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
           class="brand">

            <svg class="logo-mark"
                 viewBox="0 0 48 48"
                 xmlns="http://www.w3.org/2000/svg">

                <defs>
                    <linearGradient id="profileLogoGrad"
                                    x1="0" y1="0" x2="1" y2="1">
                        <stop offset="0%" stop-color="#ffffff"/>
                        <stop offset="100%" stop-color="#c9f7f5"/>
                    </linearGradient>
                </defs>

                <circle cx="24" cy="24" r="22"
                        fill="url(#profileLogoGrad)"/>

                <path d="M8 24 H16 L19 15 L24 33 L28 24 H40"
                      fill="none"
                      stroke="#0a2540"
                      stroke-width="2.6"
                      stroke-linecap="round"
                      stroke-linejoin="round"/>

            </svg>

            <span class="brand-name">MediBridge</span>

        </a>

        <div class="patient-profile-user">

            <div class="patient-profile-user-info">

                <strong><%= patientName %></strong>

                <span>Patient</span>

            </div>

            <div class="patient-profile-avatar">
                <%= initials %>
            </div>

        </div>

    </div>

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


<main class="profile-content">

    <div class="profile-heading">

        <span>ACCOUNT SETTINGS</span>

        <h1>My Profile</h1>

        <p>
            View your personal information and manage your patient account.
        </p>

    </div>


    <!-- PROFILE HERO -->

    <section class="profile-hero">

        <div class="profile-hero-avatar">
            <%= initials %>
        </div>

        <div class="profile-hero-info">

            <h2><%= patientName %></h2>

            <p><%= patientEmail %></p>

            <span class="profile-role">
                Patient Account
            </span>

        </div>

    </section>


    <!-- PERSONAL INFORMATION -->

    <section class="profile-panel">

        <div class="profile-panel-heading">

            <div class="profile-section-icon">
                P
            </div>

            <div>

                <h2>Personal Information</h2>

                <p>Your registered patient details</p>

            </div>

        </div>


        <div class="profile-info-grid">

            <div class="profile-info-item">
                <span>Full Name</span>
                <strong>
                    <%= patientName != null ? patientName : "Not available" %>
                </strong>
            </div>

            <div class="profile-info-item">
                <span>Email Address</span>
                <strong>
                    <%= patientEmail != null ? patientEmail : "Not available" %>
                </strong>
            </div>

            <div class="profile-info-item">
                <span>Contact Number</span>
                <strong>
                    <%= patient.getContact() != null
                            ? patient.getContact() : "Not provided" %>
                </strong>
            </div>

            <div class="profile-info-item">
                <span>Date of Birth</span>
                <strong>
                    <%= patient.getDob() != null
                            ? patient.getDob() : "Not provided" %>
                </strong>
            </div>

            <div class="profile-info-item">
                <span>Gender</span>
                <strong>
                    <%= patient.getGender() != null
                            ? patient.getGender() : "Not provided" %>
                </strong>
            </div>

            <div class="profile-info-item">
                <span>Blood Group</span>
                <strong>
                    <%= patient.getBloodGroup() != null
                            ? patient.getBloodGroup() : "Not provided" %>
                </strong>
            </div>

            <div class="profile-info-item">
                <span>Address</span>
                <strong>
                    <%= patient.getAddress() != null &&
                        !patient.getAddress().trim().isEmpty()
                            ? patient.getAddress() : "Not provided" %>
                </strong>
            </div>

        </div>

    </section>


    <!-- ACTIONS -->

    <div class="profile-actions">

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
           class="back-dashboard">
            &larr; Back to Dashboard
        </a>

        <a href="<%= request.getContextPath() %>/Patient/EditProfile.jsp"
           class="edit-profile-btn">
            Edit Profile
        </a>

    </div>

</main>

</body>
</html>
