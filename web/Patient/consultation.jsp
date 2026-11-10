
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="model.PatientBean" %>
<%@ page import="dao.PatientAppointmentDAO" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>

<%
    PatientBean patient =
        (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect(
            request.getContextPath() + "/Patient/PatientLogin.jsp"
        );
        return;
    }

    String id = request.getParameter("appointmentId");

    if (id == null || !id.matches("\\d+")) {
        response.sendRedirect(
            request.getContextPath() + "/Patient/PatientDashboard.jsp"
        );
        return;
    }

    int appointmentId = Integer.parseInt(id);

    PatientAppointmentDAO dao = new PatientAppointmentDAO();

    String meetingRoom = dao.getMeetingRoomForPatient(
        appointmentId,
        patient.getEmail()
    );

    if (meetingRoom == null || meetingRoom.trim().isEmpty()) {
        response.sendError(
            HttpServletResponse.SC_FORBIDDEN,
            "This consultation is not available."
        );
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>Patient Video Consultation | MediBridge</title>

    <style>

        body {
            margin: 0;
            font-family: Arial, sans-serif;
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
            font-size: 23px;
            font-weight: bold;
            color: #0f766e;
        }

        .container {
            max-width: 1100px;
            margin: 35px auto;
            padding: 20px;
        }

        .heading {
            margin-bottom: 20px;
        }

        .heading h1 {
            margin-bottom: 8px;
        }

        .heading p {
            color: #64748b;
        }

        .video-card {
            background: white;
            padding: 18px;
            border-radius: 15px;
            border: 1px solid #e2e8f0;
        }

        #jitsi-container {
            width: 100%;
            height: 650px;
            background: #0f172a;
            border-radius: 12px;
            overflow: hidden;
        }

        #meeting-status {
            margin: 10px 0 15px;
            color: #64748b;
        }

        .leave-button {
            display: inline-block;
            margin-top: 20px;
            padding: 13px 22px;
            background: #0f766e;
            color: white;
            text-decoration: none;
            border-radius: 8px;
            font-weight: bold;
        }

    </style>

</head>

<body>

<header class="header">

    <div class="brand">
        MediBridge
    </div>

    <strong>
        <%= patient.getName() %>
    </strong>

</header>

<main class="container">

    <div class="heading">

        <h1>Video Consultation</h1>

        <p>
            Welcome, <%= patient.getName() %>
        </p>

        <p>
            Appointment #<%= appointmentId %>
        </p>

    </div>

    <div class="video-card">

        <div id="meeting-status">
            Connecting to your doctor...
        </div>

        <div id="jitsi-container"></div>

        <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
           class="leave-button">
            Return to Dashboard
        </a>

    </div>

</main>

<script src="https://meet.jit.si/external_api.js"></script>

<script>

    const roomName = "<%= meetingRoom %>";

    const options = {

        roomName: roomName,

        width: "100%",
        height: 650,

        parentNode: document.getElementById("jitsi-container"),

        userInfo: {
            displayName: "<%= patient.getName().replace("\\", "\\\\").replace("\"", "\\\"") %>"
        },

        configOverwrite: {
            prejoinPageEnabled: false,
            startWithAudioMuted: false,
            startWithVideoMuted: false
        }

    };

    const api = new JitsiMeetExternalAPI(
        "meet.jit.si",
        options
    );

    api.addEventListener("videoConferenceJoined", function() {

        document.getElementById("meeting-status").innerText =
            "Connected! You can now talk to your doctor.";

    });

    api.addEventListener("videoConferenceLeft", function() {

        document.getElementById("meeting-status").innerText =
            "You have left the consultation.";

    });

</script>

</body>
</html>
