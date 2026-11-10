
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediBridge | Emergency Beds</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f8fc;
            color: #222;
        }

        .navbar {
            background: #0b5ed7;
            padding: 15px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            color: white;
            font-size: 25px;
            font-weight: bold;
        }

        .nav-links a {
            color: white;
            text-decoration: none;
            margin-left: 25px;
            font-size: 16px;
        }

        .container {
            width: 90%;
            max-width: 1100px;
            margin: 30px auto;
        }

        .heading {
            text-align: center;
            margin-bottom: 30px;
        }

        .heading h1 {
            color: #d90429;
            font-size: 32px;
        }

        .emergency-box {
            background: #fff0f0;
            border-left: 6px solid #d90429;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
        }

        .call-button {
            display: inline-block;
            background: #d90429;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            margin-top: 10px;
        }

        .bed-container {
            display: flex;
            gap: 20px;
            margin-bottom: 35px;
        }

        .bed-card {
            background: white;
            flex: 1;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 2px 8px #ccc;
            text-align: center;
        }

        .bed-card h2 {
            color: #0b5ed7;
        }

        .number {
            font-size: 35px;
            font-weight: bold;
            color: #198754;
        }

        .available {
            color: #198754;
            font-weight: bold;
        }

        .limited {
            color: #e09f00;
            font-weight: bold;
        }

        .form-box {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 8px #ccc;
        }

        .form-box h2 {
            color: #0b5ed7;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
        }

        input, select {
            width: 100%;
            padding: 11px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
            box-sizing: border-box;
        }

        .submit-button {
            width: 100%;
            margin-top: 20px;
            padding: 13px;
            background: #198754;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 17px;
            cursor: pointer;
        }

        .submit-button:hover {
            background: #146c43;
        }

        .footer {
            text-align: center;
            background: #0b5ed7;
            color: white;
            padding: 20px;
            margin-top: 40px;
        }

        @media(max-width: 700px) {
            .bed-container {
                flex-direction: column;
            }

            .navbar {
                flex-direction: column;
                gap: 15px;
            }
        }
    </style>
</head>

<body>

<div class="navbar">
    <div class="logo">MediBridge</div>

    <div class="nav-links">
        <a href="../index.jsp">Home</a>
        <a href="../index.jsp#services">Services</a>
        <a href="emergency.jsp">Emergency</a>
    </div>
</div>

<div class="container">

    <div class="heading">
        <h1>🛏️ Emergency Room & Bed Availability</h1>
        <p>Check emergency room, ICU and trauma bed availability.</p>
    </div>

    <div class="emergency-box">
        <h2>🚨 Critical Emergency?</h2>
        <p>
            If the patient is in a life-threatening condition,
            contact emergency services immediately.
        </p>
        <a href="tel:112" class="call-button">📞 Call 112</a>
    </div>

    <h2>Current Emergency Bed Status</h2>

    <div class="bed-container">

        <div class="bed-card">
            <h2>🏥 Emergency Room</h2>
            <div class="number">5</div>
            <p>Available Beds</p>
            <p class="available">● Available</p>
            <p>Total Capacity: 12</p>
        </div>

        <div class="bed-card">
            <h2>❤️ ICU</h2>
            <div class="number">2</div>
            <p>Available Beds</p>
            <p class="limited">● Limited Availability</p>
            <p>Total Capacity: 10</p>
        </div>

        <div class="bed-card">
            <h2>🚑 Trauma Room</h2>
            <div class="number">3</div>
            <p>Available Beds</p>
            <p class="available">● Available</p>
            <p>Total Capacity: 8</p>
        </div>

    </div>

    <div class="form-box">
        <h2>🛏️ Request Emergency Bed</h2>

        <form action="<%= request.getContextPath() %>/emergency_room" method="post">

            <label>Patient Name</label>
            <input type="text" name="patient_name"
                   placeholder="Enter patient name" required>

            <label>Contact Number</label>
            <input type="tel" name="contact"
                   placeholder="Enter contact number" required>

            <label>Patient Age</label>
            <input type="number" name="patient_age"
                   placeholder="Enter age" min="1" max="120" required>

            <label>Bed Type</label>
            <select name="bed_type" required>
                <option value="">-- Select Bed Type --</option>
                <option value="Emergency">Emergency Room Bed</option>
                <option value="ICU">ICU Bed</option>
                <option value="Trauma">Trauma Bed</option>
            </select>

            <button type="submit" class="submit-button">
                🛏️ Request Emergency Bed
            </button>

        </form>
    </div>

</div>

<div class="footer">
    © 2026 MediBridge | Emergency Healthcare Services
</div>

</body>
</html>
