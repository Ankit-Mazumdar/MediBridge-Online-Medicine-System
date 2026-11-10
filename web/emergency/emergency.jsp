
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <title>MediBridge | Emergency</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="Request emergency medical assistance, ambulance dispatch and emergency department support from MediBridge — 24/7.">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link rel="stylesheet" href="../css/style.css">
    <link rel="stylesheet" href="../css/emergency.css">
    
</head>


<style>
/* Emergency-only navbar - isolated from global navbar CSS */

header.emergency-navbar {
    position: relative !important;
    top: auto !important;
    left: auto !important;
    right: auto !important;
    width: 100% !important;
    height: auto !important;
    min-height: 76px !important;
    padding: 0 !important;
    margin: 0 !important;
    background: #ffffff !important;
    border-bottom: 1px solid #e2e8f0 !important;
    box-shadow: 0 3px 14px rgba(15, 35, 60, 0.07) !important;
    z-index: 1000 !important;
}

.emergency-nav-container {
    width: 92% !important;
    max-width: 1180px !important;
    min-height: 76px !important;
    margin: 0 auto !important;
    padding: 0 !important;
    display: flex !important;
    flex-direction: row !important;
    align-items: center !important;
    justify-content: space-between !important;
    gap: 20px !important;
}

.emergency-logo {
    color: #183b64 !important;
    font-family: 'Inter', Arial, sans-serif !important;
    font-size: 25px !important;
    font-weight: 800 !important;
    text-decoration: none !important;
    white-space: nowrap !important;
}

.emergency-nav-links {
    position: static !important;
    display: flex !important;
    flex-direction: row !important;
    align-items: center !important;
    justify-content: flex-end !important;
    gap: 12px !important;
    width: auto !important;
    max-height: none !important;
    padding: 0 !important;
    margin: 0 !important;
    overflow: visible !important;
    background: transparent !important;
    border: 0 !important;
}

.emergency-nav-links a {
    display: inline-flex !important;
    align-items: center !important;
    padding: 10px 17px !important;
    margin: 0 !important;
    border: 0 !important;
    border-radius: 8px !important;
    color: #40536b !important;
    background: transparent !important;
    font-size: 14px !important;
    font-weight: 600 !important;
    text-decoration: none !important;
    white-space: nowrap !important;
}

.emergency-nav-links a:hover,
.emergency-nav-links a.active {
    color: #0d9488 !important;
    background: #e6f7f5 !important;
}

@media (max-width: 600px) {
    .emergency-nav-container {
        flex-direction: column !important;
        justify-content: center !important;
        padding: 12px 0 !important;
        gap: 8px !important;
    }

    .emergency-nav-links {
        width: 100% !important;
        justify-content: center !important;
        gap: 4px !important;
    }

    .emergency-nav-links a {
        padding: 9px 12px !important;
        font-size: 13px !important;
    }
}
</style>


<body>

    <!-- Navigation -->
<!--    <header class="navbar">

        <div class="nav-container">

            <a href="index.jsp" class="logo">
                <span class="brand-name">MediBridge</span>
            </a>

            <nav class="nav-links">

                <a href="../index.jsp">Home</a>

                <a href="../index.jsp#services">Services</a>

                <a href="emergency.jsp" class="active">
                    Emergency
                </a>

            </nav>

        </div>

    </header>-->


<header class="navbar emergency-navbar">
    <div class="emergency-nav-container">

        <a href="../index.jsp" class="emergency-logo">
            MediBridge
        </a>

        <nav class="emergency-nav-links">
            <a href="../index.jsp">Home</a>
            <a href="../index.jsp#services">Services</a>
            <a href="emergency.jsp" class="active">Emergency</a>
        </nav>

    </div>
