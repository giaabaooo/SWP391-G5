
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <link rel="stylesheet" href="https://unpkg.com/bootstrap@5.3.3/dist/css/bootstrap.min.css">
        <title>Password Reset</title>
        <style>
            body {
                background-color: #f8f9fa; /* Light background color */
            }
        </style>
    </head>
    <body>

        <!-- Center content vertically and horizontally -->
        <div class="d-flex justify-content-center align-items-center vh-100">
            <div class="card text-center" style="width: 350px;">
                <div class="card-header h5 text-white bg-primary">Password Reset</div>
                <div class="card-body px-4">
                    <p class="card-text py-2">
                        Enter your email address, and we'll send you instructions to reset your password.
                    </p>

                    <%-- Display message if set in request attribute --%>
                    <% String message = (String) request.getAttribute("mess"); %>
                    <% if (message != null) { %>
                    <p style="color: red;"><%= message %></p>
                    <% } %>
                    <!-- Form for password reset -->
                    <form action="forgotpw" method="post">
                        <div class="form-outline">
                            <input type="email" id="typeEmail" class="form-control my-3" name="email" placeholder="name@example.com" required />
                        </div>
                        <button type="submit" class="btn btn-primary w-100">Reset Password</button>
                    </form>

                    <div class="d-flex justify-content-between mt-4">
                        <a class="login" href="login.jsp">Login</a>
                        <a class="signup" href="signup.jsp">Register</a>
                    </div>
                </div>
            </div>
        </div>

    </body>
</html>
