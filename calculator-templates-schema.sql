-- Δημιουργία πίνακα για Calculator Templates
-- Εκτελέστε αυτό το script στη MySQL βάση δεδομένων σας

USE school_db; -- Αλλάξτε με το όνομα της βάσης σας

-- Δημιουργία πίνακα για Calculator Templates
CREATE TABLE IF NOT EXISTS CalculatorTemplates (
    id INT AUTO_INCREMENT PRIMARY KEY,
    filename VARCHAR(255) NOT NULL COMMENT 'Όνομα αρχείου που αποθηκεύεται',
    original_name VARCHAR(255) NOT NULL COMMENT 'Αρχικό όνομα αρχείου',
    template_type VARCHAR(100) NOT NULL COMMENT 'Τύπος template (π.χ. anthropistikes, thetikes, κλπ)',
    file_data LONGBLOB NOT NULL COMMENT 'Δεδομένα του Excel αρχείου',
    file_size INT NOT NULL COMMENT 'Μέγεθος αρχείου σε bytes',
    mimetype VARCHAR(255) NOT NULL COMMENT 'MIME type του αρχείου',
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Ημερομηνία ανεβάσματος',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Ημερομηνία δημιουργίας',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Ημερομηνία τελευταίας ενημέρωσης',
    created_by VARCHAR(100) DEFAULT 'admin' COMMENT 'Χρήστης που ανέβασε το αρχείο',
    
    UNIQUE KEY unique_filename (filename),
    INDEX idx_template_type (template_type),
    INDEX idx_upload_date (upload_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας για αποθήκευση Excel templates του calculator';
