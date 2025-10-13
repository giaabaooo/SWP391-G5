/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.CustomerRequest;
import data.User;
import data.Device;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author Admin
 */
public class CustomerRequestDAO extends DBContext {

    public ArrayList<CustomerRequest> list(int page, int pageSize, String keyword, String status, String fromDate, String toDate) {
        ArrayList<CustomerRequest> listRequest = new ArrayList<>();

        String sql = "SELECT cr.*,u.full_name,p.name FROM customerrequest cr\n"
                + "join user u on u.id = cr.customer_id\n"
                + "join device d on d.id = cr.device_id\n"
                + "JOIN ContractItem ci ON d.contract_item_id = ci.id\n"
                + "JOIN Product p ON ci.product_id = p.id";
        ArrayList<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u.full_name LIKE ? OR p.name LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND cr.request_date >= ?";
            params.add(fromDate);
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND cr.request_date <= ?";
            params.add(toDate);
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND cr.is_active = ?";
            params.add(status.equals("active") ? 1 : 0);
        }

        sql += " LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {

                User cus = new User();
                cus.setFullName(rs.getString("full_name"));

                Device de = new Device();
                de.setProductName(rs.getString("name"));

                CustomerRequest cr = new CustomerRequest();
                cr.setId(rs.getInt("id"));
                cr.setCustomer_id(rs.getInt("customer_id"));
                cr.setDevice_id(rs.getInt("device_id"));
                cr.setRequest_type(rs.getString("request_type"));
                cr.setTitle(rs.getString("title"));
                cr.setDescription(rs.getString("description"));
                cr.setRequest_date(rs.getDate("request_date"));
                cr.setStatus(rs.getString("status"));
                cr.setIsActive(rs.getBoolean("is_active"));
                cr.setCustomer(cus);
                cr.setDevice(de);

                listRequest.add(cr);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listRequest;
    }

    public CustomerRequest getRequestById(int requestId) {
        String sql = "SELECT cr.*,u.full_name,p.name FROM customerrequest cr\n"
                + "JOIN user u on u.id = cr.customer_id\n"
                + "JOIN device d on d.id = cr.device_id\n"
                + "JOIN ContractItem ci ON d.contract_item_id = ci.id\n"
                + "JOIN Product p ON ci.product_id = p.id";
        ArrayList<Object> params = new ArrayList<>();

        sql += " WHERE cr.id = ?";
        params.add(requestId);

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {

                User cus = new User();
                cus.setFullName(rs.getString("full_name"));

                Device de = new Device();
                de.setProductName(rs.getString("name"));

                CustomerRequest cr = new CustomerRequest();
                cr.setId(rs.getInt("id"));
                cr.setCustomer_id(rs.getInt("customer_id"));
                cr.setDevice_id(rs.getInt("device_id"));
                cr.setRequest_type(rs.getString("request_type"));
                cr.setTitle(rs.getString("title"));
                cr.setDescription(rs.getString("description"));
                cr.setRequest_date(rs.getDate("request_date"));
                cr.setStatus(rs.getString("status"));
                cr.setIsActive(rs.getBoolean("is_active"));
                cr.setCustomer(cus);
                cr.setDevice(de);

                return cr;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<CustomerRequest> getRequestsByUserId(int userId, String keyword, String type, String status, int offset, int limit) {
        List<CustomerRequest> list = new ArrayList<>();

        String sql = """
        SELECT 
            cr.id AS request_id,
            p.name AS product_name,
            cr.title,
            cr.request_type,
            cr.request_date,
            cr.status
        FROM CustomerRequest cr
        JOIN Device d ON cr.device_id = d.id
        JOIN ContractItem ci ON d.contract_item_id = ci.id
        JOIN Product p ON ci.product_id = p.id
        LEFT JOIN CustomerRequestMeta crm ON cr.id = crm.request_id
        JOIN Contract ct ON ci.contract_id = ct.id
        WHERE ct.customer_id = ?
    """;

        // dynamic filters
        if (keyword != null && !keyword.isEmpty()) {
            sql += " AND (p.name LIKE ? OR cr.title LIKE ?) ";
        }
        if (type != null && !type.equalsIgnoreCase("ALL")) {
            sql += " AND cr.request_type = ? ";
        }
        if (status != null && !status.equalsIgnoreCase("ALL")) {
            sql += " AND cr.status = ? ";
        }

        sql += """
        GROUP BY cr.id
        ORDER BY cr.request_date DESC
        LIMIT ? OFFSET ?
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
            if (status != null && !status.equalsIgnoreCase("ALL")) {
                ps.setString(index++, status);
            }

            ps.setInt(index++, limit);
            ps.setInt(index++, offset);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                CustomerRequest req = new CustomerRequest();
                req.setId(rs.getInt("request_id"));
                req.setProductName(rs.getString("product_name"));
                req.setTitle(rs.getString("title"));
                req.setRequest_type(rs.getString("request_type"));
                req.setRequest_date(rs.getTimestamp("request_date"));
                req.setStatus(rs.getString("status"));
                list.add(req);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

}
