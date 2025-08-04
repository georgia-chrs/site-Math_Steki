-- Schema για τον πίνακα δεδομένων σχολών (Schools Data)
-- Αυτός ο πίνακας αποθηκεύει τα δεδομένα που ανεβάζει ο admin από CSV/Excel

CREATE TABLE IF NOT EXISTS SchoolsData (
    id INT AUTO_INCREMENT PRIMARY KEY,
    school_id VARCHAR(20) NOT NULL,
    school_name VARCHAR(255) NOT NULL,
    university VARCHAR(255) NOT NULL,
    position_type VARCHAR(100) NOT NULL,
    scientific_field VARCHAR(255) NOT NULL,
    min_moria INT DEFAULT 0,
    max_moria INT DEFAULT 0,
    
    -- Μετασχηματισμένα πεδία για τον υπολογιστή μορίων
    field_code VARCHAR(50) NOT NULL,
    school_type ENUM('gel', 'epal') NOT NULL,
    avg_score INT DEFAULT 0,
    
    -- Metadata
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    uploaded_by VARCHAR(100) DEFAULT 'admin',
    file_type VARCHAR(20) DEFAULT 'unknown',
    batch_id VARCHAR(100),
    
    INDEX idx_school_id (school_id),
    INDEX idx_school_type (school_type),
    INDEX idx_field_code (field_code),
    INDEX idx_scientific_field (scientific_field),
    INDEX idx_position_type (position_type),
    INDEX idx_upload_date (upload_date),
    INDEX idx_batch_id (batch_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Προσθήκη μερικών δειγματικών δεδομένων για τεστ
INSERT INTO SchoolsData (school_id, school_name, university, position_type, scientific_field, min_moria, max_moria, field_code, school_type, avg_score, file_type, batch_id) VALUES
('101', 'Ιατρική', 'Εθνικό Καποδιστριακό Πανεπιστήμιο Αθηνών', 'ΓΕΛ', 'Θετικές Επιστήμες', 19800, 21500, 'thetiko', 'gel', 20650, 'sample', 'sample_batch_1'),
('102', 'Οδοντιατρική', 'Εθνικό Καποδιστριακό Πανεπιστήμιο Αθηνών', 'ΓΕΛ', 'Θετικές Επιστήμες', 19000, 21000, 'thetiko', 'gel', 20000, 'sample', 'sample_batch_1'),
('103', 'Φαρμακευτική', 'Εθνικό Καποδιστριακό Πανεπιστήμιο Αθηνών', 'ΓΕΛ', 'Θετικές Επιστήμες', 18500, 20800, 'thetiko', 'gel', 19650, 'sample', 'sample_batch_1'),
('104', 'Νομική', 'Εθνικό Καποδιστριακό Πανεπιστήμιο Αθηνών', 'ΓΕΛ', 'Θεωρητικές Επιστήμες', 17500, 19500, 'theoretiko', 'gel', 18500, 'sample', 'sample_batch_1'),
('105', 'Πληροφορική', 'ΤΕΙ Αθήνας', 'ΕΠΑΛ', 'Τεχνολογικές Επιστήμες', 14000, 17000, 'pliroforiki', 'epal', 15500, 'sample', 'sample_batch_1'),
('106', 'Μηχανολογία', 'ΤΕΙ Πειραιά', 'ΕΠΑΛ', 'Τεχνολογικές Επιστήμες', 13500, 16500, 'mixanologia', 'epal', 15000, 'sample', 'sample_batch_1');

-- Δείκτες για βελτίωση απόδοσης
CREATE INDEX idx_moria_range ON SchoolsData (min_moria, max_moria);
CREATE INDEX idx_search_combo ON SchoolsData (school_type, field_code, min_moria);

SELECT COUNT(*) AS 'Αριθμός δειγματικών εγγραφών Schools Data' FROM SchoolsData;
