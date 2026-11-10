
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
    if (session == null || session.getAttribute("admin") == null) {
        response.sendRedirect(
            request.getContextPath() + "/admin/adminLogin.jsp"
        );
        return;
    }

    int medicineId = 0;
    String name = "";
    String description = "";
    double price = 0;
    boolean hasImage = false;
    boolean medicineFound = false;

    try {
        medicineId = Integer.parseInt(request.getParameter("id"));

        if (medicineId <= 0) {
            throw new NumberFormatException();
        }

        String sql =
            "SELECT MEDICINE_NAME, DESCRIPTION, PRICE, " +
            "CASE WHEN IMAGE_DATA IS NOT NULL THEN 1 ELSE 0 END AS HAS_IMAGE " +
            "FROM MEDICINE WHERE MEDICINE_ID = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, medicineId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    medicineFound = true;
                    name = rs.getString("MEDICINE_NAME");
                    description = rs.getString("DESCRIPTION");
                    price = rs.getDouble("PRICE");
                    hasImage = rs.getInt("HAS_IMAGE") == 1;
                }
            }
        }

    } catch (NumberFormatException e) {
        response.sendRedirect(
            request.getContextPath() + "/admin/manageStock.jsp?error=invalidInput"
        );
        return;

    } catch (Exception e) {
        application.log("Error loading medicine for editing", e);
        response.sendRedirect(
            request.getContextPath() + "/admin/manageStock.jsp?error=editFailed"
        );
        return;
    }

    if (!medicineFound) {
        response.sendRedirect(
            request.getContextPath() + "/admin/manageStock.jsp?error=medicineNotFound"
        );
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Medicine | MediBridge</title>

    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/css/medicineStock.css">

    <style>
        .edit-page {
            max-width: 720px;
            margin: 40px auto;
            padding: 25px;
        }

        .edit-card {
            background: #fff;
            padding: 30px;
            border-radius: 16px;
            box-shadow: 0 8px 30px rgba(15, 23, 42, 0.08);
        }

        .edit-card h2 {
            margin-top: 0;
            color: #172554;
        }

        .edit-card .form-group {
            margin-bottom: 20px;
        }

        .edit-card label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
        }

        .edit-card input[type="text"],
        .edit-card input[type="number"],
        .edit-card textarea {
            width: 100%;
            box-sizing: border-box;
        }

        .current-image {
            width: 150px;
            height: 130px;
            object-fit: contain;
            border: 1px solid #e2e8f0;
            border-radius: 10px;
            padding: 5px;
            background: #fff;
            display: block;
            margin-bottom: 12px;
        }

        .edit-actions {
            display: flex;
            gap: 12px;
            align-items: center;
            flex-wrap: wrap;
        }

        .save-edit-btn {
            border: none;
            border-radius: 8px;
            padding: 12px 22px;
            background: #2563eb;
            color: white;
            cursor: pointer;
            font-weight: 600;
        }

        .cancel-edit-btn {
            text-decoration: none;
            color: #475569;
            font-weight: 600;
        }

        .edit-error {
            background: #fee2e2;
            color: #991b1b;
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 18px;
        }

        .image-help {
            display: block;
            margin-top: 7px;
            color: #64748b;
        }

        #new-image-preview {
            max-width: 150px;
            max-height: 130px;
            object-fit: contain;
            display: none;
            margin-top: 12px;
        }
    </style>
</head>

<body>

<div class="edit-page">
    <div class="edit-card">

        <h2>Edit Medicine</h2>
        <p>Update medicine information in your inventory.</p>

        <% if ("invalidInput".equals(request.getParameter("error"))) { %>
            <div class="edit-error">Please enter valid medicine details.</div>
        <% } else if ("imageTooLarge".equals(request.getParameter("error"))) { %>
            <div class="edit-error">Image size must not exceed 2 MB.</div>
        <% } else if ("invalidImage".equals(request.getParameter("error"))) { %>
            <div class="edit-error">Please upload a valid JPG, JPEG or PNG image.</div>
        <% } else if ("editFailed".equals(request.getParameter("error"))) { %>
            <div class="edit-error">Unable to update medicine. Please try again.</div>
        <% } %>

        <form action="<%= request.getContextPath() %>/EditMedicineServlet"
              method="post"
              enctype="multipart/form-data">

            <input type="hidden" name="medicine_id"
                   value="<%= medicineId %>">

            <div class="form-group">
                <label>Medicine Name</label>
                <input type="text"
                       name="medicine_name"
                       maxlength="150"
                       value="<%= escapeHTML(name) %>"
                       required>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description"
                          rows="4"
                          maxlength="1000"><%= escapeHTML(description) %></textarea>
            </div>

            <div class="form-group">
                <label>Price (Rs.)</label>
                <input type="number"
                       name="price"
                       step="0.01"
                       min="0.01"
                       value="<%= String.format(java.util.Locale.US, "%.2f", price) %>"
                       required>
            </div>

            <div class="form-group">
                <label>Current Medicine Photo</label>

                <% if (hasImage) { %>
                    <img class="current-image"
                         src="<%= request.getContextPath() %>/MedicineImageServlet?id=<%= medicineId %>"
                         alt="Current medicine photo">
                <% } else { %>
                    <p>No photo uploaded.</p>
                <% } %>
            </div>

            <div class="form-group">
                <label>Replace Photo (Optional)</label>

                <input type="file"
                       name="medicine_image"
                       id="medicine_image"
                       accept=".jpg,.jpeg,.png,image/jpeg,image/png">

                <small class="image-help">
                    Leave empty to keep the existing photo.
                    JPG, JPEG or PNG. Maximum 2 MB.
                </small>

                <img id="new-image-preview" alt="New image preview">
            </div>

            <div class="edit-actions">
                <button type="submit" class="save-edit-btn">
                    Save Changes
                </button>

                <a href="<%= request.getContextPath() %>/admin/manageStock.jsp"
                   class="cancel-edit-btn">
                    Cancel
                </a>
            </div>

        </form>
    </div>
</div>

<script>
    const imageInput = document.getElementById("medicine_image");
    const preview = document.getElementById("new-image-preview");
    let previewURL = null;

    imageInput.addEventListener("change", function () {
        const file = this.files[0];

        if (!file) {
            preview.style.display = "none";
            return;
        }

        if (!["image/jpeg", "image/png"].includes(file.type)) {
            alert("Please select a JPG, JPEG or PNG image.");
            this.value = "";
            preview.style.display = "none";
            return;
        }

        if (file.size > 2 * 1024 * 1024) {
            alert("Image size must not exceed 2 MB.");
            this.value = "";
            preview.style.display = "none";
            return;
        }

        if (previewURL) {
            URL.revokeObjectURL(previewURL);
        }

        previewURL = URL.createObjectURL(file);
        preview.src = previewURL;
        preview.style.display = "block";
    });
</script>

</body>
</html>
