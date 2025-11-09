<%@ page pageEncoding="UTF-8" contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">

    <head>
        <meta charset="utf-8">
        <title>CRM - Register</title> 
        <meta content="width=device-width, initial-scale=1.0" name="viewport">
        <meta content="" name="keywords">
        <meta content="" name="description">

        <link rel="preconnect" href="https://fonts.googleapis.com">
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
        <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">

        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">

        <link href="css/login/lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">
        <link href="css/login/lib/tempusdominus/css/tempusdominus-bootstrap-4.min.css" rel="stylesheet" />

        <link href="css/login/log/bootstrap.min.css" rel="stylesheet">

        <link href="css/login/log/style.css" rel="stylesheet">
    </head>

    <body>
        <form class="login-form" action="register" method="POST">
            <div class="container-fluid position-relative bg-white d-flex p-0">
                <div id="spinner" class="show bg-white position-fixed translate-middle w-100 vh-100 top-50 start-50 d-flex align-items-center justify-content-center">
                    <div class="spinner-border text-primary" style="width: 3rem; height: 3rem;" role="status">
                        <span class="sr-only">Loading...</span>
                    </div>
                </div>
         
                <div class="container-fluid">
                    <div class="row h-100 align-items-center justify-content-center" style="min-height: 100vh;">
                        <div class="col-12 col-sm-8 col-md-6 col-lg-5 col-xl-4">
                             <div class="text-center mb-4">                                   
                                    <img src="img/logo-Crm.png" alt="Company Logo" style="max-width: 250px; margin-bottom: 1rem;"/>                          
                               </div>
                            
                            <div class="bg-light rounded p-4 p-sm-5 my-4 mx-3">
                                <div class="d-flex align-items-center justify-content-between mb-3">
                                    <h3>Sign Up</h3> 
                                </div>
                          
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger" role="alert">
                                        ${error}
                                    </div>
                                </c:if>
                         
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="username" name="username" placeholder="Username" required>
                                    <label for="username">Username *</label>
                                </div>
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="fullName" name="fullName" placeholder="Full Name" required>
                                    <label for="fullName">Full Name *</label>
                                </div>
                                <div class="form-floating mb-3">
                                    <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                                    <label for="email">Email *</label>
                                </div>
                                <div class="form-floating mb-3">
                                    <input type="tel" class="form-control" id="phone" name="phone" placeholder="Phone" required>
                                    <label for="phone">Phone *</label>
                                </div>
                                <div class="form-floating mb-3">
                                    <input type="text" class="form-control" id="address" name="address" placeholder="Address (Optional)">
                                    <label for="address">Address (Optional)</label>
                                </div>
                                <div class="form-floating mb-4">
                                    <input type="password" class="form-control" id="password" name="password" placeholder="Password" required>
                                    <label for="password">Password *</label>
                                 
                                    <span toggle="#password" class="fa fa-fw fa-eye field-icon toggle-password" 
                                          style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #6c757d;">
                                    </span>
                                </div>
                                <div class="form-floating mb-4">
                                    <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" placeholder="Confirm Password" required>
                                    <label for="confirmPassword">Confirm Password *</label>
                                   
                                    <span toggle="#confirmPassword" class="fa fa-fw fa-eye field-icon toggle-password" 
                                          style="position: absolute; right: 15px; top: 50%; transform: translateY(-50%); cursor: pointer; color: #6c757d;">
                                    </span>
                                </div>
                             <button type="submit" value="Register" class="btn btn-primary py-3 w-100 mb-4">Sign Up</button> 
                            
                                <p class="text-center mb-0">Already have an account? <a href="login.jsp">Sign In</a></p>

                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
            <script src="lib/chart/chart.min.js"></script>
            <script src="lib/easing/easing.min.js"></script>
            <script src="lib/waypoints/waypoints.min.js"></script>
            <script src="lib/owlcarousel/owl.carousel.min.js"></script>
            <script src="lib/tempusdominus/js/moment.min.js"></script>
            <script src="lib/tempusdominus/js/moment-timezone.min.js"></script>
            <script src="lib/tempusdominus/js/tempusdominus-bootstrap-4.min.js"></script>

            <script src="js/main.js"></script>
                        
            <script>
                $(document).ready(function () {                  
                    $(".toggle-password").click(function () {                       
                        $(this).toggleClass("fa-eye fa-eye-slash");
                        var inputId = $(this).attr("toggle");
                        var input = $(inputId);
                        if (input.attr("type") === "password") {
                            input.attr("type", "text");
                        } else {
                            input.attr("type", "password");
                        }
                    });
                });
            </script>
        </form>
    </body>

</html>