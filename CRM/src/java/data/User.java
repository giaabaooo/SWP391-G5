package data;

import java.util.ArrayList;

public class User {
    private int id;
    private Role role;
    private String username;
    private String password;
    private String fullName;
    private String email;
    private String phone;
    private String address;
    private boolean isActive;
    private Employee e;
    private ArrayList<Role> roles = new ArrayList<>();

    // getter/setter
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public Role getRole() { return role; }
    public void setRole(Role role) { this.role = role; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }

    
    
    public Employee getE() { return e; }
    public void setE(Employee e) { this.e = e; }

    public ArrayList<Role> getRoles() { return roles; }
    public void setRoles(ArrayList<Role> roles) { this.roles = roles; }
    
    
}
