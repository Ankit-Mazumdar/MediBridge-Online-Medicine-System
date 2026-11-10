<%-- 
    Document   : ForgotPasswordQuestion
    Created on : 4 Sep, 2026, 10:17:23 AM
    Author     : ankit
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Security Verification | MediBridge</title>

    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/logins.css">
    <link rel="stylesheet" href="../css/ForgotPassword.css">
</head>

<body>

<div class="auth-page">

    <a href="ForgotPassword.jsp" class="auth-back">
        ← Back
    </a>

    <div class="auth-shell">

        <div class="auth-brand">
            <div class="brand">

                <svg class="logo-mark" viewBox="0 0 42 42" fill="none"
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
                    🔐
                </div>

                <div>
                    <h1>Security Verification</h1>
                    <p>Answer your security question to continue.</p>
                </div>

            </div>

            <div class="forgot-info">

                Please answer the security question associated
                with your MediBridge account.

            </div>

            <%
                String error = request.getParameter("error");
            %>

            <% if ("answer".equals(error)) { %>

                <div class="error-message">
                    Incorrect answer. Please try again.
                </div>

            <% } %>


            <form action="../PatientForgotPasswordServlet" method="post">

                <input type="hidden"
                       name="action"
                       value="verify">


                <div class="field">

                    <label>Security Question</label>

                    <div class="forgot-info">
                        <%= session.getAttribute("resetQuestion") %>
                    </div>

                </div>


                <div class="field">

                    <label for="security-answer">
                        Your Answer
                    </label>

                    <input type="text"
                           id="security-answer"
                           name="securityAnswer"
                           placeholder="Enter your answer"
                           required>

                </div>


                <button type="submit"
                        class="btn btn-primary btn-block">

                    Verify Answer

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