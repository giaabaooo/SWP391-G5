/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.Feedback;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;
/**
 *
 * @author admin
 */
public class FeedbackDAO extends DBContext {
    public List<Feedback> getFeedbacksByCustomer(int userId,String keyword, String type, String rating, int offset, int limit) {
        List<Feedback> list = new ArrayList<>();
        String sql = """
            SELECT 
                r.id AS request_id,
                r.title,
                r.request_type,
                p.name AS product_name,
                r.description,
                m.customer_comment,
                m.rating,
                r.request_date
            FROM CustomerRequest r
            JOIN CustomerRequestMeta m ON r.id = m.request_id
            JOIN Device d ON r.device_id = d.id
            JOIN ContractItem ci ON d.contract_item_id = ci.id
            JOIN Product p ON ci.product_id = p.id
            JOIN Contract c ON ci.contract_id = c.id
            WHERE c.customer_id = ? 
              AND m.customer_comment IS NOT NULL
            
        """;
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (p.name LIKE ? OR r.title LIKE ?) ";
        }
        if (type != null && !type.equalsIgnoreCase("ALL")) {
            sql += " AND r.request_type = ? ";
        }
        if (rating != null && !rating.equalsIgnoreCase("ALL")) {
            sql += " AND m.rating = ? ";
        }

        sql += """
        ORDER BY r.request_date DESC LIMIT ? OFFSET ?
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            int index = 1;
            ps.setInt(index++, userId);

            if (keyword != null && !keyword.isEmpty()) {
                ps.setString(index++, "%" + keyword + "%");
                ps.setString(index++, "%" + keyword + "%");
            }
            if (type != null && !type.equalsIgnoreCase("ALL")) {
                ps.setString(index++, type);
            }
            if (rating  != null && !rating .equalsIgnoreCase("ALL")) {
                ps.setString(index++, rating );
            }
            
            ps.setInt(index++, limit);
            ps.setInt(index++, offset);
           
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Feedback fb = new Feedback();
                fb.setRequestId(rs.getInt("request_id"));
                fb.setTitle(rs.getString("title"));
                fb.setRequestType(rs.getString("request_type"));
                fb.setProductName(rs.getString("product_name"));
                fb.setDescription(rs.getString("description"));
                fb.setComment(rs.getString("customer_comment"));
                fb.setRating(rs.getInt("rating"));
                fb.setRequestDate(rs.getTimestamp("request_date"));
                list.add(fb);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
