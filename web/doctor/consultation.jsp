
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.Doctor" %>
<%@ page import="dao.AppointmentDAO" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<%
    Doctor doctor = (Doctor) session.getAttribute("doctor");

    if (doctor == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String id = request.getParameter("appointmentId");

    if (id == null || !id.matches("\\d+")) {
        response.sendRedirect(request.getContextPath() + "/AppointmentServlet");
        return;
    }

    int appointmentId = Integer.parseInt(id);

    AppointmentDAO dao = new AppointmentDAO();

    String meetingRoom = dao.getMeetingRoomForDoctor(
        appointmentId,
        doctor.getDoctorId()
    );

    if (meetingRoom == null || meetingRoom.trim().isEmpty()) {
        response.sendError(
            HttpServletResponse.SC_NOT_FOUND,
            "Consultation room not found. Please check the appointment."
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Video Consultation | MediBridge</title>

    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <style>
        body {
            margin: 0;
            font-family: 'Inter', sans-serif;
            background: #f1f5f9;
            color: #0f172a;
        }

        .header {
            background: white;
            padding: 20px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            border-bottom: 1px solid #e2e8f0;
        }

        .brand {
            font-family: 'Manrope', sans-serif;
            font-size: 22px;
            font-weight: 800;
            color: #0f766e;
        }

        .header span {
            font-weight: 600;
        }

        .container {
            max-width: 1100px;
            margin: 35px auto;
            padding: 20px;
        }

        .heading {
            margin-bottom: 22px;
        }

        .heading h1 {
            font-family: 'Manrope', sans-serif;
            margin-bottom: 8px;
        }

        .heading p {
            color: #64748b;
        }

        .video-card {
            background: white;
            padding: 18px;
            border-radius: 16px;
            border: 1px solid #e2e8f0;
        }

        #jitsi-container {
            width: 100%;
            height: 650px;
            background: #0f172a;
            border-radius: 12px;
            overflow: hidden;
        }

        .actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 22px;
            gap: 15px;
            flex-wrap: wrap;
        }

        .back-button {
            color: #0f766e;
            text-decoration: none;
            font-weight: 600;
        }

        .complete-button {
            background: #dc2626;
            color: white;
            padding: 13px 22px;
            border: none;
            border-radius: 8px;
            font-weight: 700;
            cursor: pointer;
        }

        .complete-button:hover {
            background: #b91c1c;
        }

        #meeting-status {
            color: #64748b;
            margin: 12px 0;
        }
    </style>
</head>

<body>

<header class="header">
    <div class="brand">MediBridge</div>
    <span>Dr. <%= doctor.getFullName() %></span>
</header>

<main class="container">

    <div class="heading">
        <h1>Patient Video Consultation</h1>
        <p>Appointment #<%= appointmentId %></p>
        <p>Welcome, Dr. <%= doctor.getFullName() %></p>
    </div>

    <div class="video-card">

        <div id="meeting-status">
            Connecting to your consultation room...
        </div>

        <div id="jitsi-container"></div>

        <div class="actions">

            <a class="back-button"
               href="<%= request.getContextPath() %>/AppointmentServlet">
                Back to Appointments
            </a>

            <form action="<%= request.getContextPath() %>/AppointmentServlet"
                  method="post"
                  onsubmit="return confirm('Are you sure you want to complete this consultation?');">

                <input type="hidden"
                       name="appointmentId"
                       value="<%= appointmentId %>">

                <input type="hidden"
                       name="action"
                       value="complete">

                <button type="submit" class="complete-button">
                    Complete Consultation
                </button>

            </form>

        </div>

    </div>

</main>

<script src="https://meet.jit.si/external_api.js"></script>

<script>
    const roomName = "<%= meetingRoom %>";

    const domain = "meet.jit.si";

    const options = {
        roomName: roomName,
        width: "100%",
        height: 650,
        parentNode: document.getElementById("jitsi-container"),

        userInfo: {
            displayName: "Doctor"
        },

        configOverwrite: {
            prejoinPageEnabled: false,
            startWithAudioMuted: false,
            startWithVideoMuted: false
        }
    };

    const api = new JitsiMeetExternalAPI(domain, options);

    api.addEventListener("videoConferenceJoined", function () {
        document.getElementById("meeting-status").innerText =
            "You are connected to the consultation.";
    });

    api.addEventListener("videoConferenceLeft", function () {
        document.getElementById("meeting-status").innerText =
            "You have left the consultation.";
    });
</script>

</body>
</html>
