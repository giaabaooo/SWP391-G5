<!DOCTYPE html>
<html>
    <head>
        <title>Login</title>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="stylesheet" href="css/style.css">
    </head>
    <body class="login-container">
        <div class="login-container">
            <form class="login-form" action="login" method="POST">
                <h2>Login</h2>
                <div class="form-group">
                    <label for="username">Username:</label>
                    <input type="text" id="username" name="username" placeholder="Enter your username" required>
                </div>
                <div class="form-group">
                    <label for="password">Password:</label>
                    <input type="password" id="password" name="password" placeholder="Enter your password" required>
                </div>
                <input type="submit" value="Login" class="login-button">

                <!-- Forgot password link -->
                <div class="form-footer">
                    <a href="forgotPassword.jsp" class="forgot-link">Forgot Password?</a>
                </div>
            </form>
        </div>
    </body>
</html>
