
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="admin.Admin" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp#admin");
        return;
    }

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String adminName = admin.getFullName();
    String adminEmail = admin.getEmail();

    String initials = "A";

    if (adminName != null && !adminName.trim().isEmpty()) {
        String[] parts = adminName.trim().split("\\s+");

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

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Admin Profile | MediBridge</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: #f3f6fb;
            color: #172b4d;
        }

        /* NAVBAR */

        .navbar {
            background: linear-gradient(120deg, #0a2540, #123b59);
            color: white;
            padding: 20px 6%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            font-family: 'Manrope', sans-serif;
            font-size: 23px;
            font-weight: 800;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .navbar a:hover {
            color: #8ff2df;
        }

        /* CONTAINER */

        .container {
            max-width: 780px;
            margin: 45px auto;
            padding: 0 20px;
        }

        .profile-card {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 32px;
            box-shadow: 0 4px 18px rgba(15, 23, 42, 0.05);
        }

        /* PROFILE HEADER */

        .profile-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 28px;
        }

        .avatar {
            width: 76px;
            height: 76px;
            flex-shrink: 0;
            border-radius: 50%;
            background: #dff7f5;
            color: #087e8b;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 25px;
            font-weight: 800;
        }

        h1 {
            font-family: 'Manrope', sans-serif;
            margin: 0 0 7px;
            font-size: 25px;
        }

        .subtitle {
            color: #64748b;
            margin: 0;
            font-size: 13px;
        }

        .role {
            display: inline-block;
            margin-top: 10px;
            background: #e0f7f3;
            color: #087e8b;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: 700;
        }

        /* DETAILS */

        .section-title {
            font-family: 'Manrope', sans-serif;
            font-size: 17px;
            margin: 0 0 18px;
        }

        .detail {
            padding: 17px 0;
            border-top: 1px solid #e8edf4;
        }

        .label {
            display: block;
            color: #64748b;
            font-size: 12px;
            margin-bottom: 8px;
        }

        .value {
            font-weight: 700;
            font-size: 14px;
            overflow-wrap: anywhere;
        }

        /* MESSAGES */

        .success-message {
            padding: 13px 15px;
            border-radius: 8px;
            background: #e6f8f2;
            color: #087e65;
            border: 1px solid #b5ead9;
            margin-bottom: 20px;
            font-size: 13px;
        }

        .error-message {
            padding: 13px 15px;
            border-radius: 8px;
            background: #fff0f0;
            color: #dc2626;
            border: 1px solid #fecaca;
            margin-bottom: 20px;
            font-size: 13px;
        }

        /* PASSWORD FORM */

        .security-section {
            border-top: 1px solid #e8edf4;
            margin-top: 15px;
            padding-top: 25px;
        }

        .security-description {
            color: #64748b;
            font-size: 13px;
            line-height: 1.6;
            margin-bottom: 22px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            font-size: 13px;
            font-weight: 600;
            margin-bottom: 8px;
        }

        .form-group input {
            width: 100%;
            padding: 13px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            font-size: 14px;
            outline: none;
            font-family: 'Inter', sans-serif;
        }

        .form-group input:focus {
            border-color: #087e8b;
            box-shadow: 0 0 0 3px rgba(8, 126, 139, 0.1);
        }

        /* BUTTONS */

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        .btn {
            display: inline-block;
            padding: 12px 18px;
            border-radius: 8px;
            text-decoration: none;
            font-weight: 700;
            font-size: 13px;
            border: none;
            cursor: pointer;
        }

        .btn-primary {
            background: #087e8b;
            color: white;
        }

        .btn-primary:hover {
            background: #066874;
        }

        .btn-danger {
            background: #fff0f0;
            color: #dc2626;
        }

        .btn-danger:hover {
            background: #fee2e2;
        }

        @media (max-width: 500px) {

            .profile-card {
                padding: 22px;
            }

            .container {
                margin-top: 25px;
            }

            .profile-header {
                align-items: flex-start;
            }

            h1 {
                font-size: 21px;
            }
        }

    </style>

</head>


<body>

    <!-- NAVBAR -->

    <div class="navbar">

        <div class="brand">
            MediBridge
        </div>

        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
            &larr; Dashboard
        </a>

    </div>


    <!-- PROFILE CONTENT -->

    <div class="container">

        <div class="profile-card">


            <!-- SUCCESS MESSAGE -->

            <% if (request.getAttribute("success") != null) { %>

                <div class="success-message">
                    <%= request.getAttribute("success") %>
                </div>

            <% } %>


            <!-- ERROR MESSAGE -->

            <% if (request.getAttribute("error") != null) { %>

                <div class="error-message">
                    <%= request.getAttribute("error") %>
                </div>

            <% } %>


            <!-- PROFILE HEADER -->

            <div class="profile-header">

                <div class="avatar">
                    <%= initials %>
                </div>

                <div>

                    <h1>Admin Profile</h1>

                    <p class="subtitle">
                        <%= adminName != null ? adminName : "Administrator" %>
                    </p>

                    <span class="role">
                        Administrator Account
                    </span>

                </div>

            </div>


            <!-- ACCOUNT INFORMATION -->

            <h2 class="section-title">
                Account Information
            </h2>


            <div class="detail">

                <span class="label">
                    Full Name
                </span>

                <span class="value">
                    <%= adminName != null ? adminName : "Not available" %>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Email Address
                </span>

                <span class="value">
                    <%= adminEmail != null ? adminEmail : "Not available" %>
                </span>

            </div>


            <div class="detail">

                <span class="label">
                    Role
                </span>

                <span class="value">
                    Administrator
                </span>

            </div>


            <!-- CHANGE PASSWORD -->

            <div class="security-section">

                <h2 class="section-title">
                    Change Password
                </h2>

                <p class="security-description">
                    Update your administrator account password.
                    Enter your current password and choose a new one.
                </p>


                <form action="<%= request.getContextPath() %>/admin/change-password"
                      method="post">

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


                    <div class="form-group">

                        <label for="newPassword">
                            New Password
                        </label>

                        <input type="password"
                               id="newPassword"
                               name="newPassword"
                               placeholder="Enter new password"
                               minlength="6"
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
                               placeholder="Confirm new password"
                               minlength="6"
                               autocomplete="new-password"
                               required>

                    </div>


                    <button type="submit" class="btn btn-primary">
                        Update Password
                    </button>

                </form>

            </div>


            <!-- ACTIONS -->

            <div class="actions">

                <a class="btn btn-primary"
                   href="<%= request.getContextPath() %>/admin/dashboard.jsp">

                    Back to Dashboard

                </a>


                <form action="<%= request.getContextPath() %>/admin/logout"
                      method="post"
                      style="margin:0;">

                    <button class="btn btn-danger" type="submit">
                        Logout
                    </button>

                </form>

            </div>


        </div>

    </div>

</body>
</html>
