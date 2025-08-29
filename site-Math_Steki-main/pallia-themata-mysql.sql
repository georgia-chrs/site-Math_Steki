-- SQL Schema για τα PDF Παλιών Θεμάτων
-- Για MySQL Database

CREATE TABLE PalliaThemata (
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
    
    CONSTRAINT chk_lykeio CHECK (lykeio IN ('ΓΕΛ', 'ΕΠΑΛ')),
    INDEX idx_lykeio_subject_year (lykeio, subject, year),
    INDEX idx_subject (subject),
    INDEX idx_year (year)
);

-- Προσθήκη κάποιων δειγμάτων (χωρίς file_data για τώρα)
INSERT INTO PalliaThemata (title, lykeio, subject, year, filename, description, file_size, upload_date) VALUES
('Μαθηματικά Προσανατολισμού 2024', 'ΓΕΛ', 'Μαθηματικά', '2024', 'mathimatika_gel_2024_themata.pdf', 'Θέματα Μαθηματικών Προσανατολισμού Πανελλαδικών Εξετάσεων 2024', '2.3 MB', '2024-07-15'),
('Φυσική Προσανατολισμού 2024', 'ΓΕΛ', 'Φυσική', '2024', 'fysiki_gel_2024_themata.pdf', 'Θέματα Φυσικής Προσανατολισμού Πανελλαδικών Εξετάσεων 2024', '1.8 MB', '2024-07-15'),
('Μαθηματικά ΕΠΑΛ 2024', 'ΕΠΑΛ', 'Μαθηματικά', '2024', 'mathimatika_epal_2024_themata.pdf', 'Θέματα Μαθηματικών ΕΠΑΛ Πανελλαδικών Εξετάσεων 2024', '2.0 MB', '2024-07-15');
