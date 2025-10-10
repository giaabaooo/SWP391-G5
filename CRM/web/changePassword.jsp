<%@include file="Menulist.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đổi mật khẩu</title>
    
    <style>
        :root {
            --primary-color: #4e73df;
            --danger-color: #e74a3b;
            --success-color: #1cc88a;
            --error-color: #e74a3b;
            --text-color: #5a5c69;
            --border-radius: 0.35rem;
            --box-shadow: 0 .15rem 1.75rem 0 rgba(58,59,69,.15);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: "Nunito", -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            color: var(--text-color);
            background: #f8f9fc;
            min-height: 100vh;
            margin: 0;
        }

        #wrapper {
            display: flex;
        }

        #content-wrapper {
            background-color: #f8f9fc;
            width: 100%;
            overflow-x: hidden;
        }

        .container {
            padding: 1.5rem;
            max-width: 1320px;
            margin: 0 auto;
        }

        .card {
            position: relative;
            display: flex;
            flex-direction: column;
            min-width: 0;
            word-wrap: break-word;
            background-color: #fff;
            background-clip: border-box;
            border: 1px solid #e3e6f0;
            border-radius: var(--border-radius);
            box-shadow: var(--box-shadow);
            margin-bottom: 1.5rem;
        }

        .card-header {
            padding: 1.5rem;
            margin-bottom: 0;
            background-color: #f8f9fc;
            border-bottom: 1px solid #e3e6f0;
        }

        .card-header h2 {
            color: var(--primary-color);
            font-size: 1.75rem;
            font-weight: 700;
            margin: 0;
        }

        .card-body {
            padding: 1.5rem;
        }

        .message {
            padding: 1rem;
            margin-bottom: 1rem;
            border-radius: var(--border-radius);
            font-size: 0.875rem;
        }

        .error {
            background-color: rgba(231, 74, 59, 0.1);
            color: var(--error-color);
            border-left: 4px solid var(--error-color);
        }

        .success {
            background-color: rgba(28, 200, 138, 0.1);
            color: var(--success-color);
            border-left: 4px solid var(--success-color);
        }

        .form-group {
            margin-bottom: 1rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            font-weight: 600;
            font-size: 0.875rem;
            color: var(--text-color);
        }

        .input-group {
            position: relative;
            display: flex;
            flex-wrap: wrap;
            align-items: stretch;
            width: 100%;
        }

        input {
            display: block;
            width: 100%;
            padding: 0.8rem 1rem;
            font-size: 0.875rem;
            line-height: 1.5;
            color: #6e707e;
            background-color: #fff;
            border: 1px solid #d1d3e2;
            border-radius: var(--border-radius);
            transition: border-color .15s ease-in-out,box-shadow .15s ease-in-out;
        }

        input:focus {
            border-color: #bac8f3;
            outline: 0;
            box-shadow: 0 0 0 0.2rem rgba(78,115,223,.25);
        }

        .toggle-password {
            position: absolute;
            right: 1rem;
            top: 50%;
            transform: translateY(-50%);
            cursor: pointer;
            color: #858796;
            transition: color 0.2s ease;
            font-size: 1rem;
        }

        .toggle-password:hover {
            color: var(--primary-color);
        }

        .btn-group {
            display: flex;
            gap: 1rem;
            margin-top: 1.5rem;
        }

        button {
            padding: 0.8rem 1.5rem;
            font-size: 0.875rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            border: none;
            border-radius: var(--border-radius);
            cursor: pointer;
            transition: all 0.2s ease-in-out;
        }

        button[type="submit"] {
            background-color: var(--primary-color);
            color: white;
            width: auto;
        }

        button[type="submit"]:hover {
            background-color: #2e59d9;
            transform: translateY(-1px);
        }

        .btn {
            background-color: var(--danger-color);
            color: white;
            width: auto;
        }

        .btn:hover {
            background-color: #be2617;
            transform: translateY(-1px);
        }

        @media (max-width: 576px) {
            .container {
                padding: 1rem;
            }

            .card-header h2 {
                font-size: 1.5rem;
            }

            .btn-group {
                flex-direction: column;
            }

            button {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    <div id="wrapper">
        <div id="content-wrapper" class="d-flex flex-column">
            <div class="container">
                <div class="card">
                    <div class="card-header">
                        <h2>Đổi mật khẩu</h2>
                    </div>
                    <div class="card-body">
                        <% if (request.getAttribute("errorMessage") != null) { %>
                            <p class="message error"><%= request.getAttribute("errorMessage") %></p>
                        <% } %>

                        <% if (request.getAttribute("successMessage") != null) { %>
                            <p class="message success"><%= request.getAttribute("successMessage") %></p>
                        <% } %>

                        <form action="account" method="post">
                            <input type="hidden" name="service" value="changePassword">
                            
                            <div class="form-group">
                                <label for="currentPassword">Mật khẩu hiện tại:</label>
                                <div class="input-group">
                                    <input type="password" id="currentPassword" name="currentPassword" required>
                                    <span class="toggle-password" onclick="togglePassword('currentPassword')">👁️</span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="newPassword">Mật khẩu mới:</label>
                                <div class="input-group">
                                    <input type="password" id="newPassword" name="newPassword" required>
                                    <span class="toggle-password" onclick="togglePassword('newPassword')">👁️</span>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="confirmPassword">Nhập lại mật khẩu mới:</label>
                                <div class="input-group">
                                    <input type="password" id="confirmPassword" name="confirmPassword" required>
                                    <span class="toggle-password" onclick="togglePassword('confirmPassword')">👁️</span>
                                </div>
                            </div>

                            <div class="btn-group">
                                <button type="submit" name="submit">Đổi mật khẩu</button>
                                <button type="button" class="btn" onclick="window.location.href = 'home'">Về Trang Chủ</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function togglePassword(inputId) {
            let input = document.getElementById(inputId);
            if (input.type === "password") {
                input.type = "text";
            } else {
                input.type = "password";
            }
        }

        // Auto-hide messages after 5 seconds
        setTimeout(function() {
            let messages = document.getElementsByClassName('message');
            for (let message of messages) {
                message.style.display = 'none';
            }
        }, 5000);
    </script>
</body>
</html>