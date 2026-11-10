package servlet;

import dao.AvailabilityDAO;
import model.Doctor;
import model.DoctorAvailability;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Date;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;
import java.util.Locale;

public class AvailabilityServlet extends HttpServlet {

    private static final List<Integer> VALID_DURATIONS =
            Arrays.asList(15, 30, 60);

    // =========================================================
    // GET: DISPLAY AVAILABILITY
    // =========================================================

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        Doctor doctor = (session == null) ? null :
                (Doctor) session.getAttribute("doctor");

        if (doctor == null || doctor.getDoctorId() == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        AvailabilityDAO dao = new AvailabilityDAO();

        List<DoctorAvailability> availabilityList =
                dao.getAvailabilityByDoctor(doctor.getDoctorId());

        request.setAttribute("availabilityList", availabilityList);

        request.getRequestDispatcher(
                "/doctor/availability.jsp"
        ).forward(request, response);
    }

    // =========================================================
    // POST: ADD OR DELETE AVAILABILITY
    // =========================================================

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);

        Doctor doctor = (session == null) ? null :
                (Doctor) session.getAttribute("doctor");

        if (doctor == null || doctor.getDoctorId() == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );

            return;
        }

        String doctorId = doctor.getDoctorId();

        String action = request.getParameter("action");

        AvailabilityDAO dao = new AvailabilityDAO();

        // =====================================================
        // DELETE AVAILABILITY
        // =====================================================

        if ("delete".equalsIgnoreCase(action)) {

            String idString = request.getParameter("id");

            try {

                if (idString == null || idString.trim().isEmpty()) {

                    redirectWithMessage(
                            request, response, "error",
                            "Invalid availability ID"
                    );

                    return;
                }

                int availabilityId = Integer.parseInt(idString);

                if (availabilityId <= 0) {

                    redirectWithMessage(
                            request, response, "error",
                            "Invalid availability ID"
                    );

                    return;
                }

                boolean deleted = dao.deleteAvailability(
                        availabilityId,
                        doctorId
                );

                if (deleted) {

                    redirectWithMessage(
                            request, response, "success",
                            "Availability deleted successfully"
                    );

                } else {

                    redirectWithMessage(
                            request, response, "error",
                            "Availability not found or could not be deleted"
                    );
                }

            } catch (NumberFormatException e) {

                redirectWithMessage(
                        request, response, "error",
                        "Invalid availability ID"
                );
            }

            return;
        }

        // =====================================================
        // ADD AVAILABILITY
        // =====================================================

        if (action != null && !"add".equalsIgnoreCase(action)) {

            redirectWithMessage(
                    request, response, "error",
                    "Invalid action"
            );

            return;
        }

        String dateString =
                request.getParameter("availabilityDate");

        String startTime =
                request.getParameter("startTime");

        String endTime =
                request.getParameter("endTime");

        String durationString =
                request.getParameter("slotDuration");

        // =====================================================
        // CHECK EMPTY FIELDS
        // =====================================================

        if (dateString == null ||
            startTime == null ||
            endTime == null ||
            durationString == null ||
            dateString.trim().isEmpty() ||
            startTime.trim().isEmpty() ||
            endTime.trim().isEmpty() ||
            durationString.trim().isEmpty()) {

            redirectWithMessage(
                    request, response, "error",
                    "Please complete all availability fields"
            );

            return;
        }

        dateString = dateString.trim();
        startTime = startTime.trim();
        endTime = endTime.trim();
        durationString = durationString.trim();

        // =====================================================
        // VALIDATE DATE
        // =====================================================

        Date availabilityDate;

        try {

            SimpleDateFormat dateFormat =
                    new SimpleDateFormat("yyyy-MM-dd", Locale.ENGLISH);

            dateFormat.setLenient(false);

            java.util.Date parsedDate =
                    dateFormat.parse(dateString);

            // Ensure the entire submitted string is valid.
            if (!dateFormat.format(parsedDate).equals(dateString)) {

                redirectWithMessage(
                        request, response, "error",
                        "Invalid availability date"
                );

                return;
            }

            availabilityDate =
                    new Date(parsedDate.getTime());

        } catch (ParseException e) {

            redirectWithMessage(
                    request, response, "error",
                    "Invalid availability date"
            );

            return;
        }

        // Compare calendar dates, not the current time.
        Calendar selectedCalendar = Calendar.getInstance();
        selectedCalendar.setTime(availabilityDate);
        selectedCalendar.set(
                Calendar.HOUR_OF_DAY, 0
        );
        selectedCalendar.set(Calendar.MINUTE, 0);
        selectedCalendar.set(Calendar.SECOND, 0);
        selectedCalendar.set(Calendar.MILLISECOND, 0);

        Calendar todayCalendar = Calendar.getInstance();
        todayCalendar.set(
                Calendar.HOUR_OF_DAY, 0
        );
        todayCalendar.set(Calendar.MINUTE, 0);
        todayCalendar.set(Calendar.SECOND, 0);
        todayCalendar.set(Calendar.MILLISECOND, 0);

        if (selectedCalendar.before(todayCalendar)) {

            redirectWithMessage(
                    request, response, "error",
                    "You cannot add availability for a past date"
            );

            return;
        }

        // =====================================================
        // VALIDATE TIME FORMAT
        // =====================================================

        if (!startTime.matches("([01][0-9]|2[0-3]):[0-5][0-9]") ||
            !endTime.matches("([01][0-9]|2[0-3]):[0-5][0-9]")) {

            redirectWithMessage(
                    request, response, "error",
                    "Invalid start or end time"
            );

            return;
        }

        if (endTime.compareTo(startTime) <= 0) {

            redirectWithMessage(
                    request, response, "error",
                    "End time must be later than start time"
            );

            return;
        }

        // =====================================================
        // VALIDATE CONSULTATION DURATION
        // =====================================================

        int slotDuration;

        try {

            slotDuration = Integer.parseInt(durationString);

        } catch (NumberFormatException e) {

            redirectWithMessage(
                    request, response, "error",
                    "Invalid consultation duration"
            );

            return;
        }

        if (!VALID_DURATIONS.contains(slotDuration)) {

            redirectWithMessage(
                    request, response, "error",
                    "Select a valid consultation duration"
            );

            return;
        }

        // =====================================================
        // CHECK THAT AT LEAST ONE COMPLETE SLOT FITS
        // =====================================================

        String[] startParts = startTime.split(":");
        String[] endParts = endTime.split(":");

        int startMinutes =
                Integer.parseInt(startParts[0]) * 60
                + Integer.parseInt(startParts[1]);

        int endMinutes =
                Integer.parseInt(endParts[0]) * 60
                + Integer.parseInt(endParts[1]);

        if ((endMinutes - startMinutes) < slotDuration) {

            redirectWithMessage(
                    request, response, "error",
                    "The selected time range is shorter than one consultation"
            );

            return;
        }

        // =====================================================
        // AUTOMATICALLY CALCULATE WEEKDAY
        // =====================================================

        SimpleDateFormat dayFormat =
                new SimpleDateFormat("EEEE", Locale.ENGLISH);

        String dayOfWeek =
                dayFormat.format(availabilityDate).toUpperCase(Locale.ENGLISH);

        // =====================================================
        // CREATE AVAILABILITY OBJECT
        // =====================================================

        DoctorAvailability availability =
                new DoctorAvailability(
                        doctorId,
                        dayOfWeek,
                        availabilityDate,
                        startTime,
                        endTime,
                        slotDuration
                );

        boolean saved = dao.addAvailability(availability);

        if (saved) {

            redirectWithMessage(
                    request, response, "success",
                    "Availability saved successfully"
            );

        } else {

            redirectWithMessage(
                    request, response, "error",
                    "Unable to save availability. Check for overlapping schedules on this date."
            );
        }
    }

    // =========================================================
    // REDIRECT HELPER
    // =========================================================

    private void redirectWithMessage(
            HttpServletRequest request,
            HttpServletResponse response,
            String type,
            String message) throws IOException {

        response.sendRedirect(
                request.getContextPath()
                + "/AvailabilityServlet?"
                + type + "="
                + java.net.URLEncoder.encode(message, "UTF-8")
        );
    }
}