</header>



    <!-- Emergency Section -->
    <main class="emergency-page">

        <!-- ===================== HERO / MONITOR ===================== -->
        <section class="emergency-hero">

            <div class="hero-inner">

                <div class="hero-text">

                    <span class="emergency-label">
                        <span class="dot-live"></span>
                        EMERGENCY DEPARTMENT &middot; LIVE
                    </span>

                    <h1>
                        Help is one call away.<br>
                        <span>Every second is monitored.</span>
                    </h1>

                    <p>
                        Get immediate access to emergency assistance, ambulance
                        dispatch and emergency department support — staffed
                        around the clock by our critical care team.
                    </p>

                    <div class="hero-stats">

                        <div class="hero-stat">
                            <div class="num mono">8<small>min avg</small></div>
                            <div class="label">Response Time</div>
                        </div>

                        <div class="hero-stat">
                            <div class="num mono">24<small>/7</small></div>
                            <div class="label">Department Staffed</div>
                        </div>

                        <div class="hero-stat">
                            <div class="num mono">32<small>units</small></div>
                            <div class="label">Ambulance Fleet</div>
                        </div>

                    </div>

                </div>

                <div class="monitor-visual">

                    <div class="monitor-head">
                        <span>MEDIBRIDGE&nbsp;ER&nbsp;MONITOR</span>
                        <span class="status-ok">● SYSTEM ONLINE</span>
                    </div>

                    <div class="ecg-wrap">
                        <svg viewBox="0 0 560 140" preserveAspectRatio="none">
                            <path class="ecg-line"
                                d="M0,70 L60,70 L80,70 L95,30 L110,110 L125,20 L140,70 L200,70
                                   L220,70 L235,30 L250,110 L265,20 L280,70 L340,70
                                   L360,70 L375,30 L390,110 L405,20 L420,70 L480,70
                                   L500,70 L515,45 L530,95 L545,70 L560,70" />
                        </svg>
                    </div>

                    <div class="monitor-readouts">

                        <div class="readout">
                            <div class="r-label mono">DISPATCH QUEUE</div>
                            <div class="r-value mono">03 active</div>
                        </div>

                        <div class="readout readout-amber">
                            <div class="r-label mono">NEAREST UNIT ETA</div>
                            <div class="r-value mono">6.4 min</div>
                        </div>

                        <div class="readout readout-critical">
                            <div class="r-label mono">TRIAGE BEDS OPEN</div>
                            <div class="r-value mono">04 / 12</div>
                        </div>

                    </div>

                </div>

            </div>

        </section>


        <!-- ===================== QUICK ACTIONS ===================== -->
        <section class="emergency-actions">

            <div class="emergency-card emergency-call">

                <div class="emergency-icon">
                    📞
                </div>

                <h2>Emergency Call</h2>

                <p>
                    If you are facing a life-threatening emergency,
                    contact emergency services immediately.
                </p>

                <a href="tel:112" class="emergency-button block">
                    Call now
                </a>

            </div>

            <div class="emergency-card">

                <div class="emergency-icon">
                    🏥
                </div>

                <h2>Emergency Department</h2>

                <p>
                    Check current bed availability and browse
                    emergency department services.
                </p>

                <a href="#services" class="emergency-button secondary block">
                    View Services
                </a>

            </div>

        </section>


        <!-- ===================== SERVICES ===================== -->
        <section class="emergency-services" id="services">

            <div class="form-heading">

                <span class="emergency-label">
                    EMERGENCY SERVICES
                </span>

                <h2>Available Emergency Services</h2>

            </div>

            <div class="service-grid">

                <div class="service-box">

                    <h3>🚑 Ambulance</h3>

                    <p>
                        GPS-dispatched emergency transportation with
                        onboard first-response equipment.
                    </p>

                    <a href="emergency_ambulance.jsp"
                       style="color: red;"
                       class="emergency-button secondary">
                        Click here
                    </a>

                </div>


                <div class="service-box">

                    <h3>👨‍⚕️ Emergency Doctor</h3>

                    <p>
                        Direct consultation with an on-duty emergency
                        physician for urgent guidance.
                    </p>

                    <a href="emergencydoctor.jsp"
                       style="color: red;"
                       class="emergency-button secondary">
                        Click here
                    </a>

                </div>


                <div class="service-box">

                    <h3>🏥 Emergency Room</h3>

                    <p>
                        Immediate hospital emergency care with
                        dedicated triage beds.
                    </p>

                    <a href="emergency_bed.jsp"
                       style="color: red;"
                       class="emergency-button secondary">
                        Click here
                    </a>

                </div>


<div class="service-box">

    <h3>🩸 Blood Bank</h3>

    <p>
        Check blood availability by blood group and
        submit an emergency blood request.
    </p>

    <a href="<%= request.getContextPath() %>/emergency/request_blood.jsp"
       class="emergency-button secondary"
       style="color: red;">
        Click here
    </a>

</div>

            </div>

        </section>


        <!-- ===================== NOTICE ===================== -->
        <section class="emergency-notice">

            <span class="notice-icon">⚠️</span>

            <div>

                <h2>Important</h2>

                <p>
                    In a life-threatening emergency, call your local
                    emergency service immediately. Do not wait for an
                    online request to be processed.
                </p>

            </div>

        </section>

    </main>


    <!-- Footer -->
    <footer class="footer">

        <div class="footer-container">

            <p>
                © 2026 MediBridge. All rights reserved.
            </p>

        </div>

    </footer>


    <!-- Floating call button -->
    <a href="tel:112" class="floating-call" id="floatingCall">
        <span class="ring"></span>
        <span class="label-text">Call 112</span>
    </a>


    <script>

        // Character counter for the emergency description field
        (function () {

            var textarea = document.getElementById('description');
            var counter = document.getElementById('charCounter');

            if (textarea && counter) {

                textarea.addEventListener('input', function () {
                    counter.textContent = textarea.value.length + ' / 500';
                });

            }

        })();


        // Show the floating call button once the hero has scrolled past
        (function () {

            var floatingCall = document.getElementById('floatingCall');
            var hero = document.querySelector('.emergency-hero');

            if (!floatingCall || !hero) {
                return;
            }

            var heroBottom = hero.offsetTop + hero.offsetHeight;

            window.addEventListener('scroll', function () {

                if (window.scrollY > heroBottom) {
                    floatingCall.classList.add('show');
                } else {
                    floatingCall.classList.remove('show');
                }

            });

        })();

    </script>

</body>
</html>
