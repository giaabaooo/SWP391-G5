/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import data.CustomerRequest;
import data.CustomerRequestAssignment;
import data.CustomerRequestMeta;
import data.User;
import data.Device;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author Admin
 */
public class CustomerRequestDAO extends DBContext {

    public ArrayList<CustomerRequest> getListRequest(int page, int pageSize, String keyword, String status, String fromDate, String toDate) {
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

    public boolean updateRequest(String status, int isActive, int requestId) {
        String sql = "UPDATE customerrequest SET \n"
                + "status = ? ,\n"
                + "is_active = ?\n"
                + "WHERE id = ? ";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setString(1, status);
            statement.setInt(2, isActive);
            statement.setInt(3, requestId);

            int rowsAffected = statement.executeUpdate();
            statement.close();

            return rowsAffected > 0;
        } catch (SQLException e) {
            System.err.println("Error updating : " + e.getMessage());
            return false;
        }
    }

    public boolean insertRejectReason(int requestId, String rejectReason) {
        String sql = "INSERT INTO customerrequestmeta (request_id, reject_reason) VALUES (?, ?)";
        try {
            PreparedStatement statement = connection.prepareStatement(sql);
            statement.setInt(1, requestId);
            statement.setString(2, rejectReason);
            return statement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error inserting reject reason: " + e.getMessage());
            return false;
        }
    }

    public ArrayList<CustomerRequestAssignment> getListTask(int page, int pageSize, String keyword, String fromDate, String toDate, String is_main) {
        ArrayList<CustomerRequestAssignment> listTask = new ArrayList<>();

        String sql = "SELECT ca.* FROM customerrequest_assignment ca\n"
                + "JOIN customerrequest cr on cr.id = ca.request_id \n"
                + "JOIN user tech on tech.id = ca.technician_id\n";

        ArrayList<Object> params = new ArrayList<>();

        if (is_main != null && !is_main.trim().isEmpty()) {
            sql += " where ca.is_main = ?";
            params.add("%" + is_main + "%");
        } else {
            sql += "where ca.is_main = 1";
        }

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (u.full_name LIKE ? OR p.name LIKE ?)";
            params.add("%" + keyword + "%");
            params.add("%" + keyword + "%");
        }

        if (fromDate != null && !fromDate.isEmpty()) {
            sql += " AND ca.assigned_date >= ?";
            params.add(fromDate);
        }

        if (toDate != null && !toDate.isEmpty()) {
            sql += " AND ca.assigned_date <= ?";
            params.add(toDate);
        }

        sql += " LIMIT ? OFFSET ?";
        params.add(pageSize);
        params.add((page - 1) * pageSize);

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            for (int i = 0; i < params.size(); i++) {
                stm.setObject(i + 1, params.get(i));
            }
            ResultSet rs = stm.executeQuery();

            UserDBContext db = new UserDBContext();

            while (rs.next()) {

                User tech = db.get(rs.getInt("technician_id"));

                ArrayList<User> listTech = new ArrayList<>();
                listTech.add(tech);

                CustomerRequest cusRe = getRequestById(rs.getInt("request_id"));

                CustomerRequestAssignment ca = new CustomerRequestAssignment();
                ca.setId(rs.getInt("id"));
                ca.setRequest_id(rs.getInt("request_id"));
                ca.setTechnician_id(rs.getInt("technician_id"));
                ca.setIs_main(rs.getInt("is_main"));
                ca.setAssigned_date(rs.getDate("assigned_date"));

                ca.setTechnician(listTech);
                ca.setCustomerRequest(cusRe);

                listTask.add(ca);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return listTask;
    }

    public CustomerRequestAssignment getTaskById(int id) {
        CustomerRequestAssignment ca = null;

        String sql = "SELECT ca.*, tech.id AS tech_id "
                + "FROM customerrequest_assignment ca "
                + "JOIN user tech ON tech.id = ca.technician_id "
                + "WHERE ca.request_id = ?";

        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, id);
            ResultSet rs = stm.executeQuery();

            UserDBContext db = new UserDBContext();
            ArrayList<User> listTech = new ArrayList<>();
            CustomerRequest cusRe;

