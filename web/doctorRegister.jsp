<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>

    <title>Doctor Registration | MediBridge</title>

    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/login.css">
    <link rel="stylesheet" href="css/doctorRegister.css">

</head>

<body class="auth-page">

    <div class="register-shell">

        <div class="register-head">

            <h1>Doctor Registration</h1>

            <p>
                Join MediBridge as a verified healthcare provider.
            </p>

        </div>


        <!-- Registration Form -->

        <form action="DoctorRegistrationServlet"
              method="post"
              enctype="multipart/form-data">


            <!-- Personal Information -->

            <div class="form-section">

                <div class="form-section-title">
                    Personal Information
                </div>

                <div class="field-grid">

                    <div class="field field-full">

                        <label>Full Name</label>

                        <input type="text"
                               name="fullName"
                               placeholder="Dr. Full Name"
                               required>

                    </div>


                    <div class="field">

                        <label>Email</label>

                        <input type="email"
                               name="email"
                               placeholder="Email"
                               required>

                    </div>


                    <div class="field">

                        <label>Phone Number</label>

                        <input type="text"
                               name="phone"
                               placeholder="10-digit mobile number"
                               required>

                    </div>


                    <div class="field">

                        <label>Password</label>

                        <input type="password"
                               name="password"
                               placeholder="Create password"
                               required>

                    </div>


                    <div class="field">

                        <label>Confirm Password</label>

                        <input type="password"
                               name="confirmPassword"
                               placeholder="Re-enter password"
                               required>

                    </div>


                    <div class="field field-full">

                        <label>Gender</label>

                        <div class="pill-group">

                            <input type="radio"
                                   id="male"
                                   name="gender"
                                   value="Male"
                                   checked>

                            <label for="male">Male</label>


                            <input type="radio"
                                   id="female"
                                   name="gender"
                                   value="Female">

                            <label for="female">Female</label>


                            <input type="radio"
                                   id="other"
                                   name="gender"
                                   value="Other">

                            <label for="other">Other</label>

                        </div>

                    </div>

                </div>

            </div>


            <!-- Professional Details -->

            <div class="form-section">

                <div class="form-section-title">
                    Professional Details
                </div>

                <div class="field-grid">


                    <div class="field">

                        <label>Specialization</label>

                        <select name="specialization" required>

                            <option value="">
                                Select Specialization
                            </option>

                            <option value="General Physician">
                                General Physician
                            </option>

                            <option value="Cardiologist">
                                Cardiologist
                            </option>

                            <option value="Dermatologist">
                                Dermatologist
                            </option>

                            <option value="Pediatrician">
                                Pediatrician
                            </option>

                            <option value="Orthopedic Surgeon">
                                Orthopedic Surgeon
                            </option>

                            <option value="Neurologist">
                                Neurologist
                            </option>

                            <option value="Gynecologist">
                                Gynecologist
                            </option>

                            <option value="ENT Specialist">
                                ENT Specialist
                            </option>

                            <option value="Psychiatrist">
                                Psychiatrist
                            </option>

                            <option value="Dentist">
                                Dentist
                            </option>

                            <option value="Other">
                                Other
                            </option>

                        </select>

                    </div>


                    <div class="field">

                        <label>Qualification</label>

                        <input type="text"
                               name="qualification"
                               placeholder="MBBS, MD"
                               required>

                    </div>


                    <div class="field">

                        <label>Medical Registration Number</label>

                        <input type="text"
                               name="medicalRegistrationNo"
                               placeholder="Registration number"
                               required>

                    </div>


                    <div class="field">

                        <label>Years of Experience</label>

                        <input type="number"
                               name="experience"
                               placeholder="e.g. 5"
                               min="0"
                               max="60"
                               required>

                    </div>

                </div>

            </div>


            <!-- Verification Documents -->

            <div class="form-section">

                <div class="form-section-title">
                    Verification Documents
                </div>


                <div class="upload-grid">


                    <div class="upload-box">

                        <div class="up-label">
                            Medical Certificate
                        </div>

                        <input type="file"
                               name="medicalCertificate"
                               accept=".pdf,.jpg,.jpeg,.png"
                               required>

                        <span class="up-hint">
                            PDF or image of your medical certificate.
                        </span>

                    </div>


                    <div class="upload-box">

                        <div class="up-label">
                            Government ID Photo
                        </div>

                        <input type="file"
                               name="govtIdPhoto"
                               accept=".jpg,.jpeg,.png"
                               required>

                        <span class="up-hint">
                            Upload a valid government ID.
                        </span>

                    </div>

                </div>

            </div>


            <!-- Terms -->

            <div class="terms-row">

                <input type="checkbox"
                       name="terms"
                       required>

                <label>
                    I agree to the terms and verification policy.
                </label>

            </div>


            <!-- Submit -->

            <button type="submit"
                    class="btn btn-primary btn-block">

                Submit for Verification

            </button>


            <p class="register-note">
                Your application will be reviewed before your account is activated.
            </p>


        </form>

    </div>

</body>
</html>