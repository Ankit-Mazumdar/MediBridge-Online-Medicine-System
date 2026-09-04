package servlet;

import dao.AvailabilityDAO;
import model.Doctor;
import model.DoctorAvailability;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;


// If you already mapped AvailabilityServlet in web.xml,
// remove the @WebServlet line below.
//
// If you are using annotations, keep it.
//
// @WebServlet("/AvailabilityServlet")

public class AvailabilityServlet extends HttpServlet {


    // ============================================================
    // GET
    // ============================================================
    // Loads the doctor's existing availability
    // and opens availability.jsp
    // ============================================================

    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session =
                request.getSession();

        Doctor doctor =
                (Doctor) session.getAttribute("doctor");


        // --------------------------------------------------------
        // Check login
        // --------------------------------------------------------

        if (doctor == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        // --------------------------------------------------------
        // Get doctor ID
        // --------------------------------------------------------

        String doctorId =
                doctor.getDoctorId();


        // --------------------------------------------------------
        // Get availability from database
        // --------------------------------------------------------

        AvailabilityDAO availabilityDAO =
                new AvailabilityDAO();

        List<DoctorAvailability> availabilityList =
                availabilityDAO.getAvailabilityByDoctor(
                        doctorId
                );


        // --------------------------------------------------------
        // Send list to JSP
        // --------------------------------------------------------

        request.setAttribute(
                "availabilityList",
                availabilityList
        );


        // --------------------------------------------------------
        // Open availability.jsp
        // --------------------------------------------------------

        request.getRequestDispatcher(
                "doctor/availability.jsp"
        ).forward(request, response);
    }



    // ============================================================
    // POST
    // ============================================================
    // Saves new availability
    // ============================================================

    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {


        HttpSession session =
                request.getSession();

        Doctor doctor =
                (Doctor) session.getAttribute("doctor");


        // --------------------------------------------------------
        // Check login
        // --------------------------------------------------------

        if (doctor == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }


        // --------------------------------------------------------
        // Get doctor ID
        // --------------------------------------------------------

        String doctorId =
                doctor.getDoctorId();


        // --------------------------------------------------------
        // Get form values
        // --------------------------------------------------------

        String dayOfWeek =
                request.getParameter("dayOfWeek");

        String startTime =
                request.getParameter("startTime");

        String endTime =
                request.getParameter("endTime");

        String slotDurationString =
                request.getParameter("slotDuration");


        // --------------------------------------------------------
        // Convert duration
        // --------------------------------------------------------

        int slotDuration =
                Integer.parseInt(slotDurationString);


        // --------------------------------------------------------
        // Create DoctorAvailability object
        // --------------------------------------------------------

        DoctorAvailability availability =
                new DoctorAvailability(
                        doctorId,
                        dayOfWeek,
                        startTime,
                        endTime,
                        slotDuration
                );


        // --------------------------------------------------------
        // Save to database
        // --------------------------------------------------------

        AvailabilityDAO availabilityDAO =
                new AvailabilityDAO();

        boolean result =
                availabilityDAO.addAvailability(
                        availability
                );


        // --------------------------------------------------------
        // Redirect
        // --------------------------------------------------------

        if (result) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/AvailabilityServlet"
                    + "?success=Availability+saved+successfully"
            );

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/AvailabilityServlet"
                    + "?error=Unable+to+save+availability"
            );
        }
    }
}