<%-- 
    Document   : PatientRegister
    Created on : 1 Sep, 2026, 5:38:53 PM
    Author     : ankit
--%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>

<head>

    <title>Patient Registration | MediBridge</title>
    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/PatientRegister.css">

</head>

<body class="auth-page">

    <div class="register-shell">

        <div class="register-head">

            <h1>Patient Registration</h1>

            <p>
                Create your MediBridge account and manage your healthcare simply.
            </p>

        </div>


        <!-- VALIDATION MESSAGES -->

        <% if ("email".equals(error)) { %>

            <div class="error-message">
                An account already exists with this email.
<!--                Please <a href="Patient/PatientLogin.jsp">login</a> instead.-->
                    Please <a href="<%= request.getContextPath() %>/Patient/PatientLogin.jsp">login</a> instead.
            </div>

        <% } %>


        <% if ("password".equals(error)) { %>

            <div class="error-message">
                Passwords do not match. Please enter the same password in both fields.
            </div>

        <% } %>


        <% if ("failed".equals(error)) { %>

            <div class="error-message">
                Registration could not be completed.
                Please check your details and try again.
            </div>

        <% } %>


<!--        <form action="../PatientRegisterServlet" method="post">-->

            <form action="<%= request.getContextPath() %>/PatientRegisterServlet" method="post">


            <!-- Personal Information -->

            <div class="form-section">

                <div class="form-section-title">
                    Personal Information
                </div>

                <div class="field-grid">


                    <div class="field field-full">

                        <label>Full Name</label>

                        <input type="text"
                               name="name"
                               placeholder="Enter your full name"
                               required>

                    </div>


                    <div class="field">

                        <label>Email</label>

                        <input type="email"
                               name="email"
                               placeholder="you@example.com"
                               class="<%= "email".equals(error) ? "input-error" : "" %>"
                               required>

                    </div>


                    <div class="field">

                        <label>Phone Number</label>

                        <input type="text"
                               name="contact"
                               placeholder="10-digit mobile number"
                               required>

                    </div>


                    <div class="field">

                        <label>Password</label>

                        <input type="password"
                               name="password"
                               placeholder="Create password"
                               class="<%= "password".equals(error) ? "input-error" : "" %>"
                               required>

                    </div>


                    <div class="field">

                        <label>Confirm Password</label>

                        <input type="password"
                               name="confirmPassword"
                               placeholder="Re-enter password"
                               class="<%= "password".equals(error) ? "input-error" : "" %>"
                               required>

                    </div>


                    <div class="field">

                        <label>Date of Birth</label>

                        <input type="date"
                               name="dob"
                               required>

                    </div>


                    <div class="field">

                        <label>Gender</label>

                        <select name="gender" required>

                            <option value="">
                                Select Gender
                            </option>

                            <option value="Male">Male</option>
                            <option value="Female">Female</option>
                            <option value="Other">Other</option>

                        </select>

                    </div>

                </div>

            </div>


            <!-- Health Information -->

            <div class="form-section">

                <div class="form-section-title">
                    Health Information
                </div>

                <div class="field-grid">


                    <div class="field">

                        <label>Blood Group</label>

                        <select name="bloodGroup" required>

                            <option value="">
                                Select Blood Group
                            </option>

                            <option value="A+">A+</option>
                            <option value="A-">A-</option>
                            <option value="B+">B+</option>
                            <option value="B-">B-</option>
                            <option value="AB+">AB+</option>
                            <option value="AB-">AB-</option>
                            <option value="O+">O+</option>
                            <option value="O-">O-</option>

                        </select>

                    </div>


                    <div class="field field-full">

                        <label>Address</label>

                        <textarea name="address"
                                  placeholder="Enter your address"
                                  rows="3"
                                  required></textarea>

                    </div>

                </div>

            </div>


            <!-- Account Recovery -->

            <div class="form-section">

                <div class="form-section-title">
                    Account Recovery
                </div>

                <div class="field-grid">


                    <div class="field field-full">

                        <label>Security Question</label>

                        <select name="securityQuestion" required>

                            <option value="">
                                Select Security Question
                            </option>

                            <option value="What is your mother's maiden name?">
                                What is your mother's maiden name?
                            </option>

                            <option value="What was the name of your first school?">
                                What was the name of your first school?
                            </option>

                            <option value="What is your favourite food?">
                                What is your favourite food?
                            </option>

                            <option value="What was the name of your first pet?">
                                What was the name of your first pet?
                            </option>

                        </select>

                    </div>


                    <div class="field field-full">

                        <label>Security Answer</label>

                        <input type="text"
                               name="securityAnswer"
                               placeholder="Enter your answer"
                               required>

                    </div>

                </div>

            </div>


            <!-- Terms -->

            <div class="terms-row">

                <input type="checkbox"
                       name="terms"
                       required>

                <label>
                    I agree to the MediBridge terms and privacy policy.
                </label>

            </div>


            <button type="submit"
                    class="btn btn-primary btn-block">

                Create Patient Account

            </button>


            <p class="register-note">

                Already have an account?

<!--                <a href="Patient/PatientLogin.jsp">
                    Login
                </a>-->
                    <a href="<%= request.getContextPath() %>/Patient/PatientLogin.jsp">Login</a>

            </p>


        </form>

    </div>

</body>
</html>