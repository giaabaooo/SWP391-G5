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
import java.util.List;
import java.util.Date;

/**
 *
 * @author Admin
 */
public class CustomerRequestDAO extends DBContext {

    public ArrayList<CustomerRequest> getListRequest(int page, int pageSize, String keyword, String status, String fromDate, String toDate, String requestType, String isActive) {
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
        if (requestType != null && !requestType.trim().isEmpty()) {
            sql += " AND (cr.request_type LIKE ? )";
            params.add("%" + requestType + "%");
        }

        if (status != null && !status.trim().isEmpty()) {
            sql += " AND (cr.status LIKE ? )";
            params.add("%" + status + "%");
        }

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

        if (isActive != null && !isActive.trim().isEmpty()) {
            sql += " AND cr.is_active = ?";
            params.add(isActive.equals("active") ? 1 : 0);
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

    public ArrayList<CustomerRequestAssignment> getListTask(int page, int pageSize, String keyword, String fromDate, String toDate, String is_main, String requestType) {
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

        if (requestType != null && !requestType.trim().isEmpty()) {
            sql += " AND (cr.request_type LIKE ? )";
            params.add("%" + requestType + "%");
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

    public boolean createRequest(CustomerRequest req) {
        String sql = "INSERT INTO CustomerRequest (customer_id, device_id, title, description, request_type, status, request_date) "
                + "VALUES (?, ?, ?, ?, ?, ?, NOW())";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, req.getCustomer_id());
            ps.setInt(2, req.getDevice_id());
            ps.setString(3, req.getTitle());
            ps.setString(4, req.getDescription());
            ps.setString(5, req.getRequest_type());
            ps.setString(6, req.getStatus());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<CustomerRequest> getCustomerRequestsByCSKH(int offset, int pageSize, String type, String status) {
        List<CustomerRequest> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("""
        SELECT cr.id, cr.customer_id, cr.device_id, cr.request_type, cr.title, cr.description,
               cr.request_date, cr.status,
               u.full_name AS customer_name, p.name AS product_name
        FROM CustomerRequest cr
        JOIN User u ON cr.customer_id = u.id
        JOIN Device d ON cr.device_id = d.id
        JOIN ContractItem ci ON d.contract_item_id = ci.id
        JOIN Product p ON ci.product_id = p.id
        WHERE 1=1
    """);

        if (type != null && !type.isEmpty()) {
            sql.append(" AND cr.request_type = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND cr.status = ?");
        }

        sql.append(" ORDER BY cr.request_date DESC LIMIT ? OFFSET ?");

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (type != null && !type.isEmpty()) {
                st.setString(idx++, type);
            }
            if (status != null && !status.isEmpty()) {
                st.setString(idx++, status);
            }
            st.setInt(idx++, pageSize);
            st.setInt(idx, offset);

            ResultSet rs = st.executeQuery();
            while (rs.next()) {
                CustomerRequest c = new CustomerRequest();
                c.setId(rs.getInt("id"));
                c.setCustomer_id(rs.getInt("customer_id"));
                c.setDevice_id(rs.getInt("device_id"));
                c.setRequest_type(rs.getString("request_type"));
                c.setTitle(rs.getString("title"));
                c.setDescription(rs.getString("description"));
                c.setRequest_date(rs.getTimestamp("request_date"));
                c.setStatus(rs.getString("status"));

                User u = new User();
                u.setId(rs.getInt("customer_id"));
                u.setFullName(rs.getString("customer_name"));
                c.setCustomer(u);

                Device d = new Device();
                d.setId(rs.getInt("device_id"));
                d.setProductName(rs.getString("product_name"));
                c.setDevice(d);

                list.add(c);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public int countCustomerRequests(String type, String status) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM CustomerRequest WHERE 1=1");
        if (type != null && !type.isEmpty()) {
            sql.append(" AND request_type = ?");
        }
        if (status != null && !status.isEmpty()) {
            sql.append(" AND status = ?");
        }

        try (PreparedStatement st = connection.prepareStatement(sql.toString())) {
            int idx = 1;
            if (type != null && !type.isEmpty()) {
                st.setString(idx++, type);
            }
            if (status != null && !status.isEmpty()) {
                st.setString(idx++, status);
            }

            ResultSet rs = st.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void transferToTechManager(int requestId) {
        String sql = "UPDATE CustomerRequest SET status = 'TRANSFERRED' WHERE id = ? AND status = 'PENDING'";
        try (PreparedStatement stm = connection.prepareStatement(sql)) {
            stm.setInt(1, requestId);
            stm.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public CustomerRequest getCusRequestById(int requestId) {
        String sql = "SELECT * FROM CustomerRequest WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    CustomerRequest req = new CustomerRequest();
                    req.setId(rs.getInt("id"));
                    req.setCustomer_id(rs.getInt("customer_id"));
                    req.setDevice_id(rs.getInt("device_id"));
                    req.setRequest_type(rs.getString("request_type"));
                    req.setTitle(rs.getString("title"));
                    req.setDescription(rs.getString("description"));
                    req.setRequest_date(rs.getTimestamp("request_date"));
                    req.setStatus(rs.getString("status"));
                    return req;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public boolean updateRequest(CustomerRequest request) {
        String sql = "UPDATE CustomerRequest SET title = ?, device_id = ?, description = ?, request_type = ? "
                   + "WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, request.getTitle());
            ps.setInt(2, request.getDevice_id());
            ps.setString(3, request.getDescription());
            ps.setString(4, request.getRequest_type());
            ps.setInt(5, request.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public CustomerRequest getRequestDetailsById(int requestId) {
    CustomerRequest req = null;
    String sql = """
        SELECT 
            cr.id AS request_id, cr.customer_id, cr.request_type, cr.title, cr.description, 
            cr.request_date, cr.status AS request_status,
            d.id AS device_id, d.serial_number, d.warranty_expiration, d.status AS device_status,
            p.name AS product_name, 
            b.name AS brand_name, 
            cat.name AS category_name
        FROM CustomerRequest cr
        JOIN Device d ON cr.device_id = d.id
        JOIN ContractItem ci ON d.contract_item_id = ci.id
        JOIN Product p ON ci.product_id = p.id
        LEFT JOIN Brand b ON p.brand_id = b.id
        LEFT JOIN Category cat ON p.category_id = cat.id       
        WHERE cr.id = ?
    """;

    try (PreparedStatement ps = connection.prepareStatement(sql)) {
        ps.setInt(1, requestId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            req = new CustomerRequest();
            
            req.setId(rs.getInt("request_id"));
            req.setCustomer_id(rs.getInt("customer_id"));
            req.setRequest_type(rs.getString("request_type"));
            req.setTitle(rs.getString("title"));
            req.setDescription(rs.getString("description"));
            req.setRequest_date(rs.getTimestamp("request_date"));
            req.setStatus(rs.getString("request_status"));
          
            Device device = new Device();
            device.setId(rs.getInt("device_id"));
            device.setSerialNumber(rs.getString("serial_number"));
            device.setWarrantyExpiration(rs.getDate("warranty_expiration"));
            device.setStatus(rs.getString("device_status"));
            device.setProductName(rs.getString("product_name")); 
            device.setBrandName(rs.getString("brand_name"));
            device.setCategoryName(rs.getString("category_name"));
            
            req.setDevice(device); 
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return req;
}
    public boolean deactivateRequest(int requestId, int customerId) {
    String sql = "UPDATE CustomerRequest SET is_active = 0 WHERE id = ? AND customer_id = ?";
    
    try  {
        PreparedStatement statement = connection.prepareStatement(sql);
        statement.setInt(1, requestId);
        statement.setInt(2, customerId); 
        
        int rowsAffected = statement.executeUpdate();
        statement.close(); 
        
        return rowsAffected > 0;
    } catch (SQLException e) {
        System.err.println("Error deactivating product: " + e.getMessage());
        return false;
    }
}
}
