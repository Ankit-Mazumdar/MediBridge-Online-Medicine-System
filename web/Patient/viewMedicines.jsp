
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="util.DBConnection" %>

<%!
    public String escapeHTML(String value) {
        if (value == null) return "";

        return value.replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;")
                    .replace("'", "&#x27;");
    }
%>

<%
    // Check patient login
    if (session == null || session.getAttribute("patientId") == null) {
        response.sendRedirect(
            request.getContextPath() + "/Patient/PatientLogin.jsp"
        );
        return;
    }

    String keyword = request.getParameter("keyword");

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Available Medicines | MediBridge</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/viewMedicines.css">

</head>

<body>

<div class="medicine-page">

    <!-- Page Header -->

    <header class="page-header">

        <h1 class="page-title">
            Available <span>Medicines</span>
        </h1>

        <div class="page-actions">

            <a href="<%= request.getContextPath() %>/OrdersServlet"
               class="history-btn">
                &#128722; My Order History
            </a>

            <a href="<%= request.getContextPath() %>/Patient/PatientDashboard.jsp"
               class="back-dashboard">
                &larr; Back to Dashboard
            </a>

        </div>

    </header>


    <!-- Search Medicine -->

    <section class="search-box">

        <form method="get"
              action="<%= request.getContextPath() %>/Patient/viewMedicines.jsp">

            <label for="keyword">Search Medicine:</label>

            <input type="text"
                   id="keyword"
                   name="keyword"
                   placeholder="Enter medicine name"
                   value="<%= escapeHTML(keyword) %>">

            <button type="submit" class="search-btn">
                Search
            </button>

            <a href="<%= request.getContextPath() %>/Patient/viewMedicines.jsp"
               class="reset-link">
                Reset
            </a>

        </form>

    </section>


    <!-- Medicine Cards -->

    <section class="medicine-grid">

<%
    try {

        con = DBConnection.getConnection();

        String sql;

        if (keyword != null && !keyword.trim().isEmpty()) {

            // Search only ACTIVE medicines

            sql =
                "SELECT MEDICINE_ID, MEDICINE_NAME, DESCRIPTION, PRICE, STOCK, " +
                "CASE WHEN IMAGE_DATA IS NOT NULL THEN 1 ELSE 0 END AS HAS_IMAGE " +
                "FROM MEDICINE " +
                "WHERE STATUS = 'ACTIVE' " +
                "AND (UPPER(MEDICINE_NAME) LIKE UPPER(?) " +
                "OR UPPER(DESCRIPTION) LIKE UPPER(?)) " +
                "ORDER BY MEDICINE_NAME";

            ps = con.prepareStatement(sql);

            String value = "%" + keyword.trim() + "%";

            ps.setString(1, value);
            ps.setString(2, value);

        } else {

            // Display all ACTIVE medicines

            sql =
                "SELECT MEDICINE_ID, MEDICINE_NAME, DESCRIPTION, PRICE, STOCK, " +
                "CASE WHEN IMAGE_DATA IS NOT NULL THEN 1 ELSE 0 END AS HAS_IMAGE " +
                "FROM MEDICINE " +
                "WHERE STATUS = 'ACTIVE' " +
                "ORDER BY MEDICINE_NAME";

            ps = con.prepareStatement(sql);
        }

        rs = ps.executeQuery();

        boolean found = false;

        while (rs.next()) {

            found = true;

            int medicineId = rs.getInt("MEDICINE_ID");

            String medicineName =
                rs.getString("MEDICINE_NAME");

            String description =
                rs.getString("DESCRIPTION");

            double price = rs.getDouble("PRICE");

            int stock = rs.getInt("STOCK");

            boolean hasImage =
                rs.getInt("HAS_IMAGE") == 1;

%>

        <article class="medicine-card">

            <!-- Medicine Image -->

            <div class="image-container">

                <% if (hasImage) { %>

                    <img
                        src="<%= request.getContextPath() %>/MedicineImageServlet?id=<%= medicineId %>"
                        class="medicine-image"
                        alt="<%= escapeHTML(medicineName) %>"
                        loading="lazy">

                <% } else { %>

                    <div class="medicine-placeholder">

                        <span>&#128138;</span>

                        <p>No Image Available</p>

                    </div>

                <% } %>

            </div>


            <!-- Medicine Details -->

            <div class="card-body">

                <div class="stock-row">

                    <span class="stock <%= stock < 20 ? "low-stock" : "available-stock" %>">

                        <%= stock > 0 ? "Stock: " + stock : "Out of Stock" %>

                        <%= (stock > 0 && stock < 20) ? "(Low Stock)" : "" %>

                    </span>

                </div>


                <h2 class="med-name">
                    <%= escapeHTML(medicineName) %>
                </h2>


                <p class="med-desc">
                    <%= escapeHTML(description) %>
                </p>


                <div class="price">
                    Rs. <%= String.format("%.2f", price) %>
                </div>


                <!-- Existing Order Functionality -->

                <form action="<%= request.getContextPath() %>/Patient/orderMedicine.jsp"
                      method="get">

                    <input type="hidden"
                           name="medicine_id"
                           value="<%= medicineId %>">

                    <input type="hidden"
                           name="medicine_name"
                           value="<%= escapeHTML(medicineName) %>">

                    <input type="hidden"
                           name="price"
                           value="<%= price %>">

                    <input type="hidden"
                           name="stock"
                           value="<%= stock %>">

                    <button type="submit"
                            class="order-btn"
                            <%= stock <= 0 ? "disabled" : "" %>>

                        <%= stock <= 0 ? "Out of Stock" : "Order Now" %>

                    </button>

                </form>

            </div>

        </article>

<%
        }

        if (!found) {
%>

        <div class="no-data">

            <div class="empty-icon">&#128269;</div>

            <h3>No Medicines Found</h3>

            <p>Try searching with another medicine name.</p>

        </div>

<%
        }

    } catch (Exception e) {

        application.log("Error loading available medicines", e);
%>

        <div class="no-data">

            <h3>Unable to Load Medicines</h3>

            <p>Please try again later.</p>

        </div>

<%
    } finally {

        try {
            if (rs != null) rs.close();
        } catch (Exception e) {}

        try {
            if (ps != null) ps.close();
        } catch (Exception e) {}

        try {
            if (con != null) con.close();
        } catch (Exception e) {}

    }
%>

    </section>

</div>

</body>
</html>
