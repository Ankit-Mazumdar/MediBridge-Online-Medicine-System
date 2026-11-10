
<%@page import="java.util.List"%>
<%@page import="java.net.URLEncoder"%>
<%@page import="model.Doctor"%>

<%
    if (session.getAttribute("admin") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Doctor> doctors =
        (List<Doctor>) request.getAttribute("doctors");

    String message = request.getParameter("message");
    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Doctor Management | MediBridge</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            padding: 25px;
            font-family: Arial, sans-serif;
            background: #f3f6fb;
            color: #172b4d;
        }

        .container {
            max-width: 1400px;
            margin: auto;
        }

        h1 {
            margin-bottom: 8px;
            color: #12345a;
        }

        .subtitle {
            color: #64748b;
            margin-bottom: 25px;
        }

        .card {
            background: white;
            padding: 24px;
            margin-bottom: 25px;
            border-radius: 12px;
            box-shadow: 0 3px 12px rgba(0, 0, 0, 0.06);
        }

        h2 {
            margin-top: 0;
            color: #12345a;
        }

        .message {
            padding: 12px;
            margin-bottom: 18px;
            border-radius: 7px;
            background: #e0f2fe;
            color: #075985;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        th, td {
            padding: 13px 12px;
            border-bottom: 1px solid #e5eaf1;
            text-align: left;
            vertical-align: top;
        }

        th {
            background: #12345a;
            color: white;
            white-space: nowrap;
        }

        tr:hover td {
            background: #f8fafc;
        }

        .status {
            display: inline-block;
            padding: 5px 9px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .PENDING {
            background: #fff3cd;
            color: #856404;
        }

        .APPROVED {
            background: #d1fae5;
            color: #065f46;
        }

        .REJECTED {
            background: #fee2e2;
            color: #991b1b;
        }

        .btn {
            display: inline-block;
            border: none;
            padding: 9px 12px;
            margin: 3px 2px;
            border-radius: 6px;
            color: white;
            text-decoration: none;
            font-size: 12px;
            cursor: pointer;
            white-space: nowrap;
        }

        .btn-view {
            background: #2563eb;
        }

        .btn-approve {
            background: #059669;
        }

        .btn-reject {
            background: #dc2626;
        }

        .btn-add {
            background: #12345a;
            padding: 11px 18px;
            font-size: 14px;
        }

        .btn:hover {
            opacity: 0.85;
        }

        .document-actions,
        .status-actions {
            margin-bottom: 8px;
        }

        .document-label {
            display: block;
            font-size: 12px;
            font-weight: bold;
            color: #475569;
            margin: 8px 0 3px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(180px, 1fr));
            gap: 16px;
        }

        .form-group label {
            display: block;
            margin-bottom: 7px;
            font-size: 13px;
            font-weight: bold;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 11px;
            border: 1px solid #cbd5e1;
            border-radius: 7px;
            background: white;
        }

        .form-actions {
            margin-top: 20px;
        }

        .empty {
            text-align: center;
            padding: 25px;
            color: #64748b;
        }

        @media (max-width: 750px) {
            body {
                padding: 12px;
            }

            .card {
                padding: 15px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }
        }
        .back-dashboard {
    display: inline-block;
    margin-bottom: 20px;
    padding: 10px 18px;
    background: #1e293b;
    color: white;
    text-decoration: none;
    border-radius: 8px;
    font-weight: 600;
}

.back-dashboard:hover {
    background: #334155;
}
    </style>
</head>

<body>
    
    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp"
   class="back-dashboard">
    ? Back to Dashboard
