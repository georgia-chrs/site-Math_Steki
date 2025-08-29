-- Schema για τον πίνακα βάσεων σχολών
-- Χρησιμοποιήστε αυτό το αρχείο για να δημιουργήσετε τον πίνακα στη MySQL

CREATE TABLE IF NOT EXISTS VaseisScholon (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Τίτλος του αρχείου',
    year VARCHAR(4) NOT NULL COMMENT 'Έτος (π.χ. 2024)',
    lykeio ENUM('ΓΕΛ', 'ΕΠΑΛ') NOT NULL COMMENT 'Τύπος λυκείου',
    field VARCHAR(100) NOT NULL COMMENT 'Πεδίο σπουδών',
    description TEXT COMMENT 'Περιγραφή του αρχείου',
    filename VARCHAR(255) NOT NULL COMMENT 'Όνομα αρχείου',
    file_data LONGBLOB NOT NULL COMMENT 'Δεδομένα PDF αρχείου',
    file_size VARCHAR(20) COMMENT 'Μέγεθος αρχείου (π.χ. 1.2 MB)',
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Ημερομηνία ανεβάσματος',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Ημερομηνία τελευταίας ενημέρωσης',
    created_by VARCHAR(100) DEFAULT 'admin' COMMENT 'Χρήστης που ανέβασε το αρχείο',
    
    INDEX idx_year (year),
    INDEX idx_lykeio (lykeio),
    INDEX idx_field (field),
    INDEX idx_upload_date (upload_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας για αποθήκευση PDF αρχείων βάσεων σχολών';

-- Προσθήκη μερικών δεδομένων δοκιμής
INSERT INTO VaseisScholon (title, year, lykeio, field, description, filename, file_data, file_size) VALUES
('Βάσεις Θετικών Επιστημών 2024', '2024', 'ΓΕΛ', 'Θετικές Επιστήμες', 
 'Βάσεις εισαγωγής για τις σχολές θετικών επιστημών για το έτος 2024', 
 'vaseis_thetikes_2024.pdf', 
 LOAD_FILE('/path/to/sample.pdf'), -- Αντικαταστήστε με πραγματικό path
 '1.2 MB'),

('Βάσεις Ανθρωπιστικών Σπουδών 2024', '2024', 'ΓΕΛ', 'Ανθρωπιστικές Επιστήμες', 
 'Βάσεις εισαγωγής για τις σχολές ανθρωπιστικών επιστημών για το έτος 2024', 
 'vaseis_anthropistikes_2024.pdf', 
 LOAD_FILE('/path/to/sample.pdf'), -- Αντικαταστήστε με πραγματικό path
 '950 KB'),

('Βάσεις ΕΠΑΛ Τεχνολογικών 2024', '2024', 'ΕΠΑΛ', 'Τεχνολογικές Επιστήμες', 
 'Βάσεις εισαγωγής για τις τεχνολογικές σχολές από ΕΠΑΛ για το έτος 2024', 
 'vaseis_epal_tech_2024.pdf', 
 LOAD_FILE('/path/to/sample.pdf'), -- Αντικαταστήστε με πραγματικό path
 '850 KB');

-- Σημείωση: Τα LOAD_FILE() commands θα πρέπει να αντικατασταθούν με πραγματικά αρχεία
-- ή να αφαιρεθούν και να προστεθούν τα δεδομένα μέσω του admin panel
