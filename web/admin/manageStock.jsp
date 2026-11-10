
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8" %>

<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
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
    // Admin session protection
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/adminLogin.jsp"
        );
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
%>

<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Medicine Stock Management | MediBridge</title>

    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/medicineStock.css">

</head>

<body>

<div class="stock-page">

    <!-- Page Header -->
    <header class="page-header">

        <div class="header-content">

            <h1 class="page-title">
                Medicine <span>Stock Management</span>
            </h1>

            <p class="page-subtitle">
                Monitor medicine inventory and manage available stock.
            </p>

        </div>

        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp"
           class="back-dashboard">
            &larr; Back to Dashboard
        </a>

    </header>


    <!-- Success Messages -->

    <% if ("stockUpdated".equals(request.getParameter("success"))) { %>

        <div class="message">
            <span class="message-icon">&#10003;</span>
            Medicine stock updated successfully.
        </div>

    <% } else if ("medicineAdded".equals(request.getParameter("success"))) { %>

        <div class="message">
            <span class="message-icon">&#10003;</span>
            Medicine added successfully.
        </div>

    <% } else if ("medicineEdited".equals(request.getParameter("success"))) { %>

        <div class="message">
            <span class="message-icon">&#10003;</span>
            Medicine details updated successfully.
        </div>

    <% } else if ("medicineDeleted".equals(request.getParameter("success"))) { %>

        <div class="message">
            <span class="message-icon">&#10003;</span>
            Medicine deleted successfully.
        </div>

    <% } else if ("medicineDeactivated".equals(request.getParameter("success"))) { %>

        <div class="message">
            <span class="message-icon">&#10003;</span>
            Medicine deactivated successfully.
        </div>

    <% } else if ("medicineReactivated".equals(request.getParameter("success"))) { %>

        <div class="message">
            <span class="message-icon">&#10003;</span>
            Medicine reactivated successfully.
        </div>

    <% } %>


    <!-- Error Messages -->

    <% if ("medicineNotFound".equals(request.getParameter("error"))) { %>

        <div class="error">
            Medicine not found.
        </div>

    <% } else if ("updateFailed".equals(request.getParameter("error"))) { %>

        <div class="error">
            Unable to update medicine stock. Please try again.
        </div>

    <% } else if ("invalidInput".equals(request.getParameter("error"))) { %>

        <div class="error">
            Please enter valid medicine details.
        </div>

    <% } else if ("imageTooLarge".equals(request.getParameter("error"))) { %>

        <div class="error">
            Image size must not exceed 2 MB.
        </div>

    <% } else if ("invalidImage".equals(request.getParameter("error"))) { %>

        <div class="error">
            Invalid image. Please upload a valid JPG, JPEG or PNG file.
        </div>

    <% } else if ("addFailed".equals(request.getParameter("error"))) { %>

        <div class="error">
            Unable to add medicine. Please try again.
        </div>

    <% } else if ("medicineHasOrders".equals(request.getParameter("error"))) { %>

        <div class="error">
            This medicine cannot be deleted because it is associated
            with existing orders.
        </div>

    <% } else if ("medicineHasActiveOrders".equals(request.getParameter("error"))) { %>

        <div class="error">
            This medicine cannot be deactivated because it has orders
            that have not yet been delivered.
        </div>

    <% } else if ("actionFailed".equals(request.getParameter("error"))) { %>

        <div class="error">
            Unable to update medicine status. Please try again.
        </div>

    <% } else if ("editFailed".equals(request.getParameter("error"))) { %>

        <div class="error">
            Unable to edit medicine. Please try again.
        </div>

    <% } else if ("deleteFailed".equals(request.getParameter("error"))) { %>

        <div class="error">
            Unable to delete medicine. Please try again.
        </div>

    <% } %>


    <!-- Medicine Stock Table -->

    <section class="stock-section">

        <div class="section-heading">

            <div>
                <h2>Medicine Inventory</h2>
                <p>View medicine prices, available quantities and status.</p>
            </div>

            <span class="section-tag">
                Stock Overview
            </span>

        </div>


        <div class="table-container">

            <table>

                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Photo</th>
                        <th>Medicine Name</th>
                        <th>Price</th>
                        <th>Current Stock</th>
                        <th>Status</th>
                        <th>Add Stock / Action</th>
                        <th>Actions</th>
                    </tr>
                </thead>

                <tbody>

                <%
                    try {

                        con = DBConnection.getConnection();

                        String sql =
                            "SELECT MEDICINE_ID, MEDICINE_NAME, PRICE, STOCK, STATUS, " +
                            "CASE WHEN IMAGE_DATA IS NOT NULL " +
                            "THEN 1 ELSE 0 END AS HAS_IMAGE " +
                            "FROM MEDICINE ORDER BY MEDICINE_ID";

                        ps = con.prepareStatement(sql);
                        rs = ps.executeQuery();

                        boolean found = false;

                        while (rs.next()) {

                            found = true;

                            int medicineId = rs.getInt("MEDICINE_ID");

                            String medicineName =
                                rs.getString("MEDICINE_NAME");

                            double price = rs.getDouble("PRICE");

                            int stock = rs.getInt("STOCK");

                            String medicineStatus =
                                rs.getString("STATUS");

                            boolean hasImage =
                                rs.getInt("HAS_IMAGE") == 1;

                %>

                    <tr>

                        <!-- Medicine ID -->
                        <td class="medicine-id">
                            #<%= medicineId %>
                        </td>


                        <!-- Medicine Photo -->
                        <td>

                            <% if (hasImage) { %>

                                <img
                                    src="<%= request.getContextPath() %>/MedicineImageServlet?id=<%= medicineId %>"
                                    alt="<%= escapeHTML(medicineName) %>"
                                    class="medicine-thumb">

                            <% } else { %>

                                <div class="no-medicine-image">
                                    No Photo
                                </div>

                            <% } %>

                        </td>


                        <!-- Medicine Name -->
                        <td class="medicine-name">
                            <%= escapeHTML(medicineName) %>
                        </td>


                        <!-- Price -->
                        <td class="medicine-price">
                            Rs. <%= String.format("%.2f", price) %>
                        </td>


                        <!-- Current Stock -->
                        <td>

                            <span class="stock-badge <%= stock < 20 ? "stock-low" : "stock-available" %>">

                                <%= stock %>

                                <%= stock < 20 ? " (Low)" : " Available" %>

                            </span>

                        </td>


                        <!-- Medicine Status -->
                        <td>

                            <% if ("ACTIVE".equalsIgnoreCase(medicineStatus)) { %>

                                <span class="status-active">
                                    ACTIVE
                                </span>

                            <% } else { %>

                                <span class="status-inactive">
                                    INACTIVE
                                </span>

                            <% } %>

                        </td>


                        <!-- Update Stock -->
                        <td>

                            <form action="<%= request.getContextPath() %>/UpdatesStockServlet"
                                  method="post"
                                  class="update-form">

                                <input type="number"
                                       name="add_stock"
                                       min="1"
                                       placeholder="Quantity"
                                       required>

                                <input type="hidden"
                                       name="medicine_id"
                                       value="<%= medicineId %>">

                                <button type="submit" class="update-btn">
                                    Update
                                </button>

                            </form>

                        </td>


                        <!-- Edit and Activate / Deactivate Actions -->
                        <td>

                            <div class="medicine-actions">

                                <!-- Edit Button -->
                                <a href="<%= request.getContextPath() %>/admin/editMedicine.jsp?id=<%= medicineId %>"
                                   class="edit-medicine-btn">
                                    Edit
                                </a>


                                <!-- Conditional Status Action -->

                                <% if ("ACTIVE".equalsIgnoreCase(medicineStatus)) { %>

                                    <form action="<%= request.getContextPath() %>/DeleteMedicineServlet"
                                          method="post"
                                          style="display:inline;"
                                          onsubmit="return confirm('Deactivate this medicine?');">

                                        <input type="hidden"
                                               name="medicine_id"
                                               value="<%= medicineId %>">

                                        <input type="hidden"
                                               name="action"
                                               value="deactivate">

                                        <button type="submit"
                                                class="delete-medicine-btn">
                                            Deactivate
                                        </button>

                                    </form>

                                <% } else { %>

                                    <form action="<%= request.getContextPath() %>/DeleteMedicineServlet"
                                          method="post"
                                          style="display:inline;">

                                        <input type="hidden"
                                               name="medicine_id"
                                               value="<%= medicineId %>">

                                        <input type="hidden"
                                               name="action"
                                               value="reactivate">

                                        <button type="submit"
                                                class="update-btn">
                                            Reactivate
                                        </button>

                                    </form>

                                <% } %>

                            </div>

                        </td>

                    </tr>

                <%
                        }

                        if (!found) {
                %>

                    <tr>
                        <td colspan="8" class="empty-row">
                            No medicines have been added yet.
                        </td>
                    </tr>

                <%
                        }

                    } catch (SQLException e) {

                        application.log("Error loading medicine stock", e);
                %>

                    <tr>
                        <td colspan="8" class="empty-row error-text">
                            Unable to load medicine stock. Please try again later.
                        </td>
                    </tr>

                <%
                    } catch (Exception e) {

                        application.log("Database connection error", e);
                %>

                    <tr>
                        <td colspan="8" class="empty-row error-text">
                            Something went wrong while loading medicines.
                        </td>
                    </tr>

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

                </tbody>

            </table>

        </div>

    </section>


    <!-- Add New Medicine -->

    <section class="add-medicine-section">

        <div class="add-medicine-card">

            <div class="form-heading">

                <div class="form-icon">
                    +
                </div>

                <h2>Add New Medicine</h2>

                <p>Add a new medicine to the MediBridge inventory.</p>

            </div>


            <form action="<%= request.getContextPath() %>/AddMedicinesServlet"
                  method="post"
                  enctype="multipart/form-data">

                <div class="form-group">

                    <label>Medicine Name</label>

                    <input type="text"
                           name="medicine_name"
                           maxlength="150"
                           placeholder="Enter medicine name"
                           required>

                </div>


                <div class="form-group">

                    <label>Description</label>

                    <textarea name="description"
                              rows="3"
                              maxlength="1000"
                              placeholder="Enter medicine description"></textarea>

                </div>


                <div class="form-row">

                    <div class="form-group">

                        <label>Price (Rs.)</label>

                        <input type="number"
                               step="0.01"
                               min="0.01"
                               name="price"
                               placeholder="Enter price"
                               required>

                    </div>


                    <div class="form-group">

                        <label>Initial Stock</label>

                        <input type="number"
                               name="stock"
                               min="0"
                               placeholder="Enter initial stock"
                               required>

                    </div>

                </div>


                <!-- Medicine Image Upload -->

                <div class="form-group image-upload-group">

                    <label for="medicine_image">
                        Medicine Photo <span>(Optional)</span>
                    </label>

                    <input type="file"
                           id="medicine_image"
                           name="medicine_image"
                           accept=".jpg,.jpeg,.png,image/jpeg,image/png">

                    <small class="image-help">
                        JPG, JPEG or PNG. Maximum file size: 2 MB.
                    </small>


                    <!-- Image Preview -->

                    <div id="image-preview-container"
                         class="image-preview-container"
                         style="display:none;">

                        <img id="image-preview"
                             src=""
                             alt="Medicine Preview">

                        <p>Image Preview</p>

                        <button type="button"
                                id="remove-image"
                                class="remove-image-btn">
                            Remove Photo
                        </button>

                    </div>

                </div>


                <button type="submit" class="add-btn">
                    Add Medicine
                </button>

            </form>

        </div>

    </section>

</div>


<!-- Image Preview Script -->

<script>

    const imageInput = document.getElementById("medicine_image");

    const previewContainer =
        document.getElementById("image-preview-container");

    const previewImage = document.getElementById("image-preview");

    const removeImageButton = document.getElementById("remove-image");

    let currentImageURL = null;


    imageInput.addEventListener("change", function () {

        const file = this.files[0];

        if (!file) {
            return;
        }

        const allowedTypes = ["image/jpeg", "image/png"];

        if (!allowedTypes.includes(file.type)) {

            alert("Please select a valid JPG, JPEG or PNG image.");

            this.value = "";
            previewContainer.style.display = "none";

            return;
        }

        if (file.size > 2 * 1024 * 1024) {

            alert("Image size must not exceed 2 MB.");

            this.value = "";
            previewContainer.style.display = "none";

            return;
        }

        if (currentImageURL) {
            URL.revokeObjectURL(currentImageURL);
        }

        currentImageURL = URL.createObjectURL(file);

        previewImage.src = currentImageURL;
        previewContainer.style.display = "block";

    });


    removeImageButton.addEventListener("click", function () {

        imageInput.value = "";

        previewImage.src = "";
        previewContainer.style.display = "none";

        if (currentImageURL) {
            URL.revokeObjectURL(currentImageURL);
            currentImageURL = null;
        }

    });

</script>


</body>
</html>
