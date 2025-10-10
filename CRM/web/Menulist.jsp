<%-- 
    Document   : Menulist
    Created on : Mar 2, 2025, 1:30:35 AM
    Author     : Nhat Anh
--%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
        <style>
            .list-group-item {
                transition: all 0.3s ease;
            }
            .list-group-item:hover {
                background-color: #f8f9fa;
            }
            .form-group {
                margin-bottom: 1rem;
            }
            .alert-banner {
                margin-bottom: 1rem;
                padding: 1rem;
                border-radius: 0.25rem;
            }
            .card {
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            }
            .card-body {
                padding: 1.5rem;
            }
            .list-group {
                position: fixed;
                top: 0;
                left: 0;
                width: 250px; /* ?i?u ch?nh theo kích th??c mong mu?n */
                height: 100vh; /* Chi?m toàn b? chi?u cao */
                background-color: #fff; /* ??i màu n?n n?u c?n */
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
                z-index: 1000; /* ??m b?o menu n?m trên các ph?n khác */
            }

            .list-group-item {
                font-size: 16px; /* Gi? font ch? ?n ??nh */
                padding: 10px 15px; /* ??m b?o kho?ng cách ??u */
                text-align: left; /* Gi? v?n b?n c?n ch?nh h?p lý */
                font-family: "Roboto", sans-serif;
            }
        </style>
    </head>
    <body>
        <div class="col-md-3 mb-4">
                    <div class="list-group shadow-sm">
                        <a href="account?service=changeCustomerProfile" 
                           class="list-group-item list-group-item-action" id="profileLink">
                            <i class="fas fa-user me-2"></i>Your Profile
                        </a>
                        <a href="account?service=changePassword" 
                           class="list-group-item list-group-item-action" id="changePasswordLink">
                            <i class="fas fa-key me-2"></i>Change Password
                        </a>
                        <a href="AvatarController?service=ChangeAvatar" 
                           class="list-group-item list-group-item-action" id="changeAvatarLink">
                            <i class="fas fa-key me-2"></i>Change Avatar
                        </a>

                        <a href="home" 
                           class="list-group-item list-group-item-action">
                            <i class="fas fa-home me-2"></i>Home
                        </a>
                    </div>
                </div>
    </body>
</html>
