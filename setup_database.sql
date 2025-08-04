-- Δημιουργία πινάκων για PDF Παλιών Θεμάτων και Βάσεων Σχολών
-- Εκτελέστε αυτό το script στη MySQL βάση δεδομένων σας

USE school_db; -- Αλλάξτε το your_database_name με το όνομα της βάσης σας

-- Δημιουργία πίνακα για Παλιά Θέματα
CREATE TABLE IF NOT EXISTS PalliaThemata (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    lykeio VARCHAR(10) NOT NULL DEFAULT 'ΓΕΛ',
    subject VARCHAR(100) NOT NULL,
    year VARCHAR(4) NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'Θέματα',
    filename VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    file_data LONGBLOB,
    file_size VARCHAR(20),
    upload_date DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    CONSTRAINT chk_lykeio CHECK (lykeio IN ('ΓΕΛ', 'ΕΠΑΛ'))
);

-- Δημιουργία πίνακα για Βάσεις Σχολών
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

-- Δημιουργία πίνακα για Μηχανογραφικό
CREATE TABLE IF NOT EXISTS Mixanografiko (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL COMMENT 'Τίτλος του αρχείου',
    lykeio ENUM('ΓΕΛ', 'ΕΠΑΛ') NOT NULL COMMENT 'Τύπος λυκείου',
    field VARCHAR(255) NOT NULL COMMENT 'Πεδίο σπουδών',
    specialty VARCHAR(255) DEFAULT '' COMMENT 'Ειδικά μαθήματα/ειδίκευση',
    description TEXT COMMENT 'Περιγραφή του αρχείου',
    filename VARCHAR(255) NOT NULL COMMENT 'Όνομα αρχείου',
    file_data LONGBLOB NOT NULL COMMENT 'Δεδομένα PDF αρχείου',
    file_size VARCHAR(50) COMMENT 'Μέγεθος αρχείου (π.χ. 1.2 MB)',
    upload_date DATE DEFAULT (CURRENT_DATE) COMMENT 'Ημερομηνία ανεβάσματος',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Ημερομηνία δημιουργίας',
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'Ημερομηνία τελευταίας ενημέρωσης',
    created_by INT DEFAULT 1 COMMENT 'ID διαχειριστή που ανέβασε το αρχείο',
    
    INDEX idx_lykeio (lykeio),
    INDEX idx_field (field),
    INDEX idx_specialty (specialty),
    INDEX idx_upload_date (upload_date)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Πίνακας για αποθήκευση PDF αρχείων μηχανογραφικού';

-- Δημιουργία indexes για καλύτερη απόδοση - Παλιά Θέματα
CREATE INDEX idx_lykeio_subject_year ON PalliaThemata (lykeio, subject, year);
CREATE INDEX idx_subject ON PalliaThemata (subject);
CREATE INDEX idx_year ON PalliaThemata (year);

-- Προσθήκη κάποιων δειγματικών δεδομένων για Παλιά Θέματα (προαιρετικό)
INSERT IGNORE INTO PalliaThemata (title, lykeio, subject, year, filename, description, file_size, upload_date) VALUES
('Μαθηματικά Προσανατολισμού 2024', 'ΓΕΛ', 'Μαθηματικά', '2024', 'mathimatika_gel_2024_themata.pdf', 'Θέματα Μαθηματικών Προσανατολισμού Πανελλαδικών Εξετάσεων 2024', '2.3 MB', '2024-07-15'),
('Φυσική Προσανατολισμού 2024', 'ΓΕΛ', 'Φυσική', '2024', 'fysiki_gel_2024_themata.pdf', 'Θέματα Φυσικής Προσανατολισμού Πανελλαδικών Εξετάσεων 2024', '1.8 MB', '2024-07-15'),
('Μαθηματικά ΕΠΑΛ 2024', 'ΕΠΑΛ', 'Μαθηματικά', '2024', 'mathimatika_epal_2024_themata.pdf', 'Θέματα Μαθηματικών ΕΠΑΛ Πανελλαδικών Εξετάσεων 2024', '2.0 MB', '2024-07-15');

-- Προσθήκη κάποιων δειγματικών δεδομένων για Βάσεις Σχολών (προαιρετικό)
-- Σημείωση: Τα file_data θα πρέπει να προστεθούν μέσω του admin panel καθώς δεν μπορούμε να έχουμε πραγματικά PDF εδώ
INSERT IGNORE INTO VaseisScholon (title, year, lykeio, field, description, filename, file_data, file_size) VALUES
('Βάσεις Θετικών Επιστημών 2024', '2024', 'ΓΕΛ', 'Θετικές Επιστήμες', 
 'Βάσεις εισαγωγής για τις σχολές θετικών επιστημών για το έτος 2024', 
 'vaseis_thetikes_2024.pdf', 
 'PLACEHOLDER', -- Θα αντικατασταθεί με πραγματικό αρχείο
 '1.2 MB'),
('Βάσεις Ανθρωπιστικών Σπουδών 2024', '2024', 'ΓΕΛ', 'Ανθρωπιστικές Επιστήμες', 
 'Βάσεις εισαγωγής για τις σχολές ανθρωπιστικών επιστημών για το έτος 2024', 
 'vaseis_anthropistikes_2024.pdf', 
 'PLACEHOLDER', -- Θα αντικατασταθεί με πραγματικό αρχείο
 '950 KB');

-- Προσθήκη κάποιων δειγματικών δεδομένων για Μηχανογραφικό (προαιρετικό)
INSERT IGNORE INTO Mixanografiko (title, lykeio, field, specialty, description, filename, file_data, file_size, upload_date) VALUES
('Οδηγός Μηχανογραφικού 2024', 'ΓΕΛ', 'Θετικές Επιστήμες', '', 'Πλήρης οδηγός για το μηχανογραφικό των θετικών επιστημών', 'odigos_mixanografikou_thetikes_2024.pdf', 'PLACEHOLDER', '2.5 MB', '2024-03-01'),
('Πίνακας Αντιστοιχίας Σχολών Καλών Τεχνών', 'ΓΕΛ', 'Καλές Τέχνες', 'Εικαστικά', 'Αναλυτικός πίνακας με τις σχολές καλών τεχνών και τα μαθήματα που εξετάζουν', 'pinakas_antistixias_kales_texnes.pdf', 'PLACEHOLDER', '1.8 MB', '2024-02-10'),
('Μηχανογραφικό ΕΠΑΛ Τεχνολογικών Σπουδών', 'ΕΠΑΛ', 'Τεχνολογικές Επιστήμες', 'Τεχνολογικά', 'Οδηγός για απόφοιτους ΕΠΑΛ που θέλουν να συνεχίσουν σε τεχνολογικές σχολές', 'mixanografiko_epal_texnologikes.pdf', 'PLACEHOLDER', '1.5 MB', '2024-02-05'),
('Ειδικά Μαθήματα Μουσικής - Οδηγίες', 'ΓΕΛ', 'Καλές Τέχνες', 'Μουσική', 'Οδηγίες για τις εξετάσεις ειδικών μαθημάτων μουσικής και επιλογή σχολών', 'eidika_mathimata_mousiki.pdf', 'PLACEHOLDER', '1.2 MB', '2024-01-30'),
('Σχολές Φυσικής Αγωγής - Μηχανογραφικό', 'ΓΕΛ', 'Αθλητισμός', 'Φυσική Αγωγή', 'Πληροφορίες για τις σχολές φυσικής αγωγής και αθλητισμού', 'scholes_fysikis_agogis.pdf', 'PLACEHOLDER', '1.7 MB', '2024-01-25'),
('Ανθρωπιστικές Σπουδές - Πλήρης Οδηγός', 'ΓΕΛ', 'Ανθρωπιστικές Επιστήμες', '', 'Αναλυτικός οδηγός για τις ανθρωπιστικές σπουδές και τις επιλογές σχολών', 'anthropistikes_spoudes_odigos.pdf', 'PLACEHOLDER', '2.1 MB', '2024-01-20');

-- Επιβεβαίωση δημιουργίας
SELECT 'Πίνακας PalliaThemata δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός δειγματικών εγγραφών Παλιών Θεμάτων' FROM PalliaThemata;

SELECT 'Πίνακας VaseisScholon δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός δειγματικών εγγραφών Βάσεων Σχολών' FROM VaseisScholon;

SELECT 'Πίνακας Mixanografiko δημιουργήθηκε επιτυχώς!' AS Status;
SELECT COUNT(*) AS 'Αριθμός δειγματικών εγγραφών Μηχανογραφικού' FROM Mixanografiko;
