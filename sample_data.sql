USE crm_device_management;

-- =====================================================
-- INSERT DATA FOR CRM DEVICE MANAGEMENT SYSTEM
-- Products: Industrial Machinery
-- Customers: Manufacturing Factories & Enterprises
-- =====================================================

-- 1. INSERT ROLES
INSERT INTO Role (name, description, is_active) VALUES
('Admin', 'System Administrator - Full access', 1),
('Customer Support Staff', 'Customer Support - Handle requests and contracts', 1),
('Technical Manager', 'Technical Manager - Supervise maintenance and repairs', 1),
('Technician', 'Technical Staff - Perform maintenance & repair', 1),
('Warehouse Staff', 'Warehouse Staff - Manage inventory', 1),
('Customer', 'Client - Manufacturing Factories', 1);

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
INSERT INTO Product (category_id, brand_id, image_url, name, description, purchase_price, selling_price, is_active) VALUES
-- CNC Machining Centers
(1, 1, '/images/haas-vf2.jpg', 'Haas VF-2SS CNC Vertical Machining Center', '3-axis vertical CNC milling machine, travel 762x406x508mm, spindle speed 12000 RPM', 1250000000, 1580000000, 1),
(1, 2, '/images/mazak-vcn510c.jpg', 'Mazak VCN-510C 5-Axis Machining Center', '5-axis machining center, advanced technology, large travel 1020x510x460mm', 3800000000, 4750000000, 1),
(1, 5, '/images/dmg-dmu50.jpg', 'DMG MORI DMU 50 CNC Universal Milling', 'Universal 5-axis milling center, high precision, travel 500x450x400mm', 4200000000, 5250000000, 1),
(1, 10, '/images/okuma-mb4000h.jpg', 'Okuma MB-4000H Horizontal Machining', 'Horizontal CNC milling machine, auto rotary table, travel 400x400x350mm', 2100000000, 2650000000, 1),

-- Lathe Machines
(2, 2, '/images/mazak-qtc200.jpg', 'Mazak QTC-200 CNC Turning Center', '2-axis CNC lathe, turning diameter 260mm, length 500mm', 850000000, 1080000000, 1),
(2, 8, '/images/doosan-lynx220.jpg', 'Doosan LYNX 220 CNC Lathe', 'CNC lathe with advanced servo system, diameter 280mm', 920000000, 1150000000, 1),
(2, 10, '/images/okuma-lb3000.jpg', 'Okuma LB-3000 EXII Turning Center', 'Premium CNC lathe, integrated C-axis, diameter 365mm', 1580000000, 1980000000, 1),

-- Pressing Machines
(3, 7, '/images/komatsu-h1f250.jpg', 'Komatsu H1F-250 Hydraulic Press', '250-ton hydraulic press machine, stroke 500mm, bed 1000x800mm', 680000000, 850000000, 1),
(3, 4, '/images/amada-hfb2204.jpg', 'Amada HFB-2204 Press Brake', 'CNC press brake 220 tons, bed length 4000mm', 1250000000, 1580000000, 1),
(3, 4, '/images/amada-rg100.jpg', 'Amada RG-100 Turret Punch Press', 'CNC turret punch press with rotating tool tower, bed 1250x2500mm', 2100000000, 2650000000, 1),

-- Welding Equipment
(4, 13, '/images/lincoln-powerwave.jpg', 'Lincoln Powerwave S500 Welding System', 'MIG/MAG welding machine 500A output, digital control', 185000000, 235000000, 1),
(4, 14, '/images/miller-deltaweld.jpg', 'Miller Deltaweld 452 MIG Welder', 'CO2/MIG welder 450A with inverter technology', 165000000, 210000000, 1),
(4, 3, '/images/fanuc-arcmate120.jpg', 'Fanuc ARC Mate 120iC Welding Robot', 'Industrial welding robot 6-axis, payload 12kg, reach 1811mm', 1850000000, 2320000000, 1),
(4, 17, '/images/mitsubishi-welder.jpg', 'Mitsubishi RV-7FLL Welding Robot', 'Versatile welding robot, 6-axis, 7kg payload, accuracy ±0.05mm', 1680000000, 2100000000, 1),

