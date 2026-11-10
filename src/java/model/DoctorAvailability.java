package model;

import java.sql.Date;

public class DoctorAvailability {

    private int availabilityId;
    private String doctorId;
    private String dayOfWeek;
    private Date availabilityDate;
    private String startTime;
    private String endTime;
    private int slotDuration;
    private String status;

    public DoctorAvailability() {
    }

    // Constructor for creating new date-based availability
    public DoctorAvailability(String doctorId,
                              String dayOfWeek,
                              Date availabilityDate,
                              String startTime,
                              String endTime,
                              int slotDuration) {

        this.doctorId = doctorId;
        this.dayOfWeek = dayOfWeek;
        this.availabilityDate = availabilityDate;
        this.startTime = startTime;
        this.endTime = endTime;
        this.slotDuration = slotDuration;
    }

    public int getAvailabilityId() {
        return availabilityId;
    }

    public void setAvailabilityId(int availabilityId) {
        this.availabilityId = availabilityId;
    }

    public String getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }

    public String getDayOfWeek() {
        return dayOfWeek;
    }

    public void setDayOfWeek(String dayOfWeek) {
        this.dayOfWeek = dayOfWeek;
    }

    public Date getAvailabilityDate() {
        return availabilityDate;
    }

    public void setAvailabilityDate(Date availabilityDate) {
        this.availabilityDate = availabilityDate;
    }

    public String getStartTime() {
        return startTime;
    }

    public void setStartTime(String startTime) {
        this.startTime = startTime;
    }

    public String getEndTime() {
        return endTime;
    }

    public void setEndTime(String endTime) {
        this.endTime = endTime;
    }

    public int getSlotDuration() {
        return slotDuration;
    }

    public void setSlotDuration(int slotDuration) {
        this.slotDuration = slotDuration;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }
}