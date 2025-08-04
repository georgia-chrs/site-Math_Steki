-- Script για δημιουργία πίνακα αποθήκευσης κωδικών για τον admin
USE school_db;

-- Δημιουργία πίνακα για αποθήκευση plain text κωδικών (μόνο για admin view)
CREATE TABLE IF NOT EXISTS UserPasswordsView (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    plain_password VARCHAR(255) NOT NULL,
    user_type ENUM('admin', 'student') NOT NULL,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_username (username),
    INDEX idx_user_type (user_type)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας plain text κωδικών για admin view';

-- Εισαγωγή υπαρχόντων κωδικών
INSERT INTO UserPasswordsView (username, plain_password, user_type) VALUES
('admin', '123', 'admin'),
('mariaio', '123', 'admin'),
('mariaio', '123', 'student'),
('giannisp', '123', 'student'),
('kostasd', '123', 'student')
ON DUPLICATE KEY UPDATE 
    plain_password = VALUES(plain_password),
    last_updated = NOW();

SELECT 'Πίνακας κωδικών δημιουργήθηκε!' AS Status;
SELECT * FROM UserPasswordsView;