-- Cutting Machines
(5, 6, '/images/trumpf-3030.jpg', 'Trumpf TruLaser 3030 Fiber Laser', 'Fiber laser cutting machine 4kW, bed 3000x1500mm, high speed', 3500000000, 4380000000, 1),
(5, 4, '/images/amada-ensis.jpg', 'Amada ENSIS-3015AJ Fiber Laser', 'Fiber laser cutter 3kW, automatic loading, bed 3000x1500mm', 3200000000, 4000000000, 1),
(5, 7, '/images/komatsu-plasma.jpg', 'Komatsu Plasma Cutter PC-1500', 'CNC plasma cutter, 150A power source, bed 2500x6000mm', 425000000, 535000000, 1),

-- Grinding Machines
(6, 10, '/images/okuma-grinder.jpg', 'Okuma UGM-6 Universal Grinding Machine', 'Universal CNC grinding machine, travel 600x450x350mm', 1150000000, 1450000000, 1),
(6, 11, '/images/brother-sg408.jpg', 'Brother SG-408 Surface Grinder', 'Surface grinding machine, bed 400x800mm, precision 0.002mm', 385000000, 485000000, 1),

-- Injection Molding
(7, 15, '/images/engel-e-max.jpg', 'Engel e-max 310/100 Injection Molding', 'Electric injection molding machine 100 tons, clamping force 1000kN, energy saving', 1450000000, 1820000000, 1),
(7, 16, '/images/arburg-470a.jpg', 'Arburg Allrounder 470 A Injection Machine', 'Hydraulic injection molding 150 tons, clamping force 1500kN, versatile', 1280000000, 1600000000, 1),
(7, 15, '/images/engel-duo.jpg', 'Engel duo 2050/350 Large Injection Machine', 'Large injection molding machine 350 tons, clamping force 3500kN, for large products', 3850000000, 4820000000, 1),

-- Conveyor Systems
(8, 18, '/images/siemens-conveyor.jpg', 'Siemens SIMATIC Conveyor System S7-1200', 'PLC-controlled conveyor system, length 20m, load capacity 500kg', 285000000, 360000000, 1),
(8, 17, '/images/mitsubishi-conveyor.jpg', 'Mitsubishi MR-J4 Servo Conveyor Line', 'Precision servo conveyor, length 15m, speed 60m/min', 385000000, 485000000, 1),

-- Packaging Machines
(9, 18, '/images/siemens-packaging.jpg', 'Siemens Automatic Packaging Line APL-300', 'Automatic packaging line, 30 packs/min, integrated weighing system', 685000000, 860000000, 1),

-- Quality Inspection Equipment
(10, 17, '/images/mitsubishi-cmm.jpg', 'Mitsubishi CMM Coordinate Measuring Machine', '3D coordinate measuring machine, travel 700x1000x600mm, accuracy 0.001mm', 1150000000, 1450000000, 1),
(10, 2, '/images/mazak-probe.jpg', 'Mazak QC-20W Quality Control System', 'Integrated quality control system, optical laser probe', 425000000, 535000000, 1);

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

-- 13. INSERT CUSTOMER REQUESTS (Warranty/Maintenance/Repair)
INSERT INTO CustomerRequest (customer_id, device_id, request_type, description, request_date, status, total_cost, customer_comment, rating, is_active) VALUES
-- Completed requests
(10, 1, 'MAINTENANCE', 'First scheduled maintenance for Mazak 5-Axis machine', '2024-07-10 08:30:00', 'CLOSED', 15000000, 'Excellent service, professional technicians', 5, 1),
(10, 3, 'MAINTENANCE', 'Scheduled maintenance for Fanuc welding robot', '2024-07-15 09:00:00', 'CLOSED', 8500000, 'Completed on time', 5, 1),
(11, 5, 'WARRANTY', 'Haas control system malfunction, warranty claim', '2024-08-05 10:15:00', 'CLOSED', 0, 'Quick response, machine working perfectly now', 5, 1),
(12, 10, 'MAINTENANCE', 'Scheduled maintenance for Komatsu press machine', '2024-08-20 08:00:00', 'CLOSED', 6500000, 'Professional service', 4, 1),

