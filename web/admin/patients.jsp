
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="model.PatientBean" %>

<%
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }

    List<PatientBean> patients =
        (List<PatientBean>) request.getAttribute("patients");

    Integer totalPatients =
        (Integer) request.getAttribute("totalPatients");

    if (patients == null) {
        response.sendRedirect(request.getContextPath() + "/admin/patients");
        return;
    }

    String contextPath = request.getContextPath();
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd MMM yyyy");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Patient Management | MediBridge</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #172b4d;
        }

        .navbar {
            background: #102a43;
            color: white;
            padding: 20px 5%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .brand {
            font-size: 23px;
            font-weight: bold;
        }

        .navbar a {
            color: white;
            text-decoration: none;
            font-size: 14px;
        }

        .container {
            max-width: 1450px;
            margin: 35px auto;
            padding: 0 22px;
        }

        .page-heading {
            margin-bottom: 25px;
        }

        .page-heading h1 {
            margin: 0 0 8px;
            font-size: 28px;
        }

        .page-heading p {
            margin: 0;
            color: #64748b;
        }

        .summary {
            background: white;
            border-radius: 12px;
            padding: 22px;
            margin-bottom: 25px;
            border: 1px solid #e2e8f0;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.04);
            max-width: 300px;
        }

        .summary-label {
            color: #64748b;
            font-size: 14px;
        }

        .summary-number {
            font-size: 34px;
            font-weight: bold;
            color: #087e8b;
            margin-top: 10px;
        }

        .table-card {
            background: white;
            border-radius: 12px;
            border: 1px solid #e2e8f0;
            overflow: hidden;
            box-shadow: 0 3px 12px rgba(15, 23, 42, 0.04);
        }

        .table-header {
            padding: 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 15px;
            flex-wrap: wrap;
        }

        .table-header h2 {
            margin: 0;
            font-size: 19px;
        }

        #searchInput {
            padding: 11px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 8px;
            width: 300px;
            max-width: 100%;
            font-size: 14px;
        }

        .table-wrapper {
            width: 100%;
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1050px;
        }

        th {
            background: #f1f5f9;
            color: #475569;
            text-align: left;
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            padding: 15px;
        }

        td {
            padding: 16px 15px;
            border-top: 1px solid #e8edf4;
            font-size: 14px;
            vertical-align: middle;
        }

        tbody tr:hover {
            background: #f8fafc;
        }

        .patient-name {
            font-weight: bold;
            color: #102a43;
        }

        .patient-id {
            color: #64748b;
            font-size: 12px;
            margin-top: 5px;
        }

        .appointment-count {
            display: inline-block;
            background: #e0f7f7;
            color: #087e8b;
            font-weight: bold;
            padding: 7px 12px;
            border-radius: 20px;
            min-width: 35px;
            text-align: center;
        }

        .empty-state {
            padding: 45px 20px;
            text-align: center;
            color: #64748b;
        }

        .back-link {
            display: inline-block;
            margin-top: 22px;
            color: #087e8b;
            text-decoration: none;
            font-weight: bold;
        }

        @media (max-width: 600px) {
            .container {
                margin-top: 24px;
                padding: 0 12px;
            }

            .page-heading h1 {
                font-size: 23px;
            }

            #searchInput {
                width: 100%;
            }
        }
    </style>
</head>

<body>

    <div class="navbar">
        <div class="brand">MediBridge</div>
        <a href="<%= contextPath %>/admin/dashboard.jsp">
             Admin Dashboard
        </a>
    </div>

    <div class="container">

        <div class="page-heading">
            <h1>Patient Management</h1>
            <p>View registered patients and their appointment history.</p>
        </div>

        <div class="summary">
            <div class="summary-label">Total Registered Patients</div>
            <div class="summary-number">
                <%= totalPatients == null ? 0 : totalPatients %>
            </div>
        </div>

        <div class="table-card">

            <div class="table-header">
                <h2>Registered Patients</h2>

                <input
                    type="text"
                    id="searchInput"
                    placeholder="Search name, email, contact or ID..."
                    onkeyup="filterPatients()">
            </div>

            <div class="table-wrapper">
                <table id="patientsTable">
                    <thead>
                        <tr>
                            <th>Patient</th>
                            <th>Email</th>
                            <th>Contact</th>
                            <th>Date of Birth</th>
                            <th>Gender</th>
                            <th>Blood Group</th>
                            <th>Total Appointments</th>
                        </tr>
                    </thead>

                    <tbody>
                    <% if (patients.isEmpty()) { %>
                        <tr>
                            <td colspan="7" class="empty-state">
                                No registered patients found.
                            </td>
                        </tr>
                    <% } else {
                        for (PatientBean p : patients) {
                    %>
                        <tr>
                            <td>
                                <div class="patient-name">
                                    <%= p.getName() == null ? "-" : p.getName() %>
                                </div>
                                <div class="patient-id">
                                    ID: <%= p.getPatientId() %>
                                </div>
                            </td>

                            <td><%= p.getEmail() == null ? "-" : p.getEmail() %></td>

                            <td><%= p.getContact() == null ? "-" : p.getContact() %></td>

                            <td>
                                <%= p.getDob() == null
                                    ? "-"
                                    : dateFormat.format(p.getDob()) %>
                            </td>

                            <td><%= p.getGender() == null ? "-" : p.getGender() %></td>

                            <td><%= p.getBloodGroup() == null ? "-" : p.getBloodGroup() %></td>

                            <td>
                                <span class="appointment-count">
                                    <%= p.getTotalAppointments() %>
                                </span>
                            </td>
                        </tr>
                    <%  }
                       } %>
                    </tbody>
                </table>
            </div>
        </div>

        <a class="back-link"
           href="<%= contextPath %>/admin/dashboard.jsp">
             Back to Dashboard
        </a>

    </div>

    <script>
        function filterPatients() {
            var input = document.getElementById("searchInput");
            var filter = input.value.toLowerCase();
            var table = document.getElementById("patientsTable");
            var rows = table.getElementsByTagName("tbody")[0]
                            .getElementsByTagName("tr");

            for (var i = 0; i < rows.length; i++) {
                var text = rows[i].textContent || rows[i].innerText;
                rows[i].style.display =
                    text.toLowerCase().indexOf(filter) > -1 ? "" : "none";
            }
        }
    </script>

</body>
</html>
