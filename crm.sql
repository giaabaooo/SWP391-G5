-- MySQL dump 10.13  Distrib 8.0.43, for Win64 (x86_64)
--
-- Host: localhost    Database: crm_device_management
-- ------------------------------------------------------
CREATE DATABASE crm_device_management
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE crm_device_management;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Payment;
DROP TABLE IF EXISTS CustomerRequestMeta;
DROP TABLE IF EXISTS CustomerRequest_Assignment;
DROP TABLE IF EXISTS MaintenanceSchedule;
DROP TABLE IF EXISTS Transaction;
DROP TABLE IF EXISTS Device;
DROP TABLE IF EXISTS ContractItem;
DROP TABLE IF EXISTS Contract;
DROP TABLE IF EXISTS Inventory;
DROP TABLE IF EXISTS ProductSerial;
DROP TABLE IF EXISTS Product;
DROP TABLE IF EXISTS Brand;
DROP TABLE IF EXISTS Category;
DROP TABLE IF EXISTS Role_Permission;
DROP TABLE IF EXISTS Permission;
DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS Role;
SET FOREIGN_KEY_CHECKS = 1;

-- Server version	8.0.43

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
    sku VARCHAR(50) NOT NULL UNIQUE,
    image_url VARCHAR(255),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    purchase_price DECIMAL(15,2),
    selling_price DECIMAL(15,2),
    is_active TINYINT(1) DEFAULT 1,
    FOREIGN KEY (category_id) REFERENCES Category(id) ON DELETE RESTRICT,
    FOREIGN KEY (brand_id) REFERENCES Brand(id) ON DELETE SET NULL,
    FULLTEXT INDEX ft_product_search (name, description)
);

CREATE TABLE ProductSerial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    serial_number VARCHAR(100) NOT NULL UNIQUE,
    status ENUM('IN_STOCK', 'SOLD', 'DELIVERED', 'WRITTEN_OFF') DEFAULT 'IN_STOCK',
    FOREIGN KEY (product_id) REFERENCES Product(id) ON DELETE RESTRICT
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
-- 1. INSERT ROLES
INSERT INTO Role (name, description, is_active) VALUES
('ADMIN', 'System Administrator - Full access', 1),
('CUSTOMER_STAFF', 'Customer Support - Handle requests and contracts', 1),
('TECH_MANAGER', 'Technical Manager - Supervise maintenance and repairs', 1),
('TECHNICIAN', 'Technical Staff - Perform maintenance & repair', 1),
('WAREHOUSE', 'Warehouse Staff - Manage inventory', 1),
('CUSTOMER', 'Client - Manufacturing Factories', 1);

-- 2. INSERT PERMISSIONS
INSERT INTO Permission (name, description, is_active) VALUES
('MANAGE_USER', 'Create, edit, delete users', 1),
('MANAGE_ROLE', 'Manage roles and permissions', 1),
('MANAGE_PRODUCT', 'Manage products and inventory', 1),
('MANAGE_CONTRACT', 'Create and manage contracts', 1),
('MANAGE_DEVICE', 'Manage devices and tracking', 1),
('MANAGE_REQUEST', 'Handle customer requests', 1),
('VIEW_REPORT', 'View system reports', 1),
('MANAGE_INVOICE', 'Create and manage invoices', 1),
('SUBMIT_REQUEST', 'Submit warranty/maintenance requests', 1),
('VIEW_OWN_CONTRACT', 'View own contracts and devices', 1);

-- 3. INSERT ROLE-PERMISSION MAPPING
INSERT INTO Role_Permission (role_id, permission_id) VALUES
-- Admin: All permissions
(1, 1), (1, 2), (1, 3), (1, 4), (1, 5), (1, 6), (1, 7), (1, 8), (1, 9), (1, 10),
-- Customer Support Staff: Handle requests, contracts, invoices, view reports
(2, 4), (2, 6), (2, 7), (2, 8),
-- Technical Manager: Supervise all technical operations, manage devices, view reports
(3, 5), (3, 6), (3, 7),
-- Technician: Handle requests and manage devices
(4, 5), (4, 6),
-- Warehouse Staff: Product and inventory management
(5, 3), (5, 5),
-- Customer: Submit requests and view own data
(6, 9), (6, 10);

-- 4. INSERT USERS (Including Staff and Customers)
INSERT INTO User (role_id, username, password, full_name, email, phone, address, is_active) VALUES
-- Admin & Staff
(1, 'admin', '123', 'John Smith', 'admin@crmdevice.com', '0901234567', 'New York, USA', 1),
(2, 'support01', '123', 'Sarah Johnson', 'support01@crmdevice.com', '0902345678', 'Chicago, USA', 1),
(2, 'support02', '123', 'Michael Brown', 'support02@crmdevice.com', '0902345679', 'Los Angeles, USA', 1),
(3, 'techmanager', '123', 'David Wilson', 'techmanager@crmdevice.com', '0903456789', 'Boston, USA', 1),
(4, 'tech01', '123', 'Robert Davis', 'tech01@crmdevice.com', '0904567890', 'Seattle, USA', 1),
(4, 'tech02', '123', 'James Miller', 'tech02@crmdevice.com', '0904567891', 'Austin, USA', 1),
(4, 'tech03', '123', 'Jennifer Garcia', 'tech03@crmdevice.com', '0904567892', 'Denver, USA', 1),
(5, 'warehouse01', '123', 'Mary Martinez', 'warehouse01@crmdevice.com', '0905678901', 'Phoenix, USA', 1),
(5, 'warehouse02', '123', 'William Anderson', 'warehouse02@crmdevice.com', '0905678902', 'Portland, USA', 1),

-- Customers (Manufacturing Factories & Enterprises)
(6, 'tesla', '123', 'Tesla Manufacturing Inc', 'procurement@tesla.com', '0241234567', 'Fremont, California', 1),
(6, 'gm', '123', 'General Motors Corp', 'purchasing@gm.com', '0236234567', 'Detroit, Michigan', 1),
(6, 'nucor', '123', 'Nucor Steel Corporation', 'purchase@nucor.com', '0243234567', 'Charlotte, North Carolina', 1),
(6, 'tyson', '123', 'Tyson Foods Manufacturing', 'procurement@tyson.com', '0283234567', 'Springdale, Arkansas', 1),
(6, 'exxon', '123', 'ExxonMobil Industrial Equipment', 'machinery@exxon.com', '0243345678', 'Irving, Texas', 1),
(6, 'kraft', '123', 'Kraft Heinz Manufacturing', 'procurement@kraftheinz.com', '0283456789', 'Pittsburgh, Pennsylvania', 1),
(6, 'usasteelworks', '123', 'USA Steel Works Corporation', 'purchase@usasteelworks.com', '0244567890', 'Birmingham, Alabama', 1),
(6, 'berryplastics', '123', 'Berry Global Plastics', 'purchase@berry.com', '0274567890', 'Evansville, Indiana', 1),
(6, 'vulcan', '123', 'Vulcan Materials Company', 'procurement@vulcan.com', '0256567890', 'Birmingham, Alabama', 1),
(6, 'inteplast', '123', 'Inteplast Group Plastics', 'purchase@inteplast.com', '0236678901', 'Livingston, New Jersey', 1);

-- 5. INSERT CATEGORIES (Types of Industrial Machinery)
INSERT INTO Category (name, description, is_active) VALUES
('CNC Machining Center', 'CNC machining centers, CNC milling machines', 1),
('Lathe Machine', 'CNC lathes and conventional turning machines', 1),
('Pressing Machine', 'Hydraulic press machines, metal stamping equipment', 1),
('Welding Equipment', 'Industrial welding equipment, welding robots', 1),
('Cutting Machine', 'Laser cutting machines, Plasma cutters, CNC cutting systems', 1),
('Grinding Machine', 'Grinding machines, industrial grinders', 1),
('Injection Molding', 'Plastic injection molding machines, industrial molding equipment', 1),
('Conveyor System', 'Production conveyor belt systems', 1),
('Packaging Machine', 'Automatic packaging machinery', 1),
('Quality Inspection', 'Quality control equipment, 3D measuring machines', 1);

-- 6. INSERT BRANDS (Machinery Manufacturers)
INSERT INTO Brand (name, description, is_active) VALUES
('Haas Automation', 'Leading CNC machine manufacturer - USA', 1),
('Mazak', 'Premium CNC and turning machines - Japan', 1),
('Fanuc', 'Industrial robotics and automation - Japan', 1),
('Amada', 'Sheet metal fabrication equipment - Japan', 1),
('DMG Mori', 'High-precision machine tools - Germany/Japan', 1),
('Trumpf', 'Laser cutting and sheet metal technology - Germany', 1),
('Komatsu', 'Heavy machinery and equipment - Japan', 1),
('Doosan', 'Industrial machinery - South Korea', 1),
('Hyundai WIA', 'Machine tools and industrial equipment - South Korea', 1),
('Okuma', 'CNC machine tools - Japan', 1),
('Brother', 'Precision machinery - Japan', 1),
('Makino', 'High-performance machining centers - Japan', 1),
('Lincoln Electric', 'Welding equipment and automation - USA', 1),
('Miller Electric', 'Welding solutions - USA', 1),
('Engel', 'Injection molding machines - Austria', 1),
('Arburg', 'Plastic processing machinery - Germany', 1),
('Mitsubishi Electric', 'Industrial automation and machinery - Japan', 1),
('Siemens', 'Industrial automation solutions - Germany', 1);

-- 7. INSERT PRODUCTS (Industrial Machinery)
INSERT INTO Product (category_id, brand_id, sku, image_url, name, description, purchase_price, selling_price, is_active) VALUES
-- CNC Machining Centers
(1, 1, 'SKU-CNC-001', '/images/haas-vf2.jpg', 'Haas VF-2SS CNC Vertical Machining Center', '3-axis vertical CNC milling machine, travel 762x406x508mm, spindle speed 12000 RPM', 1250000000, 1580000000, 1),
(1, 2, 'SKU-CNC-002', '/images/mazak-vcn510c.jpg', 'Mazak VCN-510C 5-Axis Machining Center', '5-axis machining center, advanced technology, large travel 1020x510x460mm', 3800000000, 4750000000, 1),
(1, 5, 'SKU-CNC-003', '/images/dmg-dmu50.jpg', 'DMG MORI DMU 50 CNC Universal Milling', 'Universal 5-axis milling center, high precision, travel 500x450x400mm', 4200000000, 5250000000, 1),
(1, 10, 'SKU-CNC-004', '/images/okuma-mb4000h.jpg', 'Okuma MB-4000H Horizontal Machining', 'Horizontal CNC milling machine, auto rotary table, travel 400x400x350mm', 2100000000, 2650000000, 1),

