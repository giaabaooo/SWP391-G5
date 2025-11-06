package Controller.warestaff;

import dal.ProductDAO;
import dal.TransactionDAO;
import dal.WarehouseStatsDAO;
import java.io.IOException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Provide real data for warehouse dashboard.
 */
@WebServlet("/warestaff/dashboard")
public class WarehouseDashboardController extends HttpServlet {

    private List<data.Transaction> getRecentTransactions(TransactionDAO txDao, int limit) {
        // reuse DAO paging with pageSize = limit
        return txDao.getTransactions(1, limit, null, null);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            TransactionDAO txDao = new TransactionDAO();
            WarehouseStatsDAO statsDao = new WarehouseStatsDAO();

            int totalItems = statsDao.getTotalItems();
            int lowStock = statsDao.getLowStockCount(5);
            int activeProducts = statsDao.getActiveProductsCount();
            int[] month = statsDao.getMonthImportExportCounts();
            int monthImports = month[0];
            int monthExports = month[1];

            // Daily series for the current month (for line chart)
            Map<String, int[]> monthlySeries = statsDao.getMonthDailyImportExport();
            List<String> monthDayLabels = new ArrayList<>(monthlySeries.keySet());
            List<Integer> monthDayImport = new ArrayList<>();
            List<Integer> monthDayExport = new ArrayList<>();
            for (var e : monthlySeries.values()) { monthDayImport.add(e[0]); monthDayExport.add(e[1]); }

            // Weekly chart
            Map<String, int[]> weekly = statsDao.getWeeklyImportExport(7);
            List<String> chartLabels = new ArrayList<>(weekly.keySet());
            List<Integer> chartImport = new ArrayList<>();
            List<Integer> chartExport = new ArrayList<>();
            for (var e : weekly.values()) { chartImport.add(e[0]); chartExport.add(e[1]); }

            // Recent transactions (table)
            List<data.Transaction> recentTx = getRecentTransactions(txDao, 5);

            request.setAttribute("totalItems", totalItems);
            request.setAttribute("lowStockCount", lowStock);
            request.setAttribute("activeProducts", activeProducts);
            request.setAttribute("monthImports", monthImports);
            request.setAttribute("monthExports", monthExports);
            request.setAttribute("monthDayLabels", monthDayLabels);
            request.setAttribute("monthDayImport", monthDayImport);
            request.setAttribute("monthDayExport", monthDayExport);
            request.setAttribute("chartLabels", chartLabels);
            request.setAttribute("chartImport", chartImport);
            request.setAttribute("chartExport", chartExport);
            request.setAttribute("recentTransactions", recentTx);

            request.getRequestDispatcher("/warehouse/dashboard.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error loading warehouse dashboard.");
        }
    }
}


