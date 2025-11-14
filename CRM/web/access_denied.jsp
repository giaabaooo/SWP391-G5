<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Access Denied</title>
        <style>
            body {
                font-family: Arial, sans-serif;
                display: flex;
                justify-content: center;
                align-items: center;
                height: 100vh;
                background-color: #f4f4f4;
            }
            .container {
                text-align: center;
                padding: 40px;
                background: #fff;
                border-radius: 8px;
                box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            }
            h1 {
                color: #dc3545;
            }
            p {
                font-size: 1.2rem;
            }
            a {
                color: #007bff;
                text-decoration: none;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <h1>Access Denied</h1>
            <p>You do not have permission to view this page.</p>
            <a href="javascript:window.history.length > 1 ? history.back() : '${pageContext.request.contextPath}/'">
                Go back
            </a>
        </div>
    </body>
</html>