-- In-progress requests
(13, 15, 'MAINTENANCE', 'Scheduled maintenance for automatic packaging system', '2024-10-01 09:30:00', 'IN_PROGRESS', 12000000, NULL, NULL, 1),
(14, 22, 'REPAIR', 'Welding robot drive system repair needed', '2024-10-03 14:00:00', 'ASSIGNED', 18000000, NULL, NULL, 1),

-- Pending requests
(15, 25, 'MAINTENANCE', 'Scheduled maintenance for Mitsubishi servo conveyor', '2024-10-05 08:00:00', 'PENDING', 7500000, NULL, NULL, 1),
(16, 31, 'WARRANTY', 'Hydraulic press oil leakage, warranty inspection required', '2024-10-06 11:30:00', 'PENDING', 0, NULL, NULL, 1);

-- 14. INSERT TASKS
INSERT INTO Task (request_id, title, description, start_time, end_time, status, task_cost) VALUES
-- Tasks for completed request 1
(1, 'Inspect Mazak machine systems', 'Complete inspection of mechanical and electrical systems', '2024-07-11 08:00:00', '2024-07-11 12:00:00', 'COMPLETED', 3000000),
(1, 'Oil change and lubrication', 'Change machine oil and lubricate all components', '2024-07-11 13:00:00', '2024-07-11 16:00:00', 'COMPLETED', 5000000),
(1, 'Accuracy calibration', 'Calibrate precision of all axes', '2024-07-12 08:00:00', '2024-07-12 11:00:00', 'COMPLETED', 7000000),

-- Tasks for completed request 2
(2, 'Welding robot maintenance', 'Inspect and maintain all robot joints', '2024-07-16 08:00:00', '2024-07-16 15:00:00', 'COMPLETED', 8500000),

-- Tasks for completed request 3
(3, 'Diagnose control system failure', 'Inspect and identify root cause of malfunction', '2024-08-06 08:00:00', '2024-08-06 12:00:00', 'COMPLETED', 0),
(3, 'Replace control circuit board', 'Replace faulty board (under warranty)', '2024-08-06 13:00:00', '2024-08-06 16:00:00', 'COMPLETED', 0),

-- Tasks for completed request 4
(4, 'Hydraulic press maintenance', 'Inspect hydraulic system and change oil', '2024-08-21 08:00:00', '2024-08-21 14:00:00', 'COMPLETED', 6500000),

-- Tasks for in-progress request 5
(5, 'Inspect packaging system', 'Inspect all packaging modules', '2024-10-02 08:00:00', '2024-10-02 12:00:00', 'COMPLETED', 4000000),
(5, 'Maintain weighing system', 'Calibrate scales and sensors', '2024-10-02 13:00:00', NULL, 'IN_PROGRESS', 8000000),

-- Tasks for assigned request 6
(6, 'Diagnose drive system', 'Inspect servo motor and gearbox', '2024-10-04 08:00:00', NULL, 'IN_PROGRESS', 5000000),
(6, 'Replace damaged components', 'Prepare and replace necessary parts', NULL, NULL, 'PENDING', 13000000);

-- 15. INSERT TASK ASSIGNMENTS
INSERT INTO Task_Assignment (task_id, technician_id, is_main, assigned_date) VALUES
-- Task 1 assignments (Request 1)
(1, 5, TRUE, '2024-07-10 15:00:00'),
(1, 6, FALSE, '2024-07-10 15:00:00'),
(2, 5, TRUE, '2024-07-11 08:00:00'),
(3, 5, TRUE, '2024-07-11 13:00:00'),
(3, 7, FALSE, '2024-07-11 13:00:00'),

-- Task 2 assignment (Request 2)
(4, 6, TRUE, '2024-07-15 10:00:00'),

-- Task 3 assignments (Request 3 - Warranty)
(5, 5, TRUE, '2024-08-05 14:00:00'),
(6, 5, TRUE, '2024-08-06 08:00:00'),

-- Task 4 assignment (Request 4)
(7, 7, TRUE, '2024-08-20 09:00:00'),