            while (rs.next()) {
                if (ca == null) {
                    ca = new CustomerRequestAssignment();
                    ca.setId(rs.getInt("id"));
                    ca.setRequest_id(rs.getInt("request_id"));
                    ca.setIs_main(rs.getInt("is_main"));
                    ca.setAssigned_date(rs.getDate("assigned_date"));

                    cusRe = getRequestById(rs.getInt("request_id"));
                    ca.setCustomerRequest(cusRe);
                }

                User tech = db.get(rs.getInt("tech_id"));
                listTech.add(tech);
            }

            if (ca != null) {
                ca.setTechnician(listTech);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return ca;
    }

    public void insert(CustomerRequestAssignment ca) {
        String sql = "INSERT INTO customerrequest_assignment (request_id, technician_id, is_main, assigned_date) "
                + "VALUES (?, ?, ?, ?)";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, ca.getRequest_id());
            stm.setInt(2, ca.getTechnician_id());
            stm.setInt(3, ca.getIs_main());

            java.util.Date utilDate = ca.getAssigned_date();
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
            stm.setDate(4, sqlDate);

            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateAssignedDate(int requestId, Date assignedDate) {
        String sql = "UPDATE customerrequest_assignment SET assigned_date = ? WHERE request_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setDate(1, new java.sql.Date(assignedDate.getTime()));
            stm.setInt(2, requestId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateLeader(int requestId, int leaderId) {
        try {
            // Bỏ leader cũ
            String sql1 = "UPDATE customerrequest_assignment SET is_main = 0 WHERE request_id = ?";
            try (PreparedStatement stm = connection.prepareStatement(sql1)) {
                stm.setInt(1, requestId);
                stm.executeUpdate();
            }

            // Gán leader mới
            String sql2 = "UPDATE customerrequest_assignment SET is_main = 1 WHERE request_id = ? AND technician_id = ?";
            try (PreparedStatement stm = connection.prepareStatement(sql2)) {
                stm.setInt(1, requestId);
                stm.setInt(2, leaderId);
                stm.executeUpdate();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateTechnician(int requestId, int technicianId, Date assignedDate, int isMain) {
        String sql = "UPDATE customerrequest_assignment SET assigned_date = ?, is_main = ? "
                + "WHERE request_id = ? AND technician_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setDate(1, new java.sql.Date(assignedDate.getTime()));
            stm.setInt(2, isMain);
            stm.setInt(3, requestId);
            stm.setInt(4, technicianId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public boolean existsAssignment(int requestId, int technicianId) {
        String sql = "SELECT COUNT(*) FROM customerrequest_assignment WHERE request_id = ? AND technician_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, requestId);
            stm.setInt(2, technicianId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public void insertCusRequestMeta(CustomerRequestMeta ca) {
        String sql = "INSERT INTO `crm_device_management`.`customerrequestmeta` (`request_id`, `total_cost`, `paid_amount`, `payment_status`, `payment_due_date`) "
                + "VALUES (?, ?, ?, ?, ?);";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, ca.getRequest_id());
            stm.setDouble(2, ca.getTotal_cost());
            stm.setDouble(3, ca.getPaid_amount());
            stm.setString(4, ca.getPayment_status());

            java.util.Date utilDate = ca.getPayment_due_date();
            java.sql.Date sqlDate = new java.sql.Date(utilDate.getTime());
            stm.setDate(5, sqlDate);

            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public CustomerRequestMeta getCusRequestMetaById(int requestId) {
        String sql = "SELECT * FROM `crm_device_management`.`customerrequestmeta` WHERE `request_id` = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, requestId);

            try (ResultSet rs = stm.executeQuery()) {
                if (rs.next()) {
                    CustomerRequestMeta ca = new CustomerRequestMeta();
                    ca.setRequest_id(rs.getInt("request_id"));
                    ca.setTotal_cost(rs.getDouble("total_cost"));
                    ca.setPaid_amount(rs.getDouble("paid_amount"));
                    ca.setPayment_status(rs.getString("payment_status"));

                    java.sql.Date sqlDate = rs.getDate("payment_due_date");
                    if (sqlDate != null) {
                        ca.setPayment_due_date(new java.util.Date(sqlDate.getTime()));
                    }

                    return ca;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void deleteByRequestId(int requestId) {
        String sql = "DELETE FROM customerrequest_assignment WHERE request_id = ?";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, requestId);
            stm.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
