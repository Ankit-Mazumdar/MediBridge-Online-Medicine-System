
package Servlets;

import dao.PatientAppointmentDAO;
import model.Doctor;
import model.DoctorAvailability;
import model.PatientBean;

import java.io.IOException;
import java.net.URLEncoder;
import java.sql.Date;
import java.text.SimpleDateFormat;
import java.util.List;
import java.util.Locale;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/PatientAppointmentServlet")
public class PatientAppointmentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    // ============================================================
    // GET: DISPLAY DOCTORS, DATE AND AVAILABILITY
    // ============================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("patient") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");

            return;
        }

        PatientAppointmentDAO dao =
                new PatientAppointmentDAO();

        // Get approved doctors with future active availability.
        List<Doctor> doctors = dao.getApprovedDoctors();

        request.setAttribute("doctors", doctors);

        String doctorId = request.getParameter("doctorId");
        String appointmentDate =
                request.getParameter("appointmentDate");

        if (doctorId != null &&
            !doctorId.trim().isEmpty()) {

            // Verify that the selected doctor is approved.
            Doctor selectedDoctor =
                    dao.getDoctorById(doctorId);

            if (selectedDoctor == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/PatientAppointmentServlet");

                return;
            }

            request.setAttribute(
                    "selectedDoctorId",
                    doctorId);

            // If no date is selected, show the doctor's future
            // availability records.
            if (appointmentDate == null ||
                appointmentDate.trim().isEmpty()) {

                List<DoctorAvailability> availability =
                        dao.getDoctorAvailability(doctorId);

                request.setAttribute(
                        "availability",
                        availability);

            } else {

                // Validate date format.
                if (!appointmentDate.matches(
                        "\\d{4}-\\d{2}-\\d{2}")) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/PatientAppointmentServlet"
                            + "?doctorId="
                            + encode(doctorId)
                            + "&error=invalidDate");

                    return;
                }

                try {

                    Date selectedDate =
                            Date.valueOf(appointmentDate);

                    Date today =
                            new Date(System.currentTimeMillis());

                    if (selectedDate.before(today)) {

                        response.sendRedirect(
                                request.getContextPath()
                                + "/PatientAppointmentServlet"
                                + "?doctorId="
                                + encode(doctorId)
                                + "&error=invalidDate");

                        return;
                    }

                    // IMPORTANT:
                    // Fetch availability for the exact date.
                    List<DoctorAvailability> availability =
                            dao.getDoctorAvailability(
                                    doctorId,
                                    appointmentDate);

                    // Fetch booked times in one query.
                    Set<String> bookedTimes =
                            dao.getBookedTimes(
                                    doctorId,
                                    appointmentDate);

                    SimpleDateFormat sdf =
                            new SimpleDateFormat(
                                    "EEEE",
                                    Locale.ENGLISH);

                    String selectedDay =
                            sdf.format(selectedDate)
                               .toUpperCase(Locale.ENGLISH);

                    request.setAttribute(
                            "appointmentDate",
                            appointmentDate);

                    request.setAttribute(
                            "selectedDay",
                            selectedDay);

                    request.setAttribute(
                            "availability",
                            availability);

                    request.setAttribute(
                            "bookedTimes",
                            bookedTimes);

                    request.setAttribute(
                            "selectedDoctor",
                            selectedDoctor);

                } catch (IllegalArgumentException e) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/PatientAppointmentServlet"
                            + "?doctorId="
                            + encode(doctorId)
                            + "&error=invalidDate");

                    return;
                }
            }
        }

        request.getRequestDispatcher(
                "/Patient/PatientAppointment.jsp")
                .forward(request, response);
    }


    // ============================================================
    // POST: SELECT SLOT AND CONFIRM DEMO PAYMENT
    // ============================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("patient") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/PatientLogin.jsp");

            return;
        }

        PatientBean patient =
                (PatientBean) session.getAttribute("patient");

        PatientAppointmentDAO dao =
                new PatientAppointmentDAO();

        request.setCharacterEncoding("UTF-8");

        String action = request.getParameter("action");

        // ========================================================
        // STEP 1: PATIENT SELECTS A SLOT
        // ========================================================

        if ("book".equals(action)) {

            String doctorId =
                    request.getParameter("doctorId");

            String appointmentDate =
                    request.getParameter("appointmentDate");

            String appointmentTime =
                    request.getParameter("appointmentTime");

            String availabilityIdValue =
                    request.getParameter("availabilityId");

            String slotNumberValue =
                    request.getParameter("slotNumber");

            // Validate required parameters.
            if (isEmpty(doctorId) ||
                !isValidDate(appointmentDate) ||
                !isValidTime(appointmentTime) ||
                isEmpty(availabilityIdValue) ||
                isEmpty(slotNumberValue)) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/PatientAppointmentServlet");

                return;
            }

            int availabilityId;
            int slotNumber;

            try {

                availabilityId =
                        Integer.parseInt(availabilityIdValue);

                slotNumber =
                        Integer.parseInt(slotNumberValue);

                if (availabilityId <= 0 ||
                    slotNumber <= 0) {
                    throw new NumberFormatException();
                }

            } catch (NumberFormatException e) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/PatientAppointmentServlet");

                return;
            }

            // Verify doctor is still approved.
            Doctor doctor =
                    dao.getDoctorById(doctorId);

            if (doctor == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/PatientAppointmentServlet");

                return;
            }

            // Verify selected availability belongs to this
            // doctor and selected date.
            List<DoctorAvailability> availability =
                    dao.getDoctorAvailability(
                            doctorId,
                            appointmentDate);

            boolean validSlot =
                    isValidSelectedSlot(
                            availability,
                            availabilityId,
                            slotNumber,
                            appointmentTime);

            if (!validSlot) {

                redirectWithError(
                        request,
                        response,
                        doctorId,
                        appointmentDate,
                        "invalidSlot");

                return;
            }

            // Check whether the patient already has an
            // appointment with this doctor on the same date.
            boolean duplicate =
                    dao.hasPatientAppointmentOnDate(
                            patient.getEmail(),
                            doctorId,
                            appointmentDate);

            if (duplicate) {

                redirectWithError(
                        request,
                        response,
                        doctorId,
                        appointmentDate,
                        "duplicate");

                return;
            }

            // Store selected booking details in the session.
            session.setAttribute(
                    "bookingDoctorId",
                    doctorId);

            session.setAttribute(
                    "bookingDate",
                    appointmentDate);

            session.setAttribute(
                    "bookingTime",
                    appointmentTime);

            session.setAttribute(
                    "bookingAvailabilityId",
                    availabilityId);

            session.setAttribute(
                    "bookingSlotNumber",
                    slotNumber);

            // Redirect to confirmation page.
            response.sendRedirect(
                    request.getContextPath()
                    + "/Patient/BookAppointment.jsp");

            return;
        }


        // ========================================================
        // STEP 2: PATIENT CONFIRMS APPOINTMENT AND DEMO PAYMENT
        // ========================================================

        if ("confirmBooking".equals(action)) {

            String doctorId =
                    (String) session.getAttribute(
                            "bookingDoctorId");

            String appointmentDate =
                    (String) session.getAttribute(
                            "bookingDate");

            String appointmentTime =
                    (String) session.getAttribute(
                            "bookingTime");

            Integer availabilityId =
                    (Integer) session.getAttribute(
                            "bookingAvailabilityId");

            Integer slotNumber =
                    (Integer) session.getAttribute(
                            "bookingSlotNumber");

            String reason =
                    request.getParameter("reason");

            // Check booking session.
            if (isEmpty(doctorId) ||
                !isValidDate(appointmentDate) ||
                !isValidTime(appointmentTime) ||
                availabilityId == null ||
                slotNumber == null) {

                clearBookingSession(session);

                response.sendRedirect(
                        request.getContextPath()
                        + "/PatientAppointmentServlet");

                return;
            }

            // Validate reason.
            if (reason == null) {
                reason = "";
            }

            reason = reason.trim();

            if (reason.length() > 500) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/Patient/BookAppointment.jsp"
                        + "?error=reason");

                return;
            }

            // Verify doctor still exists and is approved.
            Doctor doctor =
                    dao.getDoctorById(doctorId);

            if (doctor == null) {

                clearBookingSession(session);

                response.sendRedirect(
                        request.getContextPath()
                        + "/PatientAppointmentServlet");

                return;
            }

            /*
             * IMPORTANT:
             * Do not rely on an earlier slot check here.
             *
             * bookAppointmentWithDemoPayment() locks the
             * availability row, checks the slot again,
             * verifies the fee and inserts the appointment
             * with PAYMENT_STATUS = 'PAID' in one transaction.
             */

            boolean booked =
                    dao.bookAppointmentWithDemoPayment(
                            availabilityId,
                            slotNumber,
                            doctorId,
                            patient.getName(),
                            patient.getEmail(),
                            patient.getContact(),
                            appointmentDate,
                            appointmentTime,
                            reason);

            if (booked) {

                // Store success details for BookingSuccess.jsp.
                session.setAttribute(
                        "successDoctorId",
                        doctorId);

                session.setAttribute(
                        "successDoctorName",
                        doctor.getFullName());

                session.setAttribute(
                        "successSpecialization",
                        doctor.getSpecialization());

                session.setAttribute(
                        "successDate",
                        appointmentDate);

                session.setAttribute(
                        "successTime",
                        appointmentTime);

                session.setAttribute(
                        "successSlotNumber",
                        slotNumber);

                session.setAttribute(
                        "successAvailabilityId",
                        availabilityId);

                session.setAttribute(
                        "successReason",
                        reason);

                session.setAttribute(
                        "successPatientName",
                        patient.getName());

                session.setAttribute(
                        "successPatientEmail",
                        patient.getEmail());

                session.setAttribute(
                        "successPatientPhone",
                        patient.getContact());

                session.setAttribute(
                        "successConsultationFee",
                        doctor.getConsultationFees());

                session.setAttribute(
                        "successPaymentStatus",
                        "PAID");

                session.setAttribute(
                        "successAppointmentStatus",
                        "PENDING");

                // Clear temporary booking information.
                clearBookingSession(session);

                response.sendRedirect(
                        request.getContextPath()
                        + "/Patient/BookingSuccess.jsp");

            } else {

                /*
                 * Booking failed. It may be because:
                 * - another patient booked the slot;
                 * - the availability was removed;
                 * - the doctor is no longer approved;
                 * - the patient already has an appointment that day.
                 *
                 * No appointment/payment is committed on failure.
                 */

                clearBookingSession(session);

                redirectWithError(
                        request,
                        response,
                        doctorId,
                        appointmentDate,
                        "bookingFailed");
            }

            return;
        }

        // Unknown action.
        response.sendRedirect(
                request.getContextPath()
                + "/PatientAppointmentServlet");
    }


    // ============================================================
    // VALIDATE SELECTED SLOT AGAINST AVAILABILITY
    // ============================================================

    private boolean isValidSelectedSlot(
            List<DoctorAvailability> availabilityList,
            int availabilityId,
            int slotNumber,
            String appointmentTime) {

        if (availabilityList == null) {
            return false;
        }

        for (DoctorAvailability a : availabilityList) {

            if (a.getAvailabilityId() != availabilityId) {
                continue;
            }

            int start = convertToMinutes(a.getStartTime());
            int end = convertToMinutes(a.getEndTime());

            int duration = a.getSlotDuration();

            int selected =
                    convertToMinutes(appointmentTime);

            if (start < 0 ||
                end <= start ||
                selected < start ||
                duration <= 0) {

                return false;
            }

            int difference = selected - start;

            if (difference % duration != 0) {
                return false;
            }

            int calculatedSlot =
                    (difference / duration) + 1;

            return calculatedSlot == slotNumber
                    && selected + duration <= end;
        }

        return false;
    }


    // ============================================================
    // TIME CONVERSION
    // ============================================================

    private int convertToMinutes(String time) {

        try {

            if (!isValidTime(time)) {
                return -1;
            }

            String[] parts = time.split(":");

            int hour = Integer.parseInt(parts[0]);
            int minute = Integer.parseInt(parts[1]);

            return hour * 60 + minute;

        } catch (Exception e) {
            return -1;
        }
    }


    // ============================================================
    // VALIDATE DATE
    // ============================================================

    private boolean isValidDate(String date) {

        if (date == null ||
            !date.matches("\\d{4}-\\d{2}-\\d{2}")) {

            return false;
        }

        try {

            Date.valueOf(date);
            return true;

        } catch (IllegalArgumentException e) {
            return false;
        }
    }


    // ============================================================
    // VALIDATE TIME
    // ============================================================

    private boolean isValidTime(String time) {

        if (time == null ||
            !time.matches("\\d{2}:\\d{2}")) {

            return false;
        }

        try {

            String[] parts = time.split(":");

            int hour = Integer.parseInt(parts[0]);
            int minute = Integer.parseInt(parts[1]);

            return hour >= 0 &&
                   hour <= 23 &&
                   minute >= 0 &&
                   minute <= 59;

        } catch (Exception e) {
            return false;
        }
    }


    // ============================================================
    // EMPTY CHECK
    // ============================================================

    private boolean isEmpty(String value) {

        return value == null ||
               value.trim().isEmpty();
    }


    // ============================================================
    // CLEAR TEMPORARY BOOKING SESSION
    // ============================================================

    private void clearBookingSession(HttpSession session) {

        session.removeAttribute("bookingDoctorId");
        session.removeAttribute("bookingDate");
        session.removeAttribute("bookingTime");
        session.removeAttribute("bookingAvailabilityId");
        session.removeAttribute("bookingSlotNumber");
    }


    // ============================================================
    // REDIRECT WITH ERROR
    // ============================================================

    private void redirectWithError(
            HttpServletRequest request,
            HttpServletResponse response,
            String doctorId,
            String appointmentDate,
            String error)
            throws IOException {

        String url =
                request.getContextPath()
                + "/PatientAppointmentServlet"
                + "?doctorId=" + encode(doctorId);

        if (appointmentDate != null) {
            url += "&appointmentDate="
                    + encode(appointmentDate);
        }

        url += "&error=" + encode(error);

        response.sendRedirect(url);
    }


    // ============================================================
    // URL ENCODING
    // ============================================================

    private String encode(String value)
            throws IOException {

        return URLEncoder.encode(value, "UTF-8");
    }
}
