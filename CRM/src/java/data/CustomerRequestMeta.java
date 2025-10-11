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
public class CustomerRequestMeta {
    private int id;
    private int request_id;
    private String priority;
    private String reject_reason;
    private double total_cost;
    private double paid_amount;
    private String payment_status;
    private Date payment_due_date;
    private String customer_comment;
    private String customer_service_response;
    private int rating;

    public CustomerRequestMeta() {
    }

    public CustomerRequestMeta(int id, int request_id, String priority, String reject_reason, double total_cost, double paid_amount, String payment_status, Date payment_due_date, String customer_comment, String customer_service_response, int rating) {
        this.id = id;
        this.request_id = request_id;
        this.priority = priority;
        this.reject_reason = reject_reason;
        this.total_cost = total_cost;
        this.paid_amount = paid_amount;
        this.payment_status = payment_status;
        this.payment_due_date = payment_due_date;
        this.customer_comment = customer_comment;
        this.customer_service_response = customer_service_response;
        this.rating = rating;
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

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String getReject_reason() {
        return reject_reason;
    }

    public void setReject_reason(String reject_reason) {
        this.reject_reason = reject_reason;
    }

    public double getTotal_cost() {
        return total_cost;
    }

    public void setTotal_cost(double total_cost) {
        this.total_cost = total_cost;
    }

    public double getPaid_amount() {
        return paid_amount;
    }

    public void setPaid_amount(double paid_amount) {
        this.paid_amount = paid_amount;
    }

    public String getPayment_status() {
        return payment_status;
    }

    public void setPayment_status(String payment_status) {
        this.payment_status = payment_status;
    }

    public Date getPayment_due_date() {
        return payment_due_date;
    }

    public void setPayment_due_date(Date payment_due_date) {
        this.payment_due_date = payment_due_date;
    }

    public String getCustomer_comment() {
        return customer_comment;
    }

    public void setCustomer_comment(String customer_comment) {
        this.customer_comment = customer_comment;
    }

    public String getCustomer_service_response() {
        return customer_service_response;
    }

    public void setCustomer_service_response(String customer_service_response) {
        this.customer_service_response = customer_service_response;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }
    
    
}
