package data;

import java.util.List;
/**
 *
 * @author pdatt
 */
public class Account {

    private int accountID;
    private String Name;
    private String Email;
    private String Password;
    private String PhoneNum;
    private String Address;
    private int YearOfBirth;
    private String Gender; 
    private int LoyaltyPoint;
    private String MembershipLevel;
    private boolean Status;
    private String role;
    private int AvatarID;

    public Account(int accountID, String Name, String Email, String Password, String PhoneNum, String Address, int YearOfBirth, String Gender, int LoyaltyPoint, String MembershipLevel, boolean Status, String role) {
        this.accountID = accountID;
        this.Name = Name;
        this.Email = Email;
        this.Password = Password;
        this.PhoneNum = PhoneNum;
        this.Address = Address;
        this.YearOfBirth = YearOfBirth;
        this.Gender = Gender;
        this.LoyaltyPoint = LoyaltyPoint;
        this.MembershipLevel = MembershipLevel;
        this.Status = Status;
        this.role = role;
    }

    public Account(int accountID, String Name, String Email, String Password, String PhoneNum, String Address, int YearOfBirth, String Gender, int LoyaltyPoint, String MembershipLevel, boolean Status, String role, int AvatarID) {
        this.accountID = accountID;
        this.Name = Name;
        this.Email = Email;
        this.Password = Password;
        this.PhoneNum = PhoneNum;
        this.Address = Address;
        this.YearOfBirth = YearOfBirth;
        this.Gender = Gender;
        this.LoyaltyPoint = LoyaltyPoint;
        this.MembershipLevel = MembershipLevel;
        this.Status = Status;
        this.role = role;
        this.AvatarID = AvatarID;
    }

    public Account(boolean Status) {
        this.Status = Status;
    }

    public Account(int accountID, boolean Status) {
        this.accountID = accountID;
        this.Status = Status;
    }
    
    

    public int getAvatarID() {
        return AvatarID;
    }

    public void setAvatarID(int AvatarID) {
        this.AvatarID = AvatarID;
    }

    
    
    
    
    public int getLoyaltyPoint() {
        return LoyaltyPoint;
    }

    public String getMembershipLevel() {
        return MembershipLevel;
    }


    public void setLoyaltyPoint(int LoyaltyPoint) {
        this.LoyaltyPoint = LoyaltyPoint;
    }
    

    public Account() {
    }

    public void setMembershipLevel(String MembershipLevel) {
        this.MembershipLevel = MembershipLevel;
    }

    public Account(int accountID, String Name, String PhoneNum, String Address, int YearOfBirth, String Gender) {
        this.accountID = accountID;
        this.Name = Name;
        this.PhoneNum = PhoneNum;
        this.Address = Address;
        this.YearOfBirth = YearOfBirth;
        this.Gender = Gender;
    }

    public Account(String Name, String Email, String Password, String PhoneNum, String Address, int YearOfBirth, boolean Status, String role, String Gender) {
        this.Name = Name;
        this.Email = Email;
        this.Password = Password;
        this.PhoneNum = PhoneNum;
        this.Address = Address;
        this.YearOfBirth = YearOfBirth;
        this.Status = Status;
        this.role = role;
        this.Gender = Gender;
    }

    public Account(int accountID, String Name, String Email, String Password, String PhoneNum, String Address, int YearOfBirth, boolean Status, String Gender) {
        this.accountID = accountID;
        this.Name = Name;
        this.Email = Email;
        this.Password = Password;
        this.PhoneNum = PhoneNum;
        this.Address = Address;
        this.YearOfBirth = YearOfBirth;
        this.Status = Status;
        this.Gender = Gender;
    }

    public Account(int accountID) {
        this.accountID = accountID;
            }

    public Account(int accountID, String Name, String Email, String Password, String PhoneNum, String Address, int YearOfBirth, boolean Status, String role, String Gender) {
        this.accountID = accountID;
        this.Name = Name;
        this.Email = Email;
        this.Password = Password;
        this.PhoneNum = PhoneNum;
        this.Address = Address;
        this.YearOfBirth = YearOfBirth;
        this.Status = Status;
        this.role = role;
        this.Gender = Gender;
    }

    public int getAccountID() {
        return accountID;
    }

    public void setAccountID(int accountID) {
        this.accountID = accountID;
    }

    public String getName() {
        return Name;
    }

    public void setName(String Name) {
        this.Name = Name;
    }

    public String getEmail() {
        return Email;
    }

    public void setEmail(String Email) {
        this.Email = Email;
    }

    public String getPassword() {
        return Password;
    }

    public void setPassword(String Password) {
        this.Password = Password;
    }

    public String getPhoneNum() {
        return PhoneNum;
    }

    public void setPhoneNum(String PhoneNum) {
        this.PhoneNum = PhoneNum;
    }

    public String getAddress() {
        return Address;
    }

    public void setAddress(String Address) {
        this.Address = Address;
    }

    public int getYearOfBirth() {
        return YearOfBirth;
    }

    public void setYearOfBirth(int YearOfBirth) {
        this.YearOfBirth = YearOfBirth;
    }

    public boolean isStatus() {
        return Status;
    }

    public void setStatus(boolean Status) {
        this.Status = Status;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getGender() { 
        return Gender;
    }

    public void setGender(String Gender) { 
        this.Gender = Gender;
    }

    @Override
    public String toString() {
        return "Account{" + "accountID=" + accountID + ", Name=" + Name + ", Email=" + Email + ", Password=" + Password + ", PhoneNum=" + PhoneNum + ", Address=" + Address + ", YearOfBirth=" + YearOfBirth + ", Gender=" + Gender + ", LoyaltyPoint=" + LoyaltyPoint + ", MembershipLevel=" + MembershipLevel + ", Status=" + Status + ", role=" + role + ", AvatarID=" + AvatarID + '}';
    }

    

    
}
