<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Sign In | MediBridge</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
<link rel="stylesheet" href="css/logins.css">
</head>
<body class="auth-page">
    
<%
    String error = request.getParameter("error");

    if (error == null) {
        error = (String) request.getAttribute("error");
    }
%>


<a href="index.jsp" class="auth-back">
  <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M11 18l-6-6 6-6"/></svg>
  Back to website
</a>

<div class="auth-shell">

  <div class="auth-brand">
    <svg class="logo-mark" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg" width="36" height="36">
      <defs>
        <linearGradient id="loginLogoGrad" x1="0" y1="0" x2="1" y2="1">
          <stop offset="0%" stop-color="#1863ff"/>
          <stop offset="100%" stop-color="#14c7c2"/>
        </linearGradient>
      </defs>
      <circle cx="24" cy="24" r="22" fill="url(#loginLogoGrad)"/>
      <path d="M8 24 H16 L19 15 L24 33 L28 24 H40" fill="none" stroke="#ffffff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    <span class="brand-name">MediBridge</span>
  </div>

  <!-- ============ PATIENT SIGN-IN PANEL ============ -->
  <!-- Becomes visible only when the URL fragment is #patient (see css/login.css) -->
  <div id="patient" class="auth-panel">
<!--    <a href="login.jsp" class="role-back">-->
        <a href="<%= request.getContextPath() %>/login.jsp" class="role-back">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M11 18l-6-6 6-6"/></svg>
      Choose a different role
    </a>

    <div class="auth-panel-head">
      <div class="role-icon patient">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M8 12h8M12 8v8"/></svg>
      </div>
      <div>
        <h1>Patient Sign In</h1>
        <span>Sign in to continue to MediBridge</span>
      </div>
    </div>

<!--    <form action="PatientLoginServlet" method="post">-->
       <form action="<%= request.getContextPath() %>/PatientLoginServlet" method="post">
      <input type="hidden" name="role" value="patient">

      <div class="field">
        <label for="patient-email">Email</label>
        <input type="email" id="patient-email" name="email" placeholder="you@example.com" required>
      </div>

      <div class="field">
        <label for="patient-password">Password</label>
        <input type="password" id="patient-password" name="password" placeholder="Enter your password" required>
      </div>

      <div class="field-row"><a href="#">Forgot password?</a></div>

      <button type="submit" class="btn btn-primary btn-block">Sign In</button>
    </form>

<!--    <p class="auth-switch">New patient? <a href="register.jsp">Create account</a></p>-->
        <p class="auth-switch">New patient? <a href="<%= request.getContextPath() %>/Patient/PatientRegister.jsp">Create account</a></p>
  </div>

  <!-- ============ DOCTOR SIGN-IN PANEL ============ -->
  <!-- Becomes visible only when the URL fragment is #doctor -->
  <div id="doctor" class="auth-panel">
    <a href="login.jsp" class="role-back">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M11 18l-6-6 6-6"/></svg>
      Choose a different role
    </a>

    <div class="auth-panel-head">
      <div class="role-icon doctor">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12a8 8 0 1 1 16 0"/><path d="M12 12v6M9 21h6"/></svg>
      </div>
      <div>
        <h1>Doctor Sign In</h1>
        <span>Sign in to continue to MediBridge</span>
      </div>
    </div>
      
<!--      ---------------------------------------------------->

<% if ("Pending".equals(error)) { %>

    <p style="color: #b45309; background: #fff7ed; padding: 12px; border-radius: 8px; margin-bottom: 15px;">
        Your registration is still pending. Please wait for admin approval.
    </p>

<% } else if ("Rejected".equals(error)) { %>

    <p style="color: #b91c1c; background: #fef2f2; padding: 12px; border-radius: 8px; margin-bottom: 15px;">
        Your doctor registration application has been rejected.
    </p>

<% } else if ("NotFound".equals(error)) { %>

    <p style="color: #b91c1c; background: #fef2f2; padding: 12px; border-radius: 8px; margin-bottom: 15px;">
        Email address not found. Please check your email or register as a doctor.
    </p>

<% } else if ("Invalid".equals(error)) { %>

    <p style="color: #b91c1c; background: #fef2f2; padding: 12px; border-radius: 8px; margin-bottom: 15px;">
        Invalid email or password.
    </p>

<% } %>

