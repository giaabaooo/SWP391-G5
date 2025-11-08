/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller;

import data.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Set;

/**
 *
 * @author admin
 */
@WebFilter(urlPatterns = {"/admin/*", "/cskh/*", "/customer/*", "/techmanager/*", "/technician/*", "/warestaff/*"})
public class AuthorizationFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=sessionExpired");
            return;
        }

        User user = (User) session.getAttribute("user");
        Set<String> userPermissions = user.getPermissions();

        String requiredPermission = mapRequestToPermission(req);

        if (requiredPermission != null && !userPermissions.contains(requiredPermission)) {
            resp.sendRedirect(req.getContextPath() + "/access_denied.jsp");
            return;
        }
        chain.doFilter(request, response);
    }

    private String mapRequestToPermission(HttpServletRequest req) {
        String path = req.getServletPath();
        String action = req.getParameter("action");
        String method = req.getMethod();

        //ADMIN
        if (path.equals("/admin/user")) {
            if ("add".equals(action)) {
                return "USER_CREATE";
            }
            if ("edit".equals(action)) {
                return "USER_UPDATE";
            }
            if ("delete".equals(action)) {
                return "USER_DELETE";
            }
            return "USER_VIEW";
        }

        //CSKH
        // CSKHDashboardController
        if (path.equals("/cskh/dashboard") || path.equals("/cskh/home")) {
            return "DASHBOARD_VIEW_CSKH";
        }

        // CustomerController & CustomerDetailController
        if (path.equals("/cskh/customer")) {
            if ("POST".equalsIgnoreCase(method)) {
                return "CUSTOMER_TOGGLE_STATUS";
            }
            return "CUSTOMER_VIEW_LIST";
        }
        if (path.equals("/cskh/customer-detail")) {
            return "CUSTOMER_VIEW_DETAIL";
        }

        // ContractController & Detail
        if (path.equals("/cskh/contract")) {
            return "CONTRACT_VIEW_LIST";
        }
        if (path.equals("/cskh/contract_detail")) {
            return "CONTRACT_VIEW_DETAIL";
        }

        // ContractCreateController
        if (path.equals("/cskh/createContract")) {
            return "CONTRACT_CREATE";
        }

        // ContractUpdateController
        if (path.equals("/cskh/updateContract")) {
            return "CONTRACT_UPDATE";
        }

        // ContractDeleteController
        if (path.equals("/cskh/deleteContract")) {
            return "CONTRACT_DELETE";
        }

        // CustomerRequestController
        if (path.equals("/cskh/customer-request")) {
            if ("POST".equalsIgnoreCase(method)) {
                return "REQUEST_MANAGE_STATUS";
            }
            return "REQUEST_VIEW_LIST";
        }

        // CustomerRequestDetailController
        if (path.equals("/cskh/customer-request/detail")) {
            if ("POST".equalsIgnoreCase(method)) {
                return "REQUEST_MANAGE_DETAIL";
            }
            return "REQUEST_VIEW_DETAIL";
        }

        // FeedbackController
        if (path.equals("/cskh/feedback")) {
            return "FEEDBACK_VIEW_LIST";
        }

        //CUSTOMER
        if (path.startsWith("/customer/")) {

            // DashboardController
            if (path.equals("/customer/dashboard")) {
                return "DASHBOARD_VIEW_CUSTOMER";
            }

            // DevicesController & DetailDeviceController
            if (path.equals("/customer/devices")) {
                return "DEVICE_VIEW_LIST";
            }
            if (path.equals("/customer/detailDevice")) {
                return "DEVICE_VIEW_DETAIL";
            }

            // ContractController
            if (path.equals("/customer/contract")) {
                return "CONTRACT_VIEW_LIST_CUSTOMER";
            }

            // ListRequestController & DetailRequestController
            if (path.equals("/customer/listRequest")) {
                return "REQUEST_VIEW_LIST_CUSTOMER";
            }
            if (path.equals("/customer/detailRequest")) {
                return "REQUEST_VIEW_DETAIL_CUSTOMER";
            }

            // CreateRequestController
            if (path.equals("/customer/createRequest")) {
                return "REQUEST_CREATE";
            }

            // DeleteRequest
            if (path.equals("/customer/deleteRequest")) {
                return "REQUEST_DELETE";
            }

            // ListFeedbackController
            if (path.equals("/customer/listFeedback")) {
                return "FEEDBACK_VIEW_LIST_CUSTOMER";
            }

            // CreateFeedbackController
            if (path.equals("/customer/createFeedback")) {
                return "FEEDBACK_CREATE";
            }

            // UpdateRequest
            if (path.equals("/customer/updateRequest")) {
                return "REQUEST_UPDATE";
            }

            // UpdateFeedback
            if (path.equals("/customer/updateFeedback")) {
                return "FEEDBACK_UPDATE";
            }

            // PaymentController
            if (path.equals("/customer/payment")) {
                return "PAYMENT_VIEW_AND_PAY";
            }
        }

        //TECH MANAGER
        if (path.startsWith("/techmanager/")) {

            // DashBoardController
            if (path.equals("/techmanager/dashboard")) {
                return "DASHBOARD_VIEW_TECH";
            }

            // TechnicianController
            if (path.equals("/techmanager/technician")) {
                if ("detail".equals(action)) {
                    return "TECH_VIEW_DETAIL";
                }
                if ("delete".equals(action)) {
                    return "TECH_TOGGLE_STATUS";
                }
                return "TECH_VIEW_LIST";
            }

            // RequestController
            if (path.equals("/techmanager/request")) {
                if ("POST".equalsIgnoreCase(method)) {
                    return "REQUEST_REJECT";
                }
                if ("detail".equals(action)) {
                    return "REQUEST_VIEW_DETAIL_TECH";
                }
                if ("reject".equals(action)) {
                    return "REQUEST_REJECT";
                }
                if ("assignTask".equals(action)) {
                    return "TASK_ASSIGN";
                }
                return "REQUEST_VIEW_LIST_TECH";
            }

            // TaskController
            if (path.equals("/techmanager/task")) {
                if ("POST".equalsIgnoreCase(method)) {
                    if ("add".equals(action)) {
                        return "TASK_ASSIGN";
                    }
                    if ("update".equals(action)) {
                        return "TASK_UPDATE";
                    }
                }
                // GET
                if ("detail".equals(action)) {
                    return "TASK_VIEW_DETAIL";
                }
                if ("edit".equals(action)) {
                    return "TASK_UPDATE";
                }
                return "TASK_VIEW_LIST";
            }
        }

        //TECHNICIAN
        if (path.startsWith("/technician/")) {

            // TaskController
            if (path.equals("/technician/task")) {
                if ("POST".equalsIgnoreCase(method)) {
                    return "TASK_CREATE_BILL";
                }

                if ("createBill".equals(action)) {
                    return "TASK_CREATE_BILL";
                }
                if ("complete".equals(action) || "inProgress".equals(action)) {
                    return "TASK_UPDATE_STATUS_OWN";
                }
                if ("detail".equals(action)) {
                    return "TASK_VIEW_DETAIL_OWN";
                }
                return "TASK_VIEW_LIST_OWN";
            }
        }

        //WAREHOUSE
        if (path.startsWith("/warestaff/")) {

            if (path.equals("/warestaff/viewListProduct")) {
                return "PRODUCT_VIEW";
            }

            if (path.equals("/warestaff/viewProductDetail")) {
                return "PRODUCT_VIEW";
            }

            // AddNewProductController
            if (path.equals("/warestaff/addNewProduct")) {
                return "PRODUCT_CREATE";
            }

            if (path.equals("/warestaff/editProduct")) {
                return "PRODUCT_UPDATE";
            }

            // DeleteProductController
            if (path.equals("/warestaff/deleteProduct")) {
                return "PRODUCT_DELETE";
            }

            // BrandListController
            if (path.equals("/warestaff/brandList")) {
                return "BRAND_VIEW";
            }

            if (path.equals("/warestaff/viewBrandDetail")) {
                return "BRAND_VIEW";
            }

            // AddBrandController
            if (path.equals("/warestaff/addBrand")) {
                return "BRAND_CREATE";
            }

            if (path.equals("/warestaff/editBrand")) {
                return "BRAND_UPDATE";
            }

            // DeleteBrandController
            if (path.equals("/warestaff/deleteBrand")) {
                return "BRAND_DELETE";
            }

            // CategoryListController
            if (path.equals("/warestaff/categoryList")) {
                return "CATEGORY_VIEW";
            }

            if (path.equals("/warestaff/viewCategoryDetail")) {
                return "CATEGORY_VIEW";
            }

            // AddCategoryController
            if (path.equals("/warestaff/addCategory")) {
                return "CATEGORY_CREATE";
            }

            if (path.equals("/warestaff/editCategory")) {
                return "CATEGORY_UPDATE";
            }

            // DeleteCategoryController
            if (path.equals("/warestaff/deleteCategory")) {
                return "CATEGORY_DELETE";
            }

            // AddImportTransactionController
            if (path.equals("/warestaff/addImportTransaction")) {
                return "INVENTORY_IMPORT";
            }

            // AddExportTransactionController
            if (path.equals("/warestaff/addExportTransaction")) {
                return "INVENTORY_EXPORT";
            }

            if (path.equals("/warestaff/viewTransactionHistory")) {
                return "INVENTORY_VIEW_TRANSACTIONS";
            }

            //Dashboard
            if (path.equals("/warestaff/dashboard")) {
                return "DASHBOARD_VIEW_WAREHOUSE";
            }
        }

        return null;
    }
}
