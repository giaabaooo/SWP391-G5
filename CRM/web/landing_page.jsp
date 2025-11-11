<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>Home - Technical Support Services</title>
        <meta content="width=device-width, initial-scale=1.0" name="viewport">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <link href="${pageContext.request.contextPath}/css/login/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/login/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />
        <link href="${pageContext.request.contextPath}/css/login/log/bootstrap.min.css" rel="stylesheet">
        <link href="${pageContext.request.contextPath}/css/login/log/style.css" rel="stylesheet">

        <style>
            /* (Toàn bộ CSS cũ của bạn ở đây: .hero, .service-box, v.v...) */
            .hero {
                background: linear-gradient(rgba(24, 29, 56, .8), rgba(24, 29, 56, .8)), url(https://via.placeholder.com/1920x800.png?text=Technician);
                background-position: center center;
                background-repeat: no-repeat;
                background-size: cover;
                padding: 12rem 0;
                color: white;
            }
            .hero h1 {
                font-size: 3.2rem;
                font-weight: 700;
            }
            .hero p {
                font-size: 1.2rem;
                max-width: 700px;
                margin: 1.5rem auto;
            }
            .section-padding {
                padding: 5rem 0;
            }
            .section-title {
                font-weight: 600;
                color: #2d3748;
                margin-bottom: 3rem;
            }
            .service-box {
                padding: 2.5rem;
                border-radius: 8px;
                background: #fff;
                box-shadow: 0 4px 15px rgba(0,0,0,0.07);
                transition: all 0.3s ease;
                height: 100%;
            }
            .service-box:hover {
                transform: translateY(-10px);
                box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            }
            .service-icon {
                font-size: 3.5rem;
                color: var(--primary);
                margin-bottom: 1.5rem;
            }
            .flow-step {
                text-align: center;
                position: relative;
            }
            .flow-step .step-icon {
                width: 80px;
                height: 80px;
                background: var(--primary);
                color: white;
                border-radius: 50%;
                display: inline-flex;
                align-items: center;
                justify-content: center;
                font-size: 2.5rem;
                border: 5px solid #f8f9fa;
                box-shadow: 0 0 0 5px var(--primary);
            }
            .flow-step h5 {
                margin-top: 1.5rem;
            }
            .testimonial-box {
                font-style: italic;
                font-size: 1.1rem;
                padding: 2rem;
                background: #f8f9fa;
                border-left: 5px solid var(--primary);
                border-radius: 5px;
            }
            .footer {
                background-color: #343a40;
                padding: 3rem 0 1rem 0;
                color: #adb5bd;
            }
            .footer a {
                color: #fff;
                text-decoration: none;
            }
            .footer a:hover {
                text-decoration: underline;
            }
            /* CSS cho Form liên hệ */
            .contact-form .form-control {
                padding: 1rem;
                height: auto;
                border-radius: 5px;
            }
            .contact-form .form-label {
                font-weight: 600;
                color: #555;
            }
            .contact-form .validation-error {
                display: none;
                color: #dc3545;
                font-size: 0.9em;
                margin-top: 5px;
            }
            .contact-form .form-group.has-error .form-control {
                border-color: #dc3545;
            }
            .contact-form .form-group.has-error .validation-error {
                display: block;
            }
            /* CSS cho Thông báo (Alert) */
            .contact-alert {
                display: none; /* Ẩn mặc định */
                padding: 1rem 1.5rem;
                border-radius: 5px;
                margin-bottom: 1.5rem;
                font-size: 1.1rem;
            }
            .contact-alert.success {
                background-color: #d4edda;
                border-color: #c3e6cb;
                color: #155724;
            }
            .contact-alert.error {
                background-color: #f8d7da;
                border-color: #f5c6cb;
                color: #721c24;
            }
        </style>
    </head>

    <body>
        <div class="container-fluid position-relative bg-white d-flex p-0">
            <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                    <span class="sr-only">Loading...</span>
                </div>
            </div>

            <div class="container-fluid" style="padding: 0;">

                <section class="hero text-center">
                    <div class="container" style="position: relative;">

                        <img src="img/logo-Crm.png" alt="Logo" style="
                             position: absolute;
                             max-height: 210px;
                             top: -125px;
                             left: 50%;
                             transform: translateX(-50%);
                             ">

                        <h1>Device Warranty & Repair Services<br>Fast – Professional – Transparent</h1>
                        <p>We support customers with warranty, maintenance, and repairs for all devices – even those not purchased from our system.</p>

                        <a href="#services" class="btn btn-primary py-3 px-5 me-2 mt-2">View Services</a>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-light py-3 px-5 me-2 mt-2">Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light py-3 px-5 mt-2">Register</a>
                    </div>
                </section>

                <section class="container section-padding">
                    <div class="row align-items-center g-5">
                        <div class="col-lg-6">
                            <img src="img/bao-duong-1.jpg" class="img-fluid rounded" alt="Technical Team">
                        </div>
                        <div class="col-lg-6">
                            <h2 class="section-title text-start">About Us</h2>
                            <p class="lead">We provide electronic and industrial equipment, along with nationwide technical support.</p>
                            <p>With a team of certified technicians and a transparent workflow, we are committed to delivering the fastest and most professional service experience, getting your equipment back up and running in no time.</p>
                        </div>
                    </div>
                </section>

                <section id="services" class="section-padding bg-light">
                    <div class="container">
                        <h2 class="section-title text-center">Main Services</h2>
                        <div class="row g-4">
                            <div class="col-md-4">
                                <div class="service-box text-center">
                                    <div class="service-icon"><i class="fa fa-shield-alt"></i></div>
                                    <h5>🛡️Warranty</h5>
                                    <p>Easily track and claim warranties for products purchased through our system.</p>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary mt-3">Manage Warranties</a>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="service-box text-center">
                                    <div class="service-icon"><i class="fa fa-shield-alt"></i></div>
                                    <h5>🔄 Maintenance</h5>
                                    <p>Schedule maintenance, inspections, and periodic device calibration to ensure optimal performance.</p>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary mt-3">Schedule Maintenance</a>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="service-box text-center">
                                    <div class="service-icon"><i class="fa fa-shield-alt"></i></div>
                                    <h5>🧰  Repairs</h5>
                                    <p>Quickly submit repair requests for any device, including products not from our system.</p>
                                    <a href="${pageContext.request.contextPath}/login" class="btn btn-outline-primary mt-3">Submit Request Now</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="section-padding" style="background-color: var(--primary); color: white;">
                    <div class="container text-center">
                        <h2 class="section-title text-center" style="color: white;">Already have an account?</h2>
                        <p class="lead mb-4">Log in to the CRM system to access your dashboard and manage your tasks.</p>
                        <a href="${pageContext.request.contextPath}/login" class="btn btn-light btn-lg py-3 px-5 me-2 mt-2">🔐 System Login</a>
                        <a href="${pageContext.request.contextPath}/register" class="btn btn-outline-light btn-lg py-3 px-5 mt-2">Register New Account</a>
                    </div>
                </section>

                <section id="flow" class="container section-padding">
                    <h2 class="section-title text-center">How It Works</h2>
                    <div class="row g-4">
                        <div class="col-md-3 flow-step">
                            <div class="step-icon"><i class="fa fa-paper-plane"></i></div>
                            <h5>1. Submit Request</h5>
                            <p>You send a request via the form or by logging into the system.</p>
                        </div>
                        <div class="col-md-3 flow-step">
                            <div class="step-icon"><i class="fa fa-clipboard-check"></i></div>
                            <h5>2. Get Confirmation</h5>
                            <p>Support receives, classifies, and sends a quote (if applicable).</p>
                        </div>
                        <div class="col-md-3 flow-step">
                            <div class="step-icon"><i class="fa fa-truck"></i></div>
                            <h5>3. Track Progress</h5>
                            <p>A technician processes the request and updates the status online.</p>
                        </div>
                        <div class="col-md-3 flow-step">
                            <div class="step-icon"><i class="fa fa-star"></i></div>
                            <h5>4. Pay & Feedback</h5>
                            <p>Pay any costs (if applicable) and rate the quality of service.</p>
                        </div>
                    </div>
                </section>

                <section id="testimonials" class="section-padding bg-light">
                    <div class="container">
                        <h2 class="section-title text-center">What Our Clients Say</h2>
                        <div class="row g-4">
                            <div class="col-md-6">
                                <div class="testimonial-box">
                                    <p>"Fast service, and the staff was very enthusiastic! I was able to track the entire repair process for my equipment through the system."</p>
                                    <strong>– John D., Technical Director</strong>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="testimonial-box">
                                    <p>"The device was repaired right on schedule. The warranty management system saved our company a lot of time."</p>
                                    <strong>– Jane S., IT Manager</strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section id="contact" class="container section-padding">
                    <h2 class="section-title text-center">Contact Us for Support</h2>
                    <p class="lead text-center" style="margin-top: -2rem; margin-bottom: 3rem;">Have questions? Fill out the form below and we will get back to you.</p>

                    <div class="row">
                        <div class="col-md-8 offset-md-2">
                            <% if (request.getAttribute("error") != null) { %>
                            <div class="contact-alert error" style="display:block;"> 
                                <i class="fa fa-exclamation-triangle"></i> <%= request.getAttribute("error") %>
                            </div>
                            <% } %>
                            <% if (request.getAttribute("success") != null) { %>
                            <div class="contact-alert success" style="display:block;"> 
                                <i class="fa fa-check-circle"></i> <%= request.getAttribute("success") %>
                            </div>
                            <% } %>

                            <form id="guestContactForm" action="${pageContext.request.contextPath}/guestcontact" method="POST" class="contact-form" onsubmit="return validateContactForm();">
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="form-group mb-3" id="fullNameGroup">
                                            <label class="form-label" for="fullName">Full Name <span style="color:red">*</span></label>
                                            <input type="text" id="fullName" name="fullName" class="form-control" placeholder="Your Name">
                                            <div class="validation-error">Full Name is required.</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="form-group mb-3" id="emailGroup">
                                            <label class="form-label" for="email">Email <span style="color:red">*</span></label>
                                            <input type="email" id="email" name="email" class="form-control" placeholder="your.email@example.com">
                                            <div class="validation-error">A valid email is required.</div>
                                        </div>
                                    </div>
                                </div>
                                <div class="form-group mb-3" style="margin-top: 15px;" id="phoneGroup">
                                    <label class="form-label" for="phone">Phone <span style="color:red">*</span></label>
                                    <input type="tel" id="phone" name="phone" class="form-control" placeholder="Your Phone Number">
                                    <div class="validation-error">Invalid phone number. Only numbers, +, - are allowed.</div>
                                </div>
                                <div class="form-group mb-3" style="margin-top: 15px;" id="messageGroup">
                                    <label class="form-label" for="message">Message <span style="color:red">*</span></label>
                                    <textarea id="message" name="message" class="form-control" rows="5" placeholder="How can we help you?"></textarea>
                                    <div class="validation-error">Message cannot be empty.</div>
                                </div>

                                <div class="text-center" style="margin-top: 25px;">
                                    <button type="submit" class="btn btn-primary btn-lg py-3 px-5">Send Message</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </section>

                <footer class="footer">
                    <div class="container">
                        <div class="row g-4">
                            <div class="col-md-4">
                                <h5>About Us</h5>
                                <p>CRM System for Device Management & Technical Services.</p>
                            </div>
                            <div class="col-md-4">
                                <h5>Contact Us</h5>
                                <p class="mb-1"><i class="fa fa-phone-alt me-2"></i> Hotline: 1-800-123-4567</p>
                                <p class="mb-1"><i class="fa fa-envelope me-2"></i> Email: support@crm.com</p>
                                <p class="mb-1"><i class="fa fa-map-marker-alt me-2"></i> Address: 123 Main St, New York, NY</p>
                            </div>
                            <div class="col-md-4">
                                <h5>Policies</h5>
                                <p class="mb-1"><a href="#">Warranty Policy</a></p>
                                <p class="mb-1"><a href="#">Terms of Service</a></p>
                            </div>
                        </div>
                        <hr class="my-3">
                        <p class="text-center mb-0">&copy; 2025 CRM System. All rights reserved.</p>
                    </div>
                </footer>
            </div>
        </div>

        <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>

        <script src="js/main.js"></script>

        <script>
                                function validateContactForm() {
                                    var isValid = true;
                                    $('.form-group.has-error').removeClass('has-error');
                                    $('.contact-alert').hide();


                                    var fullName = $('#fullName').val().trim();
                                    var email = $('#email').val().trim();
                                    var message = $('#message').val().trim();
                                    var phone = $('#phone').val().trim(); 


                                    if (fullName === '') {
                                        $('#fullNameGroup').addClass('has-error');
                                        isValid = false;
                                    }
                                    if (email === '' || email.indexOf('@') === -1 || email.indexOf('.') === -1) {
                                        $('#emailGroup').addClass('has-error');
                                        isValid = false;
                                    }
                                    if (message === '') {
                                        $('#messageGroup').addClass('has-error');
                                        isValid = false;
                                    }

                                    if (phone !== '') {
                                        var phoneRegex = /^[0-9+\-\s]+$/;
                                        if (!phoneRegex.test(phone)) {
                                            $('#phoneGroup').addClass('has-error'); 
                                            isValid = false;
                                        }
                                    }

                                    if (!isValid) {
                                        $('html, body').animate({
                                            scrollTop: $(".has-error").first().offset().top - 100
                                        }, 500);
                                    } else {
                                        var submitBtn = $('#contactSubmitBtn');
                                        submitBtn.prop('disabled', true).html('<i class="fa fa-spinner fa-spin"></i> Sending...');
                                    }
                                    return isValid; 
                                }
        </script>
    </body>
</html>