-- Task 5 assignments (Request 5 - In progress)
(8, 5, TRUE, '2024-10-01 14:00:00'),
(9, 5, TRUE, '2024-10-02 08:00:00'),
(9, 6, FALSE, '2024-10-02 08:00:00'),

-- Task 6 assignments (Request 6 - In progress)
(10, 6, TRUE, '2024-10-03 15:00:00'),
(10, 7, FALSE, '2024-10-03 15:00:00'),
(11, 6, TRUE, '2024-10-04 08:00:00');

-- 16. INSERT MAINTENANCE SCHEDULES
INSERT INTO MaintenanceSchedule (device_id, next_maintenance_date, last_maintenance_date, is_auto_generated, status) VALUES
-- Devices that completed maintenance
(1, '2025-01-10', '2024-07-11', TRUE, 'PENDING'),
(3, '2025-01-15', '2024-07-16', TRUE, 'PENDING'),
(10, '2025-02-20', '2024-08-21', TRUE, 'PENDING'),

-- Upcoming maintenance
(2, '2025-01-15', NULL, TRUE, 'PENDING'),
(4, '2025-01-15', NULL, TRUE, 'PENDING'),
(5, '2025-02-10', NULL, TRUE, 'PENDING'),
(6, '2025-02-10', NULL, TRUE, 'PENDING'),
(7, '2025-02-25', NULL, TRUE, 'PENDING'),
(8, '2025-02-25', NULL, TRUE, 'PENDING'),
(9, '2025-02-25', NULL, TRUE, 'PENDING'),
(11, '2024-12-05', NULL, TRUE, 'PENDING'),
(12, '2024-12-05', NULL, TRUE, 'PENDING'),
(13, '2024-12-05', NULL, TRUE, 'PENDING'),
(14, '2024-12-05', NULL, TRUE, 'PENDING'),
(15, '2024-12-05', NULL, TRUE, 'PENDING'),

-- Overdue maintenance (for testing)
(16, '2024-10-12', NULL, TRUE, 'OVERDUE'),
(17, '2024-10-12', NULL, TRUE, 'OVERDUE');

-- 17. INSERT INVOICES
INSERT INTO Invoice (request_id, customer_id, amount, paid_amount, status, issue_date, due_date) VALUES
-- Paid invoices for completed requests
(1, 10, 15000000, 15000000, 'PAID', '2024-07-12 16:00:00', '2024-07-27'),
(2, 10, 8500000, 8500000, 'PAID', '2024-07-16 16:00:00', '2024-07-31'),
(4, 12, 6500000, 6500000, 'PAID', '2024-08-21 16:00:00', '2024-09-05'),

-- Unpaid invoice for in-progress request
(5, 13, 12000000, 0, 'UNPAID', '2024-10-02 17:00:00', '2024-10-17'),
(6, 14, 18000000, 0, 'UNPAID', '2024-10-04 17:00:00', '2024-10-19');

-- 18. INSERT PAYMENTS
INSERT INTO Payment (invoice_id, amount, status, payment_date) VALUES
-- Payments for paid invoices
(1, 15000000, 'COMPLETED', '2024-07-25 10:30:00'),
(2, 8500000, 'COMPLETED', '2024-07-28 14:15:00'),
(3, 6500000, 'COMPLETED', '2024-09-03 09:45:00');

-- =====================================================
-- SUMMARY
-- =====================================================
-- Roles: 6 roles (Admin, Customer Support Staff, Technical Manager, Technician, Warehouse Staff, Customer)
-- Users: 19 users (9 staff + 10 manufacturing companies as customers)
-- Categories: 10 categories of industrial machinery
-- Brands: 18 international machinery brands
-- Products: 27 industrial machines (CNC, Lathe, Press, Welding, Cutting, etc.)
-- Contracts: 10 contracts with major US manufacturing companies
-- Devices: 40+ devices with serial numbers deployed to customers
-- Transactions: Import/Export inventory movements
-- Customer Requests: 8 service requests (maintenance, warranty, repair)
-- Tasks: Task assignments to technicians
-- Maintenance Schedules: Scheduled and overdue maintenances
-- Invoices & Payments: Billing and payment tracking
-- =====================================================

