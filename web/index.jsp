<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>MediBridge | Healthcare, Connected</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="description" content="MediBridge connects patients, doctors, pharmacy services and emergency healthcare in one secure platform.">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
<link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- ===================== NAVBAR ===================== -->
<header class="navbar">
  <div class="container">
    <a href="index.jsp" class="brand" aria-label="MediBridge home">
      <!-- Logo mark: the site's signature heartbeat pulse, reused on login page and footer -->
      <svg class="logo-mark" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
        <defs>
          <linearGradient id="logoGrad" x1="0" y1="0" x2="1" y2="1">
            <stop offset="0%" stop-color="#1863ff"/>
            <stop offset="100%" stop-color="#14c7c2"/>
          </linearGradient>
        </defs>
        <circle cx="24" cy="24" r="22" fill="url(#logoGrad)"/>
        <path d="M8 24 H16 L19 15 L24 33 L28 24 H40" fill="none" stroke="#ffffff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/>
      </svg>
      <span class="brand-name">MediBridge</span>
    </a>

    <input type="checkbox" id="nav-toggle" class="nav-toggle">

    <nav class="nav-links">
      <a href="#about">About Us</a>
      <a href="#services">Services</a>
      <a href="#emergency">Emergency</a>
      <a href="login.jsp" class="btn btn-primary nav-signin">Sign In</a>
    </nav>

    <label for="nav-toggle" class="nav-toggle-label" aria-label="Toggle menu"><span></span></label>
  </div>
</header>

<!-- ===================== HERO ===================== -->
<section class="hero">
  <div class="container">
    <div class="hero-copy">
      <span class="eyebrow">Digital Healthcare Platform</span>
      <h1>Healthcare, <span>connected.</span></h1>
      <p>MediBridge brings patients, doctors, pharmacy services and emergency
         healthcare together on one secure platform — so care never feels
         scattered across a dozen different places.</p>

      <div class="hero-actions">
        <a href="login.jsp" class="btn btn-primary">Sign In</a>
        <a href="#services" class="btn btn-ghost">Explore Services</a>
      </div>

      <div class="hero-trust">
        <div><strong>24/7</strong><span>Emergency access</span></div>
        <div><strong>3</strong><span>Care roles, one platform</span></div>
        <div><strong>100%</strong><span>Digital &amp; secure</span></div>
      </div>
    </div>

    <div class="hero-visual">
      <div class="pulse-plate">
        <!-- Heartbeat trace: the recurring signature motif behind the hero cards -->
        <svg viewBox="0 0 400 300" preserveAspectRatio="none" xmlns="http://www.w3.org/2000/svg">
          <polyline points="0,150 90,150 110,90 130,210 150,60 170,150 400,150"
                    fill="none" stroke="#14c7c2" stroke-width="3" stroke-linecap="round" stroke-linejoin="round" opacity="0.85"/>
          <polyline points="0,220 60,220 400,220" fill="none" stroke="#ffffff" stroke-width="1" opacity="0.15"/>
          <polyline points="0,90 60,90 400,90" fill="none" stroke="#ffffff" stroke-width="1" opacity="0.15"/>
        </svg>
      </div>

      <div class="floating-card fc-1">
        <div class="fc-icon" style="background:#eaf3ff; color:#1863ff;">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12a8 8 0 1 1 16 0"/><path d="M12 12v6M9 21h6"/></svg>
        </div>
        <div><strong>Doctors Online</strong><span>128 available now</span></div>
      </div>

      <div class="floating-card fc-2">
        <div class="fc-icon" style="background:#e9fbfa; color:#14c7c2;">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="9" width="18" height="10" rx="2"/><path d="M7 9V7a5 5 0 0 1 10 0v2"/></svg>
        </div>
        <div><strong>Medicine Order</strong><span>Delivered in 45 min</span></div>
      </div>

      <div class="floating-card fc-3">
        <div class="fc-icon" style="background:#fff0ee; color:#ff5c5c;">
          <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 21s-7-4.35-9.5-8.5C.5 8.5 3 5 6.5 5c2 0 3.2 1 5.5 3 2.3-2 3.5-3 5.5-3 3.5 0 6 3.5 4 7.5C19 16.65 12 21 12 21z"/></svg>
        </div>
        <div><strong>Emergency Response</strong><span>Avg. 6 min dispatch</span></div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== ABOUT ===================== -->
