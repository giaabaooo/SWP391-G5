<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>CRM - Forgot Password</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Heebo:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.10.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.4.1/font/bootstrap-icons.css" rel="stylesheet">
    <link href="css/login/log/bootstrap.min.css" rel="stylesheet">
    <link href="css/login/log/style.css" rel="stylesheet">
</head>
<body>
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
                        <h2>Customer and Device Management</h2>                                   
                    </div>
                            
                    <div class="bg-light rounded p-4 p-sm-5 my-4 mx-3">
                        <form action="forgotpw" method="POST">
                            <div class="d-flex align-items-center justify-content-between mb-3">
                                <h3>Reset Password</h3>
                            </div>
                            
                            <c:if test="${not empty mess}">
                                <div class="alert alert-danger" role="alert">
                                    ${mess}
                                </div>
                            </c:if>

                            <p>Enter your email address, and we'll send you instructions to reset your password.</p>

                            <div class="form-floating mb-3">
                                <input type="email" class="form-control" id="email" name="email" placeholder="name@example.com" required>
                                <label for="email">Email Address</label>
                            </div>
                     
                            <button type="submit" value="Login" class="btn btn-primary py-3 w-100 mb-4">Send OTP</button>
                            
                            <div class="text-center">
                                 <a href="login.jsp">Back to Login</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        </div>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/main.js"></script>
</body>
</html>