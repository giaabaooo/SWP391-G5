package Controller.cskh;

import dal.GuestContactDAO;
import data.GuestContact;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet(name = "ManageContactsServlet", urlPatterns = {"/cskh/contacts"})
public class ContactsController extends HttpServlet {

    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        GuestContactDAO dao = new GuestContactDAO();

        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        int page = 1;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (NumberFormatException e) {
            page = 1;
        }

        int totalItems = dao.getFilteredContactsCount(status, dateFrom, dateTo);
        int totalPages = (int) Math.ceil((double) totalItems / PAGE_SIZE);

        List<GuestContact> contactList = dao.getAllContacts(status, dateFrom, dateTo, page, PAGE_SIZE);

        request.setAttribute("contactList", contactList);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalItems", totalItems);
        request.setAttribute("pageSize", PAGE_SIZE);
        request.setAttribute("statusFilter", status);
        request.setAttribute("dateFromFilter", dateFrom);
        request.setAttribute("dateToFilter", dateTo);

        request.getRequestDispatcher("/cskh/manage_contacts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            int contactId = Integer.parseInt(request.getParameter("contactId"));

            GuestContactDAO dao = new GuestContactDAO();
            boolean success = dao.markAsRead(contactId);

            if (success) {
                request.getSession().setAttribute("adminMessage", "Contact successfully marked as read!");
            } else {
                request.getSession().setAttribute("adminError", "Error: Could not mark as read (it may be already read or invalid).");
            }

        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("adminError", "Error: Invalid Contact ID.");
        }

        String page = request.getParameter("page");
        String status = request.getParameter("status");
        String dateFrom = request.getParameter("dateFrom");
        String dateTo = request.getParameter("dateTo");

        String redirectURL = buildRedirectURL(request.getContextPath() + "/cskh/contacts", page, status, dateFrom, dateTo);
        response.sendRedirect(redirectURL);
    }

    private String buildRedirectURL(String baseUrl, String page, String status, String dateFrom, String dateTo) {
        StringBuilder url = new StringBuilder(baseUrl);
        url.append("?");
        try {
            if (page != null && !page.isEmpty()) {
                url.append("page=").append(page).append("&");
            }
            if (status != null && !status.isEmpty()) {
                url.append("status=").append(URLEncoder.encode(status, "UTF-8")).append("&");
            }
            if (dateFrom != null && !dateFrom.isEmpty()) {
                url.append("dateFrom=").append(URLEncoder.encode(dateFrom, "UTF-8")).append("&");
            }
            if (dateTo != null && !dateTo.isEmpty()) {
                url.append("dateTo=").append(URLEncoder.encode(dateTo, "UTF-8")).append("&");
            }
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }
        char lastChar = url.charAt(url.length() - 1);
        if (lastChar == '&' || lastChar == '?') {
            url.deleteCharAt(url.length() - 1);
        }
        return url.toString();
    }
}
