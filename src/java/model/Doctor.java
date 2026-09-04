package model;

import java.sql.Timestamp;

public class Doctor {

    private String doctorId;
    private String fullName;
    private String email;
    private String password;
    private String phone;
    private String gender;
    private String specialization;
    private String qualification;
    private String medicalRegistrationNo;
    private Integer experience;
    private byte[] medicalCertificate;
    private byte[] govtIdPhoto;
    private String status;
    private Timestamp createdAt;

    public String getDoctorId() {
        return doctorId;
    }

    public void setDoctorId(String doctorId) {
        this.doctorId = doctorId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getQualification() {
        return qualification;
    }

    public void setQualification(String qualification) {
        this.qualification = qualification;
    }

    public String getMedicalRegistrationNo() {
        return medicalRegistrationNo;
    }

    public void setMedicalRegistrationNo(String medicalRegistrationNo) {
        this.medicalRegistrationNo = medicalRegistrationNo;
    }

    public Integer getExperience() {
        return experience;
    }

    public void setExperience(Integer experience) {
        this.experience = experience;
    }

    public byte[] getMedicalCertificate() {
        return medicalCertificate;
    }

    public void setMedicalCertificate(byte[] medicalCertificate) {
        this.medicalCertificate = medicalCertificate;
    }

    public byte[] getGovtIdPhoto() {
        return govtIdPhoto;
    }

    public void setGovtIdPhoto(byte[] govtIdPhoto) {
        this.govtIdPhoto = govtIdPhoto;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    
    
}
