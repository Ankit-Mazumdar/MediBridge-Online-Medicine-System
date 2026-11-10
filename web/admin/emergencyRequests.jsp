<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>

<%!
    // Escape database values before displaying them
    private String esc(Object value) {

        if (value == null) {
            return "-";
        }

        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;")
                .replace("'", "&#39;");
    }
%>

<%
    // Check admin login
    if (session == null || session.getAttribute("admin") == null) {

        response.sendRedirect(
                request.getContextPath() + "/login.jsp#admin"
        );

        return;
    }

    // Get requests from servlet
    List<Map<String, Object>> ambulance =
            (List<Map<String, Object>>) request.getAttribute("ambulanceRequests");

    List<Map<String, Object>> blood =
            (List<Map<String, Object>>) request.getAttribute("bloodRequests");

    List<Map<String, Object>> rooms =
            (List<Map<String, Object>>) request.getAttribute("roomRequests");

    List<Map<String, Object>> doctors =
            (List<Map<String, Object>>) request.getAttribute("doctorRequests");

    // Prevent null errors
    if (ambulance == null) {
        ambulance = new ArrayList<Map<String, Object>>();
    }

    if (blood == null) {
        blood = new ArrayList<Map<String, Object>>();
    }

    if (rooms == null) {
        rooms = new ArrayList<Map<String, Object>>();
    }

    if (doctors == null) {
        doctors = new ArrayList<Map<String, Object>>();
    }

    String ctx = request.getContextPath();

    // Selected section
    String section = request.getParameter("section");

    if (section == null) {
        section = "ambulance";
    }

    // Validate section
    if (!section.equals("ambulance")
            && !section.equals("blood")
            && !section.equals("room")
            && !section.equals("doctor")) {

        section = "ambulance";
    }
%>

<!DOCTYPE html>
<html lang="en">

<head>

    <meta charset="UTF-8">

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>MediBridge | Emergency Requests</title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            background: #f4f7fb;
            color: #1e293b;
            font-family: Arial, sans-serif;
        }

        .main {
            padding: 30px;
            max-width: 1500px;
            margin: auto;
        }

        /* Page heading */

        .heading {
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
            margin-bottom: 25px;
        }

        .heading h1 {
            margin: 0;
            font-size: 27px;
            color: #173b68;
        }

        .heading p {
            color: #64748b;
            margin-bottom: 0;
        }

        .back {
            color: white;
            background: #173b68;
            padding: 11px 18px;
            border-radius: 7px;
            text-decoration: none;
            font-size: 13px;
        }

        .back:hover {
            background: #24568e;
        }

        /* Navigation tabs */

        .tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 25px;
        }

        .tab {
            text-decoration: none;
            padding: 13px 20px;
            border-radius: 8px;
            background: white;
            color: #334155;
            font-weight: bold;
            border: 1px solid #e2e8f0;
            font-size: 13px;
        }

        .tab:hover {
            background: #eaf1fa;
        }

        .tab.active {
            background: #173b68;
            color: white;
            border-color: #173b68;
        }

        /* Main panel */

        .panel {
            background: white;
            border-radius: 12px;
            padding: 22px;
            box-shadow: 0 3px 15px rgba(0, 0, 0, .04);
        }

        .panel h2 {
            margin-top: 0;
            font-size: 21px;
            color: #173b68;
        }

        .count {
            color: #64748b;
            font-size: 13px;
            margin-bottom: 18px;
        }

        /* Tables */

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 850px;
        }

        th,
        td {
            text-align: left;
            padding: 14px 12px;
            border-bottom: 1px solid #e9eef5;
            font-size: 13px;
            vertical-align: middle;
        }

        th {
            background: #f8fafc;
            color: #475569;
            font-weight: bold;
        }

        tr:hover td {
            background: #fafcff;
        }

        /* Status labels */

        .status {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 20px;
            font-size: 11px;
            font-weight: bold;
            background: #e2e8f0;
            color: #334155;
            white-space: nowrap;
        }

        .status.AVAILABLE,
        .status.APPROVED,
        .status.COMPLETED {
            background: #dcfce7;
            color: #166534;
        }

        .status.LIMITED,
        .status.PENDING,
        .status.IN_PROGRESS,
        .status.ASSIGNED {
            background: #fef3c7;
            color: #92400e;
        }

        .status.OUT_OF_STOCK,
        .status.REJECTED {
            background: #fee2e2;
            color: #991b1b;
        }

        /* Forms */

        select {
            padding: 9px 10px;
            border-radius: 6px;
            border: 1px solid #cbd5e1;
            background: white;
            font-size: 12px;
        }

        button {
            padding: 9px 13px;
            border-radius: 6px;
            border: none;
            background: #173b68;
            color: white;
            cursor: pointer;
            font-size: 12px;
            margin-top: 5px;
        }

        button:hover {
            background: #24568e;
        }

        .update-form {
            min-width: 130px;
        }

        .update-form select {
            width: 100%;
            margin-bottom: 4px;
        }

        /* Empty state */

        .empty {
            padding: 40px 20px;
            text-align: center;
            color: #64748b;
            background: #f8fafc;
            border-radius: 8px;
        }

        /* Responsive */

        @media (max-width: 600px) {

            .main {
                padding: 15px;
            }

            .panel {
                padding: 15px;
            }

            .heading h1 {
                font-size: 23px;
            }

            .tab {
                padding: 10px 12px;
            }
        }

    </style>