-- Lathe Machines
(2, 2, 'SKU-LATHE-001', '/images/mazak-qtc200.jpg', 'Mazak QTC-200 CNC Turning Center', '2-axis CNC lathe, turning diameter 260mm, length 500mm', 850000000, 1080000000, 1),
(2, 8, 'SKU-LATHE-002', '/images/doosan-lynx220.jpg', 'Doosan LYNX 220 CNC Lathe', 'CNC lathe with advanced servo system, diameter 280mm', 920000000, 1150000000, 1),
(2, 10, 'SKU-LATHE-003', '/images/okuma-lb3000.jpg', 'Okuma LB-3000 EXII Turning Center', 'Premium CNC lathe, integrated C-axis, diameter 365mm', 1580000000, 1980000000, 1),

-- Pressing Machines
(3, 7, 'SKU-PRESS-001', '/images/komatsu-h1f250.jpg', 'Komatsu H1F-250 Hydraulic Press', '250-ton hydraulic press machine, stroke 500mm, bed 1000x800mm', 680000000, 850000000, 1),
(3, 4, 'SKU-PRESS-002', '/images/amada-hfb2204.jpg', 'Amada HFB-2204 Press Brake', 'CNC press brake 220 tons, bed length 4000mm', 1250000000, 1580000000, 1),
(3, 4, 'SKU-PRESS-003', '/images/amada-rg100.jpg', 'Amada RG-100 Turret Punch Press', 'CNC turret punch press with rotating tool tower, bed 1250x2500mm', 2100000000, 2650000000, 1),

-- Welding Equipment
(4, 13, 'SKU-WELD-001', '/images/lincoln-powerwave.jpg', 'Lincoln Powerwave S500 Welding System', 'MIG/MAG welding machine 500A output, digital control', 185000000, 235000000, 1),
(4, 14, 'SKU-WELD-002', '/images/miller-deltaweld.jpg', 'Miller Deltaweld 452 MIG Welder', 'CO2/MIG welder 450A with inverter technology', 165000000, 210000000, 1),
(4, 3, 'SKU-WELD-003', '/images/fanuc-arcmate120.jpg', 'Fanuc ARC Mate 120iC Welding Robot', 'Industrial welding robot 6-axis, payload 12kg, reach 1811mm', 1850000000, 2320000000, 1),
(4, 17, 'SKU-WELD-004', '/images/mitsubishi-welder.jpg', 'Mitsubishi RV-7FLL Welding Robot', 'Versatile welding robot, 6-axis, 7kg payload, accuracy ±0.05mm', 1680000000, 2100000000, 1),

-- Cutting Machines
(5, 6, 'SKU-CUT-001', '/images/trumpf-3030.jpg', 'Trumpf TruLaser 3030 Fiber Laser', 'Fiber laser cutting machine 4kW, bed 3000x1500mm, high speed', 3500000000, 4380000000, 1),
(5, 4, 'SKU-CUT-002', '/images/amada-ensis.jpg', 'Amada ENSIS-3015AJ Fiber Laser', 'Fiber laser cutter 3kW, automatic loading, bed 3000x1500mm', 3200000000, 4000000000, 1),
(5, 7, 'SKU-CUT-003', '/images/komatsu-plasma.jpg', 'Komatsu Plasma Cutter PC-1500', 'CNC plasma cutter, 150A power source, bed 2500x6000mm', 425000000, 535000000, 1),

-- Grinding Machines
(6, 10, 'SKU-GRIND-001', '/images/okuma-grinder.jpg', 'Okuma UGM-6 Universal Grinding Machine', 'Universal CNC grinding machine, travel 600x450x350mm', 1150000000, 1450000000, 1),
(6, 11, 'SKU-GRIND-002', '/images/brother-sg408.jpg', 'Brother SG-408 Surface Grinder', 'Surface grinding machine, bed 400x800mm, precision 0.002mm', 385000000, 485000000, 1),

-- Injection Molding
(7, 15, 'SKU-INJ-001', '/images/engel-e-max.jpg', 'Engel e-max 310/100 Injection Molding', 'Electric injection molding machine 100 tons, clamping force 1000kN, energy saving', 1450000000, 1820000000, 1),
(7, 16, 'SKU-INJ-002', '/images/arburg-470a.jpg', 'Arburg Allrounder 470 A Injection Machine', 'Hydraulic injection molding 150 tons, clamping force 1500kN, versatile', 1280000000, 1600000000, 1),
(7, 15, 'SKU-INJ-003', '/images/engel-duo.jpg', 'Engel duo 2050/350 Large Injection Machine', 'Large injection molding machine 350 tons, clamping force 3500kN, for large products', 3850000000, 4820000000, 1),

-- Conveyor Systems
(8, 18, 'SKU-CONV-001', '/images/siemens-conveyor.jpg', 'Siemens SIMATIC Conveyor System S7-1200', 'PLC-controlled conveyor system, length 20m, load capacity 500kg', 285000000, 360000000, 1),
(8, 17, 'SKU-CONV-002', '/images/mitsubishi-conveyor.jpg', 'Mitsubishi MR-J4 Servo Conveyor Line', 'Precision servo conveyor, length 15m, speed 60m/min', 385000000, 485000000, 1),

-- Packaging Machines
(9, 18, 'SKU-PACK-001', '/images/siemens-packaging.jpg', 'Siemens Automatic Packaging Line APL-300', 'Automatic packaging line, 30 packs/min, integrated weighing system', 685000000, 860000000, 1),

-- Quality Inspection Equipment
(10, 17, 'SKU-QUAL-001', '/images/mitsubishi-cmm.jpg', 'Mitsubishi CMM Coordinate Measuring Machine', '3D coordinate measuring machine, travel 700x1000x600mm, accuracy 0.001mm', 1150000000, 1450000000, 1),
(10, 2, 'SKU-QUAL-002', '/images/mazak-probe.jpg', 'Mazak QC-20W Quality Control System', 'Integrated quality control system, optical laser probe', 425000000, 535000000, 1);

-- 8. INSERT INVENTORY
INSERT INTO Inventory (product_id, quantity, is_active) VALUES
(1, 5, 1), (2, 2, 1), (3, 3, 1), (4, 4, 1),
(5, 6, 1), (6, 5, 1), (7, 3, 1),
(8, 8, 1), (9, 4, 1), (10, 3, 1),
(11, 12, 1), (12, 10, 1), (13, 6, 1), (14, 5, 1),
(15, 4, 1), (16, 3, 1), (17, 7, 1),
(18, 2, 1), (19, 3, 1),
(20, 4, 1), (21, 3, 1), (22, 2, 1),
(23, 5, 1), (24, 6, 1),
(25, 3, 1),
(26, 4, 1), (27, 3, 1);

-- 9. INSERT CONTRACTS (with Manufacturing Companies)
INSERT INTO Contract (customer_id, contract_code, contract_date, total_amount, description) VALUES
(10, 'CT-TES-2024-001', '2024-01-15', 12100000000, 'Tesla Manufacturing - CNC machines and welding systems for automotive assembly line'),
(11, 'CT-GM-2024-002', '2024-02-10', 8350000000, 'General Motors - Machining equipment and laser cutting machines'),
(12, 'CT-NUC-2024-003', '2024-02-25', 6480000000, 'Nucor Steel - Hydraulic press machines and metal cutting systems'),
(13, 'CT-TYS-2024-004', '2024-03-05', 5820000000, 'Tyson Foods - Automatic packaging machines and conveyor systems'),
(14, 'CT-EXX-2024-005', '2024-03-20', 9650000000, 'ExxonMobil - Welding robots and CNC machining for oil & gas industry'),
(15, 'CT-KFT-2024-006', '2024-04-12', 3600000000, 'Kraft Heinz - Conveyor systems and quality inspection equipment'),
(16, 'CT-USA-2024-007', '2024-05-08', 7280000000, 'USA Steel Works - Plasma cutters and metal pressing machines'),
(17, 'CT-BER-2024-008', '2024-06-15', 8240000000, 'Berry Plastics - Injection molding machines and automation systems'),
(18, 'CT-VUL-2024-009', '2024-07-22', 4650000000, 'Vulcan Materials - Machining equipment and industrial grinders'),
(19, 'CT-INT-2024-010', '2024-08-10', 6420000000, 'Inteplast Group - Injection molding machines and automation robots');

-- 10. INSERT CONTRACT ITEMS
INSERT INTO ContractItem (contract_id, product_id, quantity, unit_price, warranty_months, maintenance_months, maintenance_frequency_months) VALUES
-- Contract 1: Tesla (CT-TES-2024-001)
(1, 2, 2, 4750000000, 24, 60, 6),  -- 2x Mazak 5-Axis
(1, 13, 1, 2320000000, 24, 48, 6),  -- 1x Fanuc Welding Robot
(1, 26, 1, 1450000000, 12, 36, 6),  -- 1x CMM Machine

-- Contract 2: General Motors (CT-GM-2024-002)
(2, 1, 2, 1580000000, 18, 48, 6),  -- 2x Haas VF-2SS
(2, 15, 1, 4380000000, 24, 60, 6),  -- 1x Trumpf Laser
(2, 27, 1, 535000000, 12, 36, 6),   -- 1x QC System

-- Contract 3: Nucor Steel (CT-NUC-2024-003)
(3, 8, 3, 850000000, 18, 48, 6),   -- 3x Komatsu Press
(3, 9, 2, 1580000000, 18, 48, 6),  -- 2x Amada Press Brake
(3, 17, 1, 535000000, 12, 36, 6),  -- 1x Plasma Cutter

