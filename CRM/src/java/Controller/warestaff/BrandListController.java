package Controller.warestaff;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import dal.BrandDAO;
import data.Brand;

/**
 * List/search/filter/paginate brands for warehouse staff
 */
public class BrandListController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            BrandDAO brandDAO = new BrandDAO();

            String pageParam = request.getParameter("page");
            String pageSizeParam = request.getParameter("pageSize");
            String searchQuery = request.getParameter("search");
            String activeParam = request.getParameter("active");

            int page = 1;
            int pageSize = 10;
            Integer isActive = null;

            if (pageParam != null && !pageParam.isEmpty()) {
                try { page = Math.max(1, Integer.parseInt(pageParam)); } catch (NumberFormatException ignore) {}
            }
            if (pageSizeParam != null && !pageSizeParam.isEmpty()) {
                try {
                    pageSize = Integer.parseInt(pageSizeParam);
                    if (pageSize < 1) pageSize = 10;
                    if (pageSize > 100) pageSize = 100;
                } catch (NumberFormatException ignore) {}
            }
            if (activeParam != null && !activeParam.isEmpty() && !"all".equalsIgnoreCase(activeParam)) {
                if ("1".equals(activeParam) || "true".equalsIgnoreCase(activeParam)) {
                    isActive = 1;
                } else if ("0".equals(activeParam) || "false".equalsIgnoreCase(activeParam)) {
                    isActive = 0;
                }
            }

            List<Brand> brands = brandDAO.getBrandsWithFilters(page, pageSize, searchQuery, isActive);
            int total = brandDAO.getTotalBrandsWithFilters(searchQuery, isActive);
            int totalPages = (int) Math.ceil((double) total / pageSize);

            request.setAttribute("brands", brands);
            request.setAttribute("currentPage", page);
            request.setAttribute("pageSize", pageSize);
            request.setAttribute("totalBrands", total);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("activeFilter", activeParam);

            request.getRequestDispatcher("/warehouse/brandList.jsp").forward(request, response);
        } catch (Exception e) {
            request.setAttribute("error", "Unable to load brand list. Please try again later.");
            request.getRequestDispatcher("/warehouse/brandList.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}


