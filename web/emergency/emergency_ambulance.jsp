
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>MediBridge | Emergency Ambulance</title>

    <style>
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background-color: #f4f8fc;
            color: #222;
        }

        .navbar {
            background-color: #0b5ed7;
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

        .nav-links a:hover {
            text-decoration: underline;
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
            margin-bottom: 10px;
        }

        .heading p {
            color: #555;
        }

        .emergency-box {
            background-color: #fff0f0;
            border-left: 6px solid #d90429;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 25px;
        }

        .call-button {
            display: inline-block;
            background-color: #d90429;
            color: white;
            padding: 12px 25px;
            text-decoration: none;
            border-radius: 6px;
            font-weight: bold;
            margin-top: 10px;
        }

        .call-button:hover {
            background-color: #a90320;
        }

        .ambulance-types {
            display: flex;
            gap: 20px;
            margin-bottom: 30px;
        }

        .type-card {
            background-color: white;
            padding: 20px;
            flex: 1;
            border-radius: 10px;
            box-shadow: 0 2px 8px #cccccc;
        }

        .type-card h3 {
            color: #0b5ed7;
        }

        .form-box {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 2px 10px #cccccc;
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
            margin-top: 20px;
            width: 100%;
            padding: 13px;
            background-color: #198754;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 17px;
            cursor: pointer;
        }

        .submit-button:hover {
            background-color: #146c43;
        }

        .footer {
            text-align: center;
            margin-top: 40px;
            padding: 20px;
            background-color: #0b5ed7;
            color: white;
        }

        @media(max-width: 700px) {
            .ambulance-types {
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
            <a href="<%= request.getContextPath() %>/index.jsp">Home</a>
            <a href="<%= request.getContextPath() %>/index.jsp#services">Services</a>
            <a href="<%= request.getContextPath() %>/emergency/emergency.jsp">Emergency</a>
        </div>
    </div>

    <div class="container">

        <div class="heading">
            <h1>🚑 Emergency Ambulance</h1>
            <p>Request an ambulance quickly during a medical emergency.</p>
        </div>

        <div class="emergency-box">
            <h2>🚨 Life-Threatening Emergency?</h2>
            <p>
                If the patient is in critical condition, call the emergency
                service immediately.
            </p>

            <a href="tel:112" class="call-button">📞 Call 112 Now</a>
        </div>

        <h2>Available Ambulance Types</h2>

        <div class="ambulance-types">

            <div class="type-card">
                <h3>🚑 Basic Ambulance</h3>
                <p>
                    Suitable for patients who need transportation
                    but do not require advanced medical support.
                </p>
                <b>Equipment:</b>
                <p>First Aid Kit, Stretcher, Oxygen</p>
            </div>

            <div class="type-card">
                <h3>🚑 ICU Ambulance</h3>
                <p>
                    Suitable for critical patients who require
                    medical monitoring during transportation.
                </p>
                <b>Equipment:</b>
                <p>Ventilator, Monitor, Oxygen, Stretcher</p>
            </div>

            <div class="type-card">
                <h3>🚑 Patient Transport</h3>
                <p>
                    For transferring stable patients between
                    home, hospital or medical facilities.
                </p>
                <b>Equipment:</b>
                <p>Stretcher, Wheelchair, First Aid</p>
            </div>

        </div>

        <div class="form-box">

            <h2>🚑 Request an Ambulance</h2>

            <form action="<%= request.getContextPath() %>/emergency_ambulance"
                  method="post">

                <label>Patient Name</label>
                <input type="text"
                       name="patientName"
                       placeholder="Enter patient name"
                       maxlength="100"
                       required>

                <label>Contact Number</label>
                <input type="tel"
                       name="contact"
                       placeholder="Enter contact number"
                       maxlength="15"
                       required>

                <label>Patient Age</label>
                <input type="number"
                       name="age"
                       placeholder="Enter age"
                       min="1"
                       max="120"
                       required>

                <label>Emergency Type</label>
                <select name="emergencyType" required>
                    <option value="">-- Select Emergency --</option>
                    <option value="Accident">Accident</option>
                    <option value="Chest Pain">Chest Pain</option>
                    <option value="Breathing Problem">Breathing Problem</option>
                    <option value="Unconscious">Unconscious</option>
                    <option value="Severe Bleeding">Severe Bleeding</option>
                    <option value="Pregnancy">Pregnancy</option>
                    <option value="Other">Other</option>
                </select>

                <label>Ambulance Type</label>
                <select name="ambulanceType" required>
                    <option value="">-- Select Ambulance --</option>
                    <option value="Basic Ambulance">Basic Ambulance</option>
                    <option value="ICU Ambulance">ICU Ambulance</option>
                    <option value="Patient Transport">Patient Transport</option>
                </select>

                <label>Pickup Location</label>
                <input type="text"
                       name="pickupLocation"
                       placeholder="Enter pickup location"
                       maxlength="250"
                       required>

                <button type="submit" class="submit-button">
                    🚑 Request Ambulance
                </button>

            </form>
        </div>

    </div>

    <div class="footer">
        © 2026 MediBridge | Emergency Healthcare Services
    </div>

</body>
</html>
