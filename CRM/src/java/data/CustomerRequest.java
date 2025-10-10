/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package data;

import java.util.ArrayList;
import java.util.Date;

/**
 *
 * @author Admin
 */
public class CustomerRequest {
    private int id;
    private int customer_id;
    private int device_id;
    private String request_type;
    private String title;
    private String description;
    private Date request_date;
    private String status;
    private boolean isActive;
    private User customer ;
    private Device device ;

    public CustomerRequest() {
    }

    public CustomerRequest(int id, int customer_id, int device_id, String request_type, String title, String description, Date request_date, String status, boolean isActive, User customer, Device device) {
        this.id = id;
        this.customer_id = customer_id;
        this.device_id = device_id;
        this.request_type = request_type;
        this.title = title;
        this.description = description;
        this.request_date = request_date;
        this.status = status;
        this.isActive = isActive;
        this.customer = customer;
        this.device = device;
    }

    public User getCustomer() {
        return customer;
    }

    public void setCustomer(User customer) {
        this.customer = customer;
    }

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    

    

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCustomer_id() {
        return customer_id;
    }

    public void setCustomer_id(int customer_id) {
        this.customer_id = customer_id;
    }

    public int getDevice_id() {
        return device_id;
    }

    public void setDevice_id(int device_id) {
        this.device_id = device_id;
    }

    public String getRequest_type() {
        return request_type;
    }

    public void setRequest_type(String request_type) {
        this.request_type = request_type;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Date getRequest_date() {
        return request_date;
    }

    public void setRequest_date(Date request_date) {
        this.request_date = request_date;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }
    
    
}
