package dal;

import data.GuestContact;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.sql.ResultSet;

public class GuestContactDAO extends DBContext {

    public boolean saveContactMessage(String fullName, String email, String phone, String message) {
        String sql = """
            INSERT INTO GuestContact (full_name, email, phone, message, status) 
            VALUES (?, ?, ?, ?, 'NEW')
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, message);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<GuestContact> getAllContacts(String status, String dateFrom, String dateTo, int page, int pageSize) {
        List<GuestContact> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
            SELECT id, full_name, email, phone, message, submission_date, status
            FROM guestcontact 
            WHERE is_active = 1 
        """);
        List<Object> params = new ArrayList<>();
        addFilterClauses(sql, params, status, dateFrom, dateTo);
        sql.append(" ORDER BY CASE status WHEN 'NEW' THEN 1 ELSE 2 END, submission_date DESC ");

        int offset = (page - 1) * pageSize;
        sql.append(" LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    GuestContact contact = new GuestContact();
                    contact.setId(rs.getInt("id"));
                    contact.setFullName(rs.getString("full_name"));
                    contact.setEmail(rs.getString("email"));
                    contact.setPhone(rs.getString("phone"));
                    contact.setMessage(rs.getString("message"));
                    contact.setSubmissionDate(rs.getTimestamp("submission_date"));
                    contact.setStatus(rs.getString("status"));
                    list.add(contact);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean markAsRead(int contactId) {
        String sql = """
            UPDATE guestcontact 
            SET status = 'READ' 
            WHERE id = ? AND status = 'NEW'
        """; // 
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, contactId);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public int getFilteredContactsCount(String status, String dateFrom, String dateTo) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM guestcontact WHERE is_active = 1");
        List<Object> params = new ArrayList<>();

        addFilterClauses(sql, params, status, dateFrom, dateTo);

        try (PreparedStatement ps = connection.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    private void addFilterClauses(StringBuilder sql, List<Object> params, String status, String dateFrom, String dateTo) {
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
            params.add(status);
        }
        if (dateFrom != null && !dateFrom.isEmpty()) {
            sql.append(" AND submission_date >= ?");
            params.add(dateFrom + " 00:00:00");
        }
        if (dateTo != null && !dateTo.isEmpty()) {
            sql.append(" AND submission_date <= ?");
            params.add(dateTo + " 23:59:59");
        }
    }
}
