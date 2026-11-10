
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="admin.Admin" %>

<%
    Admin admin = (Admin) session.getAttribute("admin");

    if (admin == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp#admin");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title>Admin Dashboard | MediBridge</title>

    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@700;800&family=Inter:wght@400;500;600;700&display=swap"
          rel="stylesheet">

    <!-- Existing MediBridge stylesheet -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/style.css">

    <!-- Admin dashboard stylesheet -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/admin.css">
</head>

<body class="admin-page">

    <!-- Top Navigation -->
    <header class="admin-topbar">

        <div class="admin-brand">
            <div class="admin-brand-mark">M</div>

            <div>
                <h2>MediBridge</h2>
                <span>Administration Portal</span>
            </div>
        </div>

        <form action="<%= request.getContextPath() %>/admin/logout"
              method="post">

            <button type="submit" class="admin-logout">
                Logout
            </button>

        </form>

    </header>


    <!-- Dashboard Content -->
    <main class="admin-container">

        <!-- Welcome Section -->
        <section class="admin-welcome">

            <p class="admin-eyebrow">Admin Workspace</p>

            <h1>
                Welcome, <%= admin.getFullName() %>
            </h1>

            <p>
                Manage and monitor your MediBridge healthcare platform
                from one place.
            </p>

            <span class="admin-status">
                ● Account <%= admin.getStatus() %>
            </span>

        </section>


        <!-- Management Cards -->
        <h2 class="admin-section-heading">
            Platform Management
        </h2>

        <div class="admin-grid">


            <!-- Doctor Management -->
            <section class="admin-card"
                     onclick="window.location.href='<%= request.getContextPath() %>/admin/doctors'"
                     style="cursor: pointer;">

                <div class="admin-card-icon">⚕</div>

                <h3>Doctor Management</h3>

                <p>
                    Review doctor registrations, view medical certificates
                    and government IDs, approve or reject doctors,
                    and manage doctor accounts.
                </p>

            </section>


            <!-- Patient Management -->
            <section class="admin-card">

                <div class="admin-card-icon">♙</div>

                <a href="<%= request.getContextPath() %>/admin/patients">
                    <h3>Patient Management</h3>
                </a>

                <p>
                    View registered patients and their information.
                </p>

            </section>


            <!-- Admin Profile -->
            <section class="admin-card">

                <div class="admin-card-icon">👤</div>

                <h3>Admin Profile</h3>

                <p>
                    View your administrator account information.
                </p>

                <a href="<%= request.getContextPath() %>/admin/profile"
                   class="admin-card-link">
                    View Profile →
                </a>

            </section>


            <!-- Medicine Management -->
            <section class="admin-card"
                     onclick="window.location.href='<%= request.getContextPath() %>/admin/manageStock.jsp'"
                     style="cursor: pointer;">

                <div class="admin-card-icon">✚</div>

                <h3>Medicine Management</h3>

                <p>
                    Add new medicines, update medicine details,
                    manage prices, and monitor available stock.
                </p>

                <span class="admin-card-link">
                    Manage Medicines →
                </span>

            </section>


<!-- Medicine Orders -->
<section class="admin-card"
         onclick="window.location.href='<%= request.getContextPath() %>/AdminOrdersServlet'"
         style="cursor: pointer;">

    <div class="admin-card-icon">▤</div>

    <h3>Medicine Orders</h3>

    <p>
        View patient medicine orders, check ordered medicines,
        quantities, prices, and approve or reject order requests.
    </p>

    <span class="admin-card-link">
        Manage Orders →
    </span>

</section>


            <!-- Emergency Requests -->
            <section class="admin-card">

                <div class="admin-card-icon">＋</div>

                <a href="<%=request.getContextPath()%>/admin/emergency-requests">
    Emergency Requests
</a>

                <p>
                    View ambulance, blood, room, and emergency doctor requests.
                </p>

            </section>


        </div>

    </main>


    <!-- Footer -->
    <footer class="admin-footer">
        © MediBridge | Administration Portal
    </footer>

</body>
</html>
