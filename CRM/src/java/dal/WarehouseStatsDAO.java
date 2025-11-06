package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class WarehouseStatsDAO extends DBContext {

    public int getTotalItems() {
        String sql = "SELECT COALESCE(SUM(quantity),0) FROM Inventory WHERE is_active=1";
        try (PreparedStatement ps = connection.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            System.err.println("Error getTotalItems: " + e.getMessage());
            return 0;
        }
    }

    public int getLowStockCount(int threshold) {
        String sql = "SELECT COUNT(*) FROM Inventory i JOIN Product p ON p.id=i.product_id WHERE i.is_active=1 AND p.is_active=1 AND i.quantity < ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, threshold);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? rs.getInt(1) : 0;
            }
        } catch (SQLException e) {
            System.err.println("Error getLowStockCount: " + e.getMessage());
            return 0;
        }
    }

    public int getActiveProductsCount() {
        String sql = "SELECT COUNT(*) FROM Product WHERE is_active=1";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        } catch (SQLException e) {
            System.err.println("Error getActiveProductsCount: " + e.getMessage());
            return 0;
        }
    }

    public int[] getTodayImportExportCounts() {
        String sql = "SELECT type, COUNT(*) FROM `Transaction` WHERE is_active=1 AND DATE(transaction_date)=CURDATE() GROUP BY type";
        int[] r = new int[]{0,0};
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String t = rs.getString(1);
                int c = rs.getInt(2);
                if ("IMPORT".equalsIgnoreCase(t)) r[0] = c; else if ("EXPORT".equalsIgnoreCase(t)) r[1] = c;
            }
        } catch (SQLException e) {
            System.err.println("Error getTodayImportExportCounts: " + e.getMessage());
        }
        return r;
    }

    public int[] getMonthImportExportCounts() {
        String sql = "SELECT type, COUNT(*) FROM `Transaction` " +
                     "WHERE is_active=1 AND YEAR(transaction_date)=YEAR(CURDATE()) AND MONTH(transaction_date)=MONTH(CURDATE()) " +
                     "GROUP BY type";
        int[] r = new int[]{0,0};
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                String t = rs.getString(1);
                int c = rs.getInt(2);
                if ("IMPORT".equalsIgnoreCase(t)) r[0] = c; else if ("EXPORT".equalsIgnoreCase(t)) r[1] = c;
            }
        } catch (SQLException e) {
            System.err.println("Error getMonthImportExportCounts: " + e.getMessage());
        }
        return r;
    }

    public Map<String, int[]> getWeeklyImportExport(int days) {
        LocalDate today = LocalDate.now();
        LocalDate start = today.minusDays(days - 1);
        Map<String, int[]> series = new LinkedHashMap<>();
        for (int i = 0; i < days; i++) {
            LocalDate d = start.plusDays(i);
            series.put(d.toString(), new int[]{0, 0});
        }
        String sql = "SELECT DATE(transaction_date) as d, type, COUNT(*) as c FROM `Transaction` WHERE is_active=1 AND transaction_date >= ? GROUP BY DATE(transaction_date), type";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(start.atStartOfDay()));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String d = rs.getString("d");
                    String type = rs.getString("type");
                    int c = rs.getInt("c");
                    int[] v = series.get(d);
                    if (v != null) {
                        if ("IMPORT".equalsIgnoreCase(type)) v[0] = c; else if ("EXPORT".equalsIgnoreCase(type)) v[1] = c;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getWeeklyImportExport: " + e.getMessage());
        }
        return series;
    }

    public Map<String, int[]> getMonthDailyImportExport() {
        java.time.LocalDate first = java.time.LocalDate.now().withDayOfMonth(1);
        int length = first.lengthOfMonth();
        java.time.LocalDate last = first.plusDays(length - 1);
        Map<String, int[]> series = new LinkedHashMap<>();
        for (int i = 0; i < length; i++) {
            java.time.LocalDate d = first.plusDays(i);
            series.put(d.toString(), new int[]{0, 0});
        }
        String sql = "SELECT DATE(transaction_date) as d, type, COUNT(*) as c FROM `Transaction` " +
                     "WHERE is_active=1 AND transaction_date BETWEEN ? AND ? GROUP BY DATE(transaction_date), type";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setTimestamp(1, Timestamp.valueOf(first.atStartOfDay()));
            ps.setTimestamp(2, Timestamp.valueOf(last.plusDays(1).atStartOfDay().minusSeconds(1)));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    String d = rs.getString("d");
                    String type = rs.getString("type");
                    int c = rs.getInt("c");
                    int[] v = series.get(d);
                    if (v != null) {
                        if ("IMPORT".equalsIgnoreCase(type)) v[0] = c; else if ("EXPORT".equalsIgnoreCase(type)) v[1] = c;
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error getMonthDailyImportExport: " + e.getMessage());
        }
        return series;
    }
}


