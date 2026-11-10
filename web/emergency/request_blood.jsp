
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>MediBridge | Blood Bank</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/emergency.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/blood.css">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/Emergency_blood.css">

    <style>
        .blood-request-form {
            max-width: 650px;
            margin: 35px auto;
            padding: 30px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.10);
        }

        .blood-request-form h2 {
            color: #0b5ed7;
            margin-bottom: 10px;
        }

        .blood-request-form label {
            display: block;
            margin-top: 18px;
            font-weight: bold;
            color: #333;
        }

        .blood-request-form input,
        .blood-request-form select {
            width: 100%;
            padding: 12px;
            margin-top: 7px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .blood-submit {
            width: 100%;
            padding: 14px;
            margin-top: 25px;
            background: #d90429;
            color: white;
            border: none;
            border-radius: 7px;
            font-size: 16px;
            font-weight: bold;
            cursor: pointer;
        }

        .blood-submit:hover {
            background: #b80020;
        }

        .blood-intro {
            text-align: center;
            padding: 35px 15px 10px;
        }

        .blood-intro h1 {
            color: #d90429;
        }

        .blood-intro p {
            color: #666;
        }

        .blood-footer {
            text-align: center;
            padding: 20px;
            margin-top: 40px;
            background: #0b5ed7;
            color: white;
        }

        .blood-navbar {
            background: #0b5ed7;
            padding: 18px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .blood-brand {
            color: white;
            font-size: 25px;
            font-weight: bold;
            text-decoration: none;
        }

        .blood-nav-links a {
            color: white;
            text-decoration: none;
            margin-left: 22px;
        }

        @media(max-width: 650px) {
            .blood-navbar {
                flex-direction: column;
                gap: 15px;
            }

            .blood-nav-links a {
                margin: 0 8px;
            }

            .blood-request-form {
                width: 85%;
                padding: 20px;
            }
        }
    </style>
</head>

<body>

<!-- Navigation -->
<header class="blood-navbar">

    <a href="<%= request.getContextPath() %>/index.jsp"
       class="blood-brand">
        MediBridge
    </a>

    <nav class="blood-nav-links">

        <a href="<%= request.getContextPath() %>/index.jsp">
            Home
        </a>

        <a href="<%= request.getContextPath() %>/index.jsp#services">
            Services
        </a>

        <a href="<%= request.getContextPath() %>/emergency/emergency.jsp">
            Emergency
        </a>

    </nav>

</header>

<main class="blood-page">

    <section class="blood-intro">

        <h1>🩸 Find, Check & Request Blood</h1>

        <p>
            Search blood availability by blood group or submit a request.
            Our blood bank team will review your request.
        </p>

    </section>

  
     

    <!-- Blood Request Form -->
    <section class="blood-request-form">

        <h2>🩸 Request Blood</h2>

        <p>
            Fill in the details below if the required blood
            group is limited or unavailable.
        </p>

        <form action="<%= request.getContextPath() %>/emergency_blood"
              method="post">

            <label>Patient Name</label>

            <input type="text"
                   name="patientName"
                   placeholder="Enter patient name"
                   maxlength="100"
                   required>

            <label>Blood Group</label>

            <select name="bloodGroup" required>

                <option value="">Select blood group</option>

                <option value="A+">A+</option>
                <option value="A-">A-</option>
                <option value="B+">B+</option>
                <option value="B-">B-</option>
                <option value="O+">O+</option>
                <option value="O-">O-</option>
                <option value="AB+">AB+</option>
                <option value="AB-">AB-</option>

            </select>

            <label>Units Required</label>

            <input type="number"
                   name="unitsRequired"
                   placeholder="Enter number of units"
                   min="1"
                   required>

            <label>Contact Number</label>

            <input type="tel"
                   name="contactNumber"
                   placeholder="Enter contact number"
                   maxlength="15"
                   pattern="[0-9+\-\s]{7,15}"
                   required>

            <button type="submit" class="blood-submit">
                🩸 Submit Blood Request
            </button>

        </form>

    </section>

</main>

<footer class="blood-footer">
    © 2026 MediBridge. All rights reserved.
</footer>

</body>
</html>