</head>

<body>

<div class="main">

    <!-- PAGE HEADING -->

    <div class="heading">

        <div>

            <h1>Emergency Requests</h1>

            <p>
                Manage all emergency assistance requests.
            </p>

        </div>

        <a href="<%=ctx%>/admin/dashboard.jsp" class="back">
            Back to Dashboard
        </a>

    </div>


    <!-- FOUR SECTIONS -->

    <div class="tabs">

        <a class="tab <%= "ambulance".equals(section) ? "active" : "" %>"
           href="<%=ctx%>/admin/emergency-requests?section=ambulance">

            Ambulance (<%= ambulance.size() %>)

        </a>

        <a class="tab <%= "blood".equals(section) ? "active" : "" %>"
           href="<%=ctx%>/admin/emergency-requests?section=blood">

            Blood (<%= blood.size() %>)

        </a>

        <a class="tab <%= "room".equals(section) ? "active" : "" %>"
           href="<%=ctx%>/admin/emergency-requests?section=room">

            Bed / Room (<%= rooms.size() %>)

        </a>

        <a class="tab <%= "doctor".equals(section) ? "active" : "" %>"
           href="<%=ctx%>/admin/emergency-requests?section=doctor">

            Emergency Doctor (<%= doctors.size() %>)

        </a>

    </div>


    <!-- MAIN CONTENT -->

    <div class="panel">


        <!-- ================================= -->
        <!-- 1. AMBULANCE REQUESTS -->
        <!-- ================================= -->

        <% if ("ambulance".equals(section)) { %>

            <h2>Ambulance Requests</h2>

            <p class="count">
                View and manage patient ambulance requests.
            </p>

            <% if (ambulance.isEmpty()) { %>

                <div class="empty">
                    No ambulance requests found.
                </div>

            <% } else { %>

                <div class="table-wrap">

                    <table>

                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Contact</th>
                            <th>Age</th>
                            <th>Emergency / Ambulance</th>
                            <th>Pickup Location</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Update</th>
                        </tr>

                        <% for (Map<String, Object> r : ambulance) {

                            String currentStatus =
                                    String.valueOf(r.get("STATUS")).trim();

                            boolean terminal =
                                    "COMPLETED".equalsIgnoreCase(currentStatus)
                                    || "REJECTED".equalsIgnoreCase(currentStatus);
                        %>

                            <tr>

                                <td>
                                    <%= esc(r.get("REQUEST_ID")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("PATIENT_NAME")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("CONTACT")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("AGE")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("DETAIL")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("LOCATION")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("REQUEST_DATE")) %>
                                </td>

                                <td>
                                    <span class="status">
                                        <%= esc(r.get("STATUS")) %>
                                    </span>
                                </td>

                                <td>

                                    <% if (!terminal) { %>

                                        <form class="update-form"
                                              action="<%=ctx%>/admin/update-emergency-request"
                                              method="post">

                                            <input type="hidden"
                                                   name="type"
                                                   value="ambulance">

                                            <input type="hidden"
                                                   name="section"
                                                   value="ambulance">

                                            <input type="hidden"
                                                   name="requestId"
                                                   value="<%= esc(r.get("REQUEST_ID")) %>">

                                            <select name="status">

                                                <option value="PENDING">Pending</option>

                                                <option value="APPROVED">Approved</option>

                                                <option value="IN_PROGRESS">In Progress</option>

                                                <option value="COMPLETED">Completed</option>

                                                <option value="REJECTED">Rejected</option>

                                            </select>

                                            <button type="submit">
                                                Update
                                            </button>

                                        </form>

                                    <% } %>

                                </td>

                            </tr>

                        <% } %>

                    </table>

                </div>

            <% } %>

        <% } %>


        <!-- ================================= -->
        <!-- 2. BLOOD REQUESTS -->
        <!-- ================================= -->

        <% if ("blood".equals(section)) { %>

            <h2>Blood Requests</h2>

            <p class="count">
                Manage patient blood requests.
            </p>

            <% if (blood.isEmpty()) { %>

                <div class="empty">
                    No blood requests found.
                </div>

            <% } else { %>

                <div class="table-wrap">

                    <table>

                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Contact</th>
                            <th>Blood Details</th>
                            <th>Request Status</th>
                            <th>Update Status</th>
                        </tr>

                        <% for (Map<String, Object> r : blood) {

                            String currentStatus =
                                    String.valueOf(r.get("STATUS")).trim();

                            boolean terminal =
                                    "COMPLETED".equalsIgnoreCase(currentStatus)
                                    || "REJECTED".equalsIgnoreCase(currentStatus);
                        %>

                            <tr>

                                <td>
                                    <%= esc(r.get("REQUEST_ID")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("PATIENT_NAME")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("CONTACT")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("DETAIL")) %>
                                </td>

                                <td>
                                    <span class="status <%= esc(currentStatus.toUpperCase()) %>">
                                        <%= esc(currentStatus) %>
                                    </span>
                                </td>

                                <td>

                                    <% if (!terminal) { %>

                                        <form class="update-form"
                                              action="<%=ctx%>/admin/update-emergency-request"
                                              method="post">

                                            <input type="hidden"
                                                   name="type"
                                                   value="blood">

                                            <input type="hidden"
                                                   name="section"
                                                   value="blood">

                                            <input type="hidden"
                                                   name="requestId"
                                                   value="<%= esc(r.get("REQUEST_ID")) %>">

                                            <select name="status">

                                                <option value="PENDING">Pending</option>

                                                <option value="APPROVED">Approved</option>

                                                <option value="COMPLETED">Completed</option>

                                                <option value="REJECTED">Rejected</option>

                                            </select>

                                            <button type="submit">
                                                Update
                                            </button>

                                        </form>

                                    <% } else { %>

                                        <span class="status <%= esc(currentStatus.toUpperCase()) %>">
                                            <%= esc(currentStatus) %>
                                        </span>

                                    <% } %>

                                </td>

                            </tr>

                        <% } %>

                    </table>

                </div>

            <% } %>

        <% } %>


        <!-- ================================= -->
        <!-- 3. BED / ROOM REQUESTS -->
        <!-- ================================= -->

        <% if ("room".equals(section)) { %>

            <h2>Bed / Room Requests</h2>

            <p class="count">
                Manage emergency room and bed requests.
            </p>

            <% if (rooms.isEmpty()) { %>

                <div class="empty">
                    No room requests found.
                </div>

            <% } else { %>

                <div class="table-wrap">

                    <table>

                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Contact</th>
                            <th>Age</th>
                            <th>Bed Type</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Update</th>
                        </tr>

                        <% for (Map<String, Object> r : rooms) {

                            String currentStatus =
                                    String.valueOf(r.get("STATUS")).trim();

                            boolean terminal =
                                    "COMPLETED".equalsIgnoreCase(currentStatus)
                                    || "REJECTED".equalsIgnoreCase(currentStatus);
                        %>

                            <tr>

                                <td>
                                    <%= esc(r.get("REQUEST_ID")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("PATIENT_NAME")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("CONTACT")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("AGE")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("DETAIL")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("REQUEST_DATE")) %>
                                </td>

                                <td>
                                    <span class="status">
                                        <%= esc(r.get("STATUS")) %>
                                    </span>
                                </td>

                                <td>

                                    <% if (!terminal) { %>

                                        <form class="update-form"
                                              action="<%=ctx%>/admin/update-emergency-request"
                                              method="post">

                                            <input type="hidden"
                                                   name="type"
                                                   value="room">

                                            <input type="hidden"
                                                   name="section"
                                                   value="room">

                                            <input type="hidden"
                                                   name="requestId"
                                                   value="<%= esc(r.get("REQUEST_ID")) %>">

                                            <select name="status">

                                                <option value="PENDING">Pending</option>

                                                <option value="APPROVED">Approved</option>

                                                <option value="COMPLETED">Completed</option>

                                                <option value="REJECTED">Rejected</option>

                                            </select>

                                            <button type="submit">
                                                Update
                                            </button>

                                        </form>

                                    <% } %>

                                </td>

                            </tr>

                        <% } %>

                    </table>

                </div>

            <% } %>

        <% } %>


        <!-- ================================= -->
        <!-- 4. EMERGENCY DOCTOR REQUESTS -->
        <!-- ================================= -->

        <% if ("doctor".equals(section)) { %>

            <h2>Emergency Doctor Requests</h2>

            <p class="count">
                Manage emergency doctor assistance requests.
            </p>

            <% if (doctors.isEmpty()) { %>

                <div class="empty">
                    No emergency doctor requests found.
                </div>

            <% } else { %>

                <div class="table-wrap">

                    <table>

                        <tr>
                            <th>ID</th>
                            <th>Patient</th>
                            <th>Contact</th>
                            <th>Emergency Details</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Update</th>
                        </tr>

                        <% for (Map<String, Object> r : doctors) {

                            String currentStatus =
                                    String.valueOf(r.get("STATUS")).trim();

                            boolean terminal =
                                    "COMPLETED".equalsIgnoreCase(currentStatus)
                                    || "REJECTED".equalsIgnoreCase(currentStatus);
                        %>

                            <tr>

                                <td>
                                    <%= esc(r.get("REQUEST_ID")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("PATIENT_NAME")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("CONTACT")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("DETAIL")) %>
                                </td>

                                <td>
                                    <%= esc(r.get("REQUEST_DATE")) %>
                                </td>

                                <td>
                                    <span class="status">
                                        <%= esc(r.get("STATUS")) %>
                                    </span>
                                </td>

                                <td>

                                    <% if (!terminal) { %>

                                        <form class="update-form"
                                              action="<%=ctx%>/admin/update-emergency-request"
                                              method="post">

                                            <input type="hidden"
                                                   name="type"
                                                   value="doctor">

                                            <input type="hidden"
                                                   name="section"
                                                   value="doctor">

                                            <input type="hidden"
                                                   name="requestId"
                                                   value="<%= esc(r.get("REQUEST_ID")) %>">

                                            <select name="status">

                                                <option value="PENDING">Pending</option>

                                                <option value="ASSIGNED">Assigned</option>

                                                <option value="IN_PROGRESS">In Progress</option>

                                                <option value="COMPLETED">Completed</option>

                                                <option value="REJECTED">Rejected</option>

                                            </select>

                                            <button type="submit">
                                                Update
                                            </button>

                                        </form>

                                    <% } %>

                                </td>

                            </tr>

                        <% } %>

                    </table>

                </div>

            <% } %>

        <% } %>

    </div>

</div>

</body>

</html>