
<%@page import="model.PatientBean"%>
<%@page import="model.Doctor"%>
<%@page import="dao.PatientAppointmentDAO"%>


<%
    PatientBean patient =
            (PatientBean) session.getAttribute("patient");

    if (patient == null) {
        response.sendRedirect("PatientLogin.jsp");
        return;
    }

    String doctorId =
            (String) session.getAttribute("bookingDoctorId");

    String appointmentDate =
            (String) session.getAttribute("bookingDate");

    String appointmentTime =
            (String) session.getAttribute("bookingTime");

    Integer availabilityId =
            (Integer) session.getAttribute("bookingAvailabilityId");

    Integer slotNumber =
            (Integer) session.getAttribute("bookingSlotNumber");

    if (doctorId == null ||
        appointmentDate == null ||
        appointmentTime == null ||
        availabilityId == null ||
        slotNumber == null) {

        response.sendRedirect(
                request.getContextPath() +
                "/PatientAppointmentServlet");

        return;
    }

    // Retrieve doctor directly from database.
    PatientAppointmentDAO dao =
            new PatientAppointmentDAO();

    Doctor bookingDoctor =
            dao.getDoctorById(doctorId);

    if (bookingDoctor == null) {

        response.sendRedirect(
                request.getContextPath() +
                "/PatientAppointmentServlet");

        return;
    }

    String doctorName =
            bookingDoctor.getFullName();

    String specialization =
            bookingDoctor.getSpecialization();

    double consultationFee =
            bookingDoctor.getConsultationFees();
%>


<!DOCTYPE html>
<html>
<head>

    <meta charset="UTF-8">
    <title>Confirm Appointment | MediBridge</title>

    <link rel="stylesheet"
          href="../css/style.css">

    <style>

        body {
            background: #f4f8fc;
            font-family: Arial, sans-serif;
        }

        .booking-container {
            max-width: 650px;
            margin: 55px auto;
            padding: 35px;
            background: white;
            border-radius: 16px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.08);
        }

        .booking-container h1 {
            color: #073b66;
            margin-bottom: 8px;
        }

        .booking-subtitle {
            color: #6b7c8f;
            margin-bottom: 25px;
        }

        .booking-info {
            background: #f1fbfb;
            padding: 22px;
            border-radius: 10px;
            margin-bottom: 22px;
        }

        .booking-info h3 {
            color: #073b66;
            margin-top: 0;
            margin-bottom: 17px;
        }

        .booking-info p {
            margin: 12px 0;
            color: #40546a;
        }

        .booking-info strong {
            color: #073b66;
        }

        .slot-badge {
            display: inline-block;
            background: #d9f3f0;
            color: #087c76;
            padding: 5px 12px;
            border-radius: 20px;
            font-weight: bold;
        }

        .fee-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 18px;
            border: 1px solid #dce7ef;
            border-radius: 10px;
            margin-bottom: 22px;
        }

        .fee-section span {
            color: #53677b;
            font-weight: 600;
        }

        .fee-section strong {
            color: #073b66;
            font-size: 23px;
        }

        label {
            display: block;
            font-weight: 600;
            color: #073b66;
            margin-bottom: 9px;
        }

        textarea {
            width: 100%;
            min-height: 110px;
            padding: 12px;
            box-sizing: border-box;
            border: 1px solid #ccd8e3;
            border-radius: 8px;
            resize: vertical;
            font-family: inherit;
        }

        .payment-info {
            background: #fff9e9;
            border: 1px solid #f2dfa9;
            padding: 16px;
            border-radius: 10px;
            margin-top: 22px;
            margin-bottom: 20px;
        }

        .payment-info h3 {
            color: #856404;
            margin-top: 0;
        }

        .payment-info p {
            color: #75612d;
            font-size: 14px;
            line-height: 1.6;
            margin-bottom: 0;
        }

        .book-button {
            width: 100%;
            margin-top: 18px;
            padding: 15px;
            border: none;
            border-radius: 8px;
            background: #073b66;
            color: white;
            font-weight: 600;
            font-size: 16px;
            cursor: pointer;
        }

        .book-button:hover {
            background: #0b8f91;
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 18px;
            color: #087c91;
            text-decoration: none;
        }

    </style>

</head>

<body>

<div class="booking-container">

    <h1>Confirm Appointment</h1>

    <p class="booking-subtitle">
        Review your booking details before confirming your appointment.
    </p>

    <!-- DOCTOR INFORMATION -->

    <div class="booking-info">

        <h3>Doctor Information</h3>

        <p>
            <strong>Doctor:</strong>
            <%= doctorName %>
        </p>

        <p>
            <strong>Specialization:</strong>
            <%= specialization %>
        </p>

        <p>
            <strong>Doctor ID:</strong>
            <%= doctorId %>
        </p>

    </div>

    <!-- APPOINTMENT INFORMATION -->

    <div class="booking-info">

        <h3>Appointment Details</h3>

        <p>
            <strong>Patient:</strong>
            <%= patient.getName() %>
        </p>

        <p>
            <strong>Appointment Date:</strong>
            <%= appointmentDate %>
        </p>

        <p>
            <strong>Selected Slot:</strong>

            <span class="slot-badge">
                Slot <%= slotNumber %>
            </span>
        </p>

        <p>
            <strong>Time:</strong>
            <%= appointmentTime %>
        </p>

    </div>

    <!-- CONSULTATION FEE -->

    <div class="fee-section">

        <span>Consultation Fee</span>

        <strong>
            &#8377;<%= String.format("%.2f", consultationFee) %>
        </strong>

    </div>

    <!-- BOOKING FORM -->

    <form action="<%= request.getContextPath() %>/PatientAppointmentServlet"
          method="post">

        <input type="hidden"
               name="action"
               value="confirmBooking">

        <input type="hidden"
               name="doctorId"
               value="<%= doctorId %>">

        <input type="hidden"
               name="appointmentDate"
               value="<%= appointmentDate %>">

        <input type="hidden"
               name="appointmentTime"
               value="<%= appointmentTime %>">

        <input type="hidden"
               name="availabilityId"
               value="<%= availabilityId %>">

        <input type="hidden"
               name="slotNumber"
               value="<%= slotNumber %>">

        <label for="reason">
            Reason for Appointment
        </label>

        <textarea id="reason"
                  name="reason"
                  maxlength="500"
                  required
                  placeholder="Briefly describe your reason for consultation..."></textarea>

        <!-- DEMO PAYMENT -->

        <div class="payment-info">

            <h3>Demo Payment Information</h3>

            <p>
                This is a demonstration payment system.
                No actual money will be deducted from your account.
                Clicking the button below will simulate successful
                payment and confirm your appointment.
            </p>

        </div>

        <button type="submit" class="book-button">
            Confirm Appointment &amp; Pay
        </button>

    </form>

    <a href="<%= request.getContextPath() %>/PatientAppointmentServlet"
       class="back-link">
        Back to Appointment Booking
    </a>

</div>

</body>
</html>