-- Contract 4: Tyson Foods (CT-TYS-2024-004)
(4, 25, 1, 860000000, 12, 36, 3),  -- 1x Packaging Line
(4, 23, 2, 360000000, 12, 36, 3),  -- 2x Conveyor System
(4, 3, 2, 5250000000, 24, 60, 6),  -- 2x DMG Mori

-- Contract 5: ExxonMobil (CT-EXX-2024-005)
(5, 13, 2, 2320000000, 24, 60, 6), -- 2x Fanuc Robot
(5, 3, 1, 5250000000, 24, 60, 6),  -- 1x DMG Mori
(5, 7, 1, 1980000000, 18, 48, 6),  -- 1x Okuma Lathe

-- Contract 6: Kraft Heinz (CT-KFT-2024-006)
(6, 24, 2, 485000000, 12, 36, 3),  -- 2x Conveyor
(6, 26, 1, 1450000000, 12, 36, 6), -- 1x CMM
(6, 25, 1, 860000000, 12, 36, 3),  -- 1x Packaging

-- Contract 7: USA Steel Works (CT-USA-2024-007)
(7, 17, 2, 535000000, 12, 36, 6),  -- 2x Plasma Cutter
(7, 8, 4, 850000000, 18, 48, 6),   -- 4x Komatsu Press
(7, 15, 1, 4380000000, 24, 60, 6), -- 1x Trumpf Laser

-- Contract 8: Berry Plastics (CT-BER-2024-008)
(8, 20, 2, 1820000000, 18, 48, 6), -- 2x Engel e-max
(8, 21, 2, 1600000000, 18, 48, 6), -- 2x Arburg
(8, 23, 3, 360000000, 12, 36, 3),  -- 3x Conveyor

-- Contract 9: Vulcan Materials (CT-VUL-2024-009)
(9, 4, 2, 2650000000, 18, 48, 6),  -- 2x Okuma Horizontal
(9, 18, 2, 485000000, 12, 36, 6),  -- 2x Surface Grinder

-- Contract 10: Inteplast Group (CT-INT-2024-010)
(10, 22, 1, 4820000000, 18, 48, 6), -- 1x Engel duo Large
(10, 20, 1, 1820000000, 18, 48, 6), -- 1x Engel e-max
(10, 24, 2, 485000000, 12, 36, 3);  -- 2x Conveyor

-- 11. INSERT DEVICES (Specific equipment with serial numbers)
INSERT INTO Device (contract_item_id, serial_number, warranty_expiration, status) VALUES
-- Contract 1 devices
(1, 'MZK-5AX-2024-001', '2026-01-15', 'InWarranty'),
(1, 'MZK-5AX-2024-002', '2026-01-15', 'InWarranty'),
(2, 'FNC-WR-2024-001', '2026-01-15', 'InWarranty'),
(3, 'MIT-CMM-2024-001', '2025-01-15', 'InWarranty'),

-- Contract 2 devices
(4, 'HAS-VF2-2024-001', '2025-08-10', 'InWarranty'),
(4, 'HAS-VF2-2024-002', '2025-08-10', 'InWarranty'),
(5, 'TRF-LS-2024-001', '2026-02-10', 'InWarranty'),
(6, 'MZK-QC-2024-001', '2025-02-10', 'InWarranty'),

-- Contract 3 devices
(7, 'KMT-PR-2024-001', '2025-08-25', 'InWarranty'),
(7, 'KMT-PR-2024-002', '2025-08-25', 'InWarranty'),
(7, 'KMT-PR-2024-003', '2025-08-25', 'InWarranty'),
(8, 'AMD-PB-2024-001', '2025-08-25', 'InWarranty'),
(8, 'AMD-PB-2024-002', '2025-08-25', 'InWarranty'),
(9, 'KMT-PC-2024-001', '2025-02-25', 'InWarranty'),

-- Contract 4 devices
(10, 'SIE-PKG-2024-001', '2025-03-05', 'InWarranty'),
(11, 'SIE-CNV-2024-001', '2025-03-05', 'InWarranty'),
(11, 'SIE-CNV-2024-002', '2025-03-05', 'InWarranty'),
(12, 'DMG-DMU-2024-001', '2026-03-05', 'InWarranty'),
(12, 'DMG-DMU-2024-002', '2026-03-05', 'InWarranty'),

-- Contract 5 devices
(13, 'FNC-WR-2024-002', '2026-03-20', 'InWarranty'),
(13, 'FNC-WR-2024-003', '2026-03-20', 'InWarranty'),
(14, 'DMG-DMU-2024-003', '2026-03-20', 'InWarranty'),
(15, 'OKM-LB-2024-001', '2025-09-20', 'InWarranty'),

-- Add more devices for remaining contracts (simplified)
(16, 'MIT-CNV-2024-001', '2025-04-12', 'InWarranty'),
(16, 'MIT-CNV-2024-002', '2025-04-12', 'InWarranty'),
(17, 'MIT-CMM-2024-002', '2025-04-12', 'InWarranty'),
(18, 'SIE-PKG-2024-002', '2025-04-12', 'InWarranty'),

(19, 'KMT-PC-2024-002', '2025-05-08', 'InWarranty'),
(19, 'KMT-PC-2024-003', '2025-05-08', 'InWarranty'),
(20, 'KMT-PR-2024-004', '2025-11-08', 'InWarranty'),
(20, 'KMT-PR-2024-005', '2025-11-08', 'InWarranty'),
(20, 'KMT-PR-2024-006', '2025-11-08', 'InWarranty'),
(20, 'KMT-PR-2024-007', '2025-11-08', 'InWarranty'),
(21, 'TRF-LS-2024-002', '2026-05-08', 'InWarranty');

-- 12. INSERT TRANSACTIONS (Import/Export inventory)
INSERT INTO Transaction (product_id, contract_id, type, quantity, transaction_date, note, is_active) VALUES
-- Import transactions
(1, NULL, 'IMPORT', 10, '2024-01-01 08:00:00', 'Year opening stock - Haas VF-2SS', 1),
(2, NULL, 'IMPORT', 5, '2024-01-01 08:00:00', 'Year opening stock - Mazak 5-Axis', 1),
(3, NULL, 'IMPORT', 5, '2024-01-01 08:00:00', 'Year opening stock - DMG Mori', 1),
(13, NULL, 'IMPORT', 8, '2024-01-05 09:00:00', 'Import Fanuc welding robots from Japan factory', 1),
(15, NULL, 'IMPORT', 6, '2024-01-10 10:00:00', 'Import Trumpf laser cutters from Germany', 1),
(20, NULL, 'IMPORT', 10, '2024-01-15 08:30:00', 'Import Engel injection molding machines from Austria', 1),

-- Export transactions (for contracts)
(2, 1, 'EXPORT', 2, '2024-01-15 14:00:00', 'Shipped to Tesla - Contract CT-TES-2024-001', 1),
(13, 1, 'EXPORT', 1, '2024-01-15 14:30:00', 'Shipped welding robot to Tesla', 1),
(26, 1, 'EXPORT', 1, '2024-01-15 15:00:00', 'Shipped CMM machine to Tesla', 1),

(1, 2, 'EXPORT', 2, '2024-02-10 10:00:00', 'Shipped CNC machines to General Motors - CT-GM-2024-002', 1),
(15, 2, 'EXPORT', 1, '2024-02-10 11:00:00', 'Shipped Trumpf laser to General Motors', 1),

(8, 3, 'EXPORT', 3, '2024-02-25 09:00:00', 'Shipped press machines to Nucor Steel - CT-NUC-2024-003', 1),
(9, 3, 'EXPORT', 2, '2024-02-25 10:00:00', 'Shipped press brake to Nucor Steel', 1),

(25, 4, 'EXPORT', 1, '2024-03-05 08:00:00', 'Shipped packaging line to Tyson Foods', 1),
(23, 4, 'EXPORT', 2, '2024-03-05 09:00:00', 'Shipped conveyor systems to Tyson Foods', 1),

(13, 5, 'EXPORT', 2, '2024-03-20 10:00:00', 'Shipped welding robots to ExxonMobil', 1),
(3, 5, 'EXPORT', 1, '2024-03-20 11:00:00', 'Shipped DMG Mori to ExxonMobil', 1),

-- Additional import for restocking
(8, NULL, 'IMPORT', 5, '2024-04-01 08:00:00', 'Restocking Komatsu press machines', 1),
(23, NULL, 'IMPORT', 8, '2024-04-05 09:00:00', 'Restocking Siemens conveyor systems', 1);

SET FOREIGN_KEY_CHECKS = 0;

--
-- Table structure for table `brand`
--

DROP TABLE IF EXISTS `brand`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `brand` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `brand`
--