<section id="about" class="about">
  <div class="container">
    <div class="about-visual">
      <div class="av-row">
        <div class="av-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M8 12h8M12 8v8"/></svg></div>
        <div><strong>Patients</strong><span>Book visits &amp; manage records</span></div>
      </div>
      <div class="av-row">
        <div class="av-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12a8 8 0 1 1 16 0"/><path d="M12 12v6M9 21h6"/></svg></div>
        <div><strong>Doctors</strong><span>Manage patients &amp; schedules</span></div>
      </div>
      <div class="av-row">
        <div class="av-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="9" width="18" height="10" rx="2"/><path d="M7 9V7a5 5 0 0 1 10 0v2"/></svg></div>
        <div><strong>Pharmacy</strong><span>Fulfil &amp; track medicine orders</span></div>
      </div>
      <div class="av-row">
        <div class="av-icon"><svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 21s-7-4.35-9.5-8.5C.5 8.5 3 5 6.5 5c2 0 3.2 1 5.5 3 2.3-2 3.5-3 5.5-3 3.5 0 6 3.5 4 7.5C19 16.65 12 21 12 21z"/></svg></div>
        <div><strong>Emergency</strong><span>Immediate response, always on</span></div>
      </div>
    </div>

    <div class="about-copy">
      <span class="eyebrow">About MediBridge</span>
      <h2>One platform for every part of your care.</h2>
      <p>MediBridge is a digital healthcare platform that brings patients,
         doctors, pharmacy services and emergency response into a single,
         connected system. Instead of juggling separate apps, phone calls
         and paper records, everyone involved in your care works from the
         same trusted place — making healthcare simpler, faster and far
         more reliable.</p>

      <div class="benefit-grid">
        <div class="benefit-card">
          <div class="b-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="6" cy="6" r="2.5"/><circle cx="18" cy="18" r="2.5"/><path d="M8 7.5L16 16.5"/></svg></div>
          <h4>Connected Healthcare</h4>
          <p>Patients, doctors and pharmacy services on one platform.</p>
        </div>
        <div class="benefit-card">
          <div class="b-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3v18M3 12h18"/></svg></div>
          <h4>Easy Access</h4>
          <p>Reach the right care in a few taps, any time you need it.</p>
        </div>
        <div class="benefit-card">
          <div class="b-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 3l7 3v6c0 4.5-3 7.5-7 9-4-1.5-7-4.5-7-9V6l7-3z"/></svg></div>
          <h4>Secure Platform</h4>
          <p>Health data protected with role-based, confidential access.</p>
        </div>
        <div class="benefit-card">
          <div class="b-icon"><svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12a8 8 0 1 1 16 0"/><path d="M12 12v6"/></svg></div>
          <h4>Convenient Care</h4>
          <p>Appointments, medicines and emergencies — handled in one place.</p>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- ===================== SERVICES ===================== -->
<section id="services" class="services">
  <div class="container">
    <div class="section-heading">
      <span class="eyebrow">Our Services</span>
      <h2>Everything you need for better healthcare.</h2>
      <p>Four connected modules that cover the full journey of care, from a routine
         check-up to an urgent emergency.</p>
    </div>

    <div class="service-grid">
      <div class="service-card">
        <div class="service-icon"><svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M4 12a8 8 0 1 1 16 0"/><path d="M12 12v6M9 21h6"/></svg></div>
        <h3>Doctors</h3>
        <p>Find doctors by specialty and manage your appointments in one place.</p>
        <span class="service-link">Learn more <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M13 6l6 6-6 6"/></svg></span>
      </div>

      <div class="service-card">
        <div class="service-icon"><svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><rect x="3" y="9" width="18" height="10" rx="2"/><path d="M7 9V7a5 5 0 0 1 10 0v2"/></svg></div>
        <h3>Pharmacy</h3>
        <p>Access medicines and manage your medicine orders without the queue.</p>
        <span class="service-link">Learn more <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M13 6l6 6-6 6"/></svg></span>
      </div>

      <div class="service-card">
        <div class="service-icon"><svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><circle cx="12" cy="12" r="9"/><path d="M8 12h8M12 8v8"/></svg></div>
        <h3>Patient Care</h3>
        <p>Manage your healthcare information and access services when you need them.</p>
        <span class="service-link">Learn more <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M13 6l6 6-6 6"/></svg></span>
      </div>

      <div class="service-card">
        <div class="service-icon"><svg width="26" height="26" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path d="M12 21s-7-4.35-9.5-8.5C.5 8.5 3 5 6.5 5c2 0 3.2 1 5.5 3 2.3-2 3.5-3 5.5-3 3.5 0 6 3.5 4 7.5C19 16.65 12 21 12 21z"/></svg></div>
        <h3>Emergency</h3>
        <p>Get quick access to emergency healthcare assistance, right when it matters.</p>
        <span class="service-link">Learn more <svg width="15" height="15" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5"><path d="M5 12h14M13 6l6 6-6 6"/></svg></span>
      </div>
    </div>
  </div>
</section>

<!-- ===================== EMERGENCY ===================== -->
<section id="emergency" class="emergency">
  <div class="container">
    <span class="eyebrow">Urgent Care</span>
    <h2>Need medical help right now?</h2>
    <p>If you or someone near you is facing a medical emergency, don't wait.
       MediBridge routes you straight to emergency assistance and the nearest
       available responders.</p>
    <a href="emergency/emergency.jsp" class="btn btn-emergency">Emergency Help</a>
    <p class="emergency-note">Available 24 hours a day, 7 days a week.</p>
  </div>
</section>

<!-- ===================== FOOTER ===================== -->
<footer class="footer">
  <div class="container">
    <div>
      <div class="footer-brand">
        <svg class="logo-mark" viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">
          <circle cx="24" cy="24" r="22" fill="#1863ff"/>
          <path d="M8 24 H16 L19 15 L24 33 L28 24 H40" fill="none" stroke="#ffffff" stroke-width="2.6" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <span class="brand-name">MediBridge</span>
      </div>
      <p class="tagline">Healthcare, connected. One secure platform for patients, doctors, pharmacy and emergency care.</p>
    </div>

    <div>
      <h4>Explore</h4>
      <ul>
        <li><a href="#about">About Us</a></li>
        <li><a href="#services">Services</a></li>
        <li><a href="#emergency">Emergency</a></li>
      </ul>
    </div>

    <div>
      <h4>Account</h4>
      <ul>
        <li><a href="login.jsp">Sign In</a></li>
      </ul>
    </div>
  </div>

  <div class="container footer-bottom">
    <span>&copy; <%= java.time.Year.now() %> MediBridge. All rights reserved.</span>
    <span>Built for connected, dependable healthcare.</span>
  </div>
</footer>

</body>
</html>
