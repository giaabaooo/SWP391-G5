/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data;

import java.util.Date;

/**
 *
 * @author Admin
 */
public class CustomerRequestAssignment {
    private int id;
    private int request_id;
    private int technician_id;
    private int is_main;
    private Date assigned_date;

    public CustomerRequestAssignment() {
    }

    public CustomerRequestAssignment(int id, int request_id, int technician_id, int is_main, Date assigned_date) {
        this.id = id;
        this.request_id = request_id;
        this.technician_id = technician_id;
        this.is_main = is_main;
        this.assigned_date = assigned_date;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRequest_id() {
        return request_id;
    }

    public void setRequest_id(int request_id) {
        this.request_id = request_id;
    }

    public int getTechnician_id() {
        return technician_id;
    }

    public void setTechnician_id(int technician_id) {
        this.technician_id = technician_id;
    }

    public int getIs_main() {
        return is_main;
    }

    public void setIs_main(int is_main) {
        this.is_main = is_main;
    }

    public Date getAssigned_date() {
        return assigned_date;
    }

    public void setAssigned_date(Date assigned_date) {
        this.assigned_date = assigned_date;
    }
    
    
    
}
