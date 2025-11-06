package Controller.warestaff;

import dal.TransactionDAO;
import data.Transaction;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class ViewTransactionHistoryController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String pageParam = request.getParameter("page");
        String pageSizeParam = request.getParameter("pageSize");
        String typeFilter = request.getParameter("type"); // IMPORT/EXPORT or null
        String searchNote = request.getParameter("q");

        int page = 1;
        int pageSize = 10;
        try { if (pageParam != null) page = Math.max(1, Integer.parseInt(pageParam)); } catch (Exception ignored) {}
        try { if (pageSizeParam != null) pageSize = Math.min(100, Math.max(1, Integer.parseInt(pageSizeParam))); } catch (Exception ignored) {}

        TransactionDAO dao = new TransactionDAO();
        int total = dao.getTotalTransactions(typeFilter, searchNote);
        int totalPages = (int) Math.ceil((double) total / pageSize);
        if (totalPages == 0) totalPages = 1;
        if (page > totalPages) page = totalPages;

        List<Transaction> list = dao.getTransactions(page, pageSize, typeFilter, searchNote);

        request.setAttribute("transactions", list);
        request.setAttribute("currentPage", page);
        request.setAttribute("pageSize", pageSize);
        request.setAttribute("total", total);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("typeFilter", typeFilter);
        request.setAttribute("searchNote", searchNote);
        request.getRequestDispatcher("/warehouse/transactions.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}