<!---------------------------------------------->
      


    <form action="DoctorLoginServlet" method="post">
      <input type="hidden" name="role" value="doctor">

      <div class="field">
        <label for="doctor-email">Email</label>
        <input type="email" id="doctor-email" name="email" placeholder="you@example.com" required>
      </div>

      <div class="field">
        <label for="doctor-password">Password</label>
        <input type="password" id="doctor-password" name="password" placeholder="Enter your password" required>
      </div>

      <div class="field-row"><a href="#">Forgot password?</a></div>

      <button type="submit" class="btn btn-primary btn-block">Sign In</button>
    </form>

    <p class="auth-switch">New doctor? <a href="doctorRegister.jsp">Register as a doctor</a></p>
  </div>

  <!-- ============ ADMIN SIGN-IN PANEL ============ -->
  <!-- Becomes visible only when the URL fragment is #admin -->
  <div id="admin" class="auth-panel">
    <a href="login.jsp" class="role-back">
      <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M19 12H5M11 18l-6-6 6-6"/></svg>
      Choose a different role
    </a>

    <div class="auth-panel-head">
      <div class="role-icon admin">
        <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6l7-3z"/></svg>
      </div>
      <div>
        <h1>Admin Sign In</h1>
        <span>Sign in to continue to MediBridge</span>
      </div>
    </div>

<!--    <form action="AdminLoginServlet" method="post">-->
    <form action="<%= request.getContextPath() %>/adminLogin" method="post">
      <input type="hidden" name="role" value="admin">

      <div class="field">
        <label for="admin-email">Email</label>
        <input type="email" id="admin-email" name="email" placeholder="you@example.com" required>
      </div>

      <div class="field">
        <label for="admin-password">Password</label>
        <input type="password" id="admin-password" name="password" placeholder="Enter your password" required>
      </div>

      <div class="field-row"><a href="#">Forgot password?</a></div>

      <button type="submit" class="btn btn-primary btn-block">Sign In</button>
    </form>

    <p class="auth-note">Admin accounts are created and managed by system administrators — there is no public registration for this role.</p>
  </div>

  <!-- ============ ROLE SELECTION PANEL (default view) ============ -->
  <!-- Visible whenever the URL has no #patient / #doctor / #admin fragment -->
  <div id="role-select" class="auth-panel">
    <div class="auth-title">
      <h1>Welcome back</h1>
      <p>Choose how you'd like to sign in to MediBridge</p>
    </div>

    <div class="role-grid">
      <a href="#patient" class="role-card">
        <div class="role-icon patient">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M8 12h8M12 8v8"/></svg>
        </div>
        <div class="role-text">
          <strong>Continue as Patient</strong>
          <span>Book visits, order medicine, manage your care</span>
        </div>
        <svg class="role-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
      </a>

      <a href="#doctor" class="role-card">
        <div class="role-icon doctor">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12a8 8 0 1 1 16 0"/><path d="M12 12v6M9 21h6"/></svg>
        </div>
        <div class="role-text">
          <strong>Continue as Doctor</strong>
          <span>Manage appointments and patients</span>
        </div>
        <svg class="role-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
      </a>

      <a href="#admin" class="role-card">
        <div class="role-icon admin">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6l7-3z"/></svg>
        </div>
        <div class="role-text">
          <strong>Continue as Admin</strong>
          <span>Manage the MediBridge platform</span>
        </div>
        <svg class="role-arrow" width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M13 6l6 6-6 6"/></svg>
      </a>
    </div>
  </div>

</div>

</body>
</html>
