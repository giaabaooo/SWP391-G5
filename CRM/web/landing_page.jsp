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

        <link href="css/login/log/bootstrap.min.css" rel="stylesheet">
        <link href="css/login/log/style.css" rel="stylesheet">

        <style>
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
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-light py-3 px-5 me-2 mt-2">Login</a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-light py-3 px-5 mt-2">Register</a>
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
                                    <h5>🛡️ Product Warranty</h5>
                                    <p>Easily track and claim warranties for products purchased through our system.</p>
                                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary mt-3">Manage Warranties</a>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="service-box text-center">
                                    <div class="service-icon"><i class="fa fa-sync-alt"></i></div>
                                    <h5>🔄 Periodic Maintenance</h5>
                                    <p>Schedule maintenance, inspections, and periodic device calibration to ensure optimal performance.</p>
                                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-primary mt-3">Schedule Maintenance</a>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="service-box text-center">
                                    <div class="service-icon"><i class="fa fa-tools"></i></div>
                                    <h5>🧰 Out-of-Warranty Repairs</h5>
                                    <p>Quickly submit repair requests for any device, including products not from our system.</p>
                                    <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-primary mt-3">Submit Request Now</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="section-padding" style="background-color: var(--primary); color: white;">
                    <div class="container text-center">
                        <h2 class="section-title text-center" style="color: white;">Already have an account?</h2>
                        <p class="lead mb-4">Log in to the CRM system to access your dashboard and manage your tasks.</p>
                        <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-light btn-lg py-3 px-5 me-2 mt-2">🔐 System Login</a>
                        <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-outline-light btn-lg py-3 px-5 mt-2">Register New Account</a>
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
                            <h5>4. Pay & Review</h5>
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

                <section class="container section-padding text-center">
                    <h2>Need Technical Support Today?</h2>
                    <p class="lead my-4">Don't let broken equipment interrupt your workflow. Let us handle it.</p>
                    <a href="#services" class="btn btn-primary btn-lg py-3 px-5">Create a Request Now</a>
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
            $(document).ready(function () {
                $('#spinner').removeClass('show');
                var scrollSpy = new bootstrap.ScrollSpy(document.body, {
                    target: '#navbarCollapse',
                    offset: 70
                });
            });
        </script>
    </body>
</html>