-- Schema για τον πίνακα Mixanografiko
CREATE TABLE IF NOT EXISTS Mixanografiko (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    lykeio ENUM('ΓΕΛ', 'ΕΠΑΛ') NOT NULL,
    field VARCHAR(255) NOT NULL,
    specialty VARCHAR(255) DEFAULT '',
    description TEXT,
    filename VARCHAR(255) NOT NULL,
    file_data LONGBLOB NOT NULL,
    file_size VARCHAR(50),
    upload_date DATE DEFAULT (CURRENT_DATE),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT DEFAULT 1,
    INDEX idx_lykeio (lykeio),
    INDEX idx_field (field),
    INDEX idx_specialty (specialty),
    INDEX idx_upload_date (upload_date)
);

-- Δεδομένα δοκιμής για το Μηχανογραφικό
INSERT INTO Mixanografiko (title, lykeio, field, specialty, description, filename, file_data, file_size, upload_date) VALUES
('Οδηγός Μηχανογραφικού 2024', 'ΓΕΛ', 'Θετικές Επιστήμες', '', 'Πλήρης οδηγός για το μηχανογραφικό των θετικών επιστημών', 'odigos_mixanografikou_thetikes_2024.pdf', 'SAMPLE_PDF_DATA', '2.5 MB', '2024-03-01'),
('Πίνακας Αντιστοιχίας Σχολών Καλών Τεχνών', 'ΓΕΛ', 'Καλές Τέχνες', 'Εικαστικά', 'Αναλυτικός πίνακας με τις σχολές καλών τεχνών και τα μαθήματα που εξετάζουν', 'pinakas_antistixias_kales_texnes.pdf', 'SAMPLE_PDF_DATA', '1.8 MB', '2024-02-10'),
('Μηχανογραφικό ΕΠΑΛ Τεχνολογικών Σπουδών', 'ΕΠΑΛ', 'Τεχνολογικές Επιστήμες', 'Τεχνολογικά', 'Οδηγός για απόφοιτους ΕΠΑΛ που θέλουν να συνεχίσουν σε τεχνολογικές σχολές', 'mixanografiko_epal_texnologikes.pdf', 'SAMPLE_PDF_DATA', '1.5 MB', '2024-02-05'),
('Ειδικά Μαθήματα Μουσικής - Οδηγίες', 'ΓΕΛ', 'Καλές Τέχνες', 'Μουσική', 'Οδηγίες για τις εξετάσεις ειδικών μαθημάτων μουσικής και επιλογή σχολών', 'eidika_mathimata_mousiki.pdf', 'SAMPLE_PDF_DATA', '1.2 MB', '2024-01-30'),
('Σχολές Φυσικής Αγωγής - Μηχανογραφικό', 'ΓΕΛ', 'Αθλητισμός', 'Φυσική Αγωγή', 'Πληροφορίες για τις σχολές φυσικής αγωγής και αθλητισμού', 'scholes_fysikis_agogis.pdf', 'SAMPLE_PDF_DATA', '1.7 MB', '2024-01-25'),
('Ανθρωπιστικές Σπουδές - Πλήρης Οδηγός', 'ΓΕΛ', 'Ανθρωπιστικές Επιστήμες', '', 'Αναλυτικός οδηγός για τις ανθρωπιστικές σπουδές και τις επιλογές σχολών', 'anthropistikes_spoudes_odigos.pdf', 'SAMPLE_PDF_DATA', '2.1 MB', '2024-01-20');
