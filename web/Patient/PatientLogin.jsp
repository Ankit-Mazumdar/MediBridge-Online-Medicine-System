<%-- 
    Document   : PatientLogin
    Created on : 1 Sep, 2026, 11:49:36 PM
    Author     : ankit
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = request.getParameter("error");
    String registered = request.getParameter("registered");
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <title>Patient Sign In | MediBridge</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/logins.css">
</head>

<body class="auth-page">

    <a href="../login.jsp" class="auth-back">
        <svg width="15" height="15"
             viewBox="0 0 24 24"
             fill="none"
             stroke="currentColor"
             stroke-width="2.5">
            <path d="M19 12H5M11 18l-6-6 6-6"/>
        </svg>
        Back to login
    </a>

    <div class="auth-shell">

        <!-- MediBridge Logo -->
        <div class="auth-brand">
            <svg class="logo-mark"
                 viewBox="0 0 48 48"
                 xmlns="http://www.w3.org/2000/svg"
                 width="36"
                 height="36">
                <defs>
                    <linearGradient id="loginLogoGrad"
                                    x1="0"
                                    y1="0"
                                    x2="1"
                                    y2="1">
                        <stop offset="0%" stop-color="#1863ff"/>
                        <stop offset="100%" stop-color="#14c7c2"/>
                    </linearGradient>
                </defs>
                <circle cx="24"
                        cy="24"
                        r="22"
                        fill="url(#loginLogoGrad)"/>
                <path d="M8 24 H16 L19 15 L24 33 L28 24 H40"
                      fill="none"
                      stroke="#ffffff"
                      stroke-width="2.6"
                      stroke-linecap="round"
                      stroke-linejoin="round"/>
            </svg>
            <span class="brand-name">MediBridge</span>
        </div>

        <!-- Patient Login -->
        <div class="patient-login-panel">
            <a href="../login.jsp" class="role-back">
                <svg viewBox="0 0 24 24"
                     fill="none"
                     stroke="currentColor"
                     stroke-width="2.5">
                    <path d="M19 12H5M11 18l-6-6 6-6"/>
                </svg>
                Choose a different role
            </a>

            <div class="auth-panel-head">
                <div class="role-icon patient">
                    <svg width="20"
                         height="20"
                         viewBox="0 0 24 24"
                         fill="none"
                         stroke="currentColor"
                         stroke-width="2">
                        <circle cx="12" cy="12" r="9"/>
                        <path d="M8 12h8M12 8v8"/>
                    </svg>
                </div>

                <div>
                    <h1>Patient Sign In</h1>
                    <span>
                        Sign in to continue to MediBridge
                    </span>
                </div>
            </div>

            <!-- REGISTRATION SUCCESS MESSAGE -->
            <% if ("true".equals(registered)) { %>
                <div class="patient-success-alert">
                    <span class="alert-icon">✓</span>
                    <span>
                        Registration successful! Please login to continue.
                    </span>
                </div>
            <% } %>
            
            <!-- PASSWORD RESET SUCCESS MESSAGE -->
            <% if ("true".equals(request.getParameter("reset"))) { %>
                <div class="patient-success-alert">
                    Password reset successfully! Please login with your new password.
                </div>
            <% } %>

            <!-- EMAIL NOT FOUND MESSAGE -->
            <% if ("noaccount".equals(error)) { %>
                <div class="patient-error-alert">
                    <span class="alert-icon">!</span>
                    <span>
                        No account found with this email.
                        Please <a href="PatientRegister.jsp">register</a> to continue.
                    </span>
                </div>
            <% } %>

            <!-- WRONG PASSWORD MESSAGE -->
            <% if ("wrongpassword".equals(error)) { %>
                <div class="patient-error-alert">
                    <span class="alert-icon">!</span>
                    <span>
                        Incorrect password. Please check your password and try again.
                    </span>
                </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/PatientLoginServlet" method="post">

                <!-- EMAIL -->
                <div class="field">
                    <label for="patient-email">
                        Email
                    </label>
                    <input type="email"
                           id="patient-email"
                           name="email"
                           placeholder="you@example.com"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                           class="<%= "noaccount".equals(error) ? "patient-email-invalid" : "" %>"
                           required>
                </div>

                <!-- PASSWORD -->
                <div class="field">
                    <label for="patient-password">
                        Password
                    </label>
                    <input type="password"
                           id="patient-password"
                           name="password"
                           placeholder="Enter your password"
                           class="<%= "wrongpassword".equals(error) ? "patient-password-invalid" : "" %>"
                           required>
                </div>

                <div class="field-row">
<!--                    <a href="ForgotPassword.jsp">
                        Forgot password?
                    </a>-->
<a href="<%= request.getContextPath() %>/Patient/ForgotPassword.jsp">
    Forgot password?
</a>
                </div>

                <button type="submit"
                        class="btn btn-primary btn-block">
                    Sign In
                </button>
            </form>

            <p class="auth-switch">
                New patient?
                <a href="PatientRegister.jsp">
                    Create account
                </a>
            </p>

        </div>
    </div>

</body>
</html>