LOCK TABLES `brand` WRITE;
/*!40000 ALTER TABLE `brand` DISABLE KEYS */;
INSERT INTO `brand` VALUES (1,'Haas Automation','Leading CNC machine manufacturer - USA',1),(2,'Mazak','Premium CNC and turning machines - Japan',1),(3,'Fanuc','Industrial robotics and automation - Japan',1),(4,'Amada','Sheet metal fabrication equipment - Japan',1),(5,'DMG Mori','High-precision machine tools - Germany/Japan',1),(6,'Trumpf','Laser cutting and sheet metal technology - Germany',1),(7,'Komatsu','Heavy machinery and equipment - Japan',1),(8,'Doosan','Industrial machinery - South Korea',1),(9,'Hyundai WIA','Machine tools and industrial equipment - South Korea',1),(10,'Okuma','CNC machine tools - Japan',1),(11,'Brother','Precision machinery - Japan',1),(12,'Makino','High-performance machining centers - Japan',1),(13,'Lincoln Electric','Welding equipment and automation - USA',1),(14,'Miller Electric','Welding solutions - USA',1),(15,'Engel','Injection molding machines - Austria',1),(16,'Arburg','Plastic processing machinery - Germany',1),(17,'Mitsubishi Electric','Industrial automation and machinery - Japan',1),(18,'Siemens','Industrial automation solutions - Germany',1);
/*!40000 ALTER TABLE `brand` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `category`
--

DROP TABLE IF EXISTS `category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `category` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `category`
--

LOCK TABLES `category` WRITE;
/*!40000 ALTER TABLE `category` DISABLE KEYS */;
INSERT INTO `category` VALUES (1,'CNC Machining Center','CNC machining centers, CNC milling machines',1),(2,'Lathe Machine','CNC lathes and conventional turning machines',1),(3,'Pressing Machine','Hydraulic press machines, metal stamping equipment',1),(4,'Welding Equipment','Industrial welding equipment, welding robots',1),(5,'Cutting Machine','Laser cutting machines, Plasma cutters, CNC cutting systems',1),(6,'Grinding Machine','Grinding machines, industrial grinders',1),(7,'Injection Molding','Plastic injection molding machines, industrial molding equipment',1),(8,'Conveyor System','Production conveyor belt systems',1),(9,'Packaging Machine','Automatic packaging machinery',1),(10,'Quality Inspection','Quality control equipment, 3D measuring machines',1);
/*!40000 ALTER TABLE `category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contract`
--

DROP TABLE IF EXISTS `contract`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contract` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `contract_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `contract_date` date NOT NULL,
  `total_amount` decimal(15,2) DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `contract_code` (`contract_code`),
  KEY `customer_id` (`customer_id`),
  CONSTRAINT `contract_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contract`
--

LOCK TABLES `contract` WRITE;
/*!40000 ALTER TABLE `contract` DISABLE KEYS */;
INSERT INTO `contract` VALUES (1,10,'CT-TES-2024-001','2024-01-15',12100000000.00,'Tesla Manufacturing - CNC machines and welding systems for automotive assembly line',1),(2,11,'CT-GM-2024-002','2024-02-10',8350000000.00,'General Motors - Machining equipment and laser cutting machines',1),(3,12,'CT-NUC-2024-003','2024-02-25',6480000000.00,'Nucor Steel - Hydraulic press machines and metal cutting systems',1),(4,13,'CT-TYS-2024-004','2024-03-05',5820000000.00,'Tyson Foods - Automatic packaging machines and conveyor systems',1),(5,14,'CT-EXX-2024-005','2024-03-20',9650000000.00,'ExxonMobil - Welding robots and CNC machining for oil & gas industry',1),(6,15,'CT-KFT-2024-006','2024-04-12',3600000000.00,'Kraft Heinz - Conveyor systems and quality inspection equipment',1),(7,16,'CT-USA-2024-007','2024-05-08',7280000000.00,'USA Steel Works - Plasma cutters and metal pressing machines',1),(8,17,'CT-BER-2024-008','2024-06-15',8240000000.00,'Berry Plastics - Injection molding machines and automation systems',1),(9,18,'CT-VUL-2024-009','2024-07-22',4650000000.00,'Vulcan Materials - Machining equipment and industrial grinders',1),(10,19,'CT-INT-2024-010','2024-08-10',6420000000.00,'Inteplast Group - Injection molding machines and automation robots',1),(11,17,'CT2025-01','2025-11-03',4000000000.00,'abc',1),(12,11,'CT2025-02','2025-11-06',1580000000.00,'',1),(13,14,'TRF-LS-2024-003','2025-11-06',1580000000.00,'',1),(14,11,'xxxxxxxxxxx','2025-11-06',1580000000.00,'',1),(15,14,'CT202511001000','2025-11-10',1580000000.00,'',1),(16,14,'CT-2025-11-002','2025-11-10',3160000000.00,'',1),(17,11,'CT-2025-11-001','2025-11-11',485000000.00,'',1),(20,23,'CT-2025-11-003','2025-11-11',485000000.00,'',1);
/*!40000 ALTER TABLE `contract` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `contractitem`
--

DROP TABLE IF EXISTS `contractitem`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `contractitem` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contract_id` int NOT NULL,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `unit_price` decimal(15,2) NOT NULL,
  `warranty_months` int DEFAULT '12',
  `maintenance_months` int DEFAULT '36',
  `maintenance_frequency_months` int DEFAULT '6',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `contract_id` (`contract_id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `contractitem_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`id`) ON DELETE CASCADE,
  CONSTRAINT `contractitem_ibfk_2` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `contractitem_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=45 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contractitem`
--

LOCK TABLES `contractitem` WRITE;
/*!40000 ALTER TABLE `contractitem` DISABLE KEYS */;
INSERT INTO `contractitem` VALUES (1,1,2,2,4750000000.00,24,60,6,1),(2,1,13,1,2320000000.00,24,48,6,1),(3,1,26,1,1450000000.00,12,36,6,1),(4,2,1,2,1580000000.00,18,48,6,1),(5,2,15,1,4380000000.00,24,60,6,1),(6,2,27,1,535000000.00,12,36,6,1),(7,3,8,3,850000000.00,18,48,6,1),(8,3,9,2,1580000000.00,18,48,6,1),(9,3,17,1,535000000.00,12,36,6,1),(10,4,25,1,860000000.00,12,36,3,1),(11,4,23,2,360000000.00,12,36,3,1),(12,4,3,2,5250000000.00,24,60,6,1),(13,5,13,2,2320000000.00,24,60,6,1),(14,5,3,1,5250000000.00,24,60,6,1),(15,5,7,1,1980000000.00,18,48,6,1),(16,6,24,2,485000000.00,12,36,3,1),(17,6,26,1,1450000000.00,12,36,6,1),(18,6,25,1,860000000.00,12,36,3,1),(19,7,17,2,535000000.00,12,36,6,1),(20,7,8,4,850000000.00,18,48,6,1),(21,7,15,1,4380000000.00,24,60,6,1),(22,8,20,2,1820000000.00,18,48,6,1),(23,8,21,2,1600000000.00,18,48,6,1),(24,8,23,3,360000000.00,12,36,3,1),(25,9,4,2,2650000000.00,18,48,6,1),(26,9,18,2,485000000.00,12,36,6,1),(27,10,22,1,4820000000.00,18,48,6,1),(28,10,20,1,1820000000.00,18,48,6,1),(29,10,24,2,485000000.00,12,36,3,1),(30,11,16,1,4000000000.00,12,24,6,1),(31,12,9,1,1580000000.00,12,24,6,1),(32,13,9,1,1580000000.00,12,24,6,1),(33,14,9,1,1580000000.00,12,24,6,1),(34,15,9,1,1580000000.00,12,24,6,0),(35,16,9,1,1580000000.00,12,24,6,0),(36,16,9,1,1580000000.00,12,24,6,0),(37,16,9,1,1580000000.00,12,24,6,0),(38,16,9,1,1580000000.00,12,24,6,0),(39,16,9,1,1580000000.00,12,24,6,1),(40,16,9,1,1580000000.00,12,24,6,1),(41,15,9,1,1580000000.00,12,24,6,0),(42,15,9,1,1580000000.00,12,24,6,1),(43,17,19,1,485000000.00,12,24,6,1),(44,20,19,1,485000000.00,12,24,6,1);
/*!40000 ALTER TABLE `contractitem` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerrequest`
--

DROP TABLE IF EXISTS `customerrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerrequest` (
  `id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int NOT NULL,
  `device_id` int NOT NULL,
  `request_type` enum('WARRANTY','MAINTENANCE','REPAIR') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `request_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('PENDING','TRANSFERRED','ASSIGNED','IN_PROGRESS','COMPLETED','AWAITING_PAYMENT','PAID','CLOSED','CANCELLED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `customer_id` (`customer_id`),
  KEY `device_id` (`device_id`),
  CONSTRAINT `customerrequest_ibfk_1` FOREIGN KEY (`customer_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `customerrequest_ibfk_2` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerrequest`
--

LOCK TABLES `customerrequest` WRITE;
/*!40000 ALTER TABLE `customerrequest` DISABLE KEYS */;
INSERT INTO `customerrequest` VALUES (1,10,1,'REPAIR','gdfgdfd','First scheduled maintenance for Mazak 5-Axis machine','2024-07-10 08:30:00','AWAITING_PAYMENT',1),(2,10,3,'MAINTENANCE',NULL,'Scheduled maintenance for Fanuc welding robot','2024-07-15 09:00:00','ASSIGNED',1),(3,11,5,'WARRANTY',NULL,'Haas control system malfunction, warranty claim','2024-08-05 10:15:00','ASSIGNED',1),(4,12,10,'MAINTENANCE',NULL,'Scheduled maintenance for Komatsu press machine','2024-08-20 08:00:00','ASSIGNED',1),(5,13,15,'MAINTENANCE',NULL,'Scheduled maintenance for automatic packaging system','2024-10-01 09:30:00','TRANSFERRED',1),(6,14,22,'REPAIR',NULL,'Welding robot drive system repair needed','2024-10-03 14:00:00','TRANSFERRED',1),(7,15,25,'MAINTENANCE',NULL,'Scheduled maintenance for Mitsubishi servo conveyor','2024-10-05 08:00:00','AWAITING_PAYMENT',1),(8,16,31,'WARRANTY',NULL,'Hydraulic press oil leakage, warranty inspection required','2024-10-06 11:30:00','TRANSFERRED',1),(9,10,1,'REPAIR','ABC','NEW REQUEST TEST','2025-11-03 23:46:59','CLOSED',1),(10,10,2,'WARRANTY','ABC2','ABC2Edit','2025-11-03 23:47:59','CLOSED',1),(11,10,2,'REPAIR','bfvsfvfsvf','vfsvfsvf','2025-11-04 11:01:16','AWAITING_PAYMENT',1),(12,10,2,'REPAIR','cccc','','2025-11-06 21:19:40','PENDING',1),(13,10,1,'WARRANTY','cccccc','','2025-11-06 21:19:48','PENDING',1),(14,10,3,'WARRANTY','ccc','','2025-11-06 21:19:57','PENDING',1),(15,10,3,'WARRANTY','ccccccc','','2025-11-06 21:20:10','PENDING',1),(16,10,1,'MAINTENANCE','bbbb','','2025-11-06 21:20:18','PENDING',1),(17,10,4,'WARRANTY','gggg','','2025-11-06 21:20:25','PENDING',1),(18,10,4,'MAINTENANCE','vvvv','','2025-11-06 21:20:42','TRANSFERRED',1),(19,10,1,'REPAIR','bbbbb','','2025-11-11 10:34:17','TRANSFERRED',1),(20,10,1,'REPAIR','bbbbb','','2025-11-11 11:05:54','PENDING',1);
/*!40000 ALTER TABLE `customerrequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerrequest_assignment`
--

DROP TABLE IF EXISTS `customerrequest_assignment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerrequest_assignment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `technician_id` int NOT NULL,
  `is_main` tinyint(1) DEFAULT '0',
  `assigned_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `estimated_hours` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `request_id` (`request_id`),
  KEY `technician_id` (`technician_id`),
  CONSTRAINT `customerrequest_assignment_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `customerrequest` (`id`) ON DELETE CASCADE,
  CONSTRAINT `customerrequest_assignment_ibfk_2` FOREIGN KEY (`technician_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=47 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerrequest_assignment`
--

LOCK TABLES `customerrequest_assignment` WRITE;
/*!40000 ALTER TABLE `customerrequest_assignment` DISABLE KEYS */;
INSERT INTO `customerrequest_assignment` VALUES (25,10,5,1,'2025-11-05 00:00:00',2),(26,7,5,1,'2025-11-05 00:00:00',2),(27,7,6,0,'2025-11-05 00:00:00',2),(28,7,7,0,'2025-11-05 00:00:00',2),(29,1,5,1,'2025-11-05 00:00:00',2),(30,1,7,0,'2025-11-05 00:00:00',2),(33,9,5,1,'2025-11-05 00:00:00',2),(34,9,6,0,'2025-11-05 00:00:00',2),(35,11,6,1,'2025-11-05 00:00:00',2),(41,3,5,1,'2025-11-05 00:00:00',10),(45,4,7,1,'2025-11-08 00:00:00',20),(46,2,6,1,'2025-11-06 00:00:00',20);
/*!40000 ALTER TABLE `customerrequest_assignment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `customerrequestmeta`
--

DROP TABLE IF EXISTS `customerrequestmeta`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `customerrequestmeta` (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `priority` enum('LOW','MEDIUM','HIGH','URGENT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'MEDIUM',
  `desired_completion_date` date DEFAULT NULL,
  `reject_reason` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `total_cost` decimal(15,2) DEFAULT '0.00',
  `paid_amount` decimal(15,2) DEFAULT '0.00',
  `payment_status` enum('UNPAID','PARTIALLY_PAID','PAID') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'UNPAID',
  `payment_due_date` date DEFAULT NULL,
  `customer_comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `customer_service_response` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `rating` int DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `request_id` (`request_id`),
  CONSTRAINT `customerrequestmeta_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `customerrequest` (`id`) ON DELETE CASCADE,
  CONSTRAINT `customerrequestmeta_chk_1` CHECK ((`rating` between 1 and 5))
) ENGINE=InnoDB AUTO_INCREMENT=35 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `customerrequestmeta`
--

LOCK TABLES `customerrequestmeta` WRITE;
/*!40000 ALTER TABLE `customerrequestmeta` DISABLE KEYS */;
INSERT INTO `customerrequestmeta` VALUES (18,10,'MEDIUM',NULL,NULL,0.00,0.00,'UNPAID',NULL,NULL,NULL,NULL),(19,9,'MEDIUM',NULL,NULL,10.00,10.00,'PAID',NULL,'ccccc','Cách hiểu này khiến cho cách phân đoạn thiếu tính khách quan. Với cách hiểu này, diện mạo đoạn văn không được xác định (đoạn văn bắt đầu từ đâu, như thế nào, các câu văn trong đoạn có mối liên kết với nhau như thế nào,…) cho nên việc xây dựng đoạn văn trở nên khó khăn, phức tạp, khó rèn luyện các thao tác để trở thành kĩ năng kĩ xảo.\r\n\r\n- Cách hiểu thứ hai (đoạn lời): Đoạn văn được hiểu là sự phân chia văn bản thành những phần nhỏ, hoàn toàn dựa vào dấu hiệu hình thức: một đoạn văn bao gồm những câu văn nằm giữa hai dấu chấm xuống dòng.\r\n\r\nCách hiểu này không tính tới tiêu chí nội dung, cơ sở ngữ nghĩa của đoạn văn. Với cách hiểu này, việc rèn luyện xây dựng đoạn văn càng trở nên mơ hồ, khó xác định vì đoạn văn không được xây dựng trên một cơ sở chung nào vì hình thức bao giờ cũng phải đi đôi với nội dung, bao chứa một nội dung nhất định và phù hợp với nội dung mà nó bao chứa.\r\n\r\n- Cách hiểu thứ ba (đoạn văn xét thao cả hai tiêu chí về ý và về lời): Đoạn văn vừa là kết quả của sự phân đoạn văn bản về nội dung ( dựa trên cơ sở logic ngữ nghĩa) vừa là kết quả của sự phân đoạn về hình thức ( dựa trên dấu hiệu hình thức thể hiện văn bản).\r\n\r\nVề mặt nội dung: đoạn văn là một ý hoàn chỉnh ở một mức độ nhất định nào đó về logic ngữ nghĩa, có thể nắm bắt được một cách tương đối dễ dàng. Mỗi đoạn văn trong văn bản diễn đạt một ý, các ý có mối liên quan chặt chẽ với nhau trên cơ sở chung là chủ đề của văn bản. Mỗi đoạn trong văn bản có một vai trò chức năng riêng và được sắp xếp theo một trật tự nhất định: đoạn mở đầu văn bản, các đoạn thân bài của văn bản (các đoạn này triển khai chủ đề của văn bản thành các khía cạch khác nhau), đoạn kết thúc văn bản. Mỗi đoạn văn bản khi tách ra vẫn có tính độc lập tương đối của nó: nội dung của đoạn tương đối hoàn chỉnh, hình thức của đoạn có một kết cấu nhất định.\r\n\r\nVề mặt hình thức: đoạn văn luôn luôn hoàn chỉnh. Sự hoàn chỉnh đó thể hiện ở những điểm sau: mỗi đoạn văn bao gồm một số câu văn nằm giữa hai dấu chấm xuống dòng, có liên kết với nhau về mặt hình thức, thể hiện bằng các phép liên kết; mỗi đoạn văn khi mở đầu, chữ cái đầu đoạn bao giờ cũng được viết hoa và viết lùi vào so với các dòng chữ khác trong đoạn.\r\n\r\nĐây là cách hiểu hợp lí, thoả đáng hơn cả giúp người đọc nhận diện đoạn văn trong văn bản một cách nhanh chóng, thuận lợi đồng thời giúp người viết tạo lập văn bản bằng cách xây dựng từng đoạn văn được rõ ràng, rành mạch.\r\n\r\nVí dụ về đoạn văn:\r\n\r\n“Vì ông lão yêu làng tha thiết nên vô cùng căm uất khi nghe tin dân làng theo giặc(1). Hai tình cảm tưởng chừng mâu thuẫn ấy đã dẫn đến một sự xung đột nội tâm dữ dội( 2). Ông Hai dứt khoát lựa chọn theo cách của ông: Làng thì yêu thật, nhưng làng theo Tây mất rồi thì phải thù( 3). Đây là một nét mới trong tình cảm của người nông dân thời kì đánh Pháp(4). Tình cảm yêu nước rộng lớn hơn đã bao trùm lên tình cảm đối với làng quê(5). Dù đã xác định như thế, nhưng ông Hai vẫn không thể dứt bỏ tình yêu đối với quê hương; vì thế mà ông xót xa cay đắng”(6).',NULL),(21,7,'MEDIUM',NULL,NULL,10000.00,0.00,NULL,'2025-11-04',NULL,NULL,NULL),(23,1,'MEDIUM',NULL,NULL,12121212.00,0.00,NULL,'2025-11-04',NULL,NULL,NULL),(24,11,'MEDIUM',NULL,NULL,0.00,0.00,'UNPAID',NULL,NULL,NULL,NULL),(31,19,'MEDIUM',NULL,NULL,0.00,0.00,'UNPAID',NULL,NULL,NULL,NULL);
/*!40000 ALTER TABLE `customerrequestmeta` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `device`
--

DROP TABLE IF EXISTS `device`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `device` (
  `id` int NOT NULL AUTO_INCREMENT,
  `contract_item_id` int NOT NULL,
  `serial_number` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `warranty_expiration` date DEFAULT NULL,
  `status` enum('InWarranty','OutOfWarranty','UnderRepair','Broken') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'InWarranty',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial_number` (`serial_number`),
  KEY `contract_item_id` (`contract_item_id`),
  CONSTRAINT `device_ibfk_1` FOREIGN KEY (`contract_item_id`) REFERENCES `contractitem` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `device`
--

LOCK TABLES `device` WRITE;
/*!40000 ALTER TABLE `device` DISABLE KEYS */;
INSERT INTO `device` VALUES (1,1,'MZK-5AX-2024-001','2026-01-15','InWarranty',1),(2,1,'MZK-5AX-2024-002','2026-01-15','InWarranty',1),(3,2,'FNC-WR-2024-001','2026-01-15','InWarranty',1),(4,3,'MIT-CMM-2024-001','2025-01-15','InWarranty',1),(5,4,'HAS-VF2-2024-001','2025-08-10','InWarranty',1),(6,4,'HAS-VF2-2024-002','2025-08-10','InWarranty',1),(7,5,'TRF-LS-2024-001','2026-02-10','InWarranty',1),(8,6,'MZK-QC-2024-001','2025-02-10','InWarranty',1),(9,7,'KMT-PR-2024-001','2025-08-25','InWarranty',1),(10,7,'KMT-PR-2024-002','2025-08-25','InWarranty',1),(11,7,'KMT-PR-2024-003','2025-08-25','InWarranty',1),(12,8,'AMD-PB-2024-001','2025-08-25','InWarranty',1),(13,8,'AMD-PB-2024-002','2025-08-25','InWarranty',1),(14,9,'KMT-PC-2024-001','2025-02-25','InWarranty',1),(15,10,'SIE-PKG-2024-001','2025-03-05','InWarranty',1),(16,11,'SIE-CNV-2024-001','2025-03-05','InWarranty',1),(17,11,'SIE-CNV-2024-002','2025-03-05','InWarranty',1),(18,12,'DMG-DMU-2024-001','2026-03-05','InWarranty',1),(19,12,'DMG-DMU-2024-002','2026-03-05','InWarranty',1),(20,13,'FNC-WR-2024-002','2026-03-20','InWarranty',1),(21,13,'FNC-WR-2024-003','2026-03-20','InWarranty',1),(22,14,'DMG-DMU-2024-003','2026-03-20','InWarranty',1),(23,15,'OKM-LB-2024-001','2025-09-20','InWarranty',1),(24,16,'MIT-CNV-2024-001','2025-04-12','InWarranty',1),(25,16,'MIT-CNV-2024-002','2025-04-12','InWarranty',1),(26,17,'MIT-CMM-2024-002','2025-04-12','InWarranty',1),(27,18,'SIE-PKG-2024-002','2025-04-12','InWarranty',1),(28,19,'KMT-PC-2024-002','2025-05-08','InWarranty',1),(29,19,'KMT-PC-2024-003','2025-05-08','InWarranty',1),(30,20,'KMT-PR-2024-004','2025-11-08','InWarranty',1),(31,20,'KMT-PR-2024-005','2025-11-08','InWarranty',1),(32,20,'KMT-PR-2024-006','2025-11-08','InWarranty',1),(33,20,'KMT-PR-2024-007','2025-11-08','InWarranty',1),(34,21,'TRF-LS-2024-002','2026-05-08','InWarranty',1),(35,30,'abcd','2026-11-03','InWarranty',1),(38,33,'TRF-LS-2024-0xxx','2026-11-06','InWarranty',1),(39,34,'123456_DEACTIVATED_39','2026-11-10','InWarranty',0),(40,35,'12345','2026-11-10','InWarranty',0),(43,38,'23456','2026-11-10','InWarranty',0),(45,41,'123456_DEACTIVATED_45','2026-11-10','InWarranty',0),(46,42,'12345699','2026-11-10','InWarranty',1),(47,43,'cccccccccc','2026-11-11','InWarranty',1),(48,44,'33333','2026-11-11','InWarranty',1);
/*!40000 ALTER TABLE `device` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guestcontact`
--

DROP TABLE IF EXISTS `guestcontact`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guestcontact` (
  `id` int NOT NULL AUTO_INCREMENT,
  `full_name` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `phone` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `submission_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `status` enum('NEW','READ') COLLATE utf8mb4_unicode_ci DEFAULT 'NEW',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guestcontact`
--

LOCK TABLES `guestcontact` WRITE;
/*!40000 ALTER TABLE `guestcontact` DISABLE KEYS */;
/*!40000 ALTER TABLE `guestcontact` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inventory`
--

DROP TABLE IF EXISTS `inventory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `inventory` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `quantity` int NOT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `inventory_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `inventory_chk_1` CHECK ((`quantity` >= 0))
) ENGINE=InnoDB AUTO_INCREMENT=28 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inventory`
--

LOCK TABLES `inventory` WRITE;
/*!40000 ALTER TABLE `inventory` DISABLE KEYS */;
INSERT INTO `inventory` VALUES (1,1,10005,1),(2,2,82,1),(3,3,3,1),(4,4,4,1),(5,5,76,1),(6,6,5,1),(7,7,3,1),(8,8,8,1),(9,9,4,1),(10,10,3,1),(11,11,12,1),(12,12,10,1),(13,13,6,1),(14,14,5,1),(15,15,4,1),(16,16,3,1),(17,17,7,1),(18,18,2,1),(19,19,3,1),(20,20,4,1),(21,21,3,1),(22,22,2,1),(23,23,5,1),(24,24,6,1),(25,25,3,1),(26,26,4,1),(27,27,3,1);
/*!40000 ALTER TABLE `inventory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `maintenanceschedule`
--

DROP TABLE IF EXISTS `maintenanceschedule`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `maintenanceschedule` (
  `id` int NOT NULL AUTO_INCREMENT,
  `device_id` int NOT NULL,
  `next_maintenance_date` date NOT NULL,
  `last_maintenance_date` date DEFAULT NULL,
  `is_auto_generated` tinyint(1) DEFAULT '1',
  `status` enum('PENDING','SCHEDULED','COMPLETED','OVERDUE') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  PRIMARY KEY (`id`),
  KEY `device_id` (`device_id`),
  CONSTRAINT `maintenanceschedule_ibfk_1` FOREIGN KEY (`device_id`) REFERENCES `device` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `maintenanceschedule`
--

LOCK TABLES `maintenanceschedule` WRITE;
/*!40000 ALTER TABLE `maintenanceschedule` DISABLE KEYS */;
INSERT INTO `maintenanceschedule` VALUES (1,1,'2025-01-10','2024-07-11',1,'PENDING'),(2,3,'2025-01-15','2024-07-16',1,'PENDING'),(3,10,'2025-02-20','2024-08-21',1,'PENDING'),(4,2,'2025-01-15',NULL,1,'PENDING'),(5,4,'2025-01-15',NULL,1,'PENDING'),(6,5,'2025-02-10',NULL,1,'PENDING'),(7,6,'2025-02-10',NULL,1,'PENDING'),(8,7,'2025-02-25',NULL,1,'PENDING'),(9,8,'2025-02-25',NULL,1,'PENDING'),(10,9,'2025-02-25',NULL,1,'PENDING'),(11,11,'2024-12-05',NULL,1,'PENDING'),(12,12,'2024-12-05',NULL,1,'PENDING'),(13,13,'2024-12-05',NULL,1,'PENDING'),(14,14,'2024-12-05',NULL,1,'PENDING'),(15,15,'2024-12-05',NULL,1,'PENDING'),(16,16,'2024-10-12',NULL,1,'OVERDUE'),(17,17,'2024-10-12',NULL,1,'OVERDUE');
/*!40000 ALTER TABLE `maintenanceschedule` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `payment`
--

DROP TABLE IF EXISTS `payment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `payment` (
  `id` int NOT NULL AUTO_INCREMENT,
  `request_id` int NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `status` enum('PENDING','COMPLETED','FAILED') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'PENDING',
  `payment_date` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `request_id` (`request_id`),
  CONSTRAINT `payment_ibfk_1` FOREIGN KEY (`request_id`) REFERENCES `customerrequest` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `payment`
--

LOCK TABLES `payment` WRITE;
/*!40000 ALTER TABLE `payment` DISABLE KEYS */;
INSERT INTO `payment` VALUES (1,9,5.00,'COMPLETED','2025-11-04 00:26:58'),(2,9,5.00,'COMPLETED','2025-11-04 00:27:06');
/*!40000 ALTER TABLE `payment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `permission`
--

DROP TABLE IF EXISTS `permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=116 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `permission`
--

LOCK TABLES `permission` WRITE;
/*!40000 ALTER TABLE `permission` DISABLE KEYS */;
INSERT INTO `permission` VALUES (25,'DASHBOARD_VIEW_CSKH','CSKH can view their dashboard',1),(26,'CUSTOMER_VIEW_LIST','CSKH can view the customer list',1),(27,'CUSTOMER_VIEW_DETAIL','CSKH can view customer details',1),(28,'CUSTOMER_TOGGLE_STATUS','CSKH can (de)activate a customer',1),(29,'CONTRACT_VIEW_LIST','CSKH can view the contract list',1),(30,'CONTRACT_VIEW_DETAIL','CSKH can view contract details',1),(31,'CONTRACT_CREATE','CSKH can create a new contract',1),(32,'CONTRACT_UPDATE','CSKH can update an existing contract',1),(33,'CONTRACT_DELETE','CSKH can (de)activate a contract',1),(34,'REQUEST_VIEW_LIST','CSKH can view the customer request list',1),(35,'REQUEST_VIEW_DETAIL','CSKH can view request details',1),(36,'REQUEST_MANAGE_STATUS','CSKH can transfer/close requests from the list',1),(37,'REQUEST_MANAGE_DETAIL','CSKH can update/cancel/respond to a request',1),(38,'FEEDBACK_VIEW_LIST','CSKH can view the feedback list',1),(39,'USER_VIEW','Admin can view user list',1),(40,'USER_CREATE','Admin can create a new user',1),(41,'USER_UPDATE','Admin can edit a user',1),(42,'USER_DELETE','Admin can (de)activate a user',1),(43,'DASHBOARD_VIEW_CUSTOMER','Customer can view their personal dashboard',1),(44,'DEVICE_VIEW_LIST','Customer can view their list of devices',1),(45,'DEVICE_VIEW_DETAIL','Customer can view device details',1),(46,'CONTRACT_VIEW_LIST_CUSTOMER','Customer can view their list of contracts',1),(47,'REQUEST_VIEW_LIST_CUSTOMER','Customer can view their list of requests',1),(48,'REQUEST_VIEW_DETAIL_CUSTOMER','Customer can view their request details',1),(49,'REQUEST_CREATE','Customer can create a new request',1),(50,'REQUEST_DELETE','Customer can delete (deactivate) their own request',1),(51,'FEEDBACK_VIEW_LIST_CUSTOMER','Customer can view their feedback list',1),(52,'FEEDBACK_CREATE','Customer can create new feedback',1),(63,'REQUEST_UPDATE','Customer can update their own request (before processing)',1),(64,'FEEDBACK_UPDATE','Customer can update their own feedback',1),(65,'PAYMENT_VIEW_AND_PAY','Customer can view the payment page and process a payment',1),(66,'DASHBOARD_VIEW_TECH','Tech Manager can view their dashboard',1),(67,'TECH_VIEW_LIST','Tech Manager can view technician list',1),(68,'TECH_VIEW_DETAIL','Tech Manager can view technician details',1),(69,'TECH_TOGGLE_STATUS','Tech Manager can (de)activate a technician',1),(70,'REQUEST_VIEW_LIST_TECH','Tech Manager can view the list of transferred requests',1),(71,'REQUEST_VIEW_DETAIL_TECH','Tech Manager can view request details',1),(72,'REQUEST_REJECT','Tech Manager can reject a request',1),(73,'TASK_ASSIGN','Tech Manager can assign technicians to a request',1),(74,'TASK_VIEW_LIST','Tech Manager can view the list of assigned tasks',1),(75,'TASK_VIEW_DETAIL','Tech Manager can view task details',1),(76,'TASK_UPDATE','Tech Manager can edit/re-assign a task',1),(77,'TASK_VIEW_LIST_OWN','Technician can view their own assigned task list',1),(78,'TASK_VIEW_DETAIL_OWN','Technician can view the details of their assigned tasks',1),(79,'TASK_UPDATE_STATUS_OWN','Technician can update task status (e.g., In Progress, Completed)',1),(80,'TASK_CREATE_BILL','Technician (main) can create a bill/invoice for a task',1),(81,'PRODUCT_VIEW','Warehouse staff can view product list and details',1),(82,'PRODUCT_CREATE','Warehouse staff can create new products',1),(83,'PRODUCT_UPDATE','Warehouse staff can edit existing products',1),(84,'PRODUCT_DELETE','Warehouse staff can deactivate/delete products',1),(85,'BRAND_VIEW','Warehouse staff can view brand list',1),(86,'BRAND_CREATE','Warehouse staff can create new brands',1),(87,'BRAND_UPDATE','Warehouse staff can edit existing brands',1),(88,'BRAND_DELETE','Warehouse staff can deactivate/delete brands',1),(89,'CATEGORY_VIEW','Warehouse staff can view category list',1),(90,'CATEGORY_CREATE','Warehouse staff can create new categories',1),(91,'CATEGORY_UPDATE','Warehouse staff can edit existing categories',1),(92,'CATEGORY_DELETE','Warehouse staff can deactivate/delete categories',1),(93,'INVENTORY_IMPORT','Warehouse staff can record a stock import',1),(94,'INVENTORY_EXPORT','Warehouse staff can record a stock export',1),(95,'INVENTORY_VIEW_TRANSACTIONS','Warehouse staff can view import/export history',1),(115,'DASHBOARD_VIEW_WAREHOUSE','Warehouse staff can view the warehouse dashboard',1);
/*!40000 ALTER TABLE `permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `product`
--

DROP TABLE IF EXISTS `product`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `product` (
  `id` int NOT NULL AUTO_INCREMENT,
  `category_id` int NOT NULL,
  `brand_id` int DEFAULT NULL,
  `image_url` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `purchase_price` decimal(15,2) DEFAULT NULL,
  `selling_price` decimal(15,2) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `unit` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `sku` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_product_sku` (`sku`),
  KEY `category_id` (`category_id`),
  KEY `brand_id` (`brand_id`),
  FULLTEXT KEY `ft_product_search` (`name`,`description`),
  CONSTRAINT `product_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `category` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `product_ibfk_2` FOREIGN KEY (`brand_id`) REFERENCES `brand` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB AUTO_INCREMENT=29 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `product`
--

LOCK TABLES `product` WRITE;
/*!40000 ALTER TABLE `product` DISABLE KEYS */;
INSERT INTO `product` VALUES (1,1,1,'https://drive.google.com/file/d/13zazNVeANPKg5ZKG12AOQ-Sg2s3Oqaku/view?usp=sharing','Haas VF-2SS CNC Vertical Machining Center','3-axis vertical CNC milling machine, travel 762x406x508mm, spindle speed 12000 RPM',1250000000.00,1580000000.00,1,NULL,'SKU-1'),(2,1,2,'/images/mazak-vcn510c.jpg','Mazak VCN-510C 5-Axis Machining Center','5-axis machining center, advanced technology, large travel 1020x510x460mm',3800000000.00,4750000000.00,1,NULL,'SKU-2'),(3,1,5,'/images/dmg-dmu50.jpg','DMG MORI DMU 50 CNC Universal Milling','Universal 5-axis milling center, high precision, travel 500x450x400mm',4200000000.00,5250000000.00,1,NULL,'SKU-3'),(4,1,10,'/images/okuma-mb4000h.jpg','Okuma MB-4000H Horizontal Machining','Horizontal CNC milling machine, auto rotary table, travel 400x400x350mm',2100000000.00,2650000000.00,1,NULL,'SKU-4'),(5,2,2,'/images/mazak-qtc200.jpg','Mazak QTC-200 CNC Turning Center','2-axis CNC lathe, turning diameter 260mm, length 500mm',850000000.00,1080000000.00,1,NULL,'SKU-5'),(6,2,8,'/images/doosan-lynx220.jpg','Doosan LYNX 220 CNC Lathe','CNC lathe with advanced servo system, diameter 280mm',920000000.00,1150000000.00,1,NULL,'SKU-6'),(7,2,10,'/images/okuma-lb3000.jpg','Okuma LB-3000 EXII Turning Center','Premium CNC lathe, integrated C-axis, diameter 365mm',1580000000.00,1980000000.00,1,NULL,'SKU-7'),(8,3,7,'/images/komatsu-h1f250.jpg','Komatsu H1F-250 Hydraulic Press','250-ton hydraulic press machine, stroke 500mm, bed 1000x800mm',680000000.00,850000000.00,1,NULL,'SKU-8'),(9,3,4,'/images/amada-hfb2204.jpg','Amada HFB-2204 Press Brake','CNC press brake 220 tons, bed length 4000mm',1250000000.00,1580000000.00,1,NULL,'SKU-9'),(10,3,4,'/images/amada-rg100.jpg','Amada RG-100 Turret Punch Press','CNC turret punch press with rotating tool tower, bed 1250x2500mm',2100000000.00,2650000000.00,1,NULL,'SKU-10'),(11,4,13,'/images/lincoln-powerwave.jpg','Lincoln Powerwave S500 Welding System','MIG/MAG welding machine 500A output, digital control',185000000.00,235000000.00,1,NULL,'SKU-11'),(12,4,14,'/images/miller-deltaweld.jpg','Miller Deltaweld 452 MIG Welder','CO2/MIG welder 450A with inverter technology',165000000.00,210000000.00,1,NULL,'SKU-12'),(13,4,3,'/images/fanuc-arcmate120.jpg','Fanuc ARC Mate 120iC Welding Robot','Industrial welding robot 6-axis, payload 12kg, reach 1811mm',1850000000.00,2320000000.00,1,NULL,'SKU-13'),(14,4,17,'/images/mitsubishi-welder.jpg','Mitsubishi RV-7FLL Welding Robot','Versatile welding robot, 6-axis, 7kg payload, accuracy ±0.05mm',1680000000.00,2100000000.00,1,NULL,'SKU-14'),(15,5,6,'/images/trumpf-3030.jpg','Trumpf TruLaser 3030 Fiber Laser','Fiber laser cutting machine 4kW, bed 3000x1500mm, high speed',3500000000.00,4380000000.00,1,NULL,'SKU-15'),(16,5,4,'/images/amada-ensis.jpg','Amada ENSIS-3015AJ Fiber Laser','Fiber laser cutter 3kW, automatic loading, bed 3000x1500mm',3200000000.00,4000000000.00,1,NULL,'SKU-16'),(17,5,7,'/images/komatsu-plasma.jpg','Komatsu Plasma Cutter PC-1500','CNC plasma cutter, 150A power source, bed 2500x6000mm',425000000.00,535000000.00,1,NULL,'SKU-17'),(18,6,10,'/images/okuma-grinder.jpg','Okuma UGM-6 Universal Grinding Machine','Universal CNC grinding machine, travel 600x450x350mm',1150000000.00,1450000000.00,1,NULL,'SKU-18'),(19,6,11,'/images/brother-sg408.jpg','Brother SG-408 Surface Grinder','Surface grinding machine, bed 400x800mm, precision 0.002mm',385000000.00,485000000.00,1,NULL,'SKU-19'),(20,7,15,'/images/engel-e-max.jpg','Engel e-max 310/100 Injection Molding','Electric injection molding machine 100 tons, clamping force 1000kN, energy saving',1450000000.00,1820000000.00,1,NULL,'SKU-20'),(21,7,16,'/images/arburg-470a.jpg','Arburg Allrounder 470 A Injection Machine','Hydraulic injection molding 150 tons, clamping force 1500kN, versatile',1280000000.00,1600000000.00,1,NULL,'SKU-21'),(22,7,15,'/images/engel-duo.jpg','Engel duo 2050/350 Large Injection Machine','Large injection molding machine 350 tons, clamping force 3500kN, for large products',3850000000.00,4820000000.00,1,NULL,'SKU-22'),(23,8,18,'/images/siemens-conveyor.jpg','Siemens SIMATIC Conveyor System S7-1200','PLC-controlled conveyor system, length 20m, load capacity 500kg',285000000.00,360000000.00,1,NULL,'SKU-23'),(24,8,17,'/images/mitsubishi-conveyor.jpg','Mitsubishi MR-J4 Servo Conveyor Line','Precision servo conveyor, length 15m, speed 60m/min',385000000.00,485000000.00,1,NULL,'SKU-24'),(25,9,18,'/images/siemens-packaging.jpg','Siemens Automatic Packaging Line APL-300','Automatic packaging line, 30 packs/min, integrated weighing system',685000000.00,860000000.00,1,NULL,'SKU-25'),(26,10,17,'/images/mitsubishi-cmm.jpg','Mitsubishi CMM Coordinate Measuring Machine','3D coordinate measuring machine, travel 700x1000x600mm, accuracy 0.001mm',1150000000.00,1450000000.00,1,NULL,'SKU-26'),(27,10,2,'/images/mazak-probe.jpg','Mazak QC-20W Quality Control System','Integrated quality control system, optical laser probe',425000000.00,535000000.00,1,NULL,'SKU-27'),(28,3,10,'img/products/product-1762868856971-cfd30c16-4932-441b-a389-df08b50980aa.jpg','RANDOM 100% CÓ 3S','',1777.00,999999999.00,1,'Set','SKU-28');
/*!40000 ALTER TABLE `product` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `productserial`
--

DROP TABLE IF EXISTS `productserial`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `productserial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `serial_number` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `status` enum('IN_STOCK','SOLD') COLLATE utf8mb4_unicode_ci DEFAULT 'IN_STOCK',
  PRIMARY KEY (`id`),
  UNIQUE KEY `serial_number` (`serial_number`),
  KEY `product_id` (`product_id`),
  CONSTRAINT `productserial_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `productserial`
--

LOCK TABLES `productserial` WRITE;
/*!40000 ALTER TABLE `productserial` DISABLE KEYS */;
/*!40000 ALTER TABLE `productserial` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role`
--

LOCK TABLES `role` WRITE;
/*!40000 ALTER TABLE `role` DISABLE KEYS */;
INSERT INTO `role` VALUES (1,'ADMIN','System Administrator - Full access',1),(2,'CUSTOMERSERVICE','Customer Support - Handle requests and contracts',1),(3,'TECH_MANAGER','Technical Manager - Supervise maintenance and repairs',1),(4,'TECHNICIAN','Technical Staff - Perform maintenance & repair',1),(5,'WAREHOUSE','Warehouse Staff - Manage inventory',1),(6,'CUSTOMER','Client - Manufacturing Factories',1);
/*!40000 ALTER TABLE `role` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `role_permission`
--

DROP TABLE IF EXISTS `role_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `role_permission` (
  `role_id` int NOT NULL,
  `permission_id` int NOT NULL,
  PRIMARY KEY (`role_id`,`permission_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `role_permission_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE CASCADE,
  CONSTRAINT `role_permission_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `role_permission`
--

LOCK TABLES `role_permission` WRITE;
/*!40000 ALTER TABLE `role_permission` DISABLE KEYS */;
INSERT INTO `role_permission` VALUES (2,25),(2,26),(2,27),(2,28),(2,29),(2,30),(2,31),(2,32),(2,33),(2,34),(2,35),(2,36),(2,37),(2,38),(1,39),(1,40),(1,41),(1,42),(6,43),(6,44),(6,45),(6,46),(6,47),(6,48),(6,49),(6,50),(6,51),(6,52),(6,63),(6,64),(6,65),(3,66),(3,67),(3,68),(3,69),(3,70),(3,71),(3,72),(3,73),(3,74),(3,75),(3,76),(4,77),(4,78),(4,79),(4,80),(5,81),(5,82),(5,83),(5,84),(5,85),(5,86),(5,87),(5,88),(5,89),(5,90),(5,91),(5,92),(5,93),(5,94),(5,95),(5,115);
/*!40000 ALTER TABLE `role_permission` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `transaction`
--

DROP TABLE IF EXISTS `transaction`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `transaction` (
  `id` int NOT NULL AUTO_INCREMENT,
  `product_id` int NOT NULL,
  `contract_id` int DEFAULT NULL,
  `type` enum('IMPORT','EXPORT') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `quantity` int NOT NULL,
  `transaction_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `note` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `product_id` (`product_id`),
  KEY `contract_id` (`contract_id`),
  CONSTRAINT `transaction_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `product` (`id`) ON DELETE RESTRICT,
  CONSTRAINT `transaction_ibfk_2` FOREIGN KEY (`contract_id`) REFERENCES `contract` (`id`) ON DELETE SET NULL,
  CONSTRAINT `transaction_chk_1` CHECK ((`quantity` > 0))
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `transaction`
--

LOCK TABLES `transaction` WRITE;
/*!40000 ALTER TABLE `transaction` DISABLE KEYS */;
INSERT INTO `transaction` VALUES (1,1,NULL,'IMPORT',10,'2024-01-01 08:00:00','Year opening stock - Haas VF-2SS',1),(2,2,NULL,'IMPORT',5,'2024-01-01 08:00:00','Year opening stock - Mazak 5-Axis',1),(3,3,NULL,'IMPORT',5,'2024-01-01 08:00:00','Year opening stock - DMG Mori',1),(4,13,NULL,'IMPORT',8,'2024-01-05 09:00:00','Import Fanuc welding robots from Japan factory',1),(5,15,NULL,'IMPORT',6,'2024-01-10 10:00:00','Import Trumpf laser cutters from Germany',1),(6,20,NULL,'IMPORT',10,'2024-01-15 08:30:00','Import Engel injection molding machines from Austria',1),(7,2,1,'EXPORT',2,'2024-01-15 14:00:00','Shipped to Tesla - Contract CT-TES-2024-001',1),(8,13,1,'EXPORT',1,'2024-01-15 14:30:00','Shipped welding robot to Tesla',1),(9,26,1,'EXPORT',1,'2024-01-15 15:00:00','Shipped CMM machine to Tesla',1),(10,1,2,'EXPORT',2,'2024-02-10 10:00:00','Shipped CNC machines to General Motors - CT-GM-2024-002',1),(11,15,2,'EXPORT',1,'2024-02-10 11:00:00','Shipped Trumpf laser to General Motors',1),(12,8,3,'EXPORT',3,'2024-02-25 09:00:00','Shipped press machines to Nucor Steel - CT-NUC-2024-003',1),(13,9,3,'EXPORT',2,'2024-02-25 10:00:00','Shipped press brake to Nucor Steel',1),(14,25,4,'EXPORT',1,'2024-03-05 08:00:00','Shipped packaging line to Tyson Foods',1),(15,23,4,'EXPORT',2,'2024-03-05 09:00:00','Shipped conveyor systems to Tyson Foods',1),(16,13,5,'EXPORT',2,'2024-03-20 10:00:00','Shipped welding robots to ExxonMobil',1),(17,3,5,'EXPORT',1,'2024-03-20 11:00:00','Shipped DMG Mori to ExxonMobil',1),(18,8,NULL,'IMPORT',5,'2024-04-01 08:00:00','Restocking Komatsu press machines',1),(19,23,NULL,'IMPORT',8,'2024-04-05 09:00:00','Restocking Siemens conveyor systems',1),(20,1,NULL,'IMPORT',10000,'2025-11-08 13:37:00',NULL,1),(21,2,NULL,'IMPORT',80,'2025-11-08 13:47:00',NULL,1),(22,5,NULL,'IMPORT',70,'2025-11-08 13:48:00',NULL,1);
/*!40000 ALTER TABLE `transaction` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` int NOT NULL AUTO_INCREMENT,
  `role_id` int NOT NULL,
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `full_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `address` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`),
  UNIQUE KEY `email` (`email`),
  KEY `role_id` (`role_id`),
  CONSTRAINT `user_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `role` (`id`) ON DELETE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=24 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,1,'admin','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','John Smith','admin@crmdevice.com','0901234567','New Yorkvvvv, Xã Lệ Viễn, Huyện Sơn Động, Tỉnh Bắc Giang',1),(2,2,'support01','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Sarah Johnson','chichphangnen@gmail.com','0902345678','abcff, Xã Tuấn Đạo, Huyện Sơn Động, Tỉnh Bắc Giang',1),(3,2,'support02','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Michael Brown','support02@crmdevice.com','0902345679','Los Angeles, USA',1),(4,3,'techmanager','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','David Wilson','techmanager@crmdevice.com','0903456789','Boston, USA',1),(5,4,'tech01','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Robert Davis','tech01@crmdevice.com','0904567890','Seattle, USA',1),(6,4,'tech02','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','James Miller','tech02@crmdevice.com','0904567891','Austin, USA',1),(7,4,'tech03','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Jennifer Garcia','tech03@crmdevice.com','0904567892','Denver, USA',1),(8,5,'warehouse01','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Mary Martinez','warehouse01@crmdevice.com','0905678901','Phoenix, USA',1),(9,5,'warehouse02','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','William Anderson','warehouse02@crmdevice.com','0905678902','Portland, USA',1),(10,6,'tesla','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Tesla Manufacturing Inc','procurement@tesla.com','0241234567','Fremont, California',1),(11,6,'gm','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','General Motors Corp','purchasing@gm.com','0236234567','Detroit, Michigan',1),(12,6,'nucor','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Nucor Steel Corporation','purchase@nucor.com','0243234567','Charlotte, North Carolina',1),(13,6,'tyson','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Tyson Foods Manufacturing','procurement@tyson.com','0283234567','Springdale, Arkansas',1),(14,6,'exxon','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','ExxonMobil Industrial Equipment','machinery@exxon.com','0243345678','Irving, Texas',1),(15,6,'kraft','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Kraft Heinz Manufacturing','procurement@kraftheinz.com','0283456789','Pittsburgh, Pennsylvania',1),(16,6,'usasteelworks','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','USA Steel Works Corporation','purchase@usasteelworks.com','0244567890','Birmingham, Alabama',1),(17,6,'berryplastics','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Berry Global Plastics','purchase@berry.com','0274567890','Evansville, Indiana',1),(18,6,'vulcan','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Vulcan Materials Company','procurement@vulcan.com','0256567890','Birmingham, Alabama',1),(19,6,'inteplast','a665a45920422f9d417e4867efdc4fb8a04a1f3fff1fa07e998e86f7f7a27ae3','Inteplast Group Plastics','purchase@inteplast.com','0236678901','Livingston, New Jersey',1),(23,6,'abcd','3b08c6f7f7de00cb9b811bbd72b8ea07fc38a489229d7c53320b5befb85b7cbe','Nguyen van f','duyndhe171846@fpt.edu.vn','0987654321','so nh 12, Phường Nếnh, Thị xã Việt Yên, Tỉnh Bắc Giang',1);
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user_permission`
--

DROP TABLE IF EXISTS `user_permission`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user_permission` (
  `user_id` int NOT NULL,
  `permission_id` int NOT NULL,
  `is_granted` tinyint(1) NOT NULL,
  PRIMARY KEY (`user_id`,`permission_id`),
  KEY `permission_id` (`permission_id`),
  CONSTRAINT `user_permission_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE CASCADE,
  CONSTRAINT `user_permission_ibfk_2` FOREIGN KEY (`permission_id`) REFERENCES `permission` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user_permission`
--

LOCK TABLES `user_permission` WRITE;
/*!40000 ALTER TABLE `user_permission` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_permission` ENABLE KEYS */;
UNLOCK TABLES;

SET FOREIGN_KEY_CHECKS = 1;

-- Dump completed on 2025-11-11 22:48:10
