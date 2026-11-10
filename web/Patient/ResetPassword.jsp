<%-- 
    Document   : ResetPassword
    Created on : 4 Sep, 2026, 10:17:42 AM
    Author     : ankit
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset Password | MediBridge</title>

    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/logins.css">
    <link rel="stylesheet" href="../css/ForgotPassword.css">
</head>

<body>

<div class="auth-page">

    <a href="PatientLogin.jsp" class="auth-back">
        ← Back to Login
    </a>

    <div class="auth-shell">

        <div class="auth-brand">

            <div class="brand">

                <svg class="logo-mark" viewBox="0 0 42 42"
                     fill="none"
                     xmlns="http://www.w3.org/2000/svg">

                    <rect width="42" height="42" rx="13"
                          fill="url(#logoGradient)"/>

                    <path d="M8 22H13L16 15L20 29L24 19L27 24H34"
                          stroke="white"
                          stroke-width="2.5"
                          stroke-linecap="round"
                          stroke-linejoin="round"/>

                    <defs>
                        <linearGradient id="logoGradient"
                                        x1="0" y1="0"
                                        x2="42" y2="42"
                                        gradientUnits="userSpaceOnUse">

                            <stop stop-color="#1863FF"/>
                            <stop offset="1" stop-color="#14C7C2"/>

                        </linearGradient>
                    </defs>

                </svg>

                <span class="brand-name">MediBridge</span>

            </div>

        </div>


        <div class="patient-forgot-panel">

            <div class="forgot-header">

                <div class="forgot-icon">
                    🔑
                </div>

                <div>

                    <h1>Reset Password</h1>

                    <p>
                        Create a new password for your account.
                    </p>

                </div>

            </div>


            <div class="forgot-info">

                Enter your new password below.
                Make sure both passwords match.

            </div>


            <%
                String error = request.getParameter("error");
            %>


            <% if ("password".equals(error)) { %>

                <div class="error-message">

                    Passwords do not match.
                    Please enter the same password in both fields.

                </div>

            <% } %>


            <% if ("failed".equals(error)) { %>

                <div class="error-message">

                    Password could not be updated.
                    Please try again.

                </div>

            <% } %>


            <form action="../PatientForgotPasswordServlet" method="post">

                <input type="hidden"
                       name="action"
                       value="reset">


                <div class="field">

                    <label for="password">
                        New Password
                    </label>

                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Enter new password"
                           required>

                </div>


                <div class="field">

                    <label for="confirmPassword">
                        Confirm New Password
                    </label>

                    <input type="password"
                           id="confirmPassword"
                           name="confirmPassword"
                           placeholder="Re-enter new password"
                           required>

                </div>


                <button type="submit"
                        class="btn btn-primary btn-block">

                    Reset Password

                </button>

            </form>


            <div class="auth-switch">

                Remember your password?

                <a href="PatientLogin.jsp">
                    Login here
                </a>

            </div>

        </div>

    </div>

</div>

</body>
</html>