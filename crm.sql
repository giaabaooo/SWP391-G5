DROP DATABASE IF EXISTS crm_device_management;
CREATE DATABASE crm_device_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE crm_device_management;

CREATE TABLE Role (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active TINYINT(1) DEFAULT 1
);

CREATE TABLE User (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role_id INT NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    full_name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    address TEXT,
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (role_id) REFERENCES Role(id) ON DELETE RESTRICT
);

CREATE TABLE Permission (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active TINYINT(1) DEFAULT 1
);

CREATE TABLE Role_Permission (
    role_id INT,
    permission_id INT,
    PRIMARY KEY (role_id, permission_id),
    FOREIGN KEY (role_id) REFERENCES Role(id) ON DELETE CASCADE,
    FOREIGN KEY (permission_id) REFERENCES Permission(id) ON DELETE CASCADE
);

CREATE TABLE Category (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    is_active TINYINT(1) DEFAULT 1
);

CREATE TABLE Brand (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description TEXT,
    is_active TINYINT(1) DEFAULT 1
);

CREATE TABLE Product (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    brand_id INT,
    image_url VARCHAR(255),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    purchase_price DECIMAL(15,2),
    selling_price DECIMAL(15,2),
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES Category(id) ON DELETE RESTRICT,
    FOREIGN KEY (brand_id) REFERENCES Brand(id) ON DELETE SET NULL
);

CREATE TABLE Inventory (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (product_id) REFERENCES Product(id) ON DELETE RESTRICT
);

CREATE TABLE Contract (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    contract_code VARCHAR(50) UNIQUE,
    contract_date DATE NOT NULL,
    total_amount DECIMAL(15,2),
    description TEXT,
    FOREIGN KEY (customer_id) REFERENCES User(id) ON DELETE RESTRICT
);

CREATE TABLE ContractItem (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(15,2) NOT NULL,
    warranty_months INT DEFAULT 12,
    maintenance_months INT DEFAULT 36,
    maintenance_frequency_months INT DEFAULT 6,
    FOREIGN KEY (contract_id) REFERENCES Contract(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Product(id) ON DELETE RESTRICT
);

CREATE TABLE Device (
    id INT AUTO_INCREMENT PRIMARY KEY,
    contract_item_id INT NOT NULL,
    serial_number VARCHAR(100) UNIQUE,
    warranty_expiration DATE,
    status ENUM('InWarranty', 'OutOfWarranty', 'UnderRepair', 'Broken') DEFAULT 'InWarranty',
    FOREIGN KEY (contract_item_id) REFERENCES ContractItem(id) ON DELETE CASCADE
);

CREATE TABLE Transaction (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    contract_id INT,
    type ENUM('IMPORT','EXPORT') NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    note TEXT,
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (product_id) REFERENCES Product(id) ON DELETE RESTRICT,
    FOREIGN KEY (contract_id) REFERENCES Contract(id) ON DELETE SET NULL
);

CREATE TABLE CustomerRequest (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    device_id INT NOT NULL,
    request_type ENUM('WARRANTY','MAINTENANCE','REPAIR') NOT NULL,
    title VARCHAR(255),
    description TEXT,
    request_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('PENDING','TRANSFERRED','ASSIGNED','IN_PROGRESS','COMPLETED','AWAITING_PAYMENT','PAID','CLOSED','CANCELLED') DEFAULT 'PENDING',
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (customer_id) REFERENCES User(id) ON DELETE RESTRICT,
    FOREIGN KEY (device_id) REFERENCES Device(id) ON DELETE RESTRICT
);

CREATE TABLE CustomerRequestMeta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    priority ENUM('LOW','MEDIUM','HIGH','URGENT') DEFAULT 'MEDIUM',
    reject_reason TEXT,
    total_cost DECIMAL(15,2) DEFAULT 0,
    paid_amount DECIMAL(15,2) DEFAULT 0,
    payment_status ENUM('UNPAID','PARTIALLY_PAID','PAID') DEFAULT 'UNPAID',
    payment_due_date DATE,
    customer_comment TEXT,
    customer_service_response TEXT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    FOREIGN KEY (request_id) REFERENCES CustomerRequest(id) ON DELETE CASCADE
);


CREATE TABLE CustomerRequest_Assignment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    technician_id INT NOT NULL,
    is_main BOOLEAN DEFAULT FALSE,
    assigned_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES CustomerRequest(id) ON DELETE CASCADE,
    FOREIGN KEY (technician_id) REFERENCES User(id) ON DELETE RESTRICT
);

CREATE TABLE MaintenanceSchedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    device_id INT NOT NULL,
    next_maintenance_date DATE NOT NULL,
    last_maintenance_date DATE,
    is_auto_generated BOOLEAN DEFAULT TRUE,
    status ENUM('PENDING','SCHEDULED','COMPLETED','OVERDUE') DEFAULT 'PENDING',
    FOREIGN KEY (device_id) REFERENCES Device(id) ON DELETE CASCADE
);


CREATE TABLE Payment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    request_id INT NOT NULL,
    amount DECIMAL(15,2) NOT NULL,
    status ENUM('PENDING','COMPLETED','FAILED') DEFAULT 'PENDING',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (request_id) REFERENCES CustomerRequest(id) ON DELETE CASCADE
);