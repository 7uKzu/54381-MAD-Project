-- Sample SQL dump for initial roles and a demo user
INSERT INTO roles (id, name, created_at, updated_at) VALUES
(1,'Donor',NOW(),NOW()),
(2,'Recipient',NOW(),NOW()),
(3,'BloodBankManager',NOW(),NOW()),
(4,'Technician',NOW(),NOW()),
(5,'Staff',NOW(),NOW()),
(6,'Admin',NOW(),NOW()),
(7,'MedicalStaff',NOW(),NOW())
ON DUPLICATE KEY UPDATE name=VALUES(name);
