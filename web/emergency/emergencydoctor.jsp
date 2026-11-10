
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">

    <title>MediBridge | Emergency Doctor</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/emergency.css">

    <style>
        .doctor-page {
            min-height: 100vh;
            padding: 60px 20px;
            background: #eaf3ff;
        }

        .doctor-container {
            max-width: 1000px;
            margin: 0 auto;
        }

        .doctor-header {
            text-align: center;
            margin-bottom: 40px;
        }

        .doctor-header h1 {
            color: #0a2540;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .doctor-header p {
            color: #55647d;
            font-size: 1rem;
        }

        .doctor-main-card {
            background: #ffffff;
            padding: 35px;
            border-radius: 20px;
            box-shadow: 0 15px 40px rgba(10, 37, 76, 0.12);
            border: 1px solid #e2e9f5;
            margin-bottom: 30px;
        }

        .doctor-icon {
            width: 65px;
            height: 65px;
            border-radius: 16px;
            background: linear-gradient(135deg, #14c7c2, #0aa6a1);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin-bottom: 20px;
        }

        .doctor-main-card h2 {
            color: #0a2540;
            margin-bottom: 10px;
        }

        .doctor-main-card p {
            color: #55647d;
            line-height: 1.6;
        }

        .doctor-form {
            margin-top: 35px;
            padding-top: 30px;
            border-top: 1px solid #e2e9f5;
        }

        .doctor-form h2 {
            color: #0a2540;
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: block;
            color: #0a2540;
            font-weight: 600;
            margin-bottom: 7px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 12px 14px;
            border: 1px solid #e2e9f5;
            border-radius: 10px;
            font-size: 0.95rem;
            box-sizing: border-box;
        }

        .form-group textarea {
            resize: vertical;
        }

        .submit-doctor {
            width: 100%;
            padding: 14px;
            border: none;
            border-radius: 10px;
            background: #14c7c2;
            color: #ffffff;
            font-size: 1rem;
            font-weight: 700;
            cursor: pointer;
        }

        .submit-doctor:hover {
            background: #0aa6a1;
        }

        .warning-box {
            margin-top: 25px;
            padding: 15px 20px;
            background: #fff4e5;
            border-left: 5px solid #ff9800;
            border-radius: 8px;
            color: #6b4a00;
        }

        @media (max-width: 700px) {
            .doctor-main-card {
                padding: 25px;
            }
        }
        /* Emergency Doctor Navbar - Match Other Emergency Pages */
header.navbar {
    width: 100% !important;
    height: 66px !important;
    min-height: 66px !important;
    background: #0d5bd7 !important;
    padding: 0 !important;
    margin: 0 !important;
    display: block !important;
    box-sizing: border-box;
}

header.navbar .nav-container {
    width: 100% !important;
    max-width: 100% !important;
    height: 66px !important;
    margin: 0 !important;
    padding: 0 30px !important;
    display: flex !important;
    align-items: center !important;
    justify-content: space-between !important;
    box-sizing: border-box;
}

header.navbar .logo {
    display: flex !important;
    align-items: center !important;
    text-decoration: none !important;
    color: #ffffff !important;
}

header.navbar .brand-name {
    color: #ffffff !important;
    font-size: 24px !important;
    font-weight: 700 !important;
}

header.navbar .nav-links {
    display: flex !important;
    align-items: center !important;
    gap: 30px !important;
}

header.navbar .nav-links a {
    color: #ffffff !important;
    text-decoration: none !important;
    font-size: 16px !important;
    font-weight: 500 !important;
}

header.navbar .nav-links a:hover {
    color: #dbeafe !important;
}

@media (max-width: 600px) {
    header.navbar .nav-container {
        padding: 0 15px !important;
    }

    header.navbar .nav-links {
        gap: 12px !important;
    }

    header.navbar .brand-name {
        font-size: 20px !important;
    }

    header.navbar .nav-links a {
        font-size: 13px !important;
    }
}
    </style>
</head>

<body>

    <!-- Navigation -->
    <header class="navbar">

        <div class="nav-container">

            <a href="../index.jsp" class="logo">
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

    </header>


    <!-- Emergency Doctor Page -->
    <main class="doctor-page">

        <div class="doctor-container">

            <!-- Heading -->
            <div class="doctor-header">

                <h1>👨‍⚕️ Emergency Doctor</h1>

                <p>
                    Get quick medical guidance from an emergency doctor
                    when you need urgent assistance.
                </p>

            </div>


            <!-- Main Card -->
            <div class="doctor-main-card">

                <div class="doctor-icon">
                    👨‍⚕️
                </div>

                <h2>Emergency Doctor Consultation</h2>

                <p>
                    Describe your emergency and connect with an available
                    emergency doctor for quick guidance.
                </p>


                <!-- Doctor Request Form -->
                <div class="doctor-form" id="doctor-form">

                    <h2>Request Emergency Doctor</h2>

                    <form action="<%= request.getContextPath() %>/emergency_doctor"
                          method="post">

                        <div class="form-group">

                            <label for="patientName">
                                Patient Name
                            </label>

                            <input type="text"
                                   id="patientName"
                                   name="patientName"
                                   placeholder="Enter patient name"
                                   maxlength="100"
                                   required>

                        </div>


                        <div class="form-group">

                            <label for="contact">
                                Contact Number
                            </label>

                            <input type="tel"
                                   id="contact"
                                   name="contact"
                                   placeholder="Enter contact number"
                                   maxlength="15"
                                   required>

                        </div>


                        <div class="form-group">

                            <label for="problem">
                                Emergency Type
                            </label>

                            <select id="problem"
                                    name="problem"
                                    required>

                                <option value="">
                                    Select emergency type
                                </option>

                                <option value="Chest Pain">
                                    Chest Pain
                                </option>

                                <option value="Breathing Problem">
                                    Breathing Problem
                                </option>

                                <option value="Accident">
                                    Accident
                                </option>

                                <option value="Severe Bleeding">
                                    Severe Bleeding
                                </option>

                                <option value="Unconscious">
                                    Unconscious
                                </option>

                                <option value="Other">
                                    Other
                                </option>

                            </select>

                        </div>


                        <div class="form-group">

                            <label for="description">
                                Describe the Problem
                            </label>

                            <textarea id="description"
                                      name="description"
                                      rows="5"
                                      maxlength="1000"
                                      placeholder="Briefly describe the patient's condition..."
                                      required></textarea>

                        </div>


                        <button type="submit" class="submit-doctor">
                            👨‍⚕️ Request Emergency Doctor
                        </button>

                    </form>


                    <!-- Important Notice -->
                    <div class="warning-box">

                        <strong>⚠️ Important:</strong>

                        If the patient is in immediate life-threatening
                        danger, call your local emergency service immediately.
                        Do not wait for an online consultation.

                    </div>

                </div>

            </div>

        </div>

    </main>


    <!-- Footer -->
    <footer class="footer">

        <div class="footer-container">

            <p>
                © 2026 MediBridge. All rights reserved.
            </p>

        </div>

    </footer>

</body>
</html>