</a>
<div class="container">

    <h1>Doctor Management</h1>
    <p class="subtitle">
        View registered doctors, verify their documents, and manage approval status.
    </p>

    <% if (message != null && !message.trim().isEmpty()) { %>
        <div class="message">
            <%= message.replace("&", "&amp;")
                       .replace("<", "&lt;")
                       .replace(">", "&gt;")
                       .replace("\"", "&quot;")
                       .replace("'", "&#39;") %>
        </div>
    <% } %>

    <!-- DOCTOR LIST -->
    <div class="card">
        <h2>Registered Doctors</h2>

        <div class="table-wrapper">
            <table>
                <thead>
                <tr>
                    <th>Doctor ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Specialization</th>
                    <th>Qualification</th>
                    <th>Status</th>
                    <th>Documents &amp; Actions</th>
                </tr>
                </thead>

                <tbody>
                <% if (doctors != null && !doctors.isEmpty()) {
                       for (Doctor doctor : doctors) {
                           String doctorId = doctor.getDoctorId();
                           String status = doctor.getStatus() == null
                               ? "PENDING"
                               : doctor.getStatus().toUpperCase();
                %>

                    <tr>
                        <td>
                            <%= doctorId == null ? "N/A" : doctorId %>
                        </td>

                        <td>
                            <%= doctor.getFullName() == null
                                ? "" : doctor.getFullName() %>
                        </td>

                        <td>
                            <%= doctor.getEmail() == null
                                ? "" : doctor.getEmail() %>
                        </td>

                        <td>
                            <%= doctor.getPhone() == null
                                ? "" : doctor.getPhone() %>
                        </td>

                        <td>
                            <%= doctor.getSpecialization() == null
                                ? "" : doctor.getSpecialization() %>
                        </td>

                        <td>
                            <%= doctor.getQualification() == null
                                ? "" : doctor.getQualification() %>
                        </td>

                        <td>
                            <span class="status <%= status %>">
                                <%= status %>
                            </span>
                        </td>

                       
<td>
    <% if (doctor.getEmail() != null &&
           !doctor.getEmail().trim().isEmpty()) { %>

        <div class="document-actions">
            <span class="document-label">
                Verification Documents
            </span>

            <a class="btn btn-view"
               href="<%= contextPath %>/admin/doctorDocument?email=<%= URLEncoder.encode(doctor.getEmail(), "UTF-8") %>&amp;type=certificate"
               target="_blank"
               rel="noopener noreferrer">
                View Medical Certificate
            </a>

            <a class="btn btn-view"
               href="<%= contextPath %>/admin/doctorDocument?email=<%= URLEncoder.encode(doctor.getEmail(), "UTF-8") %>&amp;type=govtId"
               target="_blank"
               rel="noopener noreferrer">
                View Government ID
            </a>
        </div>

    <% } else { %>

        <p style="color:#dc2626;font-size:12px;">
            Doctor email is missing. Cannot retrieve documents.
        </p>

    <% } %>

    <% if ("PENDING".equalsIgnoreCase(status)) { %>

        <form method="post"
              action="<%= contextPath %>/admin/doctors"
              style="display:inline;">

            <input type="hidden" name="action" value="status">
            <input type="hidden" name="email"
                   value="<%= doctor.getEmail() %>">
            <input type="hidden" name="status" value="APPROVED">

            <button type="submit" class="btn btn-approve">
                Approve
            </button>
        </form>

        <form method="post"
              action="<%= contextPath %>/admin/doctors"
              style="display:inline;">

            <input type="hidden" name="action" value="status">
            <input type="hidden" name="email"
                   value="<%= doctor.getEmail() %>">
            <input type="hidden" name="status" value="REJECTED">

            <button type="submit" class="btn btn-reject">
                Reject
            </button>
        </form>

    <% } %>
</td>

                    </tr>

                <%     }
                   } else { %>

                    <tr>
                        <td colspan="8" class="empty">
                            No doctors found.
                        </td>
                    </tr>

                <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <!-- ADD DOCTOR -->
    <div class="card">
        <h2>Add Doctor</h2>
        <p class="subtitle">
            Doctors added by the administrator will be marked as APPROVED.
        </p>

        <form method="post"
              action="<%= contextPath %>/admin/doctors">

            <input type="hidden" name="action" value="add">

            <div class="form-grid">

                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName"
                           required>
                </div>

                <div class="form-group">
                    <label for="email">Email *</label>
                    <input type="email" id="email" name="email"
                           required>
                </div>

                <div class="form-group">
                    <label for="password">Password *</label>
                    <input type="password" id="password" name="password"
                           required>
                </div>

                <div class="form-group">
                    <label for="phone">Phone *</label>
                    <input type="text" id="phone" name="phone"
                           maxlength="15" required>
                </div>

                <div class="form-group">
                    <label for="gender">Gender</label>
                    <select id="gender" name="gender">
                        <option value="">Select Gender</option>
                        <option value="Male">Male</option>
                        <option value="Female">Female</option>
                        <option value="Other">Other</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="specialization">Specialization *</label>
                    <input type="text" id="specialization"
                           name="specialization" required>
                </div>

                <div class="form-group">
                    <label for="qualification">Qualification</label>
                    <input type="text" id="qualification"
                           name="qualification">
                </div>

                <div class="form-group">
                    <label for="registrationNo">
                        Medical Registration No. *
                    </label>
                    <input type="text" id="registrationNo"
                           name="registrationNo" required>
                </div>

                <div class="form-group">
                    <label for="experience">Experience (years)</label>
                    <input type="number" id="experience" name="experience"
                           min="0" max="99">
                </div>

            </div>

            <div class="form-actions">
                <button type="submit" class="btn btn-add">
                    Add Doctor
                </button>
            </div>
        </form>
    </div>

</div>
</body>
</html>
