<%-- 
    Document   : ForgotPassword
    Created on : 4 Sep, 2026, 10:17:04 AM
    Author     : ankit
--%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Forgot Password | MediBridge</title>

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
                <svg class="logo-mark" viewBox="0 0 42 42" fill="none"
                     xmlns="http://www.w3.org/2000/svg">
                    <rect width="42" height="42" rx="13" fill="url(#logoGradient)"/>
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
                    🔐
                </div>

                <div>
                    <h1>Forgot Password?</h1>
                    <p>Reset your MediBridge account password securely.</p>
                </div>
            </div>

            <div class="forgot-info">
                Enter the email address registered with your
                MediBridge account.
            </div>

            <form action="<%= request.getContextPath() %>/PatientForgotPasswordServlet" method="post">

                <div class="field">
                    <label for="forgot-email">Email Address</label>

                    <input type="email"
                           id="forgot-email"
                           name="email"
                           placeholder="you@example.com"
                           required>
                </div>

                <button type="submit" class="btn btn-primary btn-block">
                    Continue
                </button>

            </form>

            <div class="auth-switch">
                Remember your password?
                <a href="PatientLogin.jsp">Login here</a>
            </div>

        </div>

    </div>

</div>

</body>